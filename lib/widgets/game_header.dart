import 'package:flutter/material.dart';
import 'package:mind_bloom/models/level.dart';
import 'package:mind_bloom/constants/app_colors.dart';

class GameHeader extends StatelessWidget {
  final Level level;
  final int score;
  final int movesRemaining;
  final VoidCallback onPause;

  const GameHeader({
    super.key,
    required this.level,
    required this.score,
    required this.movesRemaining,
    required this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Bouton retour
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(width: 16),

          // Informations du niveau
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  level.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
                Text(
                  level.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),

          // Score
          _buildInfoItem(
            icon: Icons.star,
            value: score.toString(),
            color: AppColors.gold,
          ),

          const SizedBox(width: 16),

          // Coups restants
          _buildInfoItem(
            icon: Icons.swap_horiz,
            value: movesRemaining.toString(),
            color: AppColors.primary,
          ),

          const SizedBox(width: 16),

          // Bouton pause
          IconButton(
            onPressed: onPause,
            icon: const Icon(
              Icons.pause,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
