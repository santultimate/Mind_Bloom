import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/providers/game_provider.dart';
import 'package:mind_bloom/models/level.dart';
import 'package:mind_bloom/models/tile.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

class ObjectivePanel extends StatelessWidget {
  const ObjectivePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        if (gameProvider.currentLevel == null) {
          return const SizedBox.shrink();
        }

        final objectives = gameProvider.currentObjectives;
        if (objectives.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 120),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // En-tête avec progression globale
                  Row(
                    children: [
                      Icon(
                        Icons.flag,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context)!.objectives,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // Indicateur de progression globale
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${(gameProvider.getOverallProgress() * 100).toInt()}%',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // Liste des objectifs
                  ...objectives.map(
                      (objective) => _buildObjectiveItem(context, objective)),

                  const SizedBox(height: 2),

                  // Barre de progression globale
                  _buildOverallProgressBar(
                      context, gameProvider.getOverallProgress()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildObjectiveItem(BuildContext context, LevelObjective objective) {
    final isCompleted = objective.isCompleted;
    final progress = objective.progress;

    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isCompleted
              ? AppColors.success
              : AppColors.primary.withValues(alpha: 0.2),
          width: isCompleted ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Icône de l'objectif
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.success
                  : AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getObjectiveIcon(objective),
              color: isCompleted ? Colors.white : AppColors.primary,
              size: 10,
            ),
          ),

          const SizedBox(width: 4),

          // Description et progression
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getObjectiveDescription(context, objective),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 1),

                // Barre de progression
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCompleted ? AppColors.success : AppColors.primary,
                        ),
                        minHeight: 3,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${objective.current}/${objective.target}',
                      style: TextStyle(
                        color: isCompleted
                            ? AppColors.success
                            : AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Indicateur de complétion
          if (isCompleted)
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 10,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOverallProgressBar(BuildContext context, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.globalProgress,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          minHeight: 6,
        ),
      ],
    );
  }

  IconData _getObjectiveIcon(LevelObjective objective) {
    switch (objective.type) {
      case LevelObjectiveType.collectTiles:
        return _getTileIcon(objective.tileType);
      case LevelObjectiveType.clearBlockers:
        return Icons.block;
      case LevelObjectiveType.reachScore:
        return Icons.star;
      case LevelObjectiveType.freeCreature:
        return Icons.pets;
      case LevelObjectiveType.clearJelly:
        return Icons.water_drop;
    }
  }

  IconData _getTileIcon(TileType? tileType) {
    switch (tileType) {
      case TileType.flower:
        return Icons.local_florist;
      case TileType.leaf:
        return Icons.eco;
      case TileType.crystal:
        return Icons.diamond;
      case TileType.seed:
        return Icons.grass;
      case TileType.dew:
        return Icons.water_drop;
      case TileType.sun:
        return Icons.wb_sunny;
      case TileType.moon:
        return Icons.nightlight_round;
      case TileType.gem:
        return Icons.diamond;
      case null:
        return Icons.circle;
    }
  }

  String _getObjectiveDescription(
      BuildContext context, LevelObjective objective) {
    switch (objective.type) {
      case LevelObjectiveType.collectTiles:
        final tileName = _getTileName(objective.tileType);
        return AppLocalizations.of(context)!
            .collectTilesObjective(objective.target, tileName);
      case LevelObjectiveType.clearBlockers:
        return AppLocalizations.of(context)!
            .clearBlockersObjective(objective.target);
      case LevelObjectiveType.reachScore:
        return AppLocalizations.of(context)!
            .reachScoreObjective(objective.target);
      case LevelObjectiveType.freeCreature:
        return AppLocalizations.of(context)!
            .freeCreatureObjective(objective.target);
      case LevelObjectiveType.clearJelly:
        return AppLocalizations.of(context)!
            .clearJellyObjective(objective.target);
    }
  }

  String _getTileName(TileType? tileType) {
    switch (tileType) {
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
      case null:
        return 'tuile';
    }
  }
}
