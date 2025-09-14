import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';

  Locale _currentLocale = const Locale('fr'); // Français par défaut

  Locale get currentLocale => _currentLocale;

  String get currentLanguageCode => _currentLocale.languageCode;

  bool get isEnglish => _currentLocale.languageCode == 'en';
  bool get isFrench => _currentLocale.languageCode == 'fr';

  /// Initialise le provider avec la langue sauvegardée
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);

    if (savedLanguage != null) {
      _currentLocale = Locale(savedLanguage);
    } else {
      // Utiliser la langue du système si disponible
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
      if (systemLocale.languageCode == 'en' ||
          systemLocale.languageCode == 'fr') {
        _currentLocale = systemLocale;
      }
    }

    notifyListeners();
  }

  /// Change la langue de l'application
  Future<void> setLanguage(String languageCode) async {
    if (languageCode != _currentLocale.languageCode) {
      _currentLocale = Locale(languageCode);

      // Sauvegarder la préférence
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);

      notifyListeners();
    }
  }

  /// Bascule entre français et anglais
  Future<void> toggleLanguage() async {
    final newLanguage = isFrench ? 'en' : 'fr';
    await setLanguage(newLanguage);
  }

  /// Obtient le nom de la langue actuelle
  String getCurrentLanguageName() {
    return isFrench ? 'Français' : 'English';
  }

  /// Obtient la liste des langues supportées
  List<Map<String, String>> getSupportedLanguages() {
    return [
      {'code': 'fr', 'name': 'Français'},
      {'code': 'en', 'name': 'English'},
    ];
  }
}
