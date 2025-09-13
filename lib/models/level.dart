import 'package:mind_bloom/models/tile.dart';

enum LevelDifficulty {
  easy,
  medium,
  hard,
  expert,
}

enum LevelObjectiveType {
  collectTiles,
  clearBlockers,
  reachScore,
  freeCreature,
  clearJelly,
}

class LevelObjective {
  final LevelObjectiveType type;
  final TileType? tileType;
  final int target;
  int current;

  LevelObjective({
    required this.type,
    this.tileType,
    required this.target,
    this.current = 0,
  });

  bool get isCompleted => current >= target;

  double get progress => target > 0 ? current / target : 0.0;

  LevelObjective copyWith({
    LevelObjectiveType? type,
    TileType? tileType,
    int? target,
    int? current,
  }) {
    return LevelObjective(
      type: type ?? this.type,
      tileType: tileType ?? this.tileType,
      target: target ?? this.target,
      current: current ?? this.current,
    );
  }
}

class Level {
  final int id;
  final String name;
  final String description;
  final LevelDifficulty difficulty;
  final int gridSize;
  final int maxMoves;
  final int targetScore;
  final List<LevelObjective> objectives;
  final List<List<int>> initialGrid; // -1 = vide, 0-7 = types de tuiles
  final List<List<bool>> blockers; // true = bloqué
  final List<List<bool>> jelly; // true = gelée
  final Map<String, dynamic> specialRules;
  final int energyCost;
  final List<String> rewards;
  final bool isUnlocked;
  final int stars; // 0-3

  Level({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.gridSize,
    required this.maxMoves,
    required this.targetScore,
    required this.objectives,
    required this.initialGrid,
    required this.blockers,
    required this.jelly,
    required this.specialRules,
    required this.energyCost,
    required this.rewards,
    this.isUnlocked = false,
    this.stars = 0,
  });

  // Créer un niveau simple
  factory Level.simple({
    required int id,
    required String name,
    required TileType targetTile,
    required int targetCount,
    int gridSize = 7,
    int maxMoves = 20,
  }) {
    return Level(
      id: id,
      name: name,
      description: 'Collectez $targetCount ${targetTile.name}s',
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
      rewards: ['coins:10'],
    );
  }

  // Vérifier si le niveau est terminé
  bool isCompleted(List<LevelObjective> currentObjectives) {
    return currentObjectives.every((objective) => objective.isCompleted);
  }

  // Calculer le nombre d'étoiles
  int calculateStars(int score, int movesUsed) {
    if (score >= targetScore * 1.5) return 3;
    if (score >= targetScore * 1.2) return 2;
    if (score >= targetScore) return 1;
    return 0;
  }

  // Obtenir la couleur de difficulté
  int get difficultyColor {
    switch (difficulty) {
      case LevelDifficulty.easy:
        return 0xFF48BB78; // Vert
      case LevelDifficulty.medium:
        return 0xFFFFD700; // Jaune
      case LevelDifficulty.hard:
        return 0xFFFF6B35; // Orange
      case LevelDifficulty.expert:
        return 0xFFE53E3E; // Rouge
    }
  }

  // Copier un niveau
  Level copyWith({
    int? id,
    String? name,
    String? description,
    LevelDifficulty? difficulty,
    int? gridSize,
    int? maxMoves,
    int? targetScore,
    List<LevelObjective>? objectives,
    List<List<int>>? initialGrid,
    List<List<bool>>? blockers,
    List<List<bool>>? jelly,
    Map<String, dynamic>? specialRules,
    int? energyCost,
    List<String>? rewards,
    bool? isUnlocked,
    int? stars,
  }) {
    return Level(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      gridSize: gridSize ?? this.gridSize,
      maxMoves: maxMoves ?? this.maxMoves,
      targetScore: targetScore ?? this.targetScore,
      objectives: objectives ?? this.objectives,
      initialGrid: initialGrid ?? this.initialGrid,
      blockers: blockers ?? this.blockers,
      jelly: jelly ?? this.jelly,
      specialRules: specialRules ?? this.specialRules,
      energyCost: energyCost ?? this.energyCost,
      rewards: rewards ?? this.rewards,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      stars: stars ?? this.stars,
    );
  }

  @override
  String toString() {
    return 'Level(id: $id, name: $name, difficulty: $difficulty)';
  }
}
