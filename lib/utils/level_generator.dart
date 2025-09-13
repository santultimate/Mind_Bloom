import 'dart:math';
import 'package:mind_bloom/models/level.dart';
import 'package:mind_bloom/models/tile.dart';

class LevelGenerator {
  static final Random _random = Random();

  // Générer un niveau selon son numéro avec progression intelligente
  static Level generateLevel(int levelNumber) {
    // Progression en vagues de 10 niveaux avec mécaniques spéciales
    int wave = (levelNumber - 1) ~/ 10;
    int levelInWave = (levelNumber - 1) % 10;

    // Niveaux spéciaux
    if (levelNumber % 10 == 0) {
      return _generateBossLevel(levelNumber, wave);
    } else if (levelNumber % 5 == 0) {
      return _generateSpecialLevel(levelNumber, wave);
    }

    // Progression normale avec difficulté adaptative
    if (levelNumber <= 10) {
      return _generateEasyLevel(levelNumber, levelInWave);
    } else if (levelNumber <= 25) {
      return _generateMediumLevel(levelNumber, levelInWave);
    } else if (levelNumber <= 50) {
      return _generateHardLevel(levelNumber, levelInWave);
    } else {
      return _generateExpertLevel(levelNumber, levelInWave);
    }
  }

  // Niveaux faciles (1-10)
  static Level _generateEasyLevel(int level, int levelInWave) {
    final gridSize = 6;
    final maxMoves = 25 - (level * 0.5).round();
    final targetTile = TileType
        .values[_random.nextInt(TileType.values.length)]; // Tous les types
    final targetCount = 15 + (level * 2);

    return Level(
      id: level,
      name: 'Niveau $level',
      description: 'Collectez $targetCount ${_getTileName(targetTile)}s',
      difficulty: LevelDifficulty.easy,
      gridSize: gridSize,
      maxMoves: maxMoves,
      targetScore: targetCount * 100,
      objectives: [
        LevelObjective(
          type: LevelObjectiveType.collectTiles,
          tileType: targetTile,
          target: targetCount,
        ),
      ],
      initialGrid:
          List.generate(gridSize, (i) => List.generate(gridSize, (j) => -1)),
      blockers:
          List.generate(gridSize, (i) => List.generate(gridSize, (j) => false)),
      jelly:
          List.generate(gridSize, (i) => List.generate(gridSize, (j) => false)),
      specialRules: {},
      energyCost: 1,
      rewards: ['coins:${10 + level}'],
    );
  }

  // Niveaux moyens (11-25)
  static Level _generateMediumLevel(int level, int levelInWave) {
    final gridSize = 7;
    final maxMoves = 20 - ((level - 10) * 0.3).round();
    final targetTile1 = TileType.values[_random.nextInt(6)]; // 6 premiers types
    final targetTile2 = TileType.values[_random.nextInt(6)];
    final targetCount1 = 20 + (level * 1.5).round();
    final targetCount2 = 15 + (level * 1.2).round();

    return Level(
      id: level,
      name: 'Niveau $level',
      description:
          'Collectez $targetCount1 ${_getTileName(targetTile1)}s et $targetCount2 ${_getTileName(targetTile2)}s',
      difficulty: LevelDifficulty.medium,
      gridSize: gridSize,
      maxMoves: maxMoves,
      targetScore: (targetCount1 + targetCount2) * 120,
      objectives: [
        LevelObjective(
          type: LevelObjectiveType.collectTiles,
          tileType: targetTile1,
          target: targetCount1,
        ),
        LevelObjective(
          type: LevelObjectiveType.collectTiles,
          tileType: targetTile2,
          target: targetCount2,
        ),
      ],
      initialGrid:
          List.generate(gridSize, (i) => List.generate(gridSize, (j) => -1)),
      blockers: _generateBlockers(gridSize, level - 10),
      jelly:
          List.generate(gridSize, (i) => List.generate(gridSize, (j) => false)),
      specialRules: {},
      energyCost: 2,
      rewards: ['coins:${15 + level}', 'boosters:1'],
    );
  }

