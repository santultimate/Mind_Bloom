import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/tile.dart';
import '../models/level.dart';
import 'collection_provider.dart';
import 'user_provider.dart';

class GameProvider extends ChangeNotifier {
  List<List<Tile?>> _grid = [];
  List<List<Tile?>> get grid => _grid;

  int _score = 0;
  int get score => _score;

  int _movesLeft = 0;
  int get movesLeft => _movesLeft;

  // Système de temps pour la durée du niveau (en secondes)
  // Ce minuteur compte le temps restant pour terminer le niveau
  int _timeLeft = 0;
  int get timeLeft => _timeLeft;

  // Timer supprimé - le jeu n'a plus de limite de temps
  // Timer? _gameTimer;
  // bool _isTimeRunning = false;
  // bool get isTimeRunning => _isTimeRunning;

  Level? _currentLevel;
  Level? get currentLevel => _currentLevel;

  List<LevelObjective> _currentObjectives = [];
  List<LevelObjective> get currentObjectives => _currentObjectives;

  bool _isAnimating = false;
  bool get isAnimating => _isAnimating;

  Tile? _selectedTile;
  Tile? get selectedTile => _selectedTile;

  // 🔧 OPTIMISATION PHASE 2: Batch updates pour réduire les notifyListeners()
  bool _shouldNotify = true;

  /// Groupe plusieurs mises à jour en un seul notifyListeners()
  void _batchUpdate(Function updates) {
    _shouldNotify = false;
    updates();
    _shouldNotify = true;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (_shouldNotify) super.notifyListeners();
  }

  // Animation de permutation
  Tile? _swappingTile1;
  Tile? _swappingTile2;
  bool _isSwapping = false;
  Tile? get swappingTile1 => _swappingTile1;
  Tile? get swappingTile2 => _swappingTile2;
  bool get isSwapping => _isSwapping;

  // Effet de prévisualisation
  Tile? _previewTile1;
  Tile? _previewTile2;
  bool _showPreview = false;
  Tile? get previewTile1 => _previewTile1;
  Tile? get previewTile2 => _previewTile2;
  bool get showPreview => _showPreview;

  int _nextTileId = 0; // ID unique global

  final math.Random _random = math.Random();

  // Référence au CollectionProvider pour les bonus
  CollectionProvider? _collectionProvider;

  /// Initialisation du niveau
  Future<bool> startLevel(Level level,
      {CollectionProvider? collectionProvider,
      UserProvider? userProvider}) async {
    // Consommer une vie avant de commencer le niveau
    if (userProvider != null) {
      final lifeUsed = await userProvider.useLife();
      if (!lifeUsed) {
        // Pas de vie disponible
        return false;
      }
    }

    _collectionProvider = collectionProvider;
    _currentLevel = level;

    // 🔧 CORRECTION: Réinitialiser complètement les objectifs avec current = 0
    // 🚀 NOUVEAU: Consolider les objectifs similaires pour éviter la redondance
    final consolidatedObjectives =
        Level.consolidateObjectives(level.objectives);
    _currentObjectives = consolidatedObjectives
        .map((objective) => LevelObjective(
              type: objective.type,
              tileType: objective.tileType,
              target: objective.target,
              current: 0, // Réinitialiser à 0
            ))
        .toList();

    _score = 0;
    _movesLeft = level.maxMoves;
    _selectedTile = null;
    _nextTileId = 0;

    // Debug pour tous les niveaux (commenté pour production)
    // if (kDebugMode) {
    //   debugPrint('=== DEBUG LEVEL ${level.id} GAMEPLAY ===');
    //   debugPrint('Starting Level ${level.id} with:');
    //   debugPrint('  Grid Size: ${level.gridSize}');
    //   debugPrint('  Max Moves: ${level.maxMoves}');
    //   debugPrint('  Time Left: ${_calculateTimeForLevel(level)}');
    //   debugPrint('  Objectives: ${level.objectives.length}');
    // }

    // 🚀 TIMER SUPPRIMÉ - Le jeu n'a plus de limite de temps
    _timeLeft = 0; // Pas de timer de jeu

    // Appliquer les bonus des collections
    _applyCollectionBonuses();

    _generateGrid(level.gridSize);

    // Debug de la grille générée pour tous les niveaux (commenté pour production)
    // if (kDebugMode) {
    //   debugPrint('Level ${level.id} Grid Generated:');

    //   // Debug de la distribution des tuiles
    //   final tileCounts = <TileType, int>{};
    //   for (int row = 0; row < _grid.length; row++) {
    //     String rowStr = '';
    //     for (int col = 0; col < _grid[row].length; col++) {
    //       if (_grid[row][col] != null) {
    //         final tile = _grid[row][col]!;
    //         final type = tile.type;
    //         tileCounts[type] = (tileCounts[type] ?? 0) + 1;
    //         rowStr += '${type.name[0].toUpperCase()} ';
    //       } else {
    //         rowStr += 'X ';
    //       }
    //     }
    //     debugPrint('  Row $row: $rowStr');
    //   }

    //   // Afficher la distribution des tuiles
    //   debugPrint('Tile Distribution:');
    //   tileCounts.forEach((type, count) {
    //     debugPrint('  $type: $count');
    //   });

    //   // Vérifier les objectifs
    //   debugPrint('Objectives Check:');
    //   for (final objective in _currentObjectives) {
    //     if (objective.type == LevelObjectiveType.collectTiles &&
    //         objective.tileType != null) {
    //       final available = tileCounts[objective.tileType!] ?? 0;
    //       final required = objective.target;
    //       final status = available >= required ? '✅' : '❌';
    //       debugPrint('  $status ${objective.tileType}: $available/$required');
    //     }
    //   }

    //   debugPrint('==============================');
    // }

    notifyListeners();
    return true;
  }

