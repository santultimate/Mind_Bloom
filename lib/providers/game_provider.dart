import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/tile.dart';
import '../models/level.dart';
import 'collection_provider.dart';

class GameProvider extends ChangeNotifier {
  List<List<Tile?>> _grid = [];
  List<List<Tile?>> get grid => _grid;

  int _score = 0;
  int get score => _score;

  int _movesLeft = 0;
  int get movesLeft => _movesLeft;

  Level? _currentLevel;
  Level? get currentLevel => _currentLevel;

  List<LevelObjective> _currentObjectives = [];
  List<LevelObjective> get currentObjectives => _currentObjectives;

  bool _isAnimating = false;
  bool get isAnimating => _isAnimating;

  Tile? _selectedTile;
  Tile? get selectedTile => _selectedTile;

  int _nextTileId = 0; // ID unique global

  final Random _random = Random();

  // Référence au CollectionProvider pour les bonus
  CollectionProvider? _collectionProvider;

  /// Initialisation du niveau
  void startLevel(Level level, {CollectionProvider? collectionProvider}) {
    _collectionProvider = collectionProvider;
    _currentLevel = level;
    _currentObjectives = List.from(level.objectives);
    _score = 0;
    _movesLeft = level.maxMoves;
    _selectedTile = null;
    _nextTileId = 0;

    // Appliquer les bonus des collections
    _applyCollectionBonuses();

    _generateGrid(level.gridSize);
    notifyListeners();
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
  Map<TileType, int> _calculateTileDistribution(int totalTiles) {
    final distribution = <TileType, int>{};

    // Calculer le facteur de difficulté basé sur le niveau
    final difficultyFactor = _calculateDifficultyFactor();

    // Initialiser toutes les tuiles avec une distribution équitable
    final baseCount = (totalTiles / TileType.values.length).floor();
    final remainder = totalTiles % TileType.values.length;

    for (int i = 0; i < TileType.values.length; i++) {
      final tileType = TileType.values[i];
      distribution[tileType] = baseCount + (i < remainder ? 1 : 0);
    }

    // Ajuster la distribution en fonction des objectifs et de la difficulté
    for (final objective in _currentObjectives) {
      if (objective.type == LevelObjectiveType.collectTiles &&
          objective.tileType != null) {
        final requiredTiles = objective.target;
        final currentCount = distribution[objective.tileType!] ?? 0;

        // Calculer le ratio minimum basé sur la difficulté
        // Plus le niveau est élevé, moins il y a de tuiles du type requis
        final baseRatio =
            3.0 - (difficultyFactor * 0.5); // 3.0 → 2.0 selon la difficulté
        final minRequired = (requiredTiles * baseRatio)
            .clamp(requiredTiles + (5 - difficultyFactor * 2).clamp(1, 5),
                totalTiles ~/ 2)
            .round();

        if (currentCount < minRequired) {
          // Réduire d'autres types pour augmenter le type requis
          final needed = minRequired - currentCount;
          final otherTypes =
              TileType.values.where((t) => t != objective.tileType).toList();

          // Réduire équitablement les autres types
          for (int i = 0; i < needed && otherTypes.isNotEmpty; i++) {
            final typeToReduce = otherTypes[i % otherTypes.length];
            if (distribution[typeToReduce]! > 1) {
              distribution[typeToReduce] = distribution[typeToReduce]! - 1;
              distribution[objective.tileType!] =
                  distribution[objective.tileType!]! + 1;
            }
          }
        }
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
    if (_isAnimating) return;

    if (_selectedTile == null) {
      _selectedTile = tile;
    } else {
      if (_areAdjacent(_selectedTile!, tile)) {
        _swapTiles(_selectedTile!, tile);
        if (_hasMatches()) {
          _movesLeft--;
          _processMatches();
        } else {
          // swap invalide → revert
          _swapTiles(_selectedTile!, tile);
        }
      }
      _selectedTile = null;
    }
    notifyListeners();
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
  Future<void> _processMatches() async {
    if (_isAnimating) return;
    _isAnimating = true;

    int comboCount = 0;
    const maxCombos = 3; // Limite à 3 combos maximum

    while (comboCount < maxCombos) {
      final matches = _findMatches();
      if (matches.isEmpty) break;

      comboCount++;

      // suppression et mise à jour des objectifs
      for (var match in matches) {
        for (var tile in match) {
          _grid[tile.row][tile.col] = null;
          _updateObjectives(tile.type);
        }
        // Score avec bonus pour les combos spéciaux
        int baseScore = match.length * 10;
        if (match.length >= 5) {
          baseScore *= 3; // Bonus x3 pour 5+ tuiles
        } else if (match.length >= 4) {
          baseScore *= 2; // Bonus x2 pour 4 tuiles
        }

        // Appliquer les bonus des collections
        baseScore = _applyScoreMultiplier(baseScore);

        _score += baseScore;
      }
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 300));

      // gravité
      _applyGravity();
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 200));

      // refill
      _fillEmpty();
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 200));
    }

    _isAnimating = false;
    notifyListeners();

    // Vérifier si le jeu est terminé
    _checkGameEnd();
  }

  /// Vérifie si le jeu est terminé et déclenche le callback
  void _checkGameEnd() {
    // Protection contre les états invalides
    if (_currentLevel == null || _gameEndCallback == null) return;

    if (isGameOver()) {
      final won = isLevelCompleted();
      final stars = _calculateStars();
      final movesUsed = _currentLevel!.maxMoves - _movesLeft;
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
          }
        }
      }
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
        objective.current++;
      }
    }
  }

  /// Vérifie si le niveau est complété
  bool isLevelCompleted() {
    return _currentObjectives.every((objective) => objective.isCompleted);
  }

  /// Vérifie si le jeu est terminé (plus de mouvements ou niveau complété)
  bool isGameOver() {
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
            _swapTiles(tile, belowTile);
            if (valid) return true;
          }
        }

        // Vérifier mouvement vers la droite
        if (c + 1 < size) {
          final rightTile = _grid[r][c + 1];
          if (rightTile != null) {
            _swapTiles(tile, rightTile);
            final valid = _hasMatches();
            _swapTiles(tile, rightTile);
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

  /// Audio provider pour les sons
  dynamic _audioProvider;

  /// Définit le callback de fin de jeu
  void setGameEndCallback(
      Function(bool won, int stars, int score, int movesUsed) callback) {
    _gameEndCallback = callback;
  }

  /// Définit l'audio provider
  void setAudioProvider(dynamic audioProvider) {
    _audioProvider = audioProvider;
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
              _swapTiles(tile, belowTile);
              return [tile, belowTile];
            }
            _swapTiles(tile, belowTile);
          }
        }

        // Vérifier mouvement vers la droite
        if (c + 1 < size) {
          final rightTile = _grid[r][c + 1];
          if (rightTile != null) {
            _swapTiles(tile, rightTile);
            if (_hasMatches()) {
              _swapTiles(tile, rightTile);
              return [tile, rightTile];
            }
            _swapTiles(tile, rightTile);
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
    if (_currentLevel != null) {
      startLevel(_currentLevel!, collectionProvider: _collectionProvider);
    }
  }

  // === MÉTHODES POUR LES COLLECTIONS ===

  /// Appliquer les bonus des collections au début du niveau
  void _applyCollectionBonuses() {
    if (_collectionProvider == null) return;

    final bonuses = _collectionProvider!.getActiveBonuses();

    // Bonus de mouvements supplémentaires
    if (bonuses.containsKey(BonusType.extraMoves)) {
      _movesLeft += bonuses[BonusType.extraMoves]!.toInt();
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
