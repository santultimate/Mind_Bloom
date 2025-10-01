import 'package:flutter/foundation.dart';
import 'package:mind_bloom/models/world.dart';
import 'package:mind_bloom/providers/user_provider.dart';

/// Provider pour gérer les mondes et leur déverrouillage
class WorldProvider extends ChangeNotifier {
  List<World> _worlds = [];
  bool _isInitialized = false;

  List<World> get worlds => _worlds;
  bool get isInitialized => _isInitialized;

  /// Initialise le provider avec les mondes prédéfinis
  Future<void> initialize(UserProvider userProvider) async {
    if (_isInitialized) return;

    try {
      // Charger les mondes prédéfinis
      _worlds = WorldGenerator.getAllWorlds();

      // Mettre à jour l'état de déverrouillage basé sur la progression du joueur
      await _updateWorldUnlockStatus(userProvider.completedLevels);

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing WorldProvider: $e');
      }
    }
  }

  /// Met à jour l'état de déverrouillage des mondes
  Future<void> _updateWorldUnlockStatus(List<int> completedLevels) async {
    _worlds = WorldGenerator.updateWorldUnlockStatus(_worlds, completedLevels);
  }

  /// Récupère un monde par son ID
  World? getWorldById(int worldId) {
    try {
      return _worlds.firstWhere((world) => world.id == worldId);
    } catch (e) {
      return null;
    }
  }

  /// Récupère le monde contenant un niveau donné
  World? getWorldByLevel(int levelId) {
    return WorldGenerator.getWorldByLevel(levelId);
  }

  /// Récupère les mondes déverrouillés
  List<World> getUnlockedWorlds() {
    return _worlds.where((world) => world.isUnlocked).toList();
  }

  /// Vérifie si un monde est déverrouillé
  bool isWorldUnlocked(int worldId) {
    final world = getWorldById(worldId);
    return world?.isUnlocked ?? false;
  }

  /// Met à jour la progression quand un niveau est complété
  Future<void> onLevelCompleted(int levelId, UserProvider userProvider) async {
    // Mettre à jour l'état de déverrouillage
    await _updateWorldUnlockStatus(userProvider.completedLevels);
    notifyListeners();
  }

  /// Récupère le prochain monde à déverrouiller
  World? getNextWorldToUnlock() {
    final unlockedWorlds = getUnlockedWorlds();
    if (unlockedWorlds.isEmpty) return null;

    final maxUnlockedId =
        unlockedWorlds.map((w) => w.id).reduce((a, b) => a > b ? a : b);
    final nextWorldId = maxUnlockedId + 1;

    return getWorldById(nextWorldId);
  }

  /// Récupère les statistiques des mondes
  Map<String, dynamic> getWorldStatistics(UserProvider userProvider) {
    final completedLevels = userProvider.completedLevels;
    final totalLevels = _worlds.fold(0, (sum, world) => sum + world.levelCount);
    final completedTotal = completedLevels.length;

    final worldStats = _worlds.map((world) {
      final completedInWorld =
          completedLevels.where((level) => world.containsLevel(level)).length;

      return {
        'world': world,
        'completed': completedInWorld,
        'total': world.levelCount,
        'percentage': world.levelCount > 0
            ? (completedInWorld / world.levelCount * 100).round()
            : 0,
      };
    }).toList();

    return {
      'totalWorlds': _worlds.length,
      'unlockedWorlds': getUnlockedWorlds().length,
      'totalLevels': totalLevels,
      'completedLevels': completedTotal,
      'overallProgress':
          totalLevels > 0 ? (completedTotal / totalLevels * 100).round() : 0,
      'worldStats': worldStats,
    };
  }

  /// Réinitialise tous les mondes (pour les tests ou reset)
  Future<void> reset() async {
    _worlds.clear();
    _isInitialized = false;
    notifyListeners();
  }
}
