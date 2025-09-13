import 'package:flutter/material.dart';
import 'package:mind_bloom/models/level.dart';
import 'package:mind_bloom/constants/app_colors.dart';

class LevelCard extends StatelessWidget {
  final Level level;
  final bool isUnlocked;
  final int stars;
  final VoidCallback onTap;

  const LevelCard({
    super.key,
    required this.level,
    required this.isUnlocked,
    required this.stars,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked ? AppColors.surface : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked ? AppColors.border : AppColors.textLight,
            width: 2,
          ),
          boxShadow: isUnlocked
              ? [
                  const BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Numéro du niveau
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isUnlocked ? AppColors.primary : AppColors.textLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  '${level.id}',
                  style: TextStyle(
                    color: isUnlocked ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Étoiles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Icon(
                  index < stars ? Icons.star : Icons.star_border,
                  color: index < stars ? AppColors.gold : AppColors.textLight,
                  size: 16,
                );
              }),
            ),

            const SizedBox(height: 4),

            // Icône de verrouillage si nécessaire
            if (!isUnlocked)
              const Icon(
                Icons.lock,
                color: AppColors.textLight,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
