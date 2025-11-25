import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final backgroundColor = isDark ? const Color(0xFF1A1625) : const Color(0xFFFAFAFC);
    final primaryPurple = isDark ? const Color(0xFFB388FF) : const Color(0xFF7E57C2);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('About', style: TextStyle(color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(flex: 1),
              
              // App Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark 
                      ? [const Color(0xFF7C4DFF), const Color(0xFFB388FF)]
                      : [const Color(0xFF7E57C2), const Color(0xFFB39DDB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryPurple.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shield,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'VPN App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              
              const SizedBox(height: 12),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Version 1.0.8',
                  style: TextStyle(
                    color: primaryPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'You have the latest version',
                    style: TextStyle(color: subtitleColor),
                  ),
                ],
              ),
              
              const Spacer(flex: 2),
              
              // Check for Updates Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('You already have the latest version!')),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Check for Updates'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryPurple,
                    side: BorderSide(color: primaryPurple),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Credits
              Text(
                'Made with ❤️ by VPN App Team',
                style: TextStyle(color: subtitleColor),
              ),
              const SizedBox(height: 8),
              Text(
                '© 2025 VPN App. All rights reserved.',
                style: TextStyle(color: subtitleColor, fontSize: 12),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

