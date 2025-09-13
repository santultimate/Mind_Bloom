import 'package:mind_bloom/models/tile.dart';
import 'package:mind_bloom/models/special_combination.dart';

class SpecialCombinationDetector {
  static List<SpecialCombination> findSpecialCombinations(
    List<List<Tile?>> grid,
    int gridSize,
  ) {
    List<SpecialCombination> combinations = [];
    Set<Tile> processedTiles = {};

    // Détecter les combinaisons horizontales
    combinations
        .addAll(_findHorizontalCombinations(grid, gridSize, processedTiles));

    // Détecter les combinaisons verticales
    combinations
        .addAll(_findVerticalCombinations(grid, gridSize, processedTiles));

    // Détecter les formes en L
    combinations.addAll(_findLShapes(grid, gridSize, processedTiles));

    // Détecter les formes en T
    combinations.addAll(_findTShapes(grid, gridSize, processedTiles));

    // Détecter les formes en +
    combinations.addAll(_findPlusShapes(grid, gridSize, processedTiles));

    return combinations;
  }

  // Détecter les combinaisons horizontales
  static List<SpecialCombination> _findHorizontalCombinations(
    List<List<Tile?>> grid,
    int gridSize,
    Set<Tile> processedTiles,
  ) {
    List<SpecialCombination> combinations = [];

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize - 2; col++) {
        final tile1 = grid[row][col];
        final tile2 = grid[row][col + 1];
        final tile3 = grid[row][col + 2];

        if (tile1 != null &&
            tile2 != null &&
            tile3 != null &&
            tile1.type == tile2.type &&
            tile2.type == tile3.type &&
            !processedTiles.contains(tile1)) {
          List<Tile> match = [tile1, tile2, tile3];
          processedTiles.addAll([tile1, tile2, tile3]);

          // Étendre le match vers la droite
          for (int c = col + 3; c < gridSize; c++) {
            final nextTile = grid[row][c];
            if (nextTile != null &&
                nextTile.type == tile1.type &&
                !processedTiles.contains(nextTile)) {
              match.add(nextTile);
              processedTiles.add(nextTile);
            } else {
              break;
            }
          }

          // Déterminer le type de combinaison
          SpecialCombinationType type;
          int multiplier;
          String description;

          if (match.length >= 5) {
            type = SpecialCombinationType.fiveInLine;
            multiplier = 5;
            description = '5+ en ligne horizontale';
          } else if (match.length == 4) {
            type = SpecialCombinationType.horizontal;
            multiplier = 3;
            description = '4 en ligne horizontale';
          } else {
            type = SpecialCombinationType.horizontal;
            multiplier = 1;
            description = '3 en ligne horizontale';
          }

          combinations.add(SpecialCombination(
            type: type,
            tiles: match,
            scoreMultiplier: multiplier,
            description: description,
          ));
        }
      }
    }

    return combinations;
  }

  // Détecter les combinaisons verticales
  static List<SpecialCombination> _findVerticalCombinations(
    List<List<Tile?>> grid,
    int gridSize,
    Set<Tile> processedTiles,
  ) {
    List<SpecialCombination> combinations = [];

    for (int row = 0; row < gridSize - 2; row++) {
      for (int col = 0; col < gridSize; col++) {
        final tile1 = grid[row][col];
        final tile2 = grid[row + 1][col];
        final tile3 = grid[row + 2][col];

        if (tile1 != null &&
            tile2 != null &&
            tile3 != null &&
            tile1.type == tile2.type &&
            tile2.type == tile3.type &&
            !processedTiles.contains(tile1)) {
          List<Tile> match = [tile1, tile2, tile3];
          processedTiles.addAll([tile1, tile2, tile3]);

          // Étendre le match vers le bas
          for (int r = row + 3; r < gridSize; r++) {
            final nextTile = grid[r][col];
            if (nextTile != null &&
                nextTile.type == tile1.type &&
                !processedTiles.contains(nextTile)) {
              match.add(nextTile);
              processedTiles.add(nextTile);
            } else {
              break;
            }
          }

          // Déterminer le type de combinaison
          SpecialCombinationType type;
          int multiplier;
          String description;

          if (match.length >= 5) {
            type = SpecialCombinationType.fiveInLine;
            multiplier = 5;
            description = '5+ en ligne verticale';
          } else if (match.length == 4) {
            type = SpecialCombinationType.vertical;
            multiplier = 3;
            description = '4 en ligne verticale';
          } else {
            type = SpecialCombinationType.vertical;
            multiplier = 1;
            description = '3 en ligne verticale';
          }

          combinations.add(SpecialCombination(
            type: type,
            tiles: match,
            scoreMultiplier: multiplier,
            description: description,
          ));
        }
      }
    }

    return combinations;
  }

  // Détecter les formes en L
  static List<SpecialCombination> _findLShapes(
    List<List<Tile?>> grid,
    int gridSize,
    Set<Tile> processedTiles,
  ) {
    List<SpecialCombination> combinations = [];

    for (int row = 0; row < gridSize - 2; row++) {
      for (int col = 0; col < gridSize - 2; col++) {
        // L vers le bas-droite
        if (_isLShape(grid, row, col, 1, 1, processedTiles)) {
          combinations.add(_getLShape(grid, row, col, 1, 1));
        }
        // L vers le bas-gauche
        if (_isLShape(grid, row, col, -1, 1, processedTiles)) {
          combinations.add(_getLShape(grid, row, col, -1, 1));
        }
      }
    }

    return combinations;
  }

  // Détecter les formes en T
  static List<SpecialCombination> _findTShapes(
    List<List<Tile?>> grid,
    int gridSize,
    Set<Tile> processedTiles,
  ) {
    List<SpecialCombination> combinations = [];

    for (int row = 1; row < gridSize - 1; row++) {
      for (int col = 1; col < gridSize - 1; col++) {
        if (_isTShape(grid, row, col, processedTiles)) {
          combinations.add(_getTShape(grid, row, col));
        }
      }
    }

    return combinations;
  }

  // Détecter les formes en +
  static List<SpecialCombination> _findPlusShapes(
    List<List<Tile?>> grid,
    int gridSize,
    Set<Tile> processedTiles,
  ) {
    List<SpecialCombination> combinations = [];

    for (int row = 1; row < gridSize - 1; row++) {
      for (int col = 1; col < gridSize - 1; col++) {
        if (_isPlusShape(grid, row, col, processedTiles)) {
          combinations.add(_getPlusShape(grid, row, col));
        }
      }
    }

    return combinations;
  }

  // Vérifier si c'est une forme en L
  static bool _isLShape(
    List<List<Tile?>> grid,
    int row,
    int col,
    int dirX,
    int dirY,
    Set<Tile> processedTiles,
  ) {
    final center = grid[row][col];
    if (center == null || processedTiles.contains(center)) return false;

    // Vérifier la ligne horizontale (3 tuiles)
    for (int i = 0; i < 3; i++) {
      final tile = grid[row][col + i * dirX];
      if (tile == null ||
          tile.type != center.type ||
          processedTiles.contains(tile)) {
        return false;
      }
    }

    // Vérifier la ligne verticale (3 tuiles)
    for (int i = 0; i < 3; i++) {
      final tile = grid[row + i * dirY][col];
      if (tile == null ||
          tile.type != center.type ||
          processedTiles.contains(tile)) {
        return false;
      }
    }

    return true;
  }

  // Obtenir une forme en L
  static SpecialCombination _getLShape(
    List<List<Tile?>> grid,
    int row,
    int col,
    int dirX,
    int dirY,
  ) {
    List<Tile> tiles = [];

    // Ajouter la ligne horizontale
    for (int i = 0; i < 3; i++) {
      tiles.add(grid[row][col + i * dirX]!);
    }

    // Ajouter la ligne verticale (sans doublonner le centre)
    for (int i = 1; i < 3; i++) {
      tiles.add(grid[row + i * dirY][col]!);
    }

    return SpecialCombination(
      type: SpecialCombinationType.lShape,
      tiles: tiles,
      scoreMultiplier: 4,
      description: 'Forme en L',
    );
  }

  // Vérifier si c'est une forme en T
  static bool _isTShape(
    List<List<Tile?>> grid,
    int row,
    int col,
    Set<Tile> processedTiles,
  ) {
    final center = grid[row][col];
    if (center == null || processedTiles.contains(center)) return false;

    // Vérifier la ligne horizontale (3 tuiles)
    for (int i = -1; i <= 1; i++) {
      final tile = grid[row][col + i];
      if (tile == null ||
          tile.type != center.type ||
          processedTiles.contains(tile)) {
        return false;
      }
    }

    // Vérifier la ligne verticale (3 tuiles)
    for (int i = -1; i <= 1; i++) {
      final tile = grid[row + i][col];
      if (tile == null ||
          tile.type != center.type ||
          processedTiles.contains(tile)) {
        return false;
      }
    }

    return true;
  }

  // Obtenir une forme en T
  static SpecialCombination _getTShape(
    List<List<Tile?>> grid,
    int row,
    int col,
  ) {
    List<Tile> tiles = [];

    // Ajouter la ligne horizontale
    for (int i = -1; i <= 1; i++) {
      tiles.add(grid[row][col + i]!);
    }

    // Ajouter la ligne verticale (sans doublonner le centre)
    tiles.add(grid[row - 1][col]!);
    tiles.add(grid[row + 1][col]!);

    return SpecialCombination(
      type: SpecialCombinationType.tShape,
      tiles: tiles,
      scoreMultiplier: 4,
      description: 'Forme en T',
    );
  }

  // Vérifier si c'est une forme en +
  static bool _isPlusShape(
    List<List<Tile?>> grid,
    int row,
    int col,
    Set<Tile> processedTiles,
  ) {
    final center = grid[row][col];
    if (center == null || processedTiles.contains(center)) return false;

    // Vérifier les 4 directions (5 tuiles au total)
    final directions = [
      [0, -1],
      [0, 1],
      [-1, 0],
      [1, 0]
    ];

    for (final dir in directions) {
      final tile = grid[row + dir[0]][col + dir[1]];
      if (tile == null ||
          tile.type != center.type ||
          processedTiles.contains(tile)) {
        return false;
      }
    }

    return true;
  }

  // Obtenir une forme en +
  static SpecialCombination _getPlusShape(
    List<List<Tile?>> grid,
    int row,
    int col,
  ) {
    List<Tile> tiles = [grid[row][col]!]; // Centre

    // Ajouter les 4 directions
    tiles.add(grid[row][col - 1]!); // Gauche
    tiles.add(grid[row][col + 1]!); // Droite
    tiles.add(grid[row - 1][col]!); // Haut
    tiles.add(grid[row + 1][col]!); // Bas

    return SpecialCombination(
      type: SpecialCombinationType.plusShape,
      tiles: tiles,
      scoreMultiplier: 5,
      description: 'Forme en +',
    );
  }
}