  // Niveaux difficiles (26-50)
  static Level _generateHardLevel(int level, int levelInWave) {
    final gridSize = 8;
    final maxMoves = 18 - ((level - 25) * 0.2).round();
    final targetTile1 = TileType.values[_random.nextInt(8)]; // Tous les types
    final targetTile2 = TileType.values[_random.nextInt(8)];
    final targetTile3 = TileType.values[_random.nextInt(8)];
    final targetCount1 = 25 + (level * 1.2).round();
    final targetCount2 = 20 + (level * 1.0).round();
    final targetCount3 = 15 + (level * 0.8).round();

    return Level(
      id: level,
      name: 'Niveau $level',
      description:
          'Collectez $targetCount1 ${_getTileName(targetTile1)}s, $targetCount2 ${_getTileName(targetTile2)}s et $targetCount3 ${_getTileName(targetTile3)}s',
      difficulty: LevelDifficulty.hard,
      gridSize: gridSize,
      maxMoves: maxMoves,
      targetScore: (targetCount1 + targetCount2 + targetCount3) * 150,
      objectives: [
        LevelObjective(
          type: LevelObjectiveType.collectTiles,
          tileType: targetTile1,
          target: targetCount1,
        ),
        LevelObjective(
          type: LevelObjectiveType.collectTiles,
          tileType: targetTile2,
          target: targetCount2,
        ),
        LevelObjective(
          type: LevelObjectiveType.collectTiles,
          tileType: targetTile3,
          target: targetCount3,
        ),
      ],
      initialGrid:
          List.generate(gridSize, (i) => List.generate(gridSize, (j) => -1)),
      blockers: _generateBlockers(gridSize, (level - 25) * 2),
      jelly: _generateJelly(gridSize, level - 25),
      specialRules: {'timeLimit': 300}, // 5 minutes
      energyCost: 3,
      rewards: ['coins:${20 + level}', 'boosters:2', 'gems:1'],
    );
  }

  // Niveaux experts (51+)
  static Level _generateExpertLevel(int level, int levelInWave) {
    final gridSize = 9;
    final maxMoves = 15 - ((level - 50) * 0.1).round();
    final targetTile1 = TileType.values[_random.nextInt(8)];
    final targetTile2 = TileType.values[_random.nextInt(8)];
    final targetTile3 = TileType.values[_random.nextInt(8)];
    final targetTile4 = TileType.values[_random.nextInt(8)];
    final targetCount1 = 30 + (level * 1.0).round();
    final targetCount2 = 25 + (level * 0.8).round();
    final targetCount3 = 20 + (level * 0.6).round();
    final targetCount4 = 15 + (level * 0.4).round();

    return Level(
      id: level,
      name: 'Niveau $level',
      description: 'Défi expert : collectez 4 types différents de tuiles',
      difficulty: LevelDifficulty.expert,
      gridSize: gridSize,
      maxMoves: maxMoves,
      targetScore:
          (targetCount1 + targetCount2 + targetCount3 + targetCount4) * 200,
      objectives: [
        LevelObjective(
          type: LevelObjectiveType.collectTiles,
          tileType: targetTile1,
          target: targetCount1,
        ),
        LevelObjective(
          type: LevelObjectiveType.collectTiles,
          tileType: targetTile2,
          target: targetCount2,
        ),
        LevelObjective(
          type: LevelObjectiveType.collectTiles,
          tileType: targetTile3,
          target: targetCount3,
        ),
        LevelObjective(
          type: LevelObjectiveType.collectTiles,
          tileType: targetTile4,
          target: targetCount4,
        ),
      ],
      initialGrid:
          List.generate(gridSize, (i) => List.generate(gridSize, (j) => -1)),
      blockers: _generateBlockers(gridSize, (level - 50) * 3),
      jelly: _generateJelly(gridSize, (level - 50) * 2),
      specialRules: {
        'timeLimit': 240, // 4 minutes
        'comboRequired': 3, // Combos requis
        'powerUpBonus': 1.5, // Bonus power-ups
      },
      energyCost: 4,
      rewards: ['coins:${25 + level}', 'boosters:3', 'gems:2', 'special:1'],
    );
  }

  // Niveaux Boss (tous les 10 niveaux)
  static Level _generateBossLevel(int level, int wave) {
    final gridSize = 8 + (wave * 2); // Grille plus grande
    final maxMoves = 20 - (wave * 2); // Moins de mouvements
    final targetTile = TileType.values[_random.nextInt(8)];
    final targetCount = 50 + (wave * 20); // Objectif élevé

    return Level(
      id: level,
      name: 'Boss Niveau $level',
      description:
          'Défi Boss : Collectez $targetCount ${_getTileName(targetTile)}s',
      difficulty: LevelDifficulty.expert,
      gridSize: gridSize,
      maxMoves: maxMoves,
      targetScore: targetCount * 300,
      objectives: [
        LevelObjective(
          type: LevelObjectiveType.collectTiles,
          tileType: targetTile,
          target: targetCount,
        ),
      ],
      initialGrid:
          List.generate(gridSize, (i) => List.generate(gridSize, (j) => -1)),
      blockers: _generateBlockers(gridSize, 5 + wave * 2),
      jelly: _generateJelly(gridSize, 3 + wave),
      specialRules: {
        'timeLimit': 300 - (wave * 30), // Moins de temps
        'comboRequired': 5 + wave, // Plus de combos requis
        'powerUpBonus': 2.0 + (wave * 0.5), // Bonus power-ups
        'bossMode': true,
      },
      energyCost: 5 + wave,
      rewards: [
        'coins:${100 + level * 5}',
        'boosters:5',
        'gems:3',
        'special:2'
      ],
    );
  }