  /// Génère une grille sans matches initiaux
  void _generateGrid(int size) {
    // Protection contre les tailles invalides
    if (size <= 0) {
      _grid = [];
      return;
    }

    _grid = List.generate(size, (row) => List.filled(size, null));

    // Calculer la distribution des tuiles basée sur les objectifs
    final tileDistribution = _calculateTileDistribution(size * size);

    // Remplir la grille ligne par ligne avec la distribution optimisée
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        _grid[row][col] =
            _createSafeTileWithDistribution(row, col, tileDistribution);
      }
    }
  }

  /// Calcule la distribution optimale des tuiles basée sur les objectifs et la difficulté
  /// Inspiré de Candy Crush : garantit que les objectifs sont réalisables
  Map<TileType, int> _calculateTileDistribution(int totalTiles) {
    final distribution = <TileType, int>{};

    // 🎯 CALCULER LES OBJECTIFS REQUIS
    final requiredTileTypes = <TileType, int>{};
    int totalRequiredTiles = 0;

    for (final objective in _currentObjectives) {
      if (objective.type == LevelObjectiveType.collectTiles &&
          objective.tileType != null) {
        final required = objective.target;
        requiredTileTypes[objective.tileType!] = required;
        totalRequiredTiles += required;
      }
    }

    if (totalRequiredTiles == 0) {
      // Pas d'objectifs de tuiles, distribution équitable
      final baseCount = totalTiles ~/ TileType.values.length;
      final remainder = totalTiles % TileType.values.length;

      for (int i = 0; i < TileType.values.length; i++) {
        final tileType = TileType.values[i];
        distribution[tileType] = baseCount + (i < remainder ? 1 : 0);
      }
      return distribution;
    }

    // 🎯 DISTRIBUTION GARANTIE ET ÉQUITABLE
    // 1. Garantir que chaque tuile d'objectif soit présente avec marge de sécurité
    for (final entry in requiredTileTypes.entries) {
      final tileType = entry.key;
      final required = entry.value;

      // 🚀 GARANTIR 150% du nombre requis pour assurer la faisabilité
      // Mais pas plus que 40% du total pour maintenir le défi
      final maxAllowed = (totalTiles * 0.4).round();
      final guaranteed = math.min(
          math.max((required * 1.5).round(), required + 5), maxAllowed);
      distribution[tileType] = guaranteed;
    }

    // 2. Calculer l'espace restant pour les tuiles non-objectifs
    final usedForObjectives =
        distribution.values.fold(0, (sum, count) => sum + count);
    final remainingForOthers = totalTiles - usedForObjectives;

    // 3. Vérifier si on a assez d'espace pour les objectifs
    if (remainingForOthers < 0) {
      // Si on a trop alloué aux objectifs, s'assurer qu'on a au moins les tuiles requises
      for (final entry in requiredTileTypes.entries) {
        final tileType = entry.key;
        final required = entry.value;
        // S'assurer qu'on a au minimum le nombre requis + 10% de marge
        final minimum = (required * 1.1).round();
        if (distribution[tileType]! < minimum) {
          distribution[tileType] = minimum;
        }
      }

      // Réduire proportionnellement si nécessaire
      final newUsedForObjectives =
          distribution.values.fold(0, (sum, count) => sum + count);
      if (newUsedForObjectives > totalTiles) {
        final scale = totalTiles / newUsedForObjectives;
        for (final entry in distribution.entries.toList()) {
          distribution[entry.key] = (entry.value * scale).round();
        }
      }

      // Réajuster le total
      final finalTotal =
          distribution.values.fold(0, (sum, count) => sum + count);
      final difference = totalTiles - finalTotal;
      if (difference != 0) {
        final mostCommonType = distribution.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;
        distribution[mostCommonType] =
            distribution[mostCommonType]! + difference;
      }
      return distribution;
    }

    // 3. Distribuer les 2/3 restants entre les types non-objectifs pour corser le jeu
    final otherTypes =
        TileType.values.where((t) => !distribution.containsKey(t)).toList();

    if (otherTypes.isNotEmpty && remainingForOthers > 0) {
      // Distribution équitable pour les tuiles non-objectifs
      final baseCount = remainingForOthers ~/ otherTypes.length;
      final remainder = remainingForOthers % otherTypes.length;

      for (int i = 0; i < otherTypes.length; i++) {
        final tileType = otherTypes[i];
        // Variation contrôlée pour maintenir l'équilibre (±1)
        final variation = _random.nextInt(3) - 1; // -1, 0, ou +1
        final count = baseCount + (i < remainder ? 1 : 0) + variation;
        distribution[tileType] =
            math.max(1, count); // Au moins 1 de chaque type
      }
    }

    // 4. Ajustement final pour respecter le total exact
    final finalTotal = distribution.values.fold(0, (sum, count) => sum + count);
    if (finalTotal != totalTiles) {
      final difference = totalTiles - finalTotal;
      if (difference > 0) {
        // Ajouter aux types les plus nombreux
        final sortedEntries = distribution.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        if (sortedEntries.isNotEmpty) {
          distribution[sortedEntries.first.key] =
              sortedEntries.first.value + difference;
        }
      } else if (difference < 0) {
        // Retirer des types les plus nombreux
        final sortedEntries = distribution.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final toRemove = (-difference);
        for (final entry in sortedEntries) {
          if (entry.value > 1 && toRemove > 0) {
            final removeCount = math.min(toRemove, entry.value - 1);
            distribution[entry.key] = entry.value - removeCount;
            break;
          }
        }
      }
    }

    // 🔧 CORRECTION: Vérification finale de sécurité
    final finalCheck = distribution.values.fold(0, (sum, count) => sum + count);
    if (finalCheck != totalTiles) {
      // Si le total est encore incorrect, forcer une distribution équitable
      final baseCount = totalTiles ~/ TileType.values.length;
      final remainder = totalTiles % TileType.values.length;

      distribution.clear();
      for (int i = 0; i < TileType.values.length; i++) {
        final tileType = TileType.values[i];
        distribution[tileType] = baseCount + (i < remainder ? 1 : 0);
      }
    }

    return distribution;
  }

  /// Calcule le facteur de difficulté basé sur le niveau actuel
  double _calculateDifficultyFactor() {
    if (_currentLevel == null) return 0.0;

    // Facteur de difficulté basé sur l'ID du niveau (0.0 à 2.0)
    final levelId = _currentLevel!.id;
    final difficultyFactor = (levelId / 50.0).clamp(0.0, 2.0);

    // Ajustement basé sur la difficulté du niveau
    double difficultyMultiplier = 1.0;
    switch (_currentLevel!.difficulty) {
      case LevelDifficulty.easy:
        difficultyMultiplier = 0.5;
        break;
      case LevelDifficulty.medium:
        difficultyMultiplier = 1.0;
        break;
      case LevelDifficulty.hard:
        difficultyMultiplier = 1.5;
        break;
      case LevelDifficulty.expert:
        difficultyMultiplier = 2.0;
        break;
    }

    return difficultyFactor * difficultyMultiplier;
  }

  /// Crée une tuile qui ne génère pas de match avec distribution optimisée
  Tile _createSafeTileWithDistribution(
      int row, int col, Map<TileType, int> distribution) {
    // Créer une liste des types disponibles basée sur la distribution
    final availableTypes = <TileType>[];
    for (final entry in distribution.entries) {
      for (int i = 0; i < entry.value; i++) {
        availableTypes.add(entry.key);
      }
    }

    // Mélanger pour éviter les patterns prévisibles
    availableTypes.shuffle(_random);

    // Calculer le facteur de difficulté pour ajuster la stratégie
    final difficultyFactor = _calculateDifficultyFactor();

    while (availableTypes.isNotEmpty) {
      final type = availableTypes.removeAt(0);
      final newTile = Tile(id: _nextTileId++, type: type, row: row, col: col);

      // Vérifications de base pour éviter les matches directs
      if (_wouldCreateMatch(type, row, col)) {
        continue;
      }

      // Pour les niveaux difficiles, vérifier aussi les patterns complexes
      if (difficultyFactor > 1.0 &&
          _wouldCreateComplexPattern(type, row, col)) {
        continue;
      }

      return newTile;
    }

    // Fallback si tous les types ont été essayés
    return _createSafeTile(row, col);
  }

  /// Vérifie si un type de tuile créerait un match direct
  bool _wouldCreateMatch(TileType type, int row, int col) {
    // Vérifie si ce choix crée un match horizontal
    if (col >= 2 &&
        _grid[row][col - 1] != null &&
        _grid[row][col - 2] != null &&
        _grid[row][col - 1]!.type == type &&
        _grid[row][col - 2]!.type == type) {
      return true;
    }

    // Vérifie si ce choix crée un match vertical
    if (row >= 2 &&
        _grid[row - 1][col] != null &&
        _grid[row - 2][col] != null &&
        _grid[row - 1][col]!.type == type &&
        _grid[row - 2][col]!.type == type) {
      return true;
    }

    return false;
  }

  /// Vérifie si un type de tuile créerait un pattern complexe (pour niveaux difficiles)
  bool _wouldCreateComplexPattern(TileType type, int row, int col) {
    // Vérifier les patterns en L
    if (_wouldCreateLPattern(type, row, col)) return true;

    // Vérifier les patterns en T
    if (_wouldCreateTPattern(type, row, col)) return true;

    // Vérifier les patterns en ligne de 4
    if (_wouldCreateLineOf4(type, row, col)) return true;

    return false;
  }

  /// Vérifie si un type créerait un pattern en L
  bool _wouldCreateLPattern(TileType type, int row, int col) {
    // Pattern L vers le bas-droite
    if (row >= 1 &&
        col >= 1 &&
        _grid[row - 1][col] != null &&
        _grid[row][col - 1] != null &&
        _grid[row - 1][col]!.type == type &&
        _grid[row][col - 1]!.type == type) {
      return true;
    }

    // Pattern L vers le bas-gauche
    if (row >= 1 &&
        col + 1 < _grid.length &&
        _grid[row - 1][col] != null &&
        _grid[row][col + 1] != null &&
        _grid[row - 1][col]!.type == type &&
        _grid[row][col + 1]!.type == type) {
      return true;
    }

    return false;
  }

  /// Vérifie si un type créerait un pattern en T
  bool _wouldCreateTPattern(TileType type, int row, int col) {
    // Pattern T vers le bas
    if (row >= 1 &&
        col >= 1 &&
        col + 1 < _grid.length &&
        _grid[row - 1][col] != null &&
        _grid[row][col - 1] != null &&
        _grid[row][col + 1] != null &&
        _grid[row - 1][col]!.type == type &&
        _grid[row][col - 1]!.type == type &&
        _grid[row][col + 1]!.type == type) {
      return true;
    }

    return false;
  }

  /// Vérifie si un type créerait une ligne de 4
  bool _wouldCreateLineOf4(TileType type, int row, int col) {
    // Vérifier horizontalement
    int horizontalCount = 1;
    for (int c = col - 1; c >= 0 && _grid[row][c]?.type == type; c--) {
      horizontalCount++;
    }
    for (int c = col + 1;
        c < _grid.length && _grid[row][c]?.type == type;
        c++) {
      horizontalCount++;
    }
    if (horizontalCount >= 4) return true;

    // Vérifier verticalement
    int verticalCount = 1;
    for (int r = row - 1; r >= 0 && _grid[r][col]?.type == type; r--) {
      verticalCount++;
    }
    for (int r = row + 1;
        r < _grid.length && _grid[r][col]?.type == type;
        r++) {
      verticalCount++;
    }
    if (verticalCount >= 4) return true;

    return false;
  }

  /// Crée une tuile qui ne génère pas de match (méthode de fallback)
  Tile _createSafeTile(int row, int col) {
    while (true) {
      final type = TileType.values[_random.nextInt(TileType.values.length)];
      final newTile = Tile(id: _nextTileId++, type: type, row: row, col: col);

      // Vérifie si ce choix crée un match horizontal
      if (col >= 2 &&
          _grid[row][col - 1] != null &&
          _grid[row][col - 2] != null &&
          _grid[row][col - 1]!.type == type &&
          _grid[row][col - 2]!.type == type) {
        continue;
      }

      // Vérifie si ce choix crée un match vertical
      if (row >= 2 &&
          _grid[row - 1][col] != null &&
          _grid[row - 2][col] != null &&
          _grid[row - 1][col]!.type == type &&
          _grid[row - 2][col]!.type == type) {
        continue;
      }

      return newTile;
    }
  }

  /// Sélection / Swap
  void selectTile(Tile tile) {
    if (_isAnimating || _isSwapping) return;

    if (_selectedTile == null) {
      _selectedTile = tile;
      _clearPreview();
    } else {
      if (_areAdjacent(_selectedTile!, tile)) {
        _startSwapAnimation(_selectedTile!, tile);
      } else {
        _selectedTile = tile;
        _clearPreview();
      }
    }
    notifyListeners();
  }

  /// Démarre l'animation de permutation
  void _startSwapAnimation(Tile tile1, Tile tile2) {
    _isSwapping = true;
    _swappingTile1 = tile1;
    _swappingTile2 = tile2;
    _clearPreview();
    notifyListeners();

    // Effectuer la permutation après un court délai pour l'animation
    Future.delayed(const Duration(milliseconds: 400), () {
      _executeSwap(tile1, tile2);
    });
  }

  /// Exécute la permutation réelle
  void _executeSwap(Tile tile1, Tile tile2) {
    _swapTiles(tile1, tile2);

    if (_hasMatches()) {
      _movesLeft--;
      _processMatches();
    } else {
      // Swap invalide → revert avec animation
      Future.delayed(const Duration(milliseconds: 200), () {
        _swapTiles(tile1, tile2);
        _isSwapping = false;
        _swappingTile1 = null;
        _swappingTile2 = null;
        _selectedTile = null;
        notifyListeners();
      });
      return;
    }

    _isSwapping = false;
    _swappingTile1 = null;
    _swappingTile2 = null;
    _selectedTile = null;
    notifyListeners();
  }

  /// Efface la prévisualisation
  void _clearPreview() {
    _previewTile1 = null;
    _previewTile2 = null;
    _showPreview = false;
  }

  /// Vérifie si deux tuiles sont adjacentes
  bool _areAdjacent(Tile a, Tile b) {
    return (a.row == b.row && (a.col - b.col).abs() == 1) ||
        (a.col == b.col && (a.row - b.row).abs() == 1);
  }

  /// Échange deux tuiles
  void _swapTiles(Tile a, Tile b) {
    final tempRow = a.row;
    final tempCol = a.col;
    a.row = b.row;
    a.col = b.col;
    b.row = tempRow;
    b.col = tempCol;

    _grid[a.row][a.col] = a;
    _grid[b.row][b.col] = b;
  }

  /// Détection des matches actuels (optimisée)
  List<Set<Tile>> _findMatches() {
    final matches = <Set<Tile>>[];
    final processedTiles = <Tile>{};

    final size = _grid.length;

    // Horizontal
    for (int r = 0; r < size; r++) {
      int streak = 1;
      for (int c = 1; c < size; c++) {
        if (_grid[r][c] != null &&
            _grid[r][c - 1] != null &&
            _grid[r][c]!.type == _grid[r][c - 1]!.type) {
          streak++;
          // 🔧 CORRECTION: Vérifier le match à la fin de la ligne
          if (c == size - 1 && streak >= 3) {
            final match = _grid[r]
                .sublist(c - streak + 1, c + 1)
                .whereType<Tile>()
                .where((tile) => !processedTiles.contains(tile))
                .toSet();
            if (match.isNotEmpty) {
              matches.add(match);
              processedTiles.addAll(match);
            }
          }
        } else {
          if (streak >= 3) {
            final match = _grid[r]
                .sublist(c - streak, c)
                .whereType<Tile>()
                .where((tile) => !processedTiles.contains(tile))
                .toSet();
            if (match.isNotEmpty) {
              matches.add(match);
              processedTiles.addAll(match);
            }
          }
          streak = 1;
        }
      }
    }

    // Vertical
    for (int c = 0; c < size; c++) {
      int streak = 1;
      for (int r = 1; r < size; r++) {
        if (_grid[r][c] != null &&
            _grid[r - 1][c] != null &&
            _grid[r][c]!.type == _grid[r - 1][c]!.type) {
          streak++;
          // 🔧 CORRECTION: Vérifier le match à la fin de la colonne
          if (r == size - 1 && streak >= 3) {
            final match = _grid
                .sublist(r - streak + 1, r + 1)
                .map((row) => row[c])
                .whereType<Tile>()
                .where((tile) => !processedTiles.contains(tile))
                .toSet();
            if (match.isNotEmpty) {
              matches.add(match);
              processedTiles.addAll(match);
            }
          }
        } else {
          if (streak >= 3) {
            final match = _grid
                .sublist(r - streak, r)
                .map((row) => row[c])
                .whereType<Tile>()
                .where((tile) => !processedTiles.contains(tile))
                .toSet();
            if (match.isNotEmpty) {
              matches.add(match);
              processedTiles.addAll(match);
            }
          }
          streak = 1;
        }
      }
    }

    return matches;
  }

  bool _hasMatches() => _findMatches().isNotEmpty;

  /// Process complet : matches → suppression → gravité → refill → cascade
  /// 🔧 OPTIMISÉ: Utilisation de _batchUpdate pour réduire les rebuilds
  Future<void> _processMatches() async {
    if (_isAnimating) return;
    _isAnimating = true;

    int comboCount = 0;
    int totalMatchedTiles = 0;
    const maxCombos = 5; // Augmenté pour plus de satisfaction

    while (comboCount < maxCombos) {
      final matches = _findMatches();
      if (matches.isEmpty) break;

      comboCount++;

      // Calculer les bonus de combo
      int comboMultiplier = 1;
      if (comboCount >= 2) comboMultiplier = 2;
      if (comboCount >= 3) comboMultiplier = 3;
      if (comboCount >= 4) comboMultiplier = 4;
      if (comboCount >= 5) comboMultiplier = 5;

      // 🔧 GROUPER: suppression, score et objectifs en un seul update
      _batchUpdate(() {
        for (var match in matches) {
          totalMatchedTiles += match.length;

          for (var tile in match) {
            _grid[tile.row][tile.col] = null;
            _updateObjectives(tile.type);
          }

          // Score avec bonus pour les combos spéciaux et les cascades
          int baseScore = match.length * 15; // Augmenté de 10 à 15

          // Bonus de taille de match
          if (match.length >= 7) {
            baseScore *= 5; // Bonus x5 pour 7+ tuiles (nouveau)
          } else if (match.length >= 6) {
            baseScore *= 4; // Bonus x4 pour 6 tuiles (nouveau)
          } else if (match.length >= 5) {
            baseScore *= 3; // Bonus x3 pour 5+ tuiles
          } else if (match.length >= 4) {
            baseScore *= 2; // Bonus x2 pour 4 tuiles
          }

          // Bonus de combo en cascade
          baseScore *= comboMultiplier;

          // Bonus spécial pour les gros combos
          if (totalMatchedTiles >= 20) {
            baseScore *= 2; // Bonus spectaculaire
          }

          // Appliquer les bonus des collections
          baseScore = _applyScoreMultiplier(baseScore);

          _score += baseScore;

          // Mettre à jour les objectifs de score
          _updateScoreObjectives();

          // Feedback spécial pour les gros matches
          if (match.length >= 5) {
            _showSpecialEffect(match);
          }
        }
      });
      await Future.delayed(const Duration(
          milliseconds: 350)); // Légèrement plus long pour apprécier

      // 🔧 GROUPER: gravité et refill ensemble
      _batchUpdate(() {
        _applyGravity();
      });
      await Future.delayed(const Duration(milliseconds: 250));

      _batchUpdate(() {
        _fillEmpty();
      });
      await Future.delayed(const Duration(milliseconds: 250));
    }

    // 🔧 GROUPER: Récompenses finales et fin d'animation
    _batchUpdate(() {
      // Récompenses bonus pour les gros combos
      if (comboCount >= 3) {
        _score += comboCount * 50; // Bonus de combo
      }
      if (comboCount >= 5) {
        _score += 200; // Bonus spectaculaire
      }

      // Mettre à jour les objectifs de score avec les bonus finaux
      _updateScoreObjectives();

      _isAnimating = false;
    });

    // Vérifier si le jeu est terminé
    _checkGameEnd();
  }

  /// Affiche un effet spécial pour les gros matches
  void _showSpecialEffect(Set<Tile> match) {
    // Cette méthode peut être étendue pour des effets visuels
    // Commenté pour la version de production
    // if (kDebugMode) {
    //   debugPrint('SPECIAL EFFECT: ${match.length} tiles matched!');
    // }
  }

  // Méthodes de timer supprimées - le jeu n'a plus de limite de temps
  // int _calculateTimeForLevel(Level level) { ... }
  // void _startGameTimer() { ... }
  // void _stopGameTimer() { ... }

  /// Vérifie si le jeu est terminé et déclenche le callback
  void _checkGameEnd() {
    // Protection contre les états invalides
    if (_currentLevel == null || _gameEndCallback == null) return;

    if (isGameOver()) {
      final won = isLevelCompleted();
      final stars = _calculateStars();
      final movesUsed = (_currentLevel!.maxMoves - _movesLeft)
          .clamp(0, _currentLevel!.maxMoves);
      _gameEndCallback!(won, stars, _score, movesUsed);
    }
  }

  /// Calcule le nombre d'étoiles avec le nouveau système intelligent
  int _calculateStars() {
    if (_currentLevel == null) return 0;

    final movesUsed = _currentLevel!.maxMoves - _movesLeft;
    return _currentLevel!.calculateStars(_score, movesUsed, _currentObjectives);
  }

  /// Calcule le nombre d'étoiles (méthode publique pour l'interface)
  int calculateStars() {
    return _calculateStars();
  }

  /// Applique la gravité
  void _applyGravity() {
    final size = _grid.length;
    bool moved = true;
    int iterations = 0;
    const maxIterations =
        10; // 🔧 CORRECTION: Protection contre les boucles infinies

    while (moved && iterations < maxIterations) {
      moved = false;
      iterations++;

      for (int c = 0; c < size; c++) {
        for (int r = size - 1; r >= 0; r--) {
          if (_grid[r][c] == null) {
            int above = r - 1;
            while (above >= 0 && _grid[above][c] == null) {
              above--;
            }
            if (above >= 0) {
              final tile = _grid[above][c]!;
              _grid[r][c] = tile..row = r;
              _grid[above][c] = null;
              moved = true;
            }
          }
        }
      }
    }

    // 🔧 CORRECTION: Log d'avertissement si trop d'itérations
    if (iterations >= maxIterations) {
      // Commenté pour la version de production
      // if (kDebugMode) {
      //   debugPrint('Warning: Gravity loop reached max iterations');
      // }
    }
  }

  /// Remplit les cases vides en haut
  void _fillEmpty() {
    final size = _grid.length;

    // Calculer la distribution des tuiles pour le remplissage
    final tileDistribution = _calculateTileDistribution(size * size);

    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (_grid[r][c] == null) {
          _grid[r][c] =
              _createSmartTileWithDistribution(r, c, tileDistribution);
        }
      }
    }
  }

  /// Crée une tuile intelligente qui évite les matches directs avec distribution optimisée
  Tile _createSmartTileWithDistribution(
      int row, int col, Map<TileType, int> distribution) {
    // Créer une liste des types disponibles basée sur la distribution
    final availableTypes = <TileType>[];
    for (final entry in distribution.entries) {
      for (int i = 0; i < entry.value; i++) {
        availableTypes.add(entry.key);
      }
    }

    // Mélanger pour éviter les patterns prévisibles
    availableTypes.shuffle(_random);

    // Essayer de trouver un type qui ne crée pas de match
    for (int attempt = 0; attempt < availableTypes.length; attempt++) {
      final type = availableTypes[attempt];

      // Vérifier si ce type crée un match horizontal
      bool createsHorizontalMatch = false;
      if (col >= 2 &&
          _grid[row][col - 1] != null &&
          _grid[row][col - 2] != null &&
          _grid[row][col - 1]!.type == type &&
          _grid[row][col - 2]!.type == type) {
        createsHorizontalMatch = true;
      }

      // Vérifier si ce type crée un match vertical
      bool createsVerticalMatch = false;
      if (row >= 2 &&
          _grid[row - 1][col] != null &&
          _grid[row - 2][col] != null &&
          _grid[row - 1][col]!.type == type &&
          _grid[row - 2][col]!.type == type) {
        createsVerticalMatch = true;
      }

      // Si ce type ne crée pas de match, l'utiliser
      if (!createsHorizontalMatch && !createsVerticalMatch) {
        return Tile(id: _nextTileId++, type: type, row: row, col: col);
      }
    }

    // Si aucun type "sûr" n'est trouvé, utiliser la méthode de fallback
    return _createSmartTile(row, col);
  }

  /// Crée une tuile intelligente qui évite les matches directs (méthode de fallback)
  Tile _createSmartTile(int row, int col) {
    final availableTypes = TileType.values.toList();

    // Essayer de trouver un type qui ne crée pas de match
    for (int attempt = 0; attempt < 10; attempt++) {
      final type = availableTypes[_random.nextInt(availableTypes.length)];

      // Vérifier si ce type crée un match horizontal
      bool createsHorizontalMatch = false;
      if (col >= 2 &&
          _grid[row][col - 1] != null &&
          _grid[row][col - 2] != null &&
          _grid[row][col - 1]!.type == type &&
          _grid[row][col - 2]!.type == type) {
        createsHorizontalMatch = true;
      }

      // Vérifier si ce type crée un match vertical
      bool createsVerticalMatch = false;
      if (row >= 2 &&
          _grid[row - 1][col] != null &&
          _grid[row - 2][col] != null &&
          _grid[row - 1][col]!.type == type &&
          _grid[row - 2][col]!.type == type) {
        createsVerticalMatch = true;
      }

      // Si ce type ne crée pas de match, l'utiliser
      if (!createsHorizontalMatch && !createsVerticalMatch) {
        return Tile(id: _nextTileId++, type: type, row: row, col: col);
      }
    }

    // Si aucun type "sûr" n'est trouvé après 10 tentatives, utiliser un type aléatoire
    final fallbackType =
        TileType.values[_random.nextInt(TileType.values.length)];
    return Tile(id: _nextTileId++, type: fallbackType, row: row, col: col);
  }

  /// Met à jour les objectifs avec une tuile collectée
  void _updateObjectives(TileType tileType) {
    for (final objective in _currentObjectives) {
      if (objective.type == LevelObjectiveType.collectTiles &&
          objective.tileType == tileType) {
        // 🔧 CORRECTION: Vérifier les limites pour éviter les débordements
        if (objective.current < objective.target) {
          objective.current++;
        }
      }
    }

    // 🚀 CORRECTION: Vérifier immédiatement si tous les objectifs sont atteints
    if (isLevelCompleted()) {
      // Arrêter le traitement des matches et terminer le jeu
      _isAnimating = false;
      notifyListeners();
      _checkGameEnd();
    }
  }

  /// Met à jour les objectifs de score
  void _updateScoreObjectives() {
    for (final objective in _currentObjectives) {
      if (objective.type == LevelObjectiveType.reachScore) {
        objective.current = _score;
      }
    }

    // 🚀 CORRECTION: Vérifier immédiatement si tous les objectifs sont atteints
    if (isLevelCompleted()) {
      // Arrêter le traitement des matches et terminer le jeu
      _isAnimating = false;
      notifyListeners();
      _checkGameEnd();
    }
  }

  /// Vérifie si le niveau est complété
  bool isLevelCompleted() {
    return _currentObjectives.every((objective) => objective.isCompleted);
  }

  /// Vérifie si le jeu est terminé (plus de mouvements, temps écoulé ou niveau complété)
  bool isGameOver() {
    // 🚀 TIMER SUPPRIMÉ - Seuls les mouvements comptent
    return _movesLeft <= 0 || isLevelCompleted();
  }

  /// Calcule le progrès global des objectifs (0.0 à 1.0)
  double getOverallProgress() {
    if (_currentObjectives.isEmpty) return 0.0;

    double totalProgress = 0.0;
    for (final objective in _currentObjectives) {
      totalProgress += objective.current / objective.target;
    }
    return (totalProgress / _currentObjectives.length).clamp(0.0, 1.0);
  }

  /// Vérifie s'il reste des mouvements possibles
  bool hasValidMoves() {
    // Protection contre les états invalides
    if (_grid.isEmpty || _isAnimating) return false;

    final size = _grid.length;
    if (size <= 0) return false;

    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        final tile = _grid[r][c];
        if (tile == null) continue;

        // Vérifier mouvement vers le bas
        if (r + 1 < size) {
          final belowTile = _grid[r + 1][c];
          if (belowTile != null) {
            _swapTiles(tile, belowTile);
            final valid = _hasMatches();
            _swapTiles(tile, belowTile); // 🔧 CORRECTION: Restaurer l'état
            if (valid) return true;
          }
        }

        // Vérifier mouvement vers la droite
        if (c + 1 < size) {
          final rightTile = _grid[r][c + 1];
          if (rightTile != null) {
            _swapTiles(tile, rightTile);
            final valid = _hasMatches();
            _swapTiles(tile, rightTile); // 🔧 CORRECTION: Restaurer l'état
            if (valid) return true;
          }
        }
      }
    }
    return false;
  }

  // === MÉTHODES POUR L'INTERFACE UTILISATEUR ===

  /// Getter pour les mouvements restants (alias)
  int get movesRemaining => _movesLeft;

  /// Vérifie si le joueur peut jouer
  bool get canPlay => !_isAnimating && _movesLeft > 0;

  /// Callback pour la fin de jeu
  Function(bool won, int stars, int score, int movesUsed)? _gameEndCallback;

  /// Définit le callback de fin de jeu
  void setGameEndCallback(
      Function(bool won, int stars, int score, int movesUsed) callback) {
    _gameEndCallback = callback;
  }

  /// Mélange la grille
  void shuffleBoard() {
    if (_isAnimating) return;

    final size = _grid.length;
    final allTiles = <Tile>[];

    // Collecter toutes les tuiles
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (_grid[r][c] != null) {
          allTiles.add(_grid[r][c]!);
        }
      }
    }

    // Mélanger les types
    allTiles.shuffle(_random);

    // Redistribuer
    int index = 0;
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (_grid[r][c] != null) {
          _grid[r][c]!.type = allTiles[index].type;
          index++;
        }
      }
    }

    notifyListeners();
  }

  /// Trouve un indice (mouvement valide)
  List<Tile>? findHint() {
    final size = _grid.length;
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        final tile = _grid[r][c];
        if (tile == null) continue;

        // Vérifier mouvement vers le bas
        if (r + 1 < size) {
          final belowTile = _grid[r + 1][c];
          if (belowTile != null) {
            _swapTiles(tile, belowTile);
            if (_hasMatches()) {
              _swapTiles(tile, belowTile); // 🔧 CORRECTION: Restaurer l'état
              return [tile, belowTile];
            }
            _swapTiles(tile, belowTile); // 🔧 CORRECTION: Restaurer l'état
          }
        }

        // Vérifier mouvement vers la droite
        if (c + 1 < size) {
          final rightTile = _grid[r][c + 1];
          if (rightTile != null) {
            _swapTiles(tile, rightTile);
            if (_hasMatches()) {
              _swapTiles(tile, rightTile); // 🔧 CORRECTION: Restaurer l'état
              return [tile, rightTile];
            }
            _swapTiles(tile, rightTile); // 🔧 CORRECTION: Restaurer l'état
          }
        }
      }
    }
    return null;
  }

  /// État de l'indice actuel
  List<Tile>? _currentHint;
  List<Tile>? get currentHint => _currentHint;

  /// Affiche un indice visuel
  void showHint() {
    _currentHint = findHint();
    notifyListeners();

    // Masquer l'indice après 3 secondes
    Timer(const Duration(seconds: 3), () {
      _currentHint = null;
      notifyListeners();
    });
  }

  /// Masque l'indice actuel
  void hideHint() {
    _currentHint = null;
    notifyListeners();
  }

  /// État de pause
  bool _isPaused = false;
  bool get isPaused => _isPaused;

  /// Basculer la pause
  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  /// Remettre à zéro le jeu
  void resetGame() {
    // Réinitialiser l'état de pause
    _isPaused = false;

    // Réinitialiser les animations et sélections
    _isAnimating = false;
    _isSwapping = false;
    _selectedTile = null;
    _swappingTile1 = null;
    _swappingTile2 = null;
    _previewTile1 = null;
    _previewTile2 = null;
    _showPreview = false;

    if (_currentLevel != null) {
      // Redémarrer le niveau sans consommer de vie (c'est un redémarrage du même niveau)
      _restartLevel(_currentLevel!);
    }
  }

  /// Redémarre un niveau sans consommer de vie
  void _restartLevel(Level level) {
    _collectionProvider = _collectionProvider;
    _currentLevel = level;

    // 🔧 CORRECTION: Réinitialiser complètement les objectifs avec current = 0
    _currentObjectives = level.objectives
        .map((objective) => LevelObjective(
              type: objective.type,
              tileType: objective.tileType,
              target: objective.target,
              current: 0, // Réinitialiser à 0
            ))
        .toList();

    _score = 0;
    _movesLeft = level.maxMoves;
    _selectedTile = null;
    _nextTileId = 0;

    // 🚀 TIMER SUPPRIMÉ - Le jeu n'a plus de limite de temps
    _timeLeft = 0; // Pas de timer de jeu

    // Appliquer les bonus des collections
    _applyCollectionBonuses();

    _generateGrid(level.gridSize);

    notifyListeners();
  }

  // === MÉTHODES POUR LES COLLECTIONS ===

  /// Appliquer les bonus des collections au début du niveau
  void _applyCollectionBonuses() {
    if (_collectionProvider == null) return;

    final bonuses = _collectionProvider!.getActiveBonuses();

    // Bonus de mouvements supplémentaires
    if (bonuses.containsKey(BonusType.extraMoves)) {
      _movesLeft = (_movesLeft + bonuses[BonusType.extraMoves]!.toInt())
          .clamp(0, _currentLevel!.maxMoves);
    }
  }

  /// Appliquer le multiplicateur de score des collections
  int _applyScoreMultiplier(int baseScore) {
    if (_collectionProvider == null) return baseScore;

    final bonuses = _collectionProvider!.getActiveBonuses();

    if (bonuses.containsKey(BonusType.scoreMultiplier)) {
      return (baseScore * bonuses[BonusType.scoreMultiplier]!).toInt();
    }

    return baseScore;
  }

  /// Mettre à jour la progression des collections
  void updateCollectionProgress({
    int? matches,
    int? perfectLevel,
  }) {
    if (_collectionProvider == null) return;

    _collectionProvider!.updateProgress(
      score: _score,
      levelsCompleted: perfectLevel != null ? 1 : 0,
      matches: matches,
      perfectLevels: perfectLevel,
    );
  }

  /// Obtenir le multiplicateur de pièces des collections
  double getCoinMultiplier() {
    if (_collectionProvider == null) return 1.0;

    final bonuses = _collectionProvider!.getActiveBonuses();
    return bonuses[BonusType.coinMultiplier] ?? 1.0;
  }

  /// Obtenir les vies supplémentaires des collections
  int getExtraLives() {
    if (_collectionProvider == null) return 0;

    final bonuses = _collectionProvider!.getActiveBonuses();
    return bonuses[BonusType.extraLives]?.toInt() ?? 0;
  }
}
