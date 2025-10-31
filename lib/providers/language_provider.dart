import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  static const String _localeKey = 'app_language';

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_localeKey);

      if (languageCode != null) {
        _currentLocale = Locale(languageCode);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading saved locale: $e');
    }
  }

  Future<void> setLocale(Locale locale) async {
    try {
      _currentLocale = locale;
      notifyListeners();

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
    } catch (e) {
      print('Error saving locale: $e');
    }
  }

  Future<void> toggleLanguage() async {
    if (_currentLocale.languageCode == 'en') {
      await setLocale(const Locale('es'));
    } else {
      await setLocale(const Locale('en'));
    }
  }

  String getCurrentLanguageName() {
    switch (_currentLocale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'nl':
        return 'Nederlands';
      case 'ar':
        return 'العربية';
      case 'zh':
        return '中文';
      default:
        return 'English';
    }
  }

  String getCurrentLanguageFlag() {
    switch (_currentLocale.languageCode) {
      case 'en':
        return '🇺🇸';
      case 'es':
        return '🇪🇸';
      case 'fr':
        return '🇫🇷';
      case 'de':
        return '🇩🇪';
      case 'nl':
        return '🇳🇱';
      case 'ar':
        return '🇸🇦';
      case 'zh':
        return '🇨🇳';
      default:
        return '🌐';
    }
  }
}