  // Niveaux Spéciaux (tous les 5 niveaux)
  static Level _generateSpecialLevel(int level, int wave) {
    final gridSize = 7 + wave;
    final maxMoves = 25 - (wave * 2);

    // Mécaniques spéciales selon le niveau
    Map<String, dynamic> specialRules = {};
    String description = 'Niveau Spécial $level';

    if (level % 15 == 0) {
      // Niveau de vitesse
      specialRules = {'timeLimit': 180, 'speedBonus': 1.5};
      description = 'Défi de Vitesse : 3 minutes pour terminer !';
    } else if (level % 20 == 0) {
      // Niveau de combos
      specialRules = {'comboRequired': 8, 'comboBonus': 2.0};
      description = 'Défi de Combos : 8 combos requis !';
    } else if (level % 25 == 0) {
      // Niveau de précision
      specialRules = {'precisionMode': true, 'movePenalty': 0.5};
      description = 'Défi de Précision : Chaque mouvement compte !';
    }

    final targetTile = TileType.values[_random.nextInt(8)];
    final targetCount = 30 + (wave * 10);

    return Level(
      id: level,
      name: 'Spécial $level',
      description: description,
      difficulty: LevelDifficulty.hard,
      gridSize: gridSize,
      maxMoves: maxMoves,
      targetScore: targetCount * 250,
      objectives: [
        LevelObjective(
          type: LevelObjectiveType.collectTiles,
          tileType: targetTile,
          target: targetCount,
        ),
      ],
      initialGrid:
          List.generate(gridSize, (i) => List.generate(gridSize, (j) => -1)),
      blockers: _generateBlockers(gridSize, 3 + wave),
      jelly: _generateJelly(gridSize, 2 + wave),
      specialRules: specialRules,
      energyCost: 3 + wave,
      rewards: ['coins:${50 + level * 3}', 'boosters:3', 'gems:2', 'special:1'],
    );
  }

  // Générer des bloqueurs selon la difficulté
  static List<List<bool>> _generateBlockers(int gridSize, int difficulty) {
    final blockers =
        List.generate(gridSize, (i) => List.generate(gridSize, (j) => false));
    final blockerCount = (difficulty * 0.5).round();

    for (int i = 0; i < blockerCount; i++) {
      final row = _random.nextInt(gridSize);
      final col = _random.nextInt(gridSize);
      blockers[row][col] = true;
    }

    return blockers;
  }

  // Générer de la gelée selon la difficulté
  static List<List<bool>> _generateJelly(int gridSize, int difficulty) {
    final jelly =
        List.generate(gridSize, (i) => List.generate(gridSize, (j) => false));
    final jellyCount = (difficulty * 0.3).round();

    for (int i = 0; i < jellyCount; i++) {
      final row = _random.nextInt(gridSize);
      final col = _random.nextInt(gridSize);
      jelly[row][col] = true;
    }

    return jelly;
  }

  // Obtenir le nom d'une tuile
  static String _getTileName(TileType type) {
    switch (type) {
      case TileType.flower:
        return 'fleur';
      case TileType.leaf:
        return 'feuille';
      case TileType.crystal:
        return 'cristal';
      case TileType.seed:
        return 'graine';
      case TileType.dew:
        return 'rosée';
      case TileType.sun:
        return 'soleil';
      case TileType.moon:
        return 'lune';
      case TileType.gem:
        return 'gemme';
    }
  }

  // Générer un niveau de test
  static Level generateTestLevel() {
    return Level(
      id: 999,
      name: 'Niveau Test',
      description: 'Niveau de test pour le développement',
      difficulty: LevelDifficulty.easy,
      gridSize: 6,
      maxMoves: 30,
      targetScore: 1000,
      objectives: [
        LevelObjective(
          type: LevelObjectiveType.collectTiles,
          tileType: TileType.flower,
          target: 10,
        ),
      ],
      initialGrid: List.generate(6, (i) => List.generate(6, (j) => -1)),
      blockers: List.generate(6, (i) => List.generate(6, (j) => false)),
      jelly: List.generate(6, (i) => List.generate(6, (j) => false)),
      specialRules: {},
      energyCost: 0,
      rewards: ['coins:100'],
    );
  }
}
