import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/providers/game_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';

import 'package:mind_bloom/models/tile.dart';
import 'package:mind_bloom/widgets/animated_tile_widget.dart';
import 'package:mind_bloom/widgets/tile_swap_animation.dart';
import 'package:mind_bloom/widgets/objective_panel.dart';
import 'package:mind_bloom/widgets/game_header.dart';
import 'package:mind_bloom/widgets/lives_widget.dart';
import 'package:mind_bloom/widgets/banner_ad_widget.dart';
import 'package:mind_bloom/screens/level_complete_screen.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    _playGameMusic();
    _setupGameEndCallback();
  }

  void _playGameMusic() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playGameplayMusic();
  }

  void _setupGameEndCallback() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    gameProvider.setGameEndCallback(_onGameEnd);
  }

  void _onGameEnd(bool won, int stars, int score, int movesUsed) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final level = gameProvider.currentLevel;

    if (level != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LevelCompleteScreen(
              won: won,
              stars: stars,
              score: score,
              movesUsed: movesUsed,
              currentLevel: level,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            final level = gameProvider.currentLevel;
            if (level == null) {
              return Center(
                child: Text(AppLocalizations.of(context)!.noLevelLoaded),
              );
            }

            return Column(
              children: [
                // En-tête du jeu
                GameHeader(
                  level: level,
                  score: gameProvider.score,
                  movesRemaining: gameProvider.movesRemaining,
                  timeLeft: 0, // Timer supprimé
                  onPause: () => _showPauseDialog(),
                ),

                // Widget des vies avec boutons d'action
                LivesWidget(
                  onShuffle: _shuffleBoard,
                  onHint: _showHint,
                ),

                // Panneau des objectifs (compact et scrollable)
                const ObjectivePanel(),

                // Grille de jeu (optimisée pour afficher la grille complète)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Protection contre les contraintes négatives
                        if (constraints.maxWidth <= 0 ||
                            constraints.maxHeight <= 0) {
                          return const SizedBox.shrink();
                        }

                        // Calculer la taille optimale des tuiles pour afficher la grille complète
                        final availableWidth =
                            constraints.maxWidth - 16; // Padding minimal
                        final availableHeight =
                            constraints.maxHeight - 16; // Padding minimal
                        final spacing =
                            2.0; // Espacement minimal pour maximiser l'espace

                        // Calculer la taille maximale possible pour les tuiles
                        final tileSize = math.min(
                          (availableWidth - (level.gridSize - 1) * spacing) /
                              level.gridSize,
                          (availableHeight - (level.gridSize - 1) * spacing) /
                              level.gridSize,
                        );

                        // Taille minimale adaptée selon la taille de la grille (réduite pour éviter l'overflow)
                        final minTileSize = level.gridSize >= 8 ? 20.0 : 25.0;
                        final finalTileSize = math.max(tileSize, minTileSize);

                        return Center(
                          child: SizedBox(
                            width: finalTileSize * level.gridSize +
                                (level.gridSize - 1) * spacing,
                            height: finalTileSize * level.gridSize +
                                (level.gridSize - 1) * spacing,
                            child: Stack(
                              children: [
                                // Grille de base
                                GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: level.gridSize,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: spacing,
                                    mainAxisSpacing: spacing,
                                  ),
                                  itemCount: level.gridSize * level.gridSize,
                                  itemBuilder: (context, index) {
                                    final row = index ~/ level.gridSize;
                                    final col = index % level.gridSize;
                                    final tile = gameProvider.grid[row][col];

                                    if (tile == null) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceVariant,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      );
                                    }

                                    // Vérifier si cette tuile est en cours de permutation
                                    final isSwapping = (gameProvider
                                            .isSwapping &&
                                        (gameProvider.swappingTile1 == tile ||
                                            gameProvider.swappingTile2 ==
                                                tile));

                                    // Vérifier si cette tuile est sélectionnée
                                    final isSelected =
                                        gameProvider.selectedTile == tile;

                                    // Si la tuile est en cours de permutation, la masquer dans la grille
                                    if (isSwapping) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceVariant,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      );
                                    }

                                    return TileSelectionEffect(
                                      isSelected: isSelected,
                                      onTap: () => _onTileTap(tile),
                                      child: AnimatedTileWidget(
                                        tile: tile,
                                        size: finalTileSize,
                                        isSelected: isSelected,
                                      ),
                                    );
                                  },
                                ),

                                // Animation de permutation par-dessus la grille
                                if (gameProvider.isSwapping &&
                                    gameProvider.swappingTile1 != null &&
                                    gameProvider.swappingTile2 != null)
                                  TileSwapAnimation(
                                    tile1: gameProvider.swappingTile1!,
                                    tile2: gameProvider.swappingTile2!,
                                    tileSize: finalTileSize,
                                    spacing: spacing,
                                    isVisible: true,
                                    onComplete: () {
                                      // L'animation est terminée, le GameProvider gère le reste
                                    },
                                    child1: AnimatedTileWidget(
                                      tile: gameProvider.swappingTile1!,
                                      size: finalTileSize,
                                      isSelected: true,
                                    ),
                                    child2: AnimatedTileWidget(
                                      tile: gameProvider.swappingTile2!,
                                      size: finalTileSize,
                                      isSelected: true,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // 🚀 BANNIÈRE PUBLICITAIRE PENDANT LE JEU (plus compacte)
                const BannerAdWidget(
                  placement: 'game',
                  height: 40,
                  margin: EdgeInsets.fromLTRB(8, 4, 8, 8),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onTileTap(Tile tile) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.selectTile(tile);
  }

  void _shuffleBoard() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.shuffleBoard();
  }

  void _showHint() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    // Vérifier s'il y a des mouvements possibles
    if (!gameProvider.hasValidMoves()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.noMovesAvailable),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Afficher l'indice visuel
    gameProvider.showHint();
    audioProvider.playHint();
  }

  void _showPauseDialog() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.togglePause();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.gamePaused),
        content: Text(AppLocalizations.of(context)!.whatWouldYouLikeToDo),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resumeGame();
            },
            child: Text(AppLocalizations.of(context)!.resume),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartLevel();
            },
            child: Text(AppLocalizations.of(context)!.restart),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _exitToMenu();
            },
            child: Text(AppLocalizations.of(context)!.menu),
          ),
        ],
      ),
    );
  }

  void _resumeGame() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.togglePause();
  }

  void _restartLevel() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.resetGame();
  }

  void _exitToMenu() {
    Navigator.of(context).pop();
  }
}
