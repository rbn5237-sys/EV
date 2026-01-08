import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US');
  
  Locale get locale => _locale;
  
  String get currentLanguage {
    if (_locale.countryCode == 'Roman') return 'Roman Urdu';
    if (_locale.languageCode == 'ur') return 'اردو';
    return 'English';
  }

  bool get isUrdu => _locale.languageCode == 'ur' && _locale.countryCode != 'Roman';
  bool get isRomanUrdu => _locale.countryCode == 'Roman';
  bool get isEnglish => _locale.languageCode == 'en';

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('language_code') ?? 'en';
    final countryCode = prefs.getString('country_code') ?? 'US';
    _locale = Locale(langCode, countryCode);
    notifyListeners();
  }

  Future<void> setLanguage(String langCode, String countryCode) async {
    _locale = Locale(langCode, countryCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', langCode);
    await prefs.setString('country_code', countryCode);
    notifyListeners();
  }

  Future<void> setEnglish() async {
    await setLanguage('en', 'US');
  }

  Future<void> setUrdu() async {
    await setLanguage('ur', 'PK');
  }

  Future<void> setRomanUrdu() async {
    await setLanguage('ur', 'Roman');
  }
}
