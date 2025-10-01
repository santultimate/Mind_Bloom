import 'package:flutter/material.dart';
import 'package:mind_bloom/models/world.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

/// Widget pour afficher une carte de monde
class WorldCard extends StatelessWidget {
  final World world;
  final VoidCallback? onTap;
  final bool isSelected;

  const WorldCard({
    super.key,
    required this.world,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: isSelected ? 8 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: world.isUnlocked ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _getWorldColors(context),
              ),
            ),
            child: Stack(
              children: [
                // Contenu principal
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icône et titre
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getWorldIcon(),
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getWorldName(l10n),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _getWorldDescription(l10n),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Informations du monde
                      Row(
                        children: [
                          _buildInfoChip(
                            context,
                            'Niveaux ${world.startLevel}-${world.endLevel}',
                            Icons.stairs,
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            context,
                            '${world.levelCount} niveaux',
                            Icons.gamepad,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Overlay si verrouillé
                if (!world.isUnlocked)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black.withOpacity(0.6),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 32,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Verrouillé',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Badge de sélection
                if (isSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Récupère les couleurs du monde
  List<Color> _getWorldColors(BuildContext context) {
    final colorStrings = world.colors;
    final colors = colorStrings.map((colorString) {
      // Convertir la chaîne hex en Color
      final hex = colorString.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    }).toList();

    // Si pas assez de couleurs, utiliser des couleurs par défaut
    if (colors.length < 2) {
      return [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.primary.withOpacity(0.7),
      ];
    }

    return colors;
  }

  /// Récupère l'icône du monde
  IconData _getWorldIcon() {
    switch (world.iconName) {
      case 'seedling':
        return Icons.eco;
      case 'flower':
        return Icons.local_florist;
      case 'nightlight_round':
        return Icons.nightlight_round;
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'diamond':
        return Icons.diamond;
      case 'water_drop':
        return Icons.water_drop;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'ac_unit':
        return Icons.ac_unit;
      case 'palette':
        return Icons.palette;
      case 'star':
        return Icons.star;
      default:
        return Icons.public;
    }
  }

  /// Récupère le nom traduit du monde
  String _getWorldName(AppLocalizations l10n) {
    switch (world.nameKey) {
      case 'world_garden_beginnings':
        return l10n.world_garden_beginnings;
      case 'world_valley_flowers':
        return l10n.world_valley_flowers;
      case 'world_lunar_forest':
        return l10n.world_lunar_forest;
      case 'world_solar_meadow':
        return l10n.world_solar_meadow;
      case 'world_crystal_caverns':
        return l10n.world_crystal_caverns;
      case 'world_mystic_swamps':
        return l10n.world_mystic_swamps;
      case 'world_burning_lands':
        return l10n.world_burning_lands;
      case 'world_eternal_glacier':
        return l10n.world_eternal_glacier;
      case 'world_lost_rainbow':
        return l10n.world_lost_rainbow;
      case 'world_celestial_garden':
        return l10n.world_celestial_garden;
      default:
        return 'Monde ${world.id}';
    }
  }

  /// Récupère la description traduite du monde
  String _getWorldDescription(AppLocalizations l10n) {
    switch (world.descriptionKey) {
      case 'world_garden_beginnings_description':
        return l10n.world_garden_beginnings_description;
      case 'world_valley_flowers_description':
        return l10n.world_valley_flowers_description;
      case 'world_lunar_forest_description':
        return l10n.world_lunar_forest_description;
      case 'world_solar_meadow_description':
        return l10n.world_solar_meadow_description;
      case 'world_crystal_caverns_description':
        return l10n.world_crystal_caverns_description;
      case 'world_mystic_swamps_description':
        return l10n.world_mystic_swamps_description;
      case 'world_burning_lands_description':
        return l10n.world_burning_lands_description;
      case 'world_eternal_glacier_description':
        return l10n.world_eternal_glacier_description;
      case 'world_lost_rainbow_description':
        return l10n.world_lost_rainbow_description;
      case 'world_celestial_garden_description':
        return l10n.world_celestial_garden_description;
      default:
        return 'Description du monde ${world.id}';
    }
  }

  /// Construit une puce d'information
  Widget _buildInfoChip(BuildContext context, String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

