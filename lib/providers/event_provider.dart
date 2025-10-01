import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_system.dart';

/// Provider pour la gestion des événements avec planification annuelle
class EventProvider extends ChangeNotifier {
  static const String _eventsDataKey = 'annual_events_data';
  static const String _currentYearKey = 'current_events_year';
  static const String _userProgressKey = 'user_event_progress';

  Map<String, dynamic>? _annualEventsData;
  Map<String, dynamic> _userProgress = {};
  int _currentYear = DateTime.now().year;

  // Getters
  Map<String, dynamic>? get annualEventsData => _annualEventsData;
  Map<String, dynamic> get userProgress => _userProgress;
  int get currentYear => _currentYear;

  /// Initialise le provider et charge les données d'événements
  Future<void> initialize() async {
    await _loadEventsData();
    await _loadUserProgress();
    _checkAndUpdateEventsIfNeeded();
  }

  /// Charge les données d'événements depuis le stockage local
  Future<void> _loadEventsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final year = prefs.getInt(_currentYearKey) ?? _currentYear;
      final eventsDataString = prefs.getString(_eventsDataKey);

      if (eventsDataString != null && year == _currentYear) {
        _annualEventsData = json.decode(eventsDataString);
        _currentYear = year;
      } else {
        // Générer de nouveaux événements pour l'année en cours
        await _generateNewYearEvents();
      }
    } catch (e) {
      // En cas d'erreur, générer de nouveaux événements
      await _generateNewYearEvents();
    }
  }

  /// Génère les événements pour une nouvelle année
  Future<void> _generateNewYearEvents() async {
    _annualEventsData = EventSystem.generateAnnualEvents(_currentYear);
    await _saveEventsData();
  }

  /// Sauvegarde les données d'événements
  Future<void> _saveEventsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_currentYearKey, _currentYear);
      await prefs.setString(_eventsDataKey, json.encode(_annualEventsData));
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la sauvegarde des événements: $e');
      }
    }
  }

  /// Charge le progrès de l'utilisateur
  Future<void> _loadUserProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressString = prefs.getString(_userProgressKey);

      if (progressString != null) {
        _userProgress = json.decode(progressString);
      }
    } catch (e) {
      _userProgress = {};
    }
  }

  /// Sauvegarde le progrès de l'utilisateur
  Future<void> _saveUserProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userProgressKey, json.encode(_userProgress));
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la sauvegarde du progrès: $e');
      }
    }
  }

  /// Vérifie et met à jour les événements si nécessaire
  void _checkAndUpdateEventsIfNeeded() {
    final now = DateTime.now();
    if (now.year != _currentYear) {
      _currentYear = now.year;
      _generateNewYearEvents();
    }
  }

  /// Obtient tous les événements de l'année
  List<Map<String, dynamic>> getAllEvents() {
    if (_annualEventsData == null) return [];
    return List<Map<String, dynamic>>.from(_annualEventsData!['events'] ?? []);
  }

  /// Obtient les événements actifs pour aujourd'hui
  List<Map<String, dynamic>> getActiveEvents() {
    final allEvents = getAllEvents();
    return EventSystem.getActiveEvents(allEvents, DateTime.now());
  }

  /// Obtient les événements à venir
  List<Map<String, dynamic>> getUpcomingEvents() {
    final allEvents = getAllEvents();
    return EventSystem.getUpcomingEvents(allEvents, DateTime.now());
  }

  /// Obtient les événements passés
  List<Map<String, dynamic>> getPastEvents() {
    final allEvents = getAllEvents();
    final now = DateTime.now();

    return allEvents.where((event) {
      final endDate = DateTime.parse(event['end_date']);
      return endDate.isBefore(now);
    }).toList();
  }

  /// Obtient un événement par son ID
  Map<String, dynamic>? getEventById(String eventId) {
    final allEvents = getAllEvents();
    try {
      return allEvents.firstWhere((event) => event['id'] == eventId);
    } catch (e) {
      return null;
    }
  }

  /// Obtient le progrès de l'utilisateur pour un événement
  Map<String, dynamic> getUserEventProgress(String eventId) {
    return Map<String, dynamic>.from(_userProgress[eventId] ?? {});
  }

  /// Met à jour le progrès de l'utilisateur pour un événement
  Future<void> updateUserEventProgress(
      String eventId, Map<String, dynamic> progress) async {
    _userProgress[eventId] = progress;
    await _saveUserProgress();
    notifyListeners();
  }

  /// Obtient le progrès d'un défi spécifique
  int getChallengeProgress(String eventId, String challengeId) {
    final eventProgress = getUserEventProgress(eventId);
    final challenges =
        eventProgress['challenges'] as Map<String, dynamic>? ?? {};
    return challenges[challengeId] ?? 0;
  }

  /// Met à jour le progrès d'un défi
  Future<void> updateChallengeProgress(
      String eventId, String challengeId, int progress) async {
    final eventProgress = getUserEventProgress(eventId);
    final challenges =
        Map<String, dynamic>.from(eventProgress['challenges'] ?? {});
    challenges[challengeId] = progress;

    await updateUserEventProgress(eventId, {
      ...eventProgress,
      'challenges': challenges,
    });
  }

  /// Vérifie si un défi est complété
  bool isChallengeCompleted(String eventId, String challengeId) {
    final event = getEventById(eventId);
    if (event == null) return false;

    final challenges = event['challenges'] as List<dynamic>? ?? [];
    try {
      final challenge = challenges.firstWhere(
        (c) => c['id'] == challengeId,
      );

      final target = challenge['target'] as int;
      final progress = getChallengeProgress(eventId, challengeId);

      return progress >= target;
    } catch (e) {
      // Défi non trouvé
      return false;
    }
  }

  /// Obtient les récompenses non réclamées pour un événement
  List<Map<String, dynamic>> getUnclaimedRewards(String eventId) {
    final event = getEventById(eventId);
    if (event == null) return [];

    final eventProgress = getUserEventProgress(eventId);
    final claimedRewards =
        Set<String>.from(eventProgress['claimed_rewards'] ?? []);

    final challenges = event['challenges'] as List<dynamic>? ?? [];
    final unclaimedRewards = <Map<String, dynamic>>[];

    for (final challenge in challenges) {
      try {
        final challengeId = challenge['id'] as String;
        if (isChallengeCompleted(eventId, challengeId) &&
            !claimedRewards.contains(challengeId)) {
          unclaimedRewards.add({
            'challenge_id': challengeId,
            'reward': challenge['reward'],
            'description': challenge['description'],
          });
        }
      } catch (e) {
        // Ignorer les défis malformés
        continue;
      }
    }

    return unclaimedRewards;
  }

  /// Réclame une récompense
  Future<void> claimReward(String eventId, String challengeId) async {
    final eventProgress = getUserEventProgress(eventId);
    final claimedRewards =
        Set<String>.from(eventProgress['claimed_rewards'] ?? []);
    claimedRewards.add(challengeId);

    await updateUserEventProgress(eventId, {
      ...eventProgress,
      'claimed_rewards': claimedRewards.toList(),
    });
  }

  /// Obtient les statistiques globales des événements
  Map<String, dynamic> getEventStatistics() {
    final allEvents = getAllEvents();
    final activeEvents = getActiveEvents();
    final upcomingEvents = getUpcomingEvents();
    final pastEvents = getPastEvents();

    int totalChallengesCompleted = 0;
    int totalRewardsClaimed = 0;

    for (final event in allEvents) {
      final eventId = event['id'] as String;
      final eventProgress = getUserEventProgress(eventId);
      final challenges = event['challenges'] as List<dynamic>? ?? [];

      for (final challenge in challenges) {
        try {
          final challengeId = challenge['id'] as String;
          if (isChallengeCompleted(eventId, challengeId)) {
            totalChallengesCompleted++;
          }
        } catch (e) {
          // Ignorer les défis malformés
          continue;
        }
      }

      final claimedRewards =
          eventProgress['claimed_rewards'] as List<dynamic>? ?? [];
      totalRewardsClaimed += claimedRewards.length;
    }

    return {
      'total_events': allEvents.length,
      'active_events': activeEvents.length,
      'upcoming_events': upcomingEvents.length,
      'past_events': pastEvents.length,
      'challenges_completed': totalChallengesCompleted,
      'rewards_claimed': totalRewardsClaimed,
    };
  }

  /// Obtient les événements par thème
  List<Map<String, dynamic>> getEventsByTheme(String theme) {
    final allEvents = getAllEvents();
    return allEvents.where((event) => event['theme'] == theme).toList();
  }

  /// Obtient les événements par type
  List<Map<String, dynamic>> getEventsByType(String type) {
    final allEvents = getAllEvents();
    return allEvents.where((event) => event['type'] == type).toList();
  }

  /// Obtient les événements par priorité
  List<Map<String, dynamic>> getEventsByPriority(int priority) {
    final allEvents = getAllEvents();
    return allEvents.where((event) => event['priority'] == priority).toList();
  }

  /// Obtient les thèmes saisonniers
  Map<String, dynamic>? getSeasonalThemes() {
    return _annualEventsData?['seasonal_themes'];
  }

  /// Obtient les dates spéciales
  Map<String, dynamic>? getSpecialDates() {
    return _annualEventsData?['special_dates'];
  }

  /// Force la régénération des événements (pour les tests)
  Future<void> regenerateEvents() async {
    _currentYear = DateTime.now().year;
    await _generateNewYearEvents();
    notifyListeners();
  }

  /// Réinitialise le progrès de l'utilisateur
  Future<void> resetUserProgress() async {
    _userProgress = {};
    await _saveUserProgress();
    notifyListeners();
  }

  /// Obtient les événements du mois en cours
  List<Map<String, dynamic>> getCurrentMonthEvents() {
    final now = DateTime.now();
    final allEvents = getAllEvents();

    return allEvents.where((event) {
      final startDate = DateTime.parse(event['start_date']);
      final endDate = DateTime.parse(event['end_date']);

      // Vérifier si l'événement se déroule pendant le mois en cours
      return (startDate.month == now.month && startDate.year == now.year) ||
          (endDate.month == now.month && endDate.year == now.year) ||
          (startDate.isBefore(DateTime(now.year, now.month, 1)) &&
              endDate.isAfter(DateTime(now.year, now.month + 1, 0)));
    }).toList();
  }

  /// Obtient les événements de la semaine en cours
  List<Map<String, dynamic>> getCurrentWeekEvents() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final allEvents = getAllEvents();

    return allEvents.where((event) {
      final startDate = DateTime.parse(event['start_date']);
      final endDate = DateTime.parse(event['end_date']);

      return (startDate
                  .isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
              startDate.isBefore(endOfWeek.add(const Duration(days: 1)))) ||
          (endDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
              endDate.isBefore(endOfWeek.add(const Duration(days: 1))));
    }).toList();
  }
}
