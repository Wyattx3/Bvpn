import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../user_manager.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  bool isMMK = true; // Toggle between MMK and USD
  final TextEditingController _accountController = TextEditingController();
  final UserManager _userManager = UserManager();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Rewards'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _userManager.balanceMMK,
        builder: (context, balance, child) {
          double usdValue = balance / 4500; // Rate: 1 USD = 4500 MMK

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Balance Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Total Earnings',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${balance} MMK',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '≈ \$${usdValue.toStringAsFixed(4)} USD',
                        style: const TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),

                // Withdraw Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Withdraw Method',
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Currency Toggle
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black26 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isMMK = true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isMMK ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: isMMK ? [
                                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)
                                    ] : null,
                                  ),
                                  child: const Center(child: Text('MMK (Kpay/Wave)', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black))),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isMMK = false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: !isMMK ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: !isMMK ? [
                                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)
                                    ] : null,
                                  ),
                                  child: const Center(child: Text('USD (PayPal)', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black))),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      
                      // Input Field
                      TextField(
                        controller: _accountController,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: isMMK ? 'Phone Number' : 'Email Address',
                          prefixIcon: Icon(isMMK ? Icons.phone : Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: isDark ? Colors.grey.withOpacity(0.1) : Colors.grey.shade50,
                        ),
                        keyboardType: isMMK ? TextInputType.phone : TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 20),
                      
                      // Info Text
                      Text(
                        isMMK 
                          ? 'Minimum withdraw: 20,000 MMK'
                          : 'Minimum withdraw: \$20.00 USD',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),

                      const SizedBox(height: 20),

                      // Withdraw Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _handleWithdraw(balance, usdValue),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Request Withdraw'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleWithdraw(int balance, double usdValue) {
    if (_accountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your account details')),
      );
      return;
    }

    if (isMMK) {
      if (balance >= 20000) {
        // Proceed with withdraw
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Withdraw request submitted!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insufficient balance. Minimum 20,000 MMK')),
        );
      }
    } else {
      if (usdValue >= 20.0) {
        // Proceed with withdraw
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Withdraw request submitted!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insufficient balance. Minimum \$20 USD')),
        );
      }
    }
  }
}

