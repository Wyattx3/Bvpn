import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
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
              'Terms of Service',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Effective Date: November 2025',
              style: TextStyle(color: subtitleColor),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: '1. Acceptance of Terms',
              content: '''By accessing or using our VPN service, you agree to be bound by these Terms of Service and all applicable laws and regulations. If you do not agree with any of these terms, you are prohibited from using or accessing this service.

These terms apply to all users of the service, including browsers, customers, merchants, and content contributors.''',
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            _buildSection(
              title: '2. Description of Service',
              content: '''Our VPN service provides:

• Secure, encrypted internet connections
• Access to servers in multiple locations worldwide
• Protection of your online privacy and anonymity
• Bypass of geographic restrictions where legally permitted
• Protection on public Wi-Fi networks

We reserve the right to modify, suspend, or discontinue any aspect of the service at any time.''',
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            _buildSection(
              title: '3. User Responsibilities',
              content: '''You agree to use our service responsibly and legally. You must NOT use our service to:

• Engage in any illegal activities
• Transmit malware, viruses, or harmful code
• Infringe on intellectual property rights
• Harass, abuse, or harm others
• Spam or send unsolicited communications
• Attempt to breach security of any network
• Access content that is illegal in your jurisdiction

Violation of these terms may result in immediate termination of your account.''',
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            _buildSection(
              title: '4. Account Registration',
              content: '''To use certain features, you may need to create an account. You agree to:

• Provide accurate and complete information
• Maintain the security of your account credentials
• Notify us immediately of any unauthorized access
• Accept responsibility for all activities under your account

You must be at least 18 years old to create an account.''',
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            _buildSection(
              title: '5. Payment and Refunds',
              content: '''For premium subscriptions:

• Payment is due at the beginning of each billing period
• Subscriptions auto-renew unless cancelled
• Refund requests are handled on a case-by-case basis
• We offer a 30-day money-back guarantee for new users
• Prices may change with 30 days notice''',
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            _buildSection(
              title: '6. Intellectual Property',
              content: '''All content, features, and functionality of our service are owned by us and protected by international copyright, trademark, and other intellectual property laws.

You may not reproduce, distribute, modify, or create derivative works without our express written permission.''',
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            _buildSection(
              title: '7. Limitation of Liability',
              content: '''Our service is provided "as is" without warranties of any kind. We are not liable for:

• Service interruptions or downtime
• Data loss or security breaches beyond our control
• Actions taken by third parties
• Indirect, incidental, or consequential damages

Our total liability shall not exceed the amount paid by you in the past 12 months.''',
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            _buildSection(
              title: '8. Termination',
              content: '''We may terminate or suspend your account immediately, without prior notice, for any breach of these Terms. Upon termination:

• Your right to use the service will cease immediately
• You remain liable for all charges incurred
• Provisions that should survive termination will remain in effect''',
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            _buildSection(
              title: '9. Changes to Terms',
              content: '''We reserve the right to modify these terms at any time. We will notify users of significant changes via email or in-app notification. Continued use of the service after changes constitutes acceptance of the new terms.''',
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            _buildSection(
              title: '10. Contact Information',
              content: '''For questions about these Terms of Service, please contact us:

Email: legal@vpnapp.com
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

