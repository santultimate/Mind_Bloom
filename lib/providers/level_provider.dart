import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mind_bloom/models/level.dart';
import 'package:mind_bloom/services/level_translation_service.dart';

/// Provider pour gérer le chargement des niveaux par mondes
class LevelProvider extends ChangeNotifier {
  Map<String, List<Level>> _worldLevels = {};
  bool _isInitialized = false;

  Map<String, List<Level>> get worldLevels => _worldLevels;
  bool get isInitialized => _isInitialized;

  /// Initialise le provider en chargeant tous les niveaux par mondes
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadWorldLevels();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing LevelProvider: $e');
      }
    }
  }

  /// Charge les niveaux depuis le fichier JSON
  Future<void> _loadWorldLevels() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/world_levels.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final Map<String, dynamic> worlds =
          jsonData['worlds'] as Map<String, dynamic>;

      _worldLevels.clear();

      for (final entry in worlds.entries) {
        final worldKey = entry.key;
        final List<dynamic> levelsJson = entry.value as List<dynamic>;

        final List<Level> levels = levelsJson.map((levelJson) {
          return Level.fromJson(levelJson as Map<String, dynamic>);
        }).toList();

        _worldLevels[worldKey] = levels;
      }

      if (kDebugMode) {
        print(
            'Loaded ${_worldLevels.length} worlds with ${_worldLevels.values.fold(0, (sum, levels) => sum + levels.length)} total levels');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading world levels: $e');
      }
      rethrow;
    }
  }

  /// Récupère tous les niveaux d'un monde spécifique
  List<Level>? getWorldLevels(int worldId) {
    final worldKey = 'world_$worldId';
    return _worldLevels[worldKey];
  }

  /// Récupère tous les niveaux d'un monde par sa clé
  List<Level>? getWorldLevelsByKey(String worldKey) {
    return _worldLevels[worldKey];
  }

  /// Récupère un niveau spécifique par son ID et son monde
  Level? getLevel(int worldId, int levelId) {
    final levels = getWorldLevels(worldId);
    if (levels == null) return null;

    try {
      return levels.firstWhere((level) => level.id == levelId);
    } catch (e) {
      return null;
    }
  }

  /// Récupère tous les niveaux de tous les mondes sous forme de liste plate
  List<Level> getAllLevels() {
    return _worldLevels.values.expand((levels) => levels).toList();
  }

  /// Récupère le nombre total de niveaux
  int getTotalLevelCount() {
    return _worldLevels.values.fold(0, (sum, levels) => sum + levels.length);
  }

  /// Récupère le nombre de mondes
  int getWorldCount() {
    return _worldLevels.length;
  }

  /// Récupère tous les IDs des mondes
  List<int> getWorldIds() {
    return _worldLevels.keys
        .map((key) => int.parse(key.replaceFirst('world_', '')))
        .toList()
      ..sort();
  }

  /// Récupère le niveau suivant dans le même monde
  Level? getNextLevel(int worldId, int currentLevelId) {
    final levels = getWorldLevels(worldId);
    if (levels == null) return null;

    try {
      return levels.firstWhere((level) => level.id == currentLevelId + 1);
    } catch (e) {
      return null;
    }
  }

  /// Récupère le niveau précédent dans le même monde
  Level? getPreviousLevel(int worldId, int currentLevelId) {
    final levels = getWorldLevels(worldId);
    if (levels == null) return null;

    try {
      return levels.firstWhere((level) => level.id == currentLevelId - 1);
    } catch (e) {
      return null;
    }
  }

  /// Vérifie si un niveau existe
  bool levelExists(int worldId, int levelId) {
    return getLevel(worldId, levelId) != null;
  }

  /// Récupère les statistiques des niveaux par monde
  Map<String, dynamic> getLevelStatistics() {
    final stats = <String, dynamic>{};

    for (final entry in _worldLevels.entries) {
      final worldKey = entry.key;
      final levels = entry.value;

      final difficulties = levels.map((level) => level.difficulty).toSet();
      final totalLevels = levels.length;

      stats[worldKey] = {
        'totalLevels': totalLevels,
        'difficulties': difficulties.toList(),
        'minLevel': levels.isNotEmpty
            ? levels.map((l) => l.id).reduce((a, b) => a < b ? a : b)
            : 0,
        'maxLevel': levels.isNotEmpty
            ? levels.map((l) => l.id).reduce((a, b) => a > b ? a : b)
            : 0,
      };
    }

    return stats;
  }

  /// Force le rechargement des niveaux
  Future<void> reload() async {
    _isInitialized = false;
    _worldLevels.clear();
    await initialize();
  }

  /// Récupère un niveau avec traduction
  Level? getLevelWithTranslation(int worldId, int levelId, Locale locale) {
    final worldKey = 'world_$worldId';
    final levels = _worldLevels[worldKey];
    
    if (levels == null) return null;
    
    // Trouver le niveau par son ID local dans le monde
    try {
      final level = levels.firstWhere((l) => l.id == levelId);
      
      // Créer une copie avec les traductions
      return Level(
        id: level.id,
        name: LevelTranslationService.getLevelName(level.id, locale),
        description: LevelTranslationService.getLevelDescription(level.id, locale),
        difficulty: level.difficulty,
        gridSize: level.gridSize,
        maxMoves: level.maxMoves,
        targetScore: level.targetScore,
        objectives: level.objectives,
        initialGrid: level.initialGrid,
        blockers: level.blockers,
        jelly: level.jelly,
        specialRules: level.specialRules,
        energyCost: level.energyCost,
        rewards: level.rewards,
        isUnlocked: level.isUnlocked,
      );
    } catch (e) {
      return null;
    }
  }

  /// Récupère tous les niveaux d'un monde avec traduction
  List<Level>? getWorldLevelsWithTranslation(int worldId, Locale locale) {
    final levels = getWorldLevels(worldId);
    if (levels == null) return null;
    
    return levels.map((level) {
      return Level(
        id: level.id,
        name: LevelTranslationService.getLevelName(level.id, locale),
        description: LevelTranslationService.getLevelDescription(level.id, locale),
        difficulty: level.difficulty,
        gridSize: level.gridSize,
        maxMoves: level.maxMoves,
        targetScore: level.targetScore,
        objectives: level.objectives,
        initialGrid: level.initialGrid,
        blockers: level.blockers,
        jelly: level.jelly,
        specialRules: level.specialRules,
        energyCost: level.energyCost,
        rewards: level.rewards,
        isUnlocked: level.isUnlocked,
      );
    }).toList();
  }
}
