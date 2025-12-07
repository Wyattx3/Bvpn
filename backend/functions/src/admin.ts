/**
 * Admin Functions
 * - Process Withdrawal (Approve/Reject)
 * - Ban/Unban Device
 * - Adjust Balance
 * - CRUD Servers
 * - Update SDUI Configs
 * - Dashboard Stats
 */

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const db = admin.firestore();

// ========== HELPER: CHECK ADMIN ==========
async function checkAdmin(adminId: string): Promise<boolean> {
  const adminDoc = await db.collection("admins").doc(adminId).get();
  return adminDoc.exists;
}

// ========== PROCESS WITHDRAWAL ==========
export const processWithdrawal = functions.https.onCall(
  async (
    request: functions.https.CallableRequest<{
      adminId: string;
      withdrawalId: string;
      action: "approved" | "rejected";
      rejectionReason?: string;
    }>
  ) => {
    const { adminId, withdrawalId, action, rejectionReason } = request.data;

    if (!adminId || !withdrawalId || !action) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "adminId, withdrawalId, and action are required"
      );
    }

    // Verify admin
    const isAdmin = await checkAdmin(adminId);
    if (!isAdmin) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Admin access required"
      );
    }

    const withdrawalRef = db.collection("withdrawals").doc(withdrawalId);

    await db.runTransaction(async (transaction) => {
      const withdrawalDoc = await transaction.get(withdrawalRef);

      if (!withdrawalDoc.exists) {
        throw new functions.https.HttpsError(
          "not-found",
          "Withdrawal not found"
        );
      }

      const withdrawalData = withdrawalDoc.data();

      if (withdrawalData?.status !== "pending") {
        throw new functions.https.HttpsError(
          "failed-precondition",
          "Withdrawal already processed"
        );
      }

      // Update withdrawal status
      const updateData: Record<string, unknown> = {
        status: action,
        processedAt: admin.firestore.FieldValue.serverTimestamp(),
        processedBy: adminId,
      };

      if (action === "rejected" && rejectionReason) {
        updateData.rejectionReason = rejectionReason;
      }

      transaction.update(withdrawalRef, updateData);

      // If rejected, refund balance
      if (action === "rejected") {
        const deviceRef = db.collection("devices").doc(withdrawalData.deviceId);
        transaction.update(deviceRef, {
          balance: admin.firestore.FieldValue.increment(withdrawalData.points),
        });

        // Log refund
        const logRef = db.collection("activity_logs").doc();
        transaction.set(logRef, {
          deviceId: withdrawalData.deviceId,
          type: "admin_adjustment",
          description: `Withdrawal Rejected - Refund (${rejectionReason || "No reason"})`,
          amount: withdrawalData.points,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });
      }
    });

    return {
      success: true,
      message: `Withdrawal ${action}`,
    };
  }
);

// ========== BAN/UNBAN DEVICE ==========
export const toggleDeviceBan = functions.https.onCall(
  async (
    request: functions.https.CallableRequest<{
      adminId: string;
      deviceId: string;
      ban: boolean;
      reason?: string;
    }>
  ) => {
    const { adminId, deviceId, ban, reason } = request.data;

    if (!adminId || !deviceId || ban === undefined) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "adminId, deviceId, and ban are required"
      );
    }

    // Verify admin
    const isAdmin = await checkAdmin(adminId);
    if (!isAdmin) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Admin access required"
      );
    }

    const deviceRef = db.collection("devices").doc(deviceId);
    const deviceDoc = await deviceRef.get();

    if (!deviceDoc.exists) {
      throw new functions.https.HttpsError("not-found", "Device not found");
    }

    await deviceRef.update({
      status: ban ? "banned" : "offline",
      banReason: ban ? reason || "Banned by admin" : null,
      bannedAt: ban
        ? admin.firestore.FieldValue.serverTimestamp()
        : null,
      bannedBy: ban ? adminId : null,
    });

    return {
      success: true,
      message: ban ? "Device banned" : "Device unbanned",
    };
  }
);

