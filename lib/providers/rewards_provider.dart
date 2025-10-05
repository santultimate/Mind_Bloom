import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mind_bloom/utils/error_handler.dart';
import 'package:mind_bloom/utils/batch_saver.dart';

/// Provider unifié pour gérer les récompenses quotidiennes, quêtes et événements
class RewardsProvider extends ChangeNotifier {
  // === RÉCOMPENSES QUOTIDIENNES ===
  DateTime? _lastDailyReward;
  int _dailyRewardStreak = 0;
  bool _dailyRewardClaimed = false;

  // === QUÊTES ===
  final Map<String, int> _questProgress = {};
  final Map<String, bool> _questCompleted = {};
  // === ÉVÉNEMENTS ===
  final Map<String, dynamic> _eventProgress = {};
  bool _eventsEnabled = true;

  // === GETTERS ===
  DateTime? get lastDailyReward => _lastDailyReward;
  int get dailyRewardStreak => _dailyRewardStreak;
  bool get dailyRewardClaimed => _dailyRewardClaimed;
  Map<String, int> get questProgress => Map.unmodifiable(_questProgress);
  Map<String, bool> get questCompleted => Map.unmodifiable(_questCompleted);
  Map<String, dynamic> get eventProgress => Map.unmodifiable(_eventProgress);
  bool get eventsEnabled => _eventsEnabled;

  /// Initialise le provider
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Charger les récompenses quotidiennes
      final lastRewardString = prefs.getString('lastDailyReward');
      _lastDailyReward =
          lastRewardString != null ? DateTime.parse(lastRewardString) : null;
      _dailyRewardStreak = prefs.getInt('dailyRewardStreak') ?? 0;
      _dailyRewardClaimed = prefs.getBool('dailyRewardClaimed') ?? false;

      // Charger les quêtes
      final questProgressString = prefs.getString('questProgress');
      if (questProgressString != null && questProgressString.isNotEmpty) {
        final pairs = questProgressString.split(',');
        for (final pair in pairs) {
          if (pair.isNotEmpty) {
            final parts = pair.split(':');
            if (parts.length == 2) {
              _questProgress[parts[0]] = int.parse(parts[1]);
            }
          }
        }
      }

      final questCompletedString = prefs.getString('questCompleted');
      if (questCompletedString != null && questCompletedString.isNotEmpty) {
        final pairs = questCompletedString.split(',');
        for (final pair in pairs) {
          if (pair.isNotEmpty) {
            final parts = pair.split(':');
            if (parts.length == 2) {
              _questCompleted[parts[0]] = parts[1] == 'true';
            }
          }
        }
      }

      // Charger les événements
      final eventProgressString = prefs.getString('eventProgress');
      if (eventProgressString != null && eventProgressString.isNotEmpty) {
        // Parsing simple pour les événements
        final pairs = eventProgressString.split(',');
        for (final pair in pairs) {
          if (pair.isNotEmpty) {
            final parts = pair.split(':');
            if (parts.length >= 2) {
              final key = parts[0];
              final value = parts.sublist(1).join(':');
              _eventProgress[key] = value;
            }
          }
        }
      }

      _eventsEnabled = prefs.getBool('eventsEnabled') ?? true;

      // Vérifier les récompenses quotidiennes
      _checkDailyRewards();

