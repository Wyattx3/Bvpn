import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_selection_screen.dart';
import '../user_manager.dart';

class SplitTunnelingScreen extends StatefulWidget {
  const SplitTunnelingScreen({super.key});

  @override
  State<SplitTunnelingScreen> createState() => _SplitTunnelingScreenState();
}

class _SplitTunnelingScreenState extends State<SplitTunnelingScreen> {
  final UserManager _userManager = UserManager();
  late int _selectedOption;

  List<AppInfo> _selectedAppsForUsesVPN = [];
  List<AppInfo> _selectedAppsForBypassVPN = [];

  @override
  void initState() {
    super.initState();
    _selectedOption = _userManager.splitTunnelingMode.value;
  }

  // Dummy Apps Data
  final List<AppInfo> _allApps = [
    AppInfo('YouTube', 'com.google.youtube', Icons.play_circle_filled, Colors.red),
    AppInfo('Gmail', 'com.google.gmail', Icons.mail, Colors.redAccent),
    AppInfo('Chrome', 'com.android.chrome', Icons.public, Colors.blue),
    AppInfo('Maps', 'com.google.maps', Icons.map, Colors.green),
    AppInfo('Facebook', 'com.facebook.katana', Icons.facebook, Colors.blue.shade800),
    AppInfo('Instagram', 'com.instagram.android', Icons.camera_alt, Colors.pink),
    AppInfo('WhatsApp', 'com.whatsapp', Icons.chat, Colors.green.shade600),
    AppInfo('Spotify', 'com.spotify.music', Icons.music_note, Colors.greenAccent.shade700),
    AppInfo('Netflix', 'com.netflix.mediaclient', Icons.movie, Colors.red.shade900),
    AppInfo('Telegram', 'org.telegram.messenger', Icons.send, Colors.blueAccent),
    AppInfo('TikTok', 'com.zhiliaoapp.musically', Icons.music_video, Colors.black),
    AppInfo('Twitter', 'com.twitter.android', Icons.alternate_email, Colors.blue.shade400),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1A1625) : const Color(0xFFFAFAFC);
    final textColor = isDark ? Colors.white : Colors.black;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Split Tunneling'),
        centerTitle: true,
          backgroundColor: backgroundColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
          titleTextStyle: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildOption(
              index: 0,
              icon: Icons.call_split,
              title: 'Disable',
              subtitle: 'No effect',
            ),
            const SizedBox(height: 12),
            _buildOption(
              index: 1,
              icon: Icons.filter_list,
              title: 'Uses VPN',
              subtitle: 'Only allows selected applications to use the VPN',
                showAppsCount: _selectedOption == 1,
                selectedCount: _selectedAppsForUsesVPN.length,
                onTapApps: () => _openAppSelection(true),
            ),
            const SizedBox(height: 12),
            _buildOption(
              index: 2,
              icon: Icons.block,
              title: 'Bypass VPN',
              subtitle: 'Disallows selected applications to use the VPN',
                showAppsCount: _selectedOption == 2,
                selectedCount: _selectedAppsForBypassVPN.length,
                onTapApps: () => _openAppSelection(false),
            ),
          ],
          ),
        ),
      ),
    );
  }

  Future<void> _openAppSelection(bool isUsesVPN) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppSelectionScreen(
          title: isUsesVPN ? 'Uses VPN' : 'Bypass VPN',
          allApps: _allApps,
          selectedApps: isUsesVPN ? _selectedAppsForUsesVPN : _selectedAppsForBypassVPN,
        ),
      ),
    );

    if (result != null && result is List<AppInfo>) {
      setState(() {
        if (isUsesVPN) {
          _selectedAppsForUsesVPN = result;
        } else {
          _selectedAppsForBypassVPN = result;
        }
      });
    }
  }

  Widget _buildOption({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
    bool showAppsCount = false,
    int selectedCount = 0,
    VoidCallback? onTapApps,
  }) {
    final isSelected = _selectedOption == index;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF352F44) : Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = index;
        });
        _userManager.splitTunnelingMode.value = index;
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: Colors.deepPurple.withOpacity(0.5), width: 1) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(icon, color: isSelected ? Colors.deepPurple : (isDark ? Colors.grey : Colors.black54)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.deepPurple : Colors.transparent,
                border: Border.all(
                        color: isSelected ? Colors.deepPurple : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
                ],
              ),
            ),
            if (showAppsCount) ...[
              Divider(height: 1, color: isDark ? Colors.black12 : Colors.grey.shade100),
              InkWell(
                onTap: onTapApps,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        '$selectedCount Selected Applications',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade500),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

