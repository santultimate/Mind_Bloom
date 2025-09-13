import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/providers/game_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';

import 'package:mind_bloom/models/tile.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/widgets/animated_tile_widget.dart';
import 'package:mind_bloom/widgets/objective_panel.dart';
import 'package:mind_bloom/widgets/game_header.dart';
import 'package:mind_bloom/widgets/lives_widget.dart';
import 'package:mind_bloom/screens/level_complete_screen.dart';

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
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    gameProvider.setGameEndCallback(_onGameEnd);
    gameProvider.setAudioProvider(audioProvider);
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            final level = gameProvider.currentLevel;
            if (level == null) {
              return const Center(
                child: Text('Aucun niveau chargé'),
              );
            }

            return Column(
              children: [
                // En-tête du jeu
                GameHeader(
                  level: level,
                  score: gameProvider.score,
                  movesRemaining: gameProvider.movesRemaining,
                  onPause: () => _showPauseDialog(),
                ),

                // Widget des vies avec boutons d'action
                LivesWidget(
                  onShuffle: _shuffleBoard,
                  onHint: _showHint,
                ),

                const SizedBox(height: 2),

                // Panneau des objectifs (compact)
                const ObjectivePanel(),

                const SizedBox(height: 4),

                // Grille de jeu (optimisée pour l'espace disponible)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadow,
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

                        // Calculer la taille optimale des tuiles
                        final availableWidth =
                            constraints.maxWidth - 32; // Padding
                        final availableHeight =
                            constraints.maxHeight - 32; // Padding
                        final spacing = 4.0; // Espacement optimal

                        // Calculer la taille maximale possible pour les tuiles
                        final tileSize = math.min(
                          (availableWidth - (level.gridSize - 1) * spacing) /
                              level.gridSize,
                          (availableHeight - (level.gridSize - 1) * spacing) /
                              level.gridSize,
                        );

                        // S'assurer que les tuiles ne sont pas trop petites
                        final minTileSize = 40.0;
                        final finalTileSize = math.max(tileSize, minTileSize);

                        return Center(
                          child: SizedBox(
                            width: finalTileSize * level.gridSize +
                                (level.gridSize - 1) * spacing,
                            height: finalTileSize * level.gridSize +
                                (level.gridSize - 1) * spacing,
                            child: GridView.builder(
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
                                      color: AppColors.surfaceVariant,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  );
                                }

                                return AnimatedTileWidget(
                                  tile: tile,
                                  size: finalTileSize,
                                  onTap: () => _onTileTap(tile),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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

    final hint = gameProvider.findHint();
    if (hint != null) {
      // TODO: Implémenter l'affichage de l'indice
      if (kDebugMode) {
        print('Indice trouvé: ${hint.length} tuiles');
      }
    }
    audioProvider.playHint();
  }

  void _showPauseDialog() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.togglePause();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Jeu en pause'),
        content: const Text('Que souhaitez-vous faire ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resumeGame();
            },
            child: const Text('Reprendre'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartLevel();
            },
            child: const Text('Recommencer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _exitToMenu();
            },
            child: const Text('Menu'),
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
