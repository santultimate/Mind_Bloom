import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class QuestProvider extends ChangeNotifier {
  List<Quest> _activeQuests = [];
  List<Quest> _completedQuests = [];
  Map<String, int> _questProgress = {};
  DateTime? _lastQuestRefresh;

  // Getters
  List<Quest> get activeQuests => _activeQuests;
  List<Quest> get completedQuests => _completedQuests;
  Map<String, int> get questProgress => _questProgress;

  QuestProvider() {
    _initializeQuests();
    _loadProgress();
  }

  void _initializeQuests() {
    // Générer des quêtes quotidiennes variées
    _generateDailyQuests();
  }

  void _generateDailyQuests() {
    final now = DateTime.now();
    final seed = now.day + now.month * 31 + now.year * 365;
    final random = seed % 100;

    _activeQuests = [
      // Quête principale du jour
      _generateMainQuest(random),

      // Quêtes secondaires
      ..._generateSecondaryQuests(random),
    ];
  }

  Quest _generateMainQuest(int seed) {
    final questTypes = [
      QuestType.completeLevels,
      QuestType.earnStars,
      QuestType.collectCoins,
      QuestType.makeMatches,
      QuestType.reachScore,
    ];

    final type = questTypes[seed % questTypes.length];

    switch (type) {
      case QuestType.completeLevels:
        return Quest(
          id: 'daily_complete_levels',
          title: 'Maître des Niveaux',
          description: 'Terminez 3 niveaux aujourd\'hui',
          type: type,
          target: 3,
          current: _questProgress['daily_complete_levels'] ?? 0,
          rewards: [
            QuestReward(type: RewardType.coins, amount: 150),
            QuestReward(type: RewardType.gems, amount: 2),
          ],
          difficulty: QuestDifficulty.medium,
          isDaily: true,
        );

      case QuestType.earnStars:
        return Quest(
          id: 'daily_earn_stars',
          title: 'Chasseur d\'Étoiles',
          description: 'Gagnez 5 étoiles aujourd\'hui',
          type: type,
          target: 5,
          current: _questProgress['daily_earn_stars'] ?? 0,
          rewards: [
            QuestReward(type: RewardType.coins, amount: 200),
            QuestReward(type: RewardType.gems, amount: 3),
          ],
          difficulty: QuestDifficulty.hard,
          isDaily: true,
        );

      case QuestType.collectCoins:
        return Quest(
          id: 'daily_collect_coins',
          title: 'Collectionneur de Richesses',
          description: 'Collectez 500 pièces aujourd\'hui',
          type: type,
          target: 500,
          current: _questProgress['daily_collect_coins'] ?? 0,
          rewards: [
            QuestReward(type: RewardType.gems, amount: 5),
            QuestReward(type: RewardType.lives, amount: 3),
          ],
          difficulty: QuestDifficulty.medium,
          isDaily: true,
        );

      case QuestType.makeMatches:
        return Quest(
          id: 'daily_make_matches',
          title: 'Maître des Combos',
          description: 'Faites 50 matches aujourd\'hui',
          type: type,
          target: 50,
          current: _questProgress['daily_make_matches'] ?? 0,
          rewards: [
            QuestReward(type: RewardType.coins, amount: 100),
            QuestReward(type: RewardType.gems, amount: 1),
          ],
          difficulty: QuestDifficulty.easy,
          isDaily: true,
        );

      case QuestType.reachScore:
        return Quest(
          id: 'daily_reach_score',
          title: 'Score Légendaire',
          description: 'Atteignez 10 000 points en un niveau',
          type: type,
          target: 10000,
          current: _questProgress['daily_reach_score'] ?? 0,
          rewards: [
            QuestReward(type: RewardType.coins, amount: 300),
            QuestReward(type: RewardType.gems, amount: 5),
          ],
          difficulty: QuestDifficulty.expert,
          isDaily: true,
        );

      default:
        return Quest(
          id: 'daily_default',
          title: 'Aventurier',
          description: 'Jouez au jeu aujourd\'hui',
          type: QuestType.completeLevels,
          target: 1,
          current: _questProgress['daily_default'] ?? 0,
          rewards: [
            QuestReward(type: RewardType.coins, amount: 50),
          ],
          difficulty: QuestDifficulty.easy,
          isDaily: true,
        );
    }
  }

  List<Quest> _generateSecondaryQuests(int seed) {
    return [
      Quest(
        id: 'daily_use_hints',
        title: 'Chercheur d\'Indices',
        description: 'Utilisez 5 indices',
        type: QuestType.useHints,
        target: 5,
        current: _questProgress['daily_use_hints'] ?? 0,
        rewards: [
          QuestReward(type: RewardType.coins, amount: 75),
        ],
        difficulty: QuestDifficulty.easy,
        isDaily: true,
      ),
      Quest(
        id: 'daily_perfect_levels',
        title: 'Perfectionniste',
        description: 'Obtenez 3 étoiles sur 2 niveaux',
        type: QuestType.perfectLevels,
        target: 2,
        current: _questProgress['daily_perfect_levels'] ?? 0,
        rewards: [
          QuestReward(type: RewardType.gems, amount: 3),
          QuestReward(type: RewardType.lives, amount: 2),
        ],
        difficulty: QuestDifficulty.hard,
        isDaily: true,
      ),
    ];
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final progressJson = prefs.getString('quest_progress');
    if (progressJson != null) {
      _questProgress = Map<String, int>.from(json.decode(progressJson));
    }

    final lastRefreshString = prefs.getString('last_quest_refresh');
    if (lastRefreshString != null) {
      _lastQuestRefresh = DateTime.parse(lastRefreshString);
    }

    // Vérifier si on doit rafraîchir les quêtes quotidiennes
    _checkDailyRefresh();

    notifyListeners();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('quest_progress', json.encode(_questProgress));

    if (_lastQuestRefresh != null) {
      await prefs.setString(
          'last_quest_refresh', _lastQuestRefresh!.toIso8601String());
    }
  }

  void _checkDailyRefresh() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastQuestRefresh != null) {
      final lastRefreshDay = DateTime(_lastQuestRefresh!.year,
          _lastQuestRefresh!.month, _lastQuestRefresh!.day);

      if (today.isAfter(lastRefreshDay)) {
        // Nouveau jour, rafraîchir les quêtes
        _refreshDailyQuests();
      }
    } else {
      // Première fois
      _lastQuestRefresh = today;
    }
  }

  void _refreshDailyQuests() {
    // Sauvegarder les quêtes complétées
    _completedQuests.addAll(_activeQuests.where((q) => q.isCompleted));

    // Réinitialiser la progression des quêtes quotidiennes
    final dailyQuestIds =
        _activeQuests.where((q) => q.isDaily).map((q) => q.id);
    for (final id in dailyQuestIds) {
      _questProgress.remove(id);
    }

    // Générer de nouvelles quêtes
    _generateDailyQuests();
    _lastQuestRefresh = DateTime.now();

    _saveProgress();
  }

  // Mettre à jour la progression d'une quête
  Future<void> updateQuestProgress(QuestType type,
      {int amount = 1, int? value}) async {
    bool hasUpdates = false;

    for (final quest in _activeQuests) {
      if (quest.type == type && !quest.isCompleted) {
        final oldProgress = quest.current;

        if (value != null) {
          // Pour les quêtes de score, utiliser la valeur maximale atteinte
          quest.current = (quest.current > value) ? quest.current : value;
        } else {
          // Pour les autres quêtes, incrémenter
          quest.current += amount;
        }

        quest.current = quest.current.clamp(0, quest.target);
        _questProgress[quest.id] = quest.current;

        if (quest.current != oldProgress) {
          hasUpdates = true;

          // Vérifier si la quête est maintenant complétée
          if (quest.isCompleted && !quest.wasCompleted) {
            quest.wasCompleted = true;
            _onQuestCompleted(quest);
          }
        }
      }
    }

    if (hasUpdates) {
      await _saveProgress();
      notifyListeners();
    }
  }

  void _onQuestCompleted(Quest quest) {
    // Commenté pour la version de production
    // if (kDebugMode) {
    //   print('Quest completed: ${quest.title}');
    // }

    // Ici on pourrait jouer un son ou afficher une notification
    // Pour l'instant, on se contente du debug
  }

  // Réclamer les récompenses d'une quête
  Future<bool> claimQuestRewards(String questId) async {
    final quest = _activeQuests.firstWhere(
      (q) => q.id == questId,
      orElse: () => Quest.empty(),
    );

    if (quest.id.isEmpty || !quest.isCompleted || quest.rewardsClaimed) {
      return false;
    }

    quest.rewardsClaimed = true;
    await _saveProgress();
    notifyListeners();

    return true;
  }

  // Obtenir les quêtes par difficulté
  List<Quest> getQuestsByDifficulty(QuestDifficulty difficulty) {
    return _activeQuests.where((q) => q.difficulty == difficulty).toList();
  }

  // Obtenir les quêtes complétées non réclamées
  List<Quest> getUnclaimedCompletedQuests() {
    return _activeQuests
        .where((q) => q.isCompleted && !q.rewardsClaimed)
        .toList();
  }
}

