import 'package:flutter/material.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/models/world.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

/// Widget réutilisable pour les dialogues de completion de monde
class WorldCompletionDialog extends StatelessWidget {
  final World completedWorld;
  final String title;
  final String message;
  final List<Map<String, dynamic>> rewards;
  final VoidCallback? onContinue;
  final VoidCallback? onGoHome;

  const WorldCompletionDialog({
    Key? key,
    required this.completedWorld,
    required this.title,
    required this.message,
    required this.rewards,
    this.onContinue,
    this.onGoHome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icône de célébration
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: completedWorld.colors
                    .map((color) =>
                        Color(int.parse(color.replaceFirst('#', '0xff'))))
                    .toList(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Colors.white,
              size: 40,
            ),
          ),

          const SizedBox(height: 20),

          // Titre
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Nom du monde
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: completedWorld.colors
                    .map((color) =>
                        Color(int.parse(color.replaceFirst('#', '0xff'))))
                    .toList(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getWorldDisplayName(completedWorld),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 16),

          // Message
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Récompenses
          Container(
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
                const SizedBox(height: 8),
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
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onGoHome,
          child: Text(
            'Retour au Menu',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        if (onContinue != null)
          ElevatedButton(
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Continuer'),
          ),
      ],
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

  // Obtenir le nom d'affichage du monde
  String _getWorldDisplayName(World world) {
    switch (world.id) {
      case 1:
        return 'Débuts du Jardin';
      case 2:
        return 'Vallée des Fleurs';
      case 3:
        return 'Forêt Lunaire';
      case 4:
        return 'Prairie Solaire';
      case 5:
        return 'Caverne de Cristaux';
      case 6:
        return 'Marécages Mystiques';
      case 7:
        return 'Terres Brûlantes';
      case 8:
        return 'Glacier Éternel';
      case 9:
        return 'Arc-en-Ciel Perdu';
      case 10:
        return 'Jardin Céleste';
      default:
        return 'Monde Inconnu';
    }
  }
}