      if (kDebugMode) {
        debugPrint(
            '🎁 [RewardsProvider] Initialisé avec ${_questProgress.length} quêtes et ${_eventProgress.length} événements');
      }
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace,
          context: 'RewardsProvider.initialize');
    }
  }

  /// Vérifie les récompenses quotidiennes
  void _checkDailyRewards() {
    final now = DateTime.now();
    if (_lastDailyReward == null) {
      // Premier jour
      _dailyRewardClaimed = false;
      return;
    }

    final lastRewardDate = DateTime(
        _lastDailyReward!.year, _lastDailyReward!.month, _lastDailyReward!.day);
    final currentDate = DateTime(now.year, now.month, now.day);

    if (currentDate.isAfter(lastRewardDate)) {
      // Nouveau jour
      _dailyRewardClaimed = false;

      if (currentDate.difference(lastRewardDate).inDays == 1) {
        // Jour suivant, maintenir la série
        _dailyRewardStreak++;
      } else {
        // Plus d'un jour, reset la série
        _dailyRewardStreak = 1;
      }
    }
  }

  /// Réclame la récompense quotidienne
  Future<Map<String, int>> claimDailyReward() async {
    if (_dailyRewardClaimed) {
      throw Exception('Récompense quotidienne déjà réclamée');
    }

    _lastDailyReward = DateTime.now();
    _dailyRewardClaimed = true;

    // Calculer les récompenses basées sur la série
    final baseCoins = 50;
    final baseGems = 2;
    final streakBonus = _dailyRewardStreak * 10;

    final coins = baseCoins + streakBonus;
    final gems = baseGems +
        (_dailyRewardStreak ~/ 7); // Bonus gemmes toutes les 7 séries

    // Sauvegarder
    BatchSaver.queueChange(
        'lastDailyReward', _lastDailyReward!.toIso8601String());
    BatchSaver.queueChange('dailyRewardStreak', _dailyRewardStreak);
    BatchSaver.queueChange('dailyRewardClaimed', _dailyRewardClaimed);

    notifyListeners();

    return {
      'coins': coins,
      'gems': gems,
    };
  }

  /// Met à jour le progrès d'une quête
  Future<void> updateQuestProgress(String questId, int progress) async {
    _questProgress[questId] = progress;

    // Vérifier si la quête est terminée
    if (progress >= _getQuestTarget(questId)) {
      _questCompleted[questId] = true;
    }

    // Sauvegarder
    final progressString =
        _questProgress.entries.map((e) => '${e.key}:${e.value}').join(',');
    final completedString =
        _questCompleted.entries.map((e) => '${e.key}:${e.value}').join(',');

    BatchSaver.queueChange('questProgress', progressString);
    BatchSaver.queueChange('questCompleted', completedString);

    notifyListeners();
  }

  /// Obtient la cible d'une quête
  int _getQuestTarget(String questId) {
    // Définir les cibles des quêtes
    switch (questId) {
      case 'play_levels':
        return 10;
      case 'collect_coins':
        return 500;
      case 'use_powerups':
        return 5;
      case 'complete_world':
        return 1;
      default:
        return 1;
    }
  }

  /// Réinitialise les quêtes quotidiennes
  Future<void> resetDailyQuests() async {
    _questProgress.clear();
    _questCompleted.clear();

    BatchSaver.queueChange('questProgress', '');
    BatchSaver.queueChange('questCompleted', '');

    notifyListeners();
  }

  /// Met à jour le progrès d'un événement
  Future<void> updateEventProgress(String eventId, dynamic progress) async {
    _eventProgress[eventId] = progress;

    // Sauvegarder
    final eventString =
        _eventProgress.entries.map((e) => '${e.key}:${e.value}').join(',');
    BatchSaver.queueChange('eventProgress', eventString);

    notifyListeners();
  }

  /// Active/désactive les événements
  Future<void> setEventsEnabled(bool enabled) async {
    _eventsEnabled = enabled;
    BatchSaver.queueChange('eventsEnabled', enabled);
    notifyListeners();
  }

  /// Obtient les quêtes disponibles
  List<Map<String, dynamic>> getAvailableQuests() {
    return [
      {
        'id': 'play_levels',
        'name': 'Joueur Assidu',
        'description': 'Jouez 10 niveaux',
        'target': _getQuestTarget('play_levels'),
        'progress': _questProgress['play_levels'] ?? 0,
        'reward': {'coins': 100, 'gems': 1},
        'completed': _questCompleted['play_levels'] ?? false,
      },
      {
        'id': 'collect_coins',
        'name': 'Collectionneur',
        'description': 'Collectez 500 pièces',
        'target': _getQuestTarget('collect_coins'),
        'progress': _questProgress['collect_coins'] ?? 0,
        'reward': {'coins': 200, 'gems': 2},
        'completed': _questCompleted['collect_coins'] ?? false,
      },
      {
        'id': 'use_powerups',
        'name': 'Stratège',
        'description': 'Utilisez 5 power-ups',
        'target': _getQuestTarget('use_powerups'),
        'progress': _questProgress['use_powerups'] ?? 0,
        'reward': {'coins': 150, 'gems': 1},
        'completed': _questCompleted['use_powerups'] ?? false,
      },
      {
        'id': 'complete_world',
        'name': 'Explorateur',
        'description': 'Terminez un monde',
        'target': _getQuestTarget('complete_world'),
        'progress': _questProgress['complete_world'] ?? 0,
        'reward': {'coins': 300, 'gems': 3},
        'completed': _questCompleted['complete_world'] ?? false,
      },
    ];
  }

  /// Obtient les événements actifs
  List<Map<String, dynamic>> getActiveEvents() {
    if (!_eventsEnabled) return [];

    return [
      {
        'id': 'weekend_bonus',
        'name': 'Bonus Weekend',
        'description': 'Double récompenses ce weekend',
        'isActive': _isWeekend(),
        'multiplier': 2.0,
      },
      {
        'id': 'streak_challenge',
        'name': 'Défi de Série',
        'description': 'Maintenez une série de 7 jours',
        'isActive': true,
        'progress': _dailyRewardStreak,
        'target': 7,
      },
    ];
  }

  /// Vérifie si c'est le weekend
  bool _isWeekend() {
    final now = DateTime.now();
    return now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
  }

  /// Nettoie les données obsolètes
  Future<void> cleanup() async {
    // Supprimer les événements expirés
    // TODO: Implémenter la logique de nettoyage des événements expirés
  }
}
