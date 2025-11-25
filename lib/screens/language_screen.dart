import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = 'English';

  final List<Map<String, String>> languages = [
    {'name': 'English', 'native': 'English', 'code': 'en'},
    {'name': 'Myanmar', 'native': 'မြန်မာ', 'code': 'my'},
    {'name': 'Chinese', 'native': '中文', 'code': 'zh'},
    {'name': 'Thai', 'native': 'ไทย', 'code': 'th'},
    {'name': 'Japanese', 'native': '日本語', 'code': 'ja'},
    {'name': 'Korean', 'native': '한국어', 'code': 'ko'},
    {'name': 'Vietnamese', 'native': 'Tiếng Việt', 'code': 'vi'},
    {'name': 'Hindi', 'native': 'हिन्दी', 'code': 'hi'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          final isSelected = selectedLanguage == language['name'];

          return InkWell(
            onTap: () {
              setState(() {
                selectedLanguage = language['name']!;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Language changed to ${language['name']}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.deepPurple.withOpacity(0.1)
                    : (isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50),
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: Colors.deepPurple, width: 1.5)
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          language['name']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.deepPurple : textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          language['native']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle, color: Colors.deepPurple),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