// ========== ADJUST BALANCE ==========
export const adjustBalance = functions.https.onCall(
  async (
    request: functions.https.CallableRequest<{
      adminId: string;
      deviceId: string;
      amount: number;
      reason: string;
    }>
  ) => {
    const { adminId, deviceId, amount, reason } = request.data;

    if (!adminId || !deviceId || amount === undefined || !reason) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "adminId, deviceId, amount, and reason are required"
      );
    }

    // Verify admin
    const isAdmin = await checkAdmin(adminId);
    if (!isAdmin) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Admin access required"
      );
    }

    const deviceRef = db.collection("devices").doc(deviceId);

    await db.runTransaction(async (transaction) => {
      const deviceDoc = await transaction.get(deviceRef);

      if (!deviceDoc.exists) {
        throw new functions.https.HttpsError("not-found", "Device not found");
      }

      const currentBalance = deviceDoc.data()?.balance || 0;
      const newBalance = currentBalance + amount;

      if (newBalance < 0) {
        throw new functions.https.HttpsError(
          "failed-precondition",
          "Balance cannot go negative"
        );
      }

      transaction.update(deviceRef, {
        balance: newBalance,
      });

      // Log activity
      const logRef = db.collection("activity_logs").doc();
      transaction.set(logRef, {
        deviceId,
        type: "admin_adjustment",
        description: reason,
        amount,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        adjustedBy: adminId,
      });
    });

    return {
      success: true,
      message: `Balance adjusted by ${amount > 0 ? "+" : ""}${amount}`,
    };
  }
);

// ========== CRUD SERVERS ==========
export const addServer = functions.https.onCall(
  async (
    request: functions.https.CallableRequest<{
      adminId: string;
      server: {
        name: string;
        flag: string;
        address: string;
        port: number;
        uuid: string;
        alterId?: number;
        security?: string;
        network?: string;
        path?: string;
        tls?: boolean;
        country: string;
        isPremium?: boolean;
      };
    }>
  ) => {
    const { adminId, server } = request.data;

    if (!adminId || !server) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "adminId and server data are required"
      );
    }

    // Verify admin
    const isAdmin = await checkAdmin(adminId);
    if (!isAdmin) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Admin access required"
      );
    }

    const serverRef = db.collection("servers").doc();
    await serverRef.set({
      ...server,
      alterId: server.alterId || 0,
      security: server.security || "auto",
      network: server.network || "ws",
      path: server.path || "/",
      tls: server.tls !== false,
      isPremium: server.isPremium || false,
      status: "online",
      load: 0,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      createdBy: adminId,
    });

    return {
      success: true,
      serverId: serverRef.id,
      message: "Server added successfully",
    };
  }
);

export const updateServer = functions.https.onCall(
  async (
    request: functions.https.CallableRequest<{
      adminId: string;
      serverId: string;
      updates: Record<string, unknown>;
    }>
  ) => {
    const { adminId, serverId, updates } = request.data;

    if (!adminId || !serverId || !updates) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "adminId, serverId, and updates are required"
      );
    }

    // Verify admin
    const isAdmin = await checkAdmin(adminId);
    if (!isAdmin) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Admin access required"
      );
    }

    const serverRef = db.collection("servers").doc(serverId);
    const serverDoc = await serverRef.get();

    if (!serverDoc.exists) {
      throw new functions.https.HttpsError("not-found", "Server not found");
    }

    await serverRef.update({
      ...updates,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedBy: adminId,
    });

    return {
      success: true,
      message: "Server updated successfully",
    };
  }
);

export const deleteServer = functions.https.onCall(
  async (
    request: functions.https.CallableRequest<{
      adminId: string;
      serverId: string;
    }>
  ) => {
    const { adminId, serverId } = request.data;

    if (!adminId || !serverId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "adminId and serverId are required"
      );
    }

    // Verify admin
    const isAdmin = await checkAdmin(adminId);
    if (!isAdmin) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Admin access required"
      );
    }

    await db.collection("servers").doc(serverId).delete();

    return {
      success: true,
      message: "Server deleted successfully",
    };
  }
);

