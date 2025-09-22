import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyRewardsProvider extends ChangeNotifier {
  DateTime? _lastClaimDate;
  int _consecutiveDays = 0;
  bool _todaysClaimed = false;
  Map<int, DailyReward> _rewardCycle = {};

  // Getters
  DateTime? get lastClaimDate => _lastClaimDate;
  int get consecutiveDays => _consecutiveDays;
  bool get todaysClaimed => _todaysClaimed;
  Map<int, DailyReward> get rewardCycle => _rewardCycle;

  DailyRewardsProvider() {
    _initializeRewards();
    _loadProgress();
  }

  void _initializeRewards() {
    _rewardCycle = {
      1: DailyReward(
        day: 1,
        coins: 50,
        gems: 0,
        lives: 1,
        description: 'Bienvenue ! Voici votre première récompense',
      ),
      2: DailyReward(
        day: 2,
        coins: 75,
        gems: 0,
        lives: 1,
        description: 'Continuez comme ça !',
      ),
      3: DailyReward(
        day: 3,
        coins: 100,
        gems: 1,
        lives: 2,
        description: 'Trois jours de suite ! Excellent !',
      ),
      4: DailyReward(
        day: 4,
        coins: 125,
        gems: 1,
        lives: 2,
        description: 'Vous êtes sur la bonne voie',
      ),
      5: DailyReward(
        day: 5,
        coins: 150,
        gems: 2,
        lives: 3,
        description: 'Cinq jours ! Vous êtes un joueur dévoué',
      ),
      6: DailyReward(
        day: 6,
        coins: 200,
        gems: 2,
        lives: 3,
        description: 'Presque une semaine complète !',
      ),
      7: DailyReward(
        day: 7,
        coins: 300,
        gems: 5,
        lives: 5,
        description: 'Semaine parfaite ! Récompense légendaire !',
        isSpecial: true,
      ),
    };
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final lastClaimString = prefs.getString('daily_reward_last_claim');
    if (lastClaimString != null) {
      _lastClaimDate = DateTime.parse(lastClaimString);
    }

    _consecutiveDays = prefs.getInt('daily_reward_consecutive') ?? 0;

    // Vérifier si c'est un nouveau jour
    _checkNewDay();

    notifyListeners();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();

    if (_lastClaimDate != null) {
      await prefs.setString(
          'daily_reward_last_claim', _lastClaimDate!.toIso8601String());
    }

    await prefs.setInt('daily_reward_consecutive', _consecutiveDays);
  }

  void _checkNewDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastClaimDate != null) {
      final lastClaimDay = DateTime(
          _lastClaimDate!.year, _lastClaimDate!.month, _lastClaimDate!.day);
      final daysDifference = today.difference(lastClaimDay).inDays;

      if (daysDifference == 0) {
        // Même jour, déjà réclamé
        _todaysClaimed = true;
      } else if (daysDifference == 1) {
        // Jour suivant, peut réclamer
        _todaysClaimed = false;
      } else {
        // Plus d'un jour, réinitialiser la série
        _consecutiveDays = 0;
        _todaysClaimed = false;
      }
    } else {
      // Première fois
      _todaysClaimed = false;
    }
  }

  // Vérifier si le joueur peut réclamer la récompense quotidienne
  bool canClaimDailyReward() {
    return !_todaysClaimed;
  }

  // Obtenir la récompense du jour actuel
  DailyReward getCurrentDayReward() {
    final currentDay = (_consecutiveDays % 7) + 1;
    return _rewardCycle[currentDay] ?? _rewardCycle[1]!;
  }

  // Obtenir la récompense du lendemain pour prévisualisation
  DailyReward getNextDayReward() {
    final nextDay = ((_consecutiveDays + 1) % 7) + 1;
    return _rewardCycle[nextDay] ?? _rewardCycle[1]!;
  }

  // Réclamer la récompense quotidienne
  Future<DailyReward?> claimDailyReward() async {
    if (!canClaimDailyReward()) return null;

    _consecutiveDays++;
    _lastClaimDate = DateTime.now();
    _todaysClaimed = true;

    final reward = getCurrentDayReward();

    await _saveProgress();
    notifyListeners();

    return reward;
  }

  // Obtenir le temps restant jusqu'à la prochaine récompense
  Duration getTimeUntilNextReward() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return tomorrow.difference(now);
  }

  // Réinitialiser les récompenses quotidiennes (pour les tests)
  Future<void> resetDailyRewards() async {
    _lastClaimDate = null;
    _consecutiveDays = 0;
    _todaysClaimed = false;

    await _saveProgress();
    notifyListeners();
  }
}

class DailyReward {
  final int day;
  final int coins;
  final int gems;
  final int lives;
  final String description;
  final bool isSpecial;

  DailyReward({
    required this.day,
    required this.coins,
    required this.gems,
    required this.lives,
    required this.description,
    this.isSpecial = false,
  });

  // Obtenir la valeur totale de la récompense (pour l'affichage)
  int get totalValue => coins + (gems * 10) + (lives * 5);
}
