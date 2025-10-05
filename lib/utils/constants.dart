/// Constantes globales de l'application
class AppConstants {
  // Configuration du jeu
  static const int maxLives = 5;
  static const int lifeRegenerationTime = 600; // 10 minutes en secondes
  static const int maxLevels = 100;
  static const int maxWorlds = 10;
  static const int levelsPerWorld = 10;

  // Configuration des achievements
  static const int maxStarsPerLevel = 3;
  static const int perfectLevelBonus = 50;
  static const int streakBonus = 10;

  // Configuration des animations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  // Configuration des timers
  static const Duration gameTimerInterval = Duration(seconds: 1);
  static const Duration lifeTimerInterval = Duration(seconds: 1);

  // Configuration des scores
  static const int baseScorePerMatch = 10;
  static const int comboMultiplier = 2;
  static const int maxComboMultiplier = 10;

  // Configuration des récompenses
  static const int baseCoinReward = 10;
  static const int baseGemReward = 1;
  static const int perfectLevelGemBonus = 2;

  // Configuration des publicités
  static const int levelsBetweenAds = 3;
  static const Duration adCooldown = Duration(minutes: 2);

  // Configuration de la sauvegarde
  static const String userDataKey = 'user_data';
  static const String settingsKey = 'settings';
  static const String progressionKey = 'progression';

  // Configuration des thèmes
  static const String lightThemeKey = 'light_theme';
  static const String darkThemeKey = 'dark_theme';
  static const String systemThemeKey = 'system_theme';

  // Configuration des langues
  static const String defaultLanguage = 'fr';
  static const List<String> supportedLanguages = ['fr', 'en'];

  // Configuration des niveaux
  static const Map<int, int> levelDifficultyThresholds = {
    1: 3, // Facile pour les niveaux 1-3
    11: 2, // Moyen pour les niveaux 11-20
    21: 1, // Difficile pour les niveaux 21+
  };

  // Configuration des mondes
  static const Map<int, String> worldThemes = {
    1: 'garden',
    2: 'valley',
    3: 'forest',
    4: 'meadow',
    5: 'caverns',
    6: 'swamps',
    7: 'lands',
    8: 'glacier',
    9: 'rainbow',
    10: 'celestial',
  };
}

/// Constantes pour les types d'événements
class EventConstants {
  static const String dailyRewardEvent = 'daily_reward';
  static const String weeklyChallengeEvent = 'weekly_challenge';
  static const String specialEvent = 'special_event';
  static const String worldUnlockEvent = 'world_unlock';
}

/// Constantes pour les types d'achievements
class AchievementConstants {
  static const String progressionCategory = 'progression';
  static const String scoreCategory = 'score';
  static const String perfectCategory = 'perfect';
  static const String comboCategory = 'combo';
  static const String streakCategory = 'streak';
  static const String socialCategory = 'social';
  static const String worldCategory = 'world';
}


