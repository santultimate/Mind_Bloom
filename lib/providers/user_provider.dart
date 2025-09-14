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

  // Paramètres de jeu
  bool _animationsEnabled = true;
  bool _vibrationsEnabled = true;
  bool _autoHintsEnabled = false;

  // Timer pour la régénération des vies
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
  int get currentStreak => _currentStreak;
  int get bestStreak => _bestStreak;
  List<int> get completedLevels => _completedLevels;
  int get levelsCompleted => _completedLevels.length;
  Map<int, int> get levelStars => _levelStars;

  // Getters pour les paramètres
  bool get animationsEnabled => _animationsEnabled;
  bool get vibrationsEnabled => _vibrationsEnabled;
  bool get autoHintsEnabled => _autoHintsEnabled;
  int get timeUntilNextLife => _timeUntilNextLife;

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

  // Vérifier le remplissage automatique des vies
  void _checkLifeRefill() {
    if (_lastLifeRefill == null || _lives >= _maxLives) return;

    final now = DateTime.now();
    final timeSinceLastRefill = now.difference(_lastLifeRefill!);
    const refillTime = Duration(minutes: 30); // 30 minutes par vie

    final livesToAdd = timeSinceLastRefill.inMinutes ~/ refillTime.inMinutes;
    if (livesToAdd > 0) {
      _lives = (_lives + livesToAdd).clamp(0, _maxLives);
      _lastLifeRefill = now;
      _saveUserData();
    }
  }

  // Démarrer le timer de régénération des vies
  void _startLifeTimer() {
    _lifeTimer?.cancel();

    if (_lives < _maxLives) {
      _updateTimeUntilNextLife();

      _lifeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_lives >= _maxLives) {
          timer.cancel();
          _timeUntilNextLife = 0;
          notifyListeners();
          return;
        }

        _updateTimeUntilNextLife();

        if (_timeUntilNextLife <= 0) {
          _addLifeFromTimer();
        }

        notifyListeners();
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
    const refillTime = Duration(minutes: 30); // 30 minutes par vie

    final totalSeconds = refillTime.inSeconds;
    final elapsedSeconds = timeSinceLastRefill.inSeconds;

    _timeUntilNextLife =
        (totalSeconds - (elapsedSeconds % totalSeconds)).clamp(0, totalSeconds);
  }

  // Ajouter une vie depuis le timer
  void _addLifeFromTimer() {
    if (_lives < _maxLives) {
      _lives++;
      _lastLifeRefill = DateTime.now();
      _saveUserData();

      if (kDebugMode) {
        print('Vie ajoutée automatiquement. Vies actuelles: $_lives');
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
    }

    // Mettre à jour les étoiles si meilleur score
    final currentStars = _levelStars[levelId] ?? 0;
    if (stars > currentStars) {
      _levelStars[levelId] = stars;
    }

    // Récompenses basées sur les étoiles (augmentées)
    int baseReward = 20 + (levelId * 2); // Progression avec le niveau
    int starBonus = stars * 10; // Doublé
    int scoreBonus = (score / 1000).floor(); // Bonus de score

    // Bonus de série (augmenté)
    int streakBonus =
        _currentStreak > 0 ? (_currentStreak * 5).clamp(0, 50) : 0;

    // Bonus de niveau
    int levelBonus = _level * 3;

    // Bonus de difficulté
    int difficultyBonus = _calculateDifficultyBonus(levelId);

    int totalReward = baseReward +
        starBonus +
        scoreBonus +
        streakBonus +
        levelBonus +
        difficultyBonus;

    _coins += totalReward;

    // Récompenses spéciales
    if (stars == 3) {
      _gems += 1; // Gemme pour 3 étoiles
    }

    if (_currentStreak >= 5) {
      _gems += 1; // Gemme pour série de 5
    }

    await _saveUserData();
    notifyListeners();
  }

  // Calculer le bonus de difficulté
  int _calculateDifficultyBonus(int levelId) {
    if (levelId <= 10) return 0; // Niveaux faciles
    if (levelId <= 25) return 5; // Niveaux moyens
    if (levelId <= 50) return 10; // Niveaux difficiles
    return 15; // Niveaux experts
  }

  // Vérifier si un niveau est débloqué
  bool isLevelUnlocked(int levelId) {
    if (levelId == 1) return true;
    return _completedLevels.contains(levelId - 1);
  }

  // Obtenir les étoiles d'un niveau
  int getLevelStars(int levelId) {
    return _levelStars[levelId] ?? 0;
  }

  // Marquer le tutoriel comme terminé
  Future<void> completeTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorialCompleted', true);
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
    _levelStars.clear();

    await _saveUserData();
    notifyListeners();
  }
}
