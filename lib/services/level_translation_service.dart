import 'dart:ui';
import '../l10n/level_translations_fr.dart';
import '../l10n/level_translations_en.dart';

/// Service de traduction pour les niveaux
class LevelTranslationService {
  static const Map<String, String> _frenchTranslations = levelTranslationsFr;
  static const Map<String, String> _englishTranslations = levelTranslationsEn;

  /// Récupère le nom traduit d'un niveau
  static String getLevelName(int levelId, Locale locale) {
    final key = 'level_${levelId}_name';

    switch (locale.languageCode) {
      case 'en':
        return _englishTranslations[key] ?? 'Level $levelId';
      case 'fr':
      default:
        return _frenchTranslations[key] ?? 'Niveau $levelId';
    }
  }

  /// Récupère la description traduite d'un niveau
  static String getLevelDescription(int levelId, Locale locale) {
    final key = 'level_${levelId}_description';

    switch (locale.languageCode) {
      case 'en':
        return _englishTranslations[key] ?? 'Complete this challenging level';
      case 'fr':
      default:
        return _frenchTranslations[key] ?? 'Terminez ce niveau difficile';
    }
  }

  /// Vérifie si une traduction existe pour un niveau
  static bool hasTranslation(int levelId, Locale locale) {
    final key = 'level_${levelId}_name';

    switch (locale.languageCode) {
      case 'en':
        return _englishTranslations.containsKey(key);
      case 'fr':
      default:
        return _frenchTranslations.containsKey(key);
    }
  }

  /// Récupère toutes les traductions disponibles pour un niveau
  static Map<String, String> getAllTranslations(int levelId) {
    return {
      'fr': getLevelName(levelId, const Locale('fr')),
      'en': getLevelName(levelId, const Locale('en')),
    };
  }
}
