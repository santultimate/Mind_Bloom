import 'package:flutter/material.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

/// Widget réutilisable pour afficher un tableau d'honneur
class HallOfFameWidget extends StatelessWidget {
  final String playerName;
  final String title;
  final String? subtitle;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Widget? additionalContent;

  const HallOfFameWidget({
    Key? key,
    required this.playerName,
    required this.title,
    this.subtitle,
    this.primaryColor,
    this.secondaryColor,
    this.additionalContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = primaryColor ?? Colors.amber;
    final secondary = secondaryColor ?? Colors.orange;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primary.withValues(alpha: 0.2),
            secondary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primary.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, color: primary, size: 28),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: primary.withValues(alpha: 0.8),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  playerName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (additionalContent != null) ...[
            const SizedBox(height: 16),
            additionalContent!,
          ],
        ],
      ),
    );
  }
}

/// Widget pour afficher les récompenses dans un tableau d'honneur
class HallOfFameRewards extends StatelessWidget {
  final List<Map<String, dynamic>> rewards;

  const HallOfFameRewards({
    Key? key,
    required this.rewards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.rewards,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: rewards
                .map((reward) => _buildRewardIcon(
                      reward['icon'] as IconData,
                      reward['color'] as Color,
                      reward['text'] as String,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardIcon(IconData icon, Color color, String text) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
