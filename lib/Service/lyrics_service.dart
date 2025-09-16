import 'package:shared_preferences/shared_preferences.dart';

// Service to handle "How to Read Lyrics" preferences
class HowToReadLyricsService {
  static const String _lyricsFormatKey = 'lyrics_reading_format';
  static const String _defaultFormat = 'english_only';

  // Save the selected lyrics reading format
  static Future<void> saveLyricsFormat(String format) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lyricsFormatKey, format);
      print('Lyrics format saved: $format');
    } catch (e) {
      print('Error saving lyrics format: $e');
    }
  }

  // Get the saved lyrics reading format
  static Future<String> getLyricsFormat() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_lyricsFormatKey) ?? _defaultFormat;
    } catch (e) {
      print('Error loading lyrics format: $e');
      return _defaultFormat;
    }
  }

  // Get required language codes based on selected format
  static List<String> getRequiredLanguages(String format) {
    switch (format) {
      case 'tamil_only':
        return ['ta'];
      case 'tamil_english':
        return ['ta', 'en'];
      case 'tamil_sinhala':
        return ['ta', 'si'];
      case 'all_three':
        return ['ta', 'si', 'en'];
      case 'english_only':
        return ['en'];
      case 'sinhala_only':
        return ['si'];
      default:
        return ['ta']; // Default to Tamil
    }
  }

  // Get display order for languages (for multi-language formats)
  static List<String> getLanguageDisplayOrder(String format) {
    switch (format) {
      case 'tamil_english':
        return ['ta', 'en'];
      case 'tamil_sinhala':
        return ['ta', 'si']; // Tamil first, then Sinhala as requested
      case 'all_three':
        return ['ta', 'si', 'en']; // Tamil, Sinhala, then English
      case 'tamil_only':
        return ['ta'];
      case 'english_only':
        return ['en'];
      case 'sinhala_only':
        return ['si'];
      default:
        return ['ta'];
    }
  }

  // Get language display name
  static String getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'ta':
        return 'Tamil';
      case 'si':
        return 'Sinhala';
      case 'en':
        return 'English Transliteration';
      default:
        return languageCode.toUpperCase();
    }
  }

  // Check if format requires multiple languages
  static bool isMultiLanguageFormat(String format) {
    return ['tamil_english', 'tamil_sinhala', 'all_three'].contains(format);
  }

  // Get format title for display
  static String getFormatTitle(String format) {
    switch (format) {
      case 'tamil_only':
        return 'Tamil Only';
      case 'tamil_english':
        return 'Tamil + English Transliteration';
      case 'tamil_sinhala':
        return 'Tamil + Sinhala Transliteration';
      case 'all_three':
        return 'All Three Formats';
      case 'english_only':
        return 'English Transliteration Only';
      case 'sinhala_only':
        return 'Sinhala Transliteration Only';
      default:
        return 'Tamil Only';
    }
  }
}
