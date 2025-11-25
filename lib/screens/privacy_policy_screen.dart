import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: November 2025',
              style: TextStyle(color: subtitleColor),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: '1. Information We Collect',
              content: '''We collect information you provide directly to us, such as when you create an account, use our services, or contact us for support.

• Account Information: Email address, username, and password
• Payment Information: Payment method details for premium subscriptions
• Usage Data: Connection logs, bandwidth usage, and app preferences
• Device Information: Device type, operating system, and unique device identifiers''',
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            _buildSection(
              title: '2. How We Use Your Information',
              content: '''We use the information we collect to:

• Provide, maintain, and improve our VPN services
• Process transactions and send related information
• Send technical notices and support messages
• Respond to your comments and questions
• Monitor and analyze trends and usage
• Detect and prevent fraudulent transactions and abuse''',
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            _buildSection(
              title: '3. No-Logs Policy',
              content: '''We are committed to protecting your privacy. We do NOT log:

• Your browsing activity or data content
• DNS queries
• IP addresses connected to VPN servers
• Connection timestamps
• Session duration
• Bandwidth usage per session

We only maintain minimal data necessary to operate our service and prevent abuse.''',
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            _buildSection(
              title: '4. Data Security',
              content: '''We implement appropriate security measures to protect your personal information:

• AES-256 encryption for all VPN connections
• Secure data storage with encryption at rest
• Regular security audits and penetration testing
• Strict access controls for our team members''',
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            _buildSection(
              title: '5. Data Sharing',
              content: '''We do not sell, trade, or rent your personal information to third parties. We may share information only in the following circumstances:

• With your consent
• To comply with legal obligations
• To protect our rights and prevent fraud
• With service providers who assist our operations''',
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            _buildSection(
              title: '6. Your Rights',
              content: '''You have the right to:

• Access your personal data
• Correct inaccurate data
• Delete your account and associated data
• Export your data
• Opt-out of marketing communications''',
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            _buildSection(
              title: '7. Contact Us',
              content: '''If you have any questions about this Privacy Policy, please contact us at:

Email: privacy@vpnapp.com
Address: 123 Privacy Street, Tech City, TC 12345''',
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}

