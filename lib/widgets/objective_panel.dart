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
          // Icône de l'objectif (agrandie avec couleur)
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.success
                  : _getObjectiveColor(objective).withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted
                    ? AppColors.success
                    : _getObjectiveColor(objective),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _getObjectiveColor(objective).withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              _getObjectiveIcon(objective),
              color: isCompleted ? Colors.white : _getObjectiveColor(objective),
              size: 18,
            ),
          ),

          const SizedBox(width: 8),

          // Description et progression
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getObjectiveDescription(context, objective),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 1),

                // Barre de progression
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor: _getObjectiveColor(objective)
                            .withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCompleted
                              ? AppColors.success
                              : _getObjectiveColor(objective),
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
                            : _getObjectiveColor(objective),
                        fontSize: 11,
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
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
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

  Color _getObjectiveColor(LevelObjective objective) {
    switch (objective.type) {
      case LevelObjectiveType.collectTiles:
        return _getTileColor(objective.tileType);
      case LevelObjectiveType.clearBlockers:
        return Colors.red;
      case LevelObjectiveType.reachScore:
        return Colors.amber;
      case LevelObjectiveType.freeCreature:
        return Colors.green;
      case LevelObjectiveType.clearJelly:
        return Colors.blue;
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
        return Icons.grain;
      case TileType.dew:
        return Icons.water_drop;
      case TileType.sun:
        return Icons.wb_sunny;
      case TileType.moon:
        return Icons.nightlight_round;
      case TileType.gem:
        return Icons.star;
      case null:
        return Icons.circle;
    }
  }

  Color _getTileColor(TileType? tileType) {
    switch (tileType) {
      case TileType.flower:
        return const Color(0xFFFF6FA3);
      case TileType.leaf:
        return const Color(0xFF48BB78);
      case TileType.crystal:
        return const Color(0xFF4299E1);
      case TileType.seed:
        return const Color(0xFF8B4513);
      case TileType.dew:
        return const Color(0xFF00CED1);
      case TileType.sun:
        return const Color(0xFFFFD700);
      case TileType.moon:
        return const Color(0xFF9370DB);
      case TileType.gem:
        return const Color(0xFF6CC6B6);
      case null:
        return Colors.grey;
    }
  }

  String _getObjectiveDescription(
      BuildContext context, LevelObjective objective) {
    switch (objective.type) {
      case LevelObjectiveType.collectTiles:
        final tileName = _getTileName(context, objective.tileType);
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

  String _getTileName(BuildContext context, TileType? tileType) {
    final locale = Localizations.localeOf(context);
    final isEnglish = locale.languageCode == 'en';

    switch (tileType) {
      case TileType.flower:
        return isEnglish ? 'flowers' : 'fleurs';
      case TileType.leaf:
        return isEnglish ? 'leaves' : 'feuilles';
      case TileType.crystal:
        return isEnglish ? 'crystals' : 'cristaux';
      case TileType.seed:
        return isEnglish ? 'seeds' : 'graines';
      case TileType.dew:
        return isEnglish ? 'dew drops' : 'rosées';
      case TileType.sun:
        return isEnglish ? 'suns' : 'soleils';
      case TileType.moon:
        return isEnglish ? 'moons' : 'lunes';
      case TileType.gem:
        return isEnglish ? 'gems' : 'gemmes';
      case null:
        return isEnglish ? 'tiles' : 'tuiles';
    }
  }
}
