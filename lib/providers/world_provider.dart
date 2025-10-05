import 'package:flutter/foundation.dart';
import 'package:mind_bloom/models/world.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/game_progression_provider.dart';

/// Provider pour gérer les mondes et leur déverrouillage
class WorldProvider extends ChangeNotifier {
  List<World> _worlds = [];
  bool _isInitialized = false;
  GameProgressionProvider? _gameProgressionProvider;

  List<World> get worlds => _worlds;
  bool get isInitialized => _isInitialized;

  /// Définit la référence au GameProgressionProvider
  void setGameProgressionProvider(
      GameProgressionProvider gameProgressionProvider) {
    _gameProgressionProvider = gameProgressionProvider;
  }

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
        debugPrint('Error initializing WorldProvider: $e');
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
    // Utiliser le système centralisé si disponible
    if (_gameProgressionProvider != null) {
      return _gameProgressionProvider!.getUnlockedWorlds();
    }

    // Fallback vers l'ancienne logique
    return _worlds.where((world) => world.isUnlocked).toList();
  }

  /// Vérifie si un monde est déverrouillé
  bool isWorldUnlocked(int worldId) {
    // Utiliser le système centralisé si disponible
    if (_gameProgressionProvider != null) {
      final unlockedWorlds = _gameProgressionProvider!.getUnlockedWorlds();
      return unlockedWorlds.any((world) => world.id == worldId);
    }

    // Fallback vers l'ancienne logique
    final world = getWorldById(worldId);
    return world?.isUnlocked ?? false;
  }

  /// Met à jour la progression quand un niveau est complété
  Future<void> onLevelCompleted(int levelId, UserProvider userProvider) async {
    // Sauvegarder l'état précédent des mondes déverrouillés
    final previouslyUnlockedWorlds =
        getUnlockedWorlds().map((w) => w.id).toSet();

    // Mettre à jour l'état de déverrouillage
    await _updateWorldUnlockStatus(userProvider.completedLevels);

    // Vérifier si de nouveaux mondes ont été déverrouillés
    final newlyUnlockedWorlds = getUnlockedWorlds()
        .where((world) => !previouslyUnlockedWorlds.contains(world.id))
        .toList();

    // Notifier les listeners (l'UI pourra afficher une notification)
    notifyListeners();

    // Retourner les nouveaux mondes déverrouillés pour notification
    if (newlyUnlockedWorlds.isNotEmpty) {
      // Cette information peut être utilisée par l'UI pour afficher une popup
      if (kDebugMode) {
        debugPrint(
            '🎉 Nouveaux mondes déverrouillés: ${newlyUnlockedWorlds.map((w) => w.id).join(', ')}');
      }

      // 🚀 CORRECTION: Mettre à jour automatiquement le monde sélectionné vers le nouveau monde
      final newestUnlockedWorld = newlyUnlockedWorlds.last;
      await userProvider.setSelectedWorld(newestUnlockedWorld.id);

      if (kDebugMode) {
        debugPrint(
            '🌍 Monde sélectionné mis à jour vers: ${newestUnlockedWorld.id}');
      }
    }
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
