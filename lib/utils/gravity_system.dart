import 'dart:math';
import 'package:mind_bloom/models/tile.dart';
import 'package:mind_bloom/models/level.dart';

class GravitySystem {
  // Appliquer la gravité avec animations fluides
  static void applyGravity(
    List<List<Tile?>> grid,
    Level level,
    Function() onUpdate,
  ) {
    bool moved = true;
    int iterations = 0;
    const maxIterations = 10;

    while (moved && iterations < maxIterations) {
      moved = false;
      iterations++;

      // Parcourir chaque colonne de bas en haut
      for (int col = 0; col < level.gridSize; col++) {
        for (int row = level.gridSize - 1; row >= 0; row--) {
          if (grid[row][col] == null && !level.blockers[row][col]) {
            // Trouver la première tuile non-nulle au-dessus
            for (int r = row - 1; r >= 0; r--) {
              if (grid[r][col] != null && !level.blockers[r][col]) {
                // Marquer la tuile comme en mouvement
                grid[r][col]!.state = TileState.swapping;

                // Déplacer la tuile vers le bas
                grid[row][col] = grid[r][col];
                grid[r][col] = null;
                grid[row][col]!.row = row;
                grid[row][col]!.state = TileState.normal;
                moved = true;
                break;
              }
            }
          }
        }
      }

      // Notifier les changements pour l'animation
      if (moved) {
        onUpdate();
        // Petite pause pour voir l'animation
        Future.delayed(const Duration(milliseconds: 100));
      }
    }

    if (iterations >= maxIterations) {
      // Commenté pour la version de production
      // if (kDebugMode) {
      //   print('Warning: Gravity loop reached max iterations');
      // }
    }
  }

  // Remplir les espaces vides avec de nouvelles tuiles
  static void fillEmptySpaces(
    List<List<Tile?>> grid,
    Level level,
    Function() onUpdate,
  ) {
    final random = Random();
    int attempts = 0;
    const maxAttempts = 100;

    // Remplir seulement les espaces vides en haut de chaque colonne
    for (int col = 0; col < level.gridSize; col++) {
      for (int row = 0; row < level.gridSize; row++) {
        if (grid[row][col] == null && !level.blockers[row][col]) {
          TileType tileType;
          attempts = 0;

          do {
            tileType = TileType.values[random.nextInt(TileType.values.length)];
            attempts++;
            if (attempts > maxAttempts) {
              // Si on ne peut pas éviter un match, prendre un type aléatoire
              tileType =
                  TileType.values[random.nextInt(TileType.values.length)];
              break;
            }
          } while (_wouldCreateMatch(grid, row, col, tileType, level.gridSize));

          // Créer la nouvelle tuile avec état spécial pour l'animation
          grid[row][col] = Tile(
            id: row * level.gridSize + col,
            type: tileType,
            row: row,
            col: col,
            state: TileState.special, // Marquer comme nouvelle tuile
          );

          // Notifier le changement pour l'animation
          onUpdate();

          // Petite pause pour voir l'animation de génération
          Future.delayed(const Duration(milliseconds: 50));
        }
      }
    }
  }

  // Vérifier si une tuile créerait un match immédiat
  static bool _wouldCreateMatch(
    List<List<Tile?>> grid,
    int row,
    int col,
    TileType tileType,
    int gridSize,
  ) {
    // Vérifier les matches horizontaux
    int horizontalCount = 1;

    // Compter vers la gauche
    for (int c = col - 1; c >= 0; c--) {
      if (grid[row][c]?.type == tileType) {
        horizontalCount++;
      } else {
        break;
      }
    }

    // Compter vers la droite
    for (int c = col + 1; c < gridSize; c++) {
      if (grid[row][c]?.type == tileType) {
        horizontalCount++;
      } else {
        break;
      }
    }

    if (horizontalCount >= 3) return true;

    // Vérifier les matches verticaux
    int verticalCount = 1;

    // Compter vers le haut
    for (int r = row - 1; r >= 0; r--) {
      if (grid[r][col]?.type == tileType) {
        verticalCount++;
      } else {
        break;
      }
    }

    // Compter vers le bas
    for (int r = row + 1; r < gridSize; r++) {
      if (grid[r][col]?.type == tileType) {
        verticalCount++;
      } else {
        break;
      }
    }

    return verticalCount >= 3;
  }

  // Calculer la distance de chute pour une tuile
  static int calculateFallDistance(
    List<List<Tile?>> grid,
    int row,
    int col,
    int gridSize,
  ) {
    int fallDistance = 0;

    for (int r = row + 1; r < gridSize; r++) {
      if (grid[r][col] == null) {
        fallDistance++;
      } else {
        break;
      }
    }

    return fallDistance;
  }

  // Obtenir toutes les tuiles qui vont tomber
  static List<Tile> getFallingTiles(
    List<List<Tile?>> grid,
    int gridSize,
  ) {
    List<Tile> fallingTiles = [];

    for (int col = 0; col < gridSize; col++) {
      for (int row = 0; row < gridSize; row++) {
        if (grid[row][col] != null) {
          int fallDistance = calculateFallDistance(grid, row, col, gridSize);
          if (fallDistance > 0) {
            fallingTiles.add(grid[row][col]!);
          }
        }
      }
    }

    return fallingTiles;
  }
}
