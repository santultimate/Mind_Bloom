import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/providers/game_provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';

class PerformanceSummaryWidget extends StatelessWidget {
  const PerformanceSummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        if (gameProvider.currentLevel == null) {
          return const SizedBox.shrink();
        }

        // Performance summary data
        final summary = {
          'score': gameProvider.score,
          'moves': gameProvider.movesRemaining,
          'stars': gameProvider.calculateStars(),
        };

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // En-tête
              Row(
                children: [
                  Icon(
                    Icons.analytics,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Performance',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Indicateurs de performance
              Row(
                children: [
                  // Score
                  Expanded(
                    child: _buildPerformanceIndicator(
                      'Score',
                      '${summary['score']}',
                      '${summary['targetScore']}',
                      (summary['score'] as int) /
                          (gameProvider.currentLevel?.targetScore ?? 1),
                      AppColors.gold,
                      Icons.star,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Efficacité des coups
                  Expanded(
                    child: _buildPerformanceIndicator(
                      'Efficacité',
                      '${summary['movesUsed']}',
                      '${summary['maxMoves']}',
                      summary['efficiency'] as double,
                      AppColors.info,
                      Icons.speed,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Objectifs complétés
              _buildObjectivesProgress(summary),

              const SizedBox(height: 12),

              // Étoiles gagnées
              _buildStarsIndicator(summary['starsEarned'] as int),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPerformanceIndicator(
    String label,
    String current,
    String target,
    double progress,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$current/$target',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildObjectivesProgress(Map<String, dynamic> summary) {
    final completed = summary['objectivesCompleted'] as int;
    final total = summary['totalObjectives'] as int;
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag, color: AppColors.success, size: 16),
              const SizedBox(width: 4),
              Text(
                'Objectifs',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$completed/$total complétés',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: AppColors.success.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildStarsIndicator(int starsEarned) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: AppColors.gold, size: 16),
          const SizedBox(width: 8),
          Text(
            'Étoiles gagnées',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Row(
            children: List.generate(3, (index) {
              return Icon(
                index < starsEarned ? Icons.star : Icons.star_border,
                color: AppColors.gold,
                size: 20,
              );
            }),
          ),
        ],
      ),
    );
  }
}
