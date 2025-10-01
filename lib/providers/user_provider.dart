import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  // Données utilisateur
  String? _userId;
  String _username = '';
  int _level = 1;
  int _experience = 0;
  int _coins = 100;
  int _gems = 10;
  int _lives = 5;
  int _maxLives = 5;
  DateTime? _lastLifeRefill;
  int _currentStreak = 0;
  int _bestStreak = 0;
  List<int> _completedLevels = [];
  final Map<int, int> _levelStars = {}; // levelId -> stars (0-3)

  // Suivi des achievements
  int _bestScore = 0;
  int _bestCombo = 0;
  int _totalScore = 0;
  int _perfectLevels = 0; // Niveaux avec 3 étoiles
  int _shareCount = 0;

  // Paramètres de jeu
  bool _animationsEnabled = true;
  bool _vibrationsEnabled = true;
  bool _autoHintsEnabled = false;
  bool _debugModeEnabled = false;
  bool _tutorialCompleted = false;

  // Timer pour la régénération des vies (en secondes)
  // Ce minuteur compte le temps jusqu'à la prochaine régénération de vie
  Timer? _lifeTimer;
  int _timeUntilNextLife = 0; // en secondes

  // Getters
  String? get userId => _userId;
  String get username => _username;
  int get level => _level;
  int get experience => _experience;
  int get coins => _coins;
  int get gems => _gems;
  int get lives => _lives;
  int get maxLives => _maxLives;
  DateTime? get lastLifeRefill => _lastLifeRefill;
  int get timeUntilNextLife => _timeUntilNextLife;
  int get currentStreak => _currentStreak;
  int get bestStreak => _bestStreak;
  List<int> get completedLevels => _completedLevels;
  int get levelsCompleted => _completedLevels.length;
  Map<int, int> get levelStars => _levelStars;

  // Getters pour les achievements
  int get bestScore => _bestScore;
  int get bestCombo => _bestCombo;
  int get totalScore => _totalScore;
  int get perfectLevels => _perfectLevels;
  int get shareCount => _shareCount;

  // Getters pour les paramètres
  bool get animationsEnabled => _animationsEnabled;
  bool get vibrationsEnabled => _vibrationsEnabled;
  bool get autoHintsEnabled => _autoHintsEnabled;
  bool get debugModeEnabled => _debugModeEnabled;
  bool get tutorialCompleted => _tutorialCompleted;

  // Initialiser l'utilisateur
  Future<void> initializeUser() async {
    final prefs = await SharedPreferences.getInstance();

    _userId = prefs.getString('userId');
    _username = prefs.getString('username') ?? 'Joueur';
    _level = prefs.getInt('level') ?? 1;
    _experience = prefs.getInt('experience') ?? 0;
    _coins = prefs.getInt('coins') ?? 100;
    _gems = prefs.getInt('gems') ?? 10;
    _lives = prefs.getInt('lives') ?? 5;
    _maxLives = prefs.getInt('maxLives') ?? 5;

    final lastRefill = prefs.getString('lastLifeRefill');
    _lastLifeRefill = lastRefill != null ? DateTime.parse(lastRefill) : null;

    // Charger les paramètres
    _animationsEnabled = prefs.getBool('animationsEnabled') ?? true;
    _vibrationsEnabled = prefs.getBool('vibrationsEnabled') ?? true;
    _autoHintsEnabled = prefs.getBool('autoHintsEnabled') ?? false;
    _debugModeEnabled = prefs.getBool('debugModeEnabled') ?? false;
    _tutorialCompleted = prefs.getBool('tutorialCompleted') ?? false;

    _currentStreak = prefs.getInt('currentStreak') ?? 0;
    _bestStreak = prefs.getInt('bestStreak') ?? 0;

    final completedLevelsString = prefs.getString('completedLevels');
    if (completedLevelsString != null) {
      _completedLevels = completedLevelsString
          .split(',')
          .where((s) => s.isNotEmpty)
          .map((s) => int.parse(s))
          .toList();
    }

    // Charger les étoiles des niveaux
    final levelStarsString = prefs.getString('levelStars');
    if (levelStarsString != null) {
      final pairs = levelStarsString.split(',');
      for (final pair in pairs) {
        if (pair.isNotEmpty) {
          final parts = pair.split(':');
          if (parts.length == 2) {
            _levelStars[int.parse(parts[0])] = int.parse(parts[1]);
          }
        }
      }
    }

    // Charger les données d'achievements
    _bestScore = prefs.getInt('bestScore') ?? 0;
    _bestCombo = prefs.getInt('bestCombo') ?? 0;
    _totalScore = prefs.getInt('totalScore') ?? 0;
    _perfectLevels = prefs.getInt('perfectLevels') ?? 0;
    _shareCount = prefs.getInt('shareCount') ?? 0;

    // Vérifier le remplissage des vies
    _checkLifeRefill();

    // Démarrer le timer de régénération
    _startLifeTimer();

    notifyListeners();
  }

  // Sauvegarder les données utilisateur
  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('userId', _userId ?? '');
    await prefs.setString('username', _username);
    await prefs.setInt('level', _level);
    await prefs.setInt('experience', _experience);
    await prefs.setInt('coins', _coins);
    await prefs.setInt('gems', _gems);
    await prefs.setInt('lives', _lives);
    await prefs.setInt('maxLives', _maxLives);

    if (_lastLifeRefill != null) {
      await prefs.setString(
          'lastLifeRefill', _lastLifeRefill!.toIso8601String());
    }

    await prefs.setInt('currentStreak', _currentStreak);
    await prefs.setInt('bestStreak', _bestStreak);

    await prefs.setString('completedLevels', _completedLevels.join(','));

    final levelStarsString =
        _levelStars.entries.map((e) => '${e.key}:${e.value}').join(',');
    await prefs.setString('levelStars', levelStarsString);

    // Sauvegarder les données d'achievements
    await prefs.setInt('bestScore', _bestScore);
    await prefs.setInt('bestCombo', _bestCombo);
    await prefs.setInt('totalScore', _totalScore);
    await prefs.setInt('perfectLevels', _perfectLevels);
    await prefs.setInt('shareCount', _shareCount);

    // Sauvegarder les paramètres
    await prefs.setBool('animationsEnabled', _animationsEnabled);
    await prefs.setBool('vibrationsEnabled', _vibrationsEnabled);
    await prefs.setBool('autoHintsEnabled', _autoHintsEnabled);
    await prefs.setBool('debugModeEnabled', _debugModeEnabled);
    await prefs.setBool('tutorialCompleted', _tutorialCompleted);
  }

  // Mettre à jour le nom d'utilisateur
  Future<void> updateUsername(String newUsername) async {
    _username = newUsername;
    await _saveUserData();
    notifyListeners();
  }

  // Ajouter de l'expérience
  Future<void> addExperience(int amount) async {
    _experience += amount;

    // Vérifier le passage de niveau
    final experienceNeeded = _level * 100;
    if (_experience >= experienceNeeded) {
      _level++;
      _experience -= experienceNeeded;
      // Récompenses de niveau
      _coins += _level * 10;
      _gems += 1;
    }

    await _saveUserData();
    notifyListeners();
  }

  // Ajouter des pièces
  Future<void> addCoins(int amount) async {
    _coins += amount;
    await _saveUserData();
    notifyListeners();
  }

  // Dépenser des pièces
  Future<bool> spendCoins(int amount) async {
    if (_coins >= amount) {
      _coins -= amount;
      await _saveUserData();
      notifyListeners();
      return true;
    }
    return false;
  }

  // Ajouter des gemmes
  Future<void> addGems(int amount) async {
    _gems += amount;
    await _saveUserData();
    notifyListeners();
  }

  // Dépenser des gemmes
  Future<bool> spendGems(int amount) async {
    if (_gems >= amount) {
      _gems -= amount;
      await _saveUserData();
      notifyListeners();
      return true;
    }
    return false;
  }

  // Utiliser une vie
  Future<bool> useLife() async {
    if (_lives > 0) {
      _lives--;

      // Redémarrer le timer si c'est la première vie utilisée
      if (_lives == _maxLives - 1) {
        _lastLifeRefill = DateTime.now();
        _startLifeTimer();
      }

      await _saveUserData();
      notifyListeners();
      return true;
    }
    return false;
  }

  // Réinitialiser la série de victoires (en cas d'échec)
  Future<void> resetStreak() async {
    _currentStreak = 0;
    await _saveUserData();
    notifyListeners();
  }

  // Mettre à jour le meilleur combo
  Future<void> updateBestCombo(int combo) async {
    if (combo > _bestCombo) {
      _bestCombo = combo;
      await _saveUserData();
      notifyListeners();
    }
  }

  // Incrémenter le compteur de partages
  Future<void> incrementShareCount() async {
    _shareCount++;
    await _saveUserData();
    notifyListeners();
  }

  // Ajouter des vies
  Future<void> addLives(int amount) async {
    _lives = (_lives + amount).clamp(0, _maxLives);
    await _saveUserData();
    notifyListeners();
  }

  // Remplir les vies
  Future<void> refillLives() async {
    _lives = _maxLives;
    _lastLifeRefill = DateTime.now();
    await _saveUserData();
    notifyListeners();
  }

  // Forcer la vérification des vies (à appeler quand l'app revient au premier plan)
  Future<void> checkLifeRegeneration() async {
    _checkLifeRefill();
    _updateTimeUntilNextLife();
    notifyListeners();
  }

  // Vérifier le remplissage automatique des vies
  void _checkLifeRefill() {
    if (_lastLifeRefill == null) {
      // Si c'est la première fois, initialiser la dernière régénération
      _lastLifeRefill = DateTime.now();
      _saveUserData();
      return;
    }

    if (_lives >= _maxLives) return;

    final now = DateTime.now();
    final timeSinceLastRefill = now.difference(_lastLifeRefill!);
    const refillTimeSeconds = 600; // 10 minutes (10 * 60 = 600 secondes)

    // Calculer combien de vies peuvent être ajoutées
    final livesToAdd = timeSinceLastRefill.inSeconds ~/ refillTimeSeconds;

    if (livesToAdd > 0) {
      final oldLives = _lives;
      _lives = (_lives + livesToAdd).clamp(0, _maxLives);

      // Mettre à jour la dernière régénération
      final actualLivesAdded = _lives - oldLives;
      if (actualLivesAdded > 0) {
        _lastLifeRefill = _lastLifeRefill!
            .add(Duration(seconds: actualLivesAdded * refillTimeSeconds));
        _saveUserData();

        // Debug pour voir la régénération
        if (kDebugMode) {
          print(
              '🔄 VIE AJOUTÉE: +$actualLivesAdded vie(s). Total: $_lives/$_maxLives');
        }
      }
    }
  }

  // Démarrer le timer de régénération des vies
  void _startLifeTimer() {
    _lifeTimer?.cancel();

    if (_lives < _maxLives) {
      _updateTimeUntilNextLife();

      // 🔧 CORRECTION: Timer optimisé pour éviter la boucle infinie
      _lifeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_lives >= _maxLives) {
          timer.cancel();
          _timeUntilNextLife = 0;
          notifyListeners();
          return;
        }

        // Sauvegarder l'état précédent
        final previousLives = _lives;
        final previousTime = _timeUntilNextLife;

        // Vérifier la régénération et mettre à jour le temps
        _checkLifeRefill();
        _updateTimeUntilNextLife();

        // Si le temps est écoulé, ajouter une vie
        if (_timeUntilNextLife <= 0 && _lives < _maxLives) {
          _addLifeFromTimer();
        }

        // Notifier seulement si quelque chose a vraiment changé
        if (_lives != previousLives ||
            (_timeUntilNextLife - previousTime).abs() >= 5) {
          notifyListeners();
        }
      });
    }
  }

  // Mettre à jour le temps restant jusqu'à la prochaine vie
  void _updateTimeUntilNextLife() {
    if (_lastLifeRefill == null || _lives >= _maxLives) {
      _timeUntilNextLife = 0;
      return;
    }

    final now = DateTime.now();
    final timeSinceLastRefill = now.difference(_lastLifeRefill!);
    const refillTimeSeconds = 600; // 10 minutes (10 * 60 = 600 secondes)

    final elapsedSeconds = timeSinceLastRefill.inSeconds;

    // Calculer le temps restant pour la prochaine vie
    final remainingSeconds =
        refillTimeSeconds - (elapsedSeconds % refillTimeSeconds);
    _timeUntilNextLife = remainingSeconds.clamp(0, refillTimeSeconds);

    // Debug pour voir le temps restant
    if (kDebugMode) {
      print('⏰ VIE: ${_timeUntilNextLife}s restantes pour la prochaine vie');
    }
  }

  // Ajouter une vie depuis le timer
  void _addLifeFromTimer() {
    if (_lives < _maxLives) {
      _lives++;
      _lastLifeRefill = DateTime.now();
      _timeUntilNextLife = 0;
      _saveUserData();

      // Debug pour voir l'ajout de vie
      if (kDebugMode) {
        print('🔄 VIE AJOUTÉE (Timer): +1 vie. Total: $_lives/$_maxLives');
      }

      // Si on a atteint le maximum, arrêter le timer
      if (_lives >= _maxLives) {
        _stopLifeTimer();
      }
    }
  }

  // Arrêter le timer
  void _stopLifeTimer() {
    _lifeTimer?.cancel();
    _lifeTimer = null;
  }

  // Nettoyer les ressources
  @override
  void dispose() {
    _stopLifeTimer();
    super.dispose();
  }

  // Mettre à jour la série
  Future<void> updateStreak(bool won) async {
    if (won) {
      _currentStreak++;
      if (_currentStreak > _bestStreak) {
        _bestStreak = _currentStreak;
      }
    } else {
      _currentStreak = 0;
    }

    await _saveUserData();
    notifyListeners();
  }

  // Compléter un niveau
  Future<void> completeLevel(int levelId, int stars, int score) async {
    if (!_completedLevels.contains(levelId)) {
      _completedLevels.add(levelId);

      // Debug: Afficher les informations de débogage (commenté pour production)
      // if (kDebugMode) {
      //   print('=== DEBUG LEVEL COMPLETION ===');
      //   print('Level $levelId completed!');
      //   print('Updated completed levels: $_completedLevels');
      //   print(
      //       'Next level ($levelId + 1) should be unlocked: ${_completedLevels.contains(levelId)}');
      //   print('=============================');
      // }
    }

    // Mettre à jour la série de victoires
    _currentStreak++;
    if (_currentStreak > _bestStreak) {
      _bestStreak = _currentStreak;
    }

    // Mettre à jour les étoiles si meilleur score
    final currentStars = _levelStars[levelId] ?? 0;
    if (stars > currentStars) {
      _levelStars[levelId] = stars;
    }

    // Mettre à jour les achievements
    if (score > _bestScore) {
      _bestScore = score;
    }
    _totalScore += score;

    if (stars == 3) {
      _perfectLevels++;
    }

    // Système de récompenses amélioré et plus généreux
    int baseReward = 30 + (levelId * 5); // Augmenté significativement
    int starBonus = stars * 20; // Doublé pour encourager la perfection
    int scoreBonus = (score / 500).floor(); // Plus généreux

    // Bonus de série considérablement augmenté
    int streakBonus =
        _currentStreak > 0 ? (_currentStreak * 10).clamp(0, 100) : 0;

    // Bonus de niveau du joueur
    int levelBonus = _level * 5;

    // Bonus de difficulté augmenté
    int difficultyBonus = _calculateDifficultyBonus(levelId);

    // Bonus de première completion (très généreux)
    int firstTimeBonus =
        !_completedLevels.contains(levelId) ? (levelId * 10) : 0;

    // Bonus de performance (nouveau)
    int performanceBonus = 0;
    if (stars == 3) {
      performanceBonus = levelId * 15; // Bonus important pour 3 étoiles
    } else if (stars == 2) {
      performanceBonus = levelId * 8;
    } else if (stars == 1) {
      performanceBonus = levelId * 3;
    }

    int totalReward = baseReward +
        starBonus +
        scoreBonus +
        streakBonus +
        levelBonus +
        difficultyBonus +
        firstTimeBonus +
        performanceBonus;

    _coins += totalReward;

    // Récompenses spéciales améliorées
    if (stars == 3) {
      _gems += 2; // Augmenté de 1 à 2 gemmes pour 3 étoiles
      // Pas de bonus de vies pour éviter la confusion
    }

    if (stars >= 2) {
      _gems += 1; // Gemme pour 2+ étoiles
    }

    // Bonus de série généreux
    if (_currentStreak >= 3) {
      _gems += 1;
    }
    if (_currentStreak >= 5) {
      _gems += 2;
      // Pas de bonus de vies pour éviter la confusion
    }
    if (_currentStreak >= 10) {
      _gems += 5;
      // Pas de bonus de vies pour éviter la confusion
    }

    // Bonus de milestone de niveau
    if (levelId % 5 == 0) {
      _gems += levelId ~/ 5; // Plus de gemmes pour les niveaux multiples de 5
      _coins += levelId * 10; // Bonus de pièces pour les milestones
    }

    if (levelId % 10 == 0) {
      _gems += 5; // Gros bonus pour les niveaux multiples de 10
      // Pas de bonus de vies pour éviter la confusion
    }

    // Ajouter de l'expérience pour la progression
    int experienceGain = (levelId * 2) + (stars * 10) + (score / 1000).floor();
    await addExperience(experienceGain);

    await _saveUserData();
    notifyListeners();
  }

  // Calculer le bonus de difficulté
  int _calculateDifficultyBonus(int levelId) {
    if (levelId <= 5) return 10; // Bonus d'encouragement pour débutants
    if (levelId <= 10) return 20; // Niveaux faciles
    if (levelId <= 15) return 35; // Transition vers moyen
    if (levelId <= 20) return 50; // Niveaux moyens
    if (levelId <= 30) return 75; // Niveaux difficiles
    if (levelId <= 40) return 100; // Niveaux très difficiles
    return 150; // Niveaux experts - bonus maximum
  }

  // Vérifier si un niveau est débloqué
  bool isLevelUnlocked(int levelId) {
    if (levelId == 1) return true;

    // PRODUCTION: Mode debug désactivé pour la version finale
    // if (_debugModeEnabled) return true;

    return _completedLevels.contains(levelId - 1);
  }

  // Obtenir les étoiles d'un niveau
  int getLevelStars(int levelId) {
    return _levelStars[levelId] ?? 0;
  }

  // Marquer le tutoriel comme terminé
  Future<void> completeTutorial() async {
    _tutorialCompleted = true;
    await _saveUserData();
    notifyListeners();
  }

  // Vérifier si le tutoriel est terminé
  Future<bool> isTutorialCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('tutorialCompleted') ?? false;
  }

  // Gestion des paramètres de jeu
  Future<void> setAnimationsEnabled(bool enabled) async {
    _animationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('animationsEnabled', enabled);
    notifyListeners();
  }

  Future<void> setVibrationsEnabled(bool enabled) async {
    _vibrationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibrationsEnabled', enabled);
    notifyListeners();
  }

  Future<void> setAutoHintsEnabled(bool enabled) async {
    _autoHintsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoHintsEnabled', enabled);
    notifyListeners();
  }

  // Méthodes publiques pour la sauvegarde/restauration
  Future<void> saveUserData() async {
    await _saveUserData();
  }

  Future<void> loadUserData() async {
    await initializeUser();
  }

  // Réinitialiser les données utilisateur (pour les tests)
  Future<void> resetUserData() async {
    _level = 1;
    _experience = 0;
    _coins = 100;
    _gems = 10;
    _lives = 5;
    _maxLives = 5;
    _lastLifeRefill = null;
    _currentStreak = 0;
    _bestStreak = 0;
    _completedLevels.clear();
    _debugModeEnabled = false; // Désactiver le mode debug lors du reset
    _levelStars.clear();

    await _saveUserData();
    notifyListeners();
  }

  // Méthode de débogage pour vérifier l'état des niveaux (commentée pour production)
  // void debugLevelStatus() {
  //   if (kDebugMode) {
  //     print('=== LEVEL STATUS DEBUG ===');
  //     print('Completed levels: $_completedLevels');
  //     print('Level stars: $_levelStars');

  //     // Vérifier les premiers 10 niveaux
  //     for (int i = 1; i <= 10; i++) {
  //       final isUnlocked = isLevelUnlocked(i);
  //       final stars = getLevelStars(i);
  //       print('Level $i: Unlocked=$isUnlocked, Stars=$stars');
  //     }
  //     print('========================');
  //   }
  // }

  // Méthode pour débloquer manuellement un niveau (commentée pour production)
  // Future<void> unlockLevel(int levelId) async {
  //   if (!_completedLevels.contains(levelId)) {
  //     _completedLevels.add(levelId);
  //     await _saveUserData();
  //     notifyListeners();

  //     if (kDebugMode) {
  //       print('Level $levelId manually unlocked');
  //     }
  //   }
  // }

  // 🚀 FONCTIONNALITÉS DEBUG (commentées pour la version de production)

  /// Active ou désactive le mode debug pour déverrouiller tous les niveaux
  // Future<void> toggleDebugMode() async {
  //   _debugModeEnabled = !_debugModeEnabled;
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('debugModeEnabled', _debugModeEnabled);
  //   notifyListeners();

  //   if (kDebugMode) {
  //     print('Debug mode ${_debugModeEnabled ? "enabled" : "disabled"}');
  //   }
  // }
}
