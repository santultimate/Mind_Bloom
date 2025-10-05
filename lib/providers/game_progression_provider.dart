import 'package:flutter/foundation.dart';
import 'package:mind_bloom/models/world.dart';
import 'package:mind_bloom/providers/world_provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';

/// Provider centralisé SIMPLIFIÉ pour gérer la progression du jeu
/// Se contente de synchroniser avec UserProvider au lieu de dupliquer la logique
class GameProgressionProvider extends ChangeNotifier {
  // Référence au UserProvider (source de vérité)
  UserProvider? _userProvider;

  // Cache pour les mondes déverrouillés
  List<World>? _cachedUnlockedWorlds;
  bool _cacheValid = false;

  // Getters qui délèguent au UserProvider
  Set<int> get completedLevels =>
      _userProvider?.completedLevels.toSet() ?? <int>{};
  Map<int, int> get levelStars => _userProvider?.levelStars ?? {};
  Map<int, int> get worldProgress => _userProvider?.worldProgress ?? {};

  /// Initialise le provider avec les références
  void initialize(UserProvider userProvider, WorldProvider worldProvider) {
    _userProvider = userProvider;

    if (kDebugMode) {
      debugPrint('=== GAME PROGRESSION INITIALIZED ===');
      debugPrint('Completed levels: ${completedLevels}');
      debugPrint('Level stars: $levelStars');
      debugPrint('World progress: $worldProgress');
      debugPrint('===================================');
    }

    _invalidateCache();
    notifyListeners();
  }

  /// LOGIQUE CORRIGÉE DE DÉVERROUILLAGE DES NIVEAUX
  bool isLevelUnlocked(int levelId) {
    // Niveau 1 toujours déverrouillé
    if (levelId == 1) return true;

    // Trouver le monde contenant ce niveau
    final allWorlds = WorldGenerator.getAllWorlds();
    final world = allWorlds.where((w) => w.containsLevel(levelId)).firstOrNull;

    if (world == null) return false;

    // Règle 1: Premier niveau d'un monde déverrouillé
    if (world.startLevel == levelId) {
      if (world.id == 1) {
        return true; // Premier monde toujours déverrouillé
      } else {
        // Vérifier si le dernier niveau du monde précédent est complété
        final previousWorld = WorldGenerator.getWorldById(world.id - 1);
        if (previousWorld != null) {
          final lastLevelOfPreviousWorld = previousWorld.endLevel;
          final isUnlocked = completedLevels.contains(lastLevelOfPreviousWorld);

          if (kDebugMode) {
            debugPrint('=== LEVEL UNLOCK DEBUG ===');
            debugPrint('Level $levelId (first of world ${world.id})');
            debugPrint('Previous world last level: $lastLevelOfPreviousWorld');
            debugPrint(
                'Is completed: ${completedLevels.contains(lastLevelOfPreviousWorld)}');
            debugPrint('Result: $isUnlocked');
            debugPrint('=========================');
          }

          return isUnlocked;
        }
      }
    }

    // Règle 2: Niveau suivant dans le même monde (progression séquentielle)
    final previousLevelCompleted = completedLevels.contains(levelId - 1);

    if (kDebugMode) {
      debugPrint('=== LEVEL UNLOCK DEBUG ===');
      debugPrint('Level $levelId (sequential in world ${world.id})');
      debugPrint('Previous level $levelId completed: $previousLevelCompleted');
      debugPrint('Result: $previousLevelCompleted');
      debugPrint('=========================');
    }

    return previousLevelCompleted;
  }

  /// LOGIQUE UNIFIÉE DE DÉVERROUILLAGE DES MONDES
  List<World> getUnlockedWorlds() {
    if (_cacheValid && _cachedUnlockedWorlds != null) {
      return _cachedUnlockedWorlds!;
    }

    // Utiliser la logique cohérente de WorldGenerator
    final unlockedWorlds =
        WorldGenerator.getUnlockedWorlds(completedLevels.toList());

    if (kDebugMode) {
      debugPrint('=== GAME PROGRESSION WORLD UNLOCK ===');
      debugPrint('Completed levels: ${completedLevels}');
      debugPrint(
          'Unlocked worlds: ${unlockedWorlds.map((w) => w.id).toList()}');
      debugPrint('=====================================');
    }

    _cachedUnlockedWorlds = unlockedWorlds;
    _cacheValid = true;
    return unlockedWorlds;
  }

  /// Marque un niveau comme complété (délègue au UserProvider)
  Future<void> completeLevel(int levelId, int stars, int score) async {
    if (_userProvider != null) {
      await _userProvider!.completeLevel(levelId, stars, score);

      if (kDebugMode) {
        debugPrint('=== LEVEL COMPLETION DELEGATED ===');
        debugPrint('Level $levelId completed with $stars stars');
        debugPrint('Updated completed levels: ${completedLevels}');
        debugPrint('World progress: $worldProgress');
        debugPrint('=================================');
      }
    }

    // Invalider le cache et notifier immédiatement
    _invalidateCache();
    notifyListeners();

    // Attendre un court délai et re-notifier pour s'assurer que l'UI se met à jour
    await Future.delayed(const Duration(milliseconds: 100));
    notifyListeners();
  }

  /// Invalide le cache des mondes déverrouillés
  void _invalidateCache() {
    _cacheValid = false;
    _cachedUnlockedWorlds = null;
  }

  /// Force la synchronisation avec le UserProvider
  void syncWithUserProvider() {
    _invalidateCache();
    notifyListeners();
  }

  /// Méthode de debug pour vérifier l'état de la progression
  void debugProgressionState() {
    if (kDebugMode) {
      debugPrint('=== GAME PROGRESSION DEBUG ===');
      debugPrint('Completed levels: ${completedLevels}');
      debugPrint('Level stars: $levelStars');
      debugPrint('World progress: $worldProgress');

      // Tester quelques niveaux
      for (int levelId = 10; levelId <= 15; levelId++) {
        final isUnlocked = isLevelUnlocked(levelId);
        debugPrint('Level $levelId: ${isUnlocked ? "UNLOCKED" : "LOCKED"}');
      }
      debugPrint('==============================');
    }
  }
}
