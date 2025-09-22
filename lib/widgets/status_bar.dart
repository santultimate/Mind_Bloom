import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

class StatusBar extends StatefulWidget {
  const StatusBar({super.key});

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    // Mettre à jour l'interface toutes les secondes pour le timer
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
              // Avatar et nom
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProvider.username,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                      ),
                      Text(
                        '${AppLocalizations.of(context)?.level ?? 'Level'} ${userProvider.level}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              // Vies avec timer si nécessaire
              _buildLivesStatus(userProvider),

              const SizedBox(width: 15),

              // Pièces
              _buildStatusItem(
                icon: Icons.monetization_on,
                value: '${userProvider.coins}',
                color: AppColors.coins,
              ),

              const SizedBox(width: 15),

              // Gemmes
              _buildStatusItem(
                icon: Icons.diamond,
                value: '${userProvider.gems}',
                color: AppColors.gold,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLivesStatus(UserProvider userProvider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.favorite,
          color: AppColors.lives,
          size: 20,
        ),
        const SizedBox(width: 4),
        Text(
          '${userProvider.lives}/${userProvider.maxLives}',
          style: TextStyle(
            color: AppColors.lives,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        // Afficher le timer si les vies ne sont pas au maximum
        if (userProvider.lives < userProvider.maxLives) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  color: Colors.red,
                  size: 12,
                ),
                const SizedBox(width: 2),
                Text(
                  _formatTime(userProvider.timeUntilNextLife),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
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
    );
  }

  // Formater le temps restant
  String _formatTime(int seconds) {
    if (seconds <= 0) return '00:00';

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
