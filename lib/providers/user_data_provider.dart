import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mind_bloom/utils/error_handler.dart';
import 'package:mind_bloom/utils/batch_saver.dart';

/// Provider pour les données de base de l'utilisateur
class UserDataProvider extends ChangeNotifier {
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

  /// Initialise les données utilisateur
  Future<void> initialize() async {
    try {
      // Charger depuis SharedPreferences via BatchSaver
      // Cette logique sera implémentée avec BatchSaver

      if (kDebugMode) {
        debugPrint('👤 [UserDataProvider] Initialisé');
      }
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace,
          context: 'UserDataProvider.initialize');
    }
  }

  /// Met à jour le nom d'utilisateur
  Future<void> updateUsername(String newUsername) async {
    _username = newUsername;
    BatchSaver.queueChange('username', _username);
    notifyListeners();
  }

  /// Ajoute de l'expérience
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

      BatchSaver.queueChange('level', _level);
      BatchSaver.queueChange('coins', _coins);
      BatchSaver.queueChange('gems', _gems);
    }

    BatchSaver.queueChange('experience', _experience);
    notifyListeners();
  }

  /// Ajoute des pièces
  Future<void> addCoins(int amount) async {
    _coins += amount;
    BatchSaver.queueChange('coins', _coins);
    notifyListeners();
  }

  /// Dépense des pièces
  Future<bool> spendCoins(int amount) async {
    if (_coins >= amount) {
      _coins -= amount;
      BatchSaver.queueChange('coins', _coins);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Ajoute des gemmes
  Future<void> addGems(int amount) async {
    _gems += amount;
    BatchSaver.queueChange('gems', _gems);
    notifyListeners();
  }

  /// Dépense des gemmes
  Future<bool> spendGems(int amount) async {
    if (_gems >= amount) {
      _gems -= amount;
      BatchSaver.queueChange('gems', _gems);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Utilise une vie
  Future<bool> useLife() async {
    if (_lives > 0) {
      _lives--;
      BatchSaver.queueChange('lives', _lives);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Ajoute des vies
  Future<void> addLives(int amount) async {
    final newLives = (_lives + amount).clamp(0, _maxLives);
    final actualLivesAdded = newLives - _lives;
    _lives = newLives;

    if (actualLivesAdded > 0) {
      BatchSaver.queueChange('lives', _lives);
      notifyListeners();
    }
  }

  /// Met à jour la série
  Future<void> updateStreak(int newStreak) async {
    _currentStreak = newStreak;
    if (newStreak > _bestStreak) {
      _bestStreak = newStreak;
      BatchSaver.queueChange('bestStreak', _bestStreak);
    }
    BatchSaver.queueChange('currentStreak', _currentStreak);
    notifyListeners();
  }

  /// Met à jour la dernière régénération de vie
  Future<void> updateLastLifeRefill(DateTime dateTime) async {
    _lastLifeRefill = dateTime;
    BatchSaver.queueChange('lastLifeRefill', dateTime.toIso8601String());
    notifyListeners();
  }
}