// ========== UPDATE SDUI CONFIG ==========
export const updateSduiConfig = functions.https.onCall(
  async (
    request: functions.https.CallableRequest<{
      adminId: string;
      screenId: string;
      config: Record<string, unknown>;
    }>
  ) => {
    const { adminId, screenId, config } = request.data;

    if (!adminId || !screenId || !config) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "adminId, screenId, and config are required"
      );
    }

    // Verify admin
    const isAdmin = await checkAdmin(adminId);
    if (!isAdmin) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Admin access required"
      );
    }

    await db.collection("sdui_configs").doc(screenId).set(
      {
        screen_id: screenId,
        config,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedBy: adminId,
      },
      { merge: true }
    );

    return {
      success: true,
      message: "Config updated successfully",
    };
  }
);

// ========== DASHBOARD STATS ==========
export const getDashboardStats = functions.https.onCall(
  async (
    request: functions.https.CallableRequest<{
      adminId: string;
    }>
  ) => {
    const { adminId } = request.data;

    if (!adminId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "adminId is required"
      );
    }

    // Verify admin
    const isAdmin = await checkAdmin(adminId);
    if (!isAdmin) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Admin access required"
      );
    }

    // Get counts
    const [devicesSnapshot, serversSnapshot, pendingWithdrawalsSnapshot] =
      await Promise.all([
        db.collection("devices").count().get(),
        db.collection("servers").where("status", "==", "online").count().get(),
        db
          .collection("withdrawals")
          .where("status", "==", "pending")
          .count()
          .get(),
      ]);

    // Get total pending withdrawal amount
    const pendingWithdrawals = await db
      .collection("withdrawals")
      .where("status", "==", "pending")
      .get();

    let totalPendingAmount = 0;
    pendingWithdrawals.docs.forEach((doc) => {
      totalPendingAmount += doc.data().points || 0;
    });

    return {
      success: true,
      stats: {
        totalDevices: devicesSnapshot.data().count,
        activeServers: serversSnapshot.data().count,
        pendingWithdrawals: pendingWithdrawalsSnapshot.data().count,
        totalPendingAmount,
      },
    };
  }
);

// ========== GET ALL DEVICES (Admin) ==========
export const getAllDevices = functions.https.onCall(
  async (
    request: functions.https.CallableRequest<{
      adminId: string;
      limit?: number;
      status?: string;
    }>
  ) => {
    const { adminId, limit = 100, status } = request.data;

    if (!adminId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "adminId is required"
      );
    }

    // Verify admin
    const isAdmin = await checkAdmin(adminId);
    if (!isAdmin) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Admin access required"
      );
    }

    let query: admin.firestore.Query = db
      .collection("devices")
      .orderBy("lastSeen", "desc")
      .limit(limit);

    if (status) {
      query = db
        .collection("devices")
        .where("status", "==", status)
        .orderBy("lastSeen", "desc")
        .limit(limit);
    }

    const snapshot = await query.get();

    const devices = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
      createdAt: doc.data().createdAt?.toDate?.()?.toISOString() || null,
      lastSeen: doc.data().lastSeen?.toDate?.()?.toISOString() || null,
    }));

    return {
      success: true,
      devices,
      count: devices.length,
    };
  }
);

// ========== GET ALL WITHDRAWALS (Admin) ==========
export const getAllWithdrawals = functions.https.onCall(
  async (
    request: functions.https.CallableRequest<{
      adminId: string;
      limit?: number;
      status?: string;
    }>
  ) => {
    const { adminId, limit = 100, status } = request.data;

    if (!adminId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "adminId is required"
      );
    }

    // Verify admin
    const isAdmin = await checkAdmin(adminId);
    if (!isAdmin) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Admin access required"
      );
    }

    let query: admin.firestore.Query = db
      .collection("withdrawals")
      .orderBy("createdAt", "desc")
      .limit(limit);

    if (status) {
      query = db
        .collection("withdrawals")
        .where("status", "==", status)
        .orderBy("createdAt", "desc")
        .limit(limit);
    }

    const snapshot = await query.get();

    const withdrawals = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
      createdAt: doc.data().createdAt?.toDate?.()?.toISOString() || null,
      processedAt: doc.data().processedAt?.toDate?.()?.toISOString() || null,
    }));

    return {
      success: true,
      withdrawals,
      count: withdrawals.length,
    };
  }
);

