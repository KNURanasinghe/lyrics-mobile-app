import 'package:flutter/material.dart';
import 'package:lyrics/widgets/main_background.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = 'English'; // Default selected language

  final List<String> languages = ['Sinhala', 'English', 'Tamil'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Language',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3A5F), // Dark blue color
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: MainBAckgound(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Language options
              ...languages.map(
                (language) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedLanguage = language;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color:
                            selectedLanguage == language
                                ? Colors.white.withOpacity(0.1)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            selectedLanguage == language
                                ? Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                )
                                : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            language,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight:
                                  selectedLanguage == language
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                            ),
                          ),
                          if (selectedLanguage == language)
                            const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
