import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'selected_language';

  static Future<void> saveLanguage(String language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, language);
    } catch (e) {
      print('Error saving language: $e');
      // You might want to add a fallback storage mechanism here
    }
  }

  static Future<String> getLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_languageKey) ?? 'English';
    } catch (e) {
      print('Error loading language: $e');
      return 'English'; // Default fallback
    }
  }

  static String getLanguageCode(String language) {
    switch (language) {
      case 'Sinhala':
        return 'si';
      case 'Tamil':
        return 'ta';
      case 'English':
      default:
        return 'en';
    }
  }
}