// Modèles de données
class Quest {
  final String id;
  final String title;
  final String description;
  final QuestType type;
  final int target;
  int current;
  final List<QuestReward> rewards;
  final QuestDifficulty difficulty;
  final bool isDaily;
  bool wasCompleted;
  bool rewardsClaimed;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.target,
    required this.current,
    required this.rewards,
    required this.difficulty,
    this.isDaily = false,
    this.wasCompleted = false,
    this.rewardsClaimed = false,
  });

  bool get isCompleted => current >= target;
  double get progress => target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;

  factory Quest.empty() {
    return Quest(
      id: '',
      title: '',
      description: '',
      type: QuestType.completeLevels,
      target: 0,
      current: 0,
      rewards: [],
      difficulty: QuestDifficulty.easy,
    );
  }
}

class QuestReward {
  final RewardType type;
  final int amount;

  QuestReward({
    required this.type,
    required this.amount,
  });
}

enum QuestType {
  completeLevels,
  earnStars,
  collectCoins,
  makeMatches,
  reachScore,
  useHints,
  perfectLevels,
  playTime,
  collectGems,
}

enum QuestDifficulty {
  easy,
  medium,
  hard,
  expert,
}

enum RewardType {
  coins,
  gems,
  lives,
  experience,
  boosters,
}
