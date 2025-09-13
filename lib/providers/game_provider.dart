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

    // Remplir la grille ligne par ligne
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        _grid[row][col] = _createSafeTile(row, col);
      }
    }
  }

  /// Crée une tuile qui ne génère pas de match
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
    if (isGameOver() && _gameEndCallback != null) {
      final won = isLevelCompleted();
      final stars = _calculateStars();
      _gameEndCallback!(
          won, stars, _score, _currentLevel!.maxMoves - _movesLeft);
    }
  }

  /// Calcule le nombre d'étoiles basé sur le score
  int _calculateStars() {
    if (_currentLevel == null) return 0;

    final targetScore = _currentLevel!.targetScore;
    final scoreRatio = _score / targetScore;

    if (scoreRatio >= 1.0) return 3;
    if (scoreRatio >= 0.7) return 2;
    if (scoreRatio >= 0.5) return 1;
    return 0;
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
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (_grid[r][c] == null) {
          _grid[r][c] = _createSmartTile(r, c);
        }
      }
    }
  }

  /// Crée une tuile intelligente qui évite les matches directs
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
    if (_grid.isEmpty) return false;

    final size = _grid.length;
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        final tile = _grid[r][c];
        if (tile == null) continue;

        if (r + 1 < size && _grid[r + 1][c] != null) {
          _swapTiles(tile, _grid[r + 1][c]!);
          final valid = _hasMatches();
          _swapTiles(tile, _grid[r + 1][c]!);
          if (valid) return true;
        }

        if (c + 1 < size && _grid[r][c + 1] != null) {
          _swapTiles(tile, _grid[r][c + 1]!);
          final valid = _hasMatches();
          _swapTiles(tile, _grid[r][c + 1]!);
          if (valid) return true;
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
          _swapTiles(tile, _grid[r + 1][c]!);
          if (_hasMatches()) {
            _swapTiles(tile, _grid[r + 1][c]!);
            return [tile, _grid[r + 1][c]!];
          }
          _swapTiles(tile, _grid[r + 1][c]!);
        }

        // Vérifier mouvement vers la droite
        if (c + 1 < size) {
          _swapTiles(tile, _grid[r][c + 1]!);
          if (_hasMatches()) {
            _swapTiles(tile, _grid[r][c + 1]!);
            return [tile, _grid[r][c + 1]!];
          }
          _swapTiles(tile, _grid[r][c + 1]!);
        }
      }
    }
    return null;
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
