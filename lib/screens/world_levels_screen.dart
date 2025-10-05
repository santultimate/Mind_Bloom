import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/models/level.dart';
import 'package:mind_bloom/models/world.dart';
import 'package:mind_bloom/providers/level_provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/providers/game_provider.dart';
import 'package:mind_bloom/providers/collection_provider.dart';
import 'package:mind_bloom/providers/game_progression_provider.dart';
import 'package:mind_bloom/screens/shop_screen.dart';
import 'package:mind_bloom/screens/game_screen.dart';
import 'package:mind_bloom/widgets/level_card.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

/// Écran pour afficher les niveaux d'un monde spécifique
class WorldLevelsScreen extends StatefulWidget {
  final World world;

  const WorldLevelsScreen({
    super.key,
    required this.world,
  });

  @override
  State<WorldLevelsScreen> createState() => _WorldLevelsScreenState();
}

class _WorldLevelsScreenState extends State<WorldLevelsScreen> {
  @override
  void initState() {
    super.initState();
    _initializeLevels();
  }

  /// Initialise les niveaux du monde
  Future<void> _initializeLevels() async {
    final levelProvider = Provider.of<LevelProvider>(context, listen: false);

    if (!levelProvider.isInitialized) {
      await levelProvider.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          _getWorldName(l10n),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer2<LevelProvider, UserProvider>(
        builder: (context, levelProvider, userProvider, child) {
          if (!levelProvider.isInitialized) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final levels = levelProvider.getWorldLevels(widget.world.id);

          if (levels == null || levels.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun niveau trouvé',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Informations du monde
              _buildWorldInfo(context, l10n, levels),

              // Liste des niveaux
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: levels.length,
                  itemBuilder: (context, index) {
                    final level = levels[index];
                    final isUnlocked = _isLevelUnlocked(level, userProvider);
                    // Calculer le numéro local du niveau dans le monde (1-10 pour chaque monde)
                    final localLevelNumber = index + 1;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: LevelCard(
                        level: level,
                        isUnlocked: isUnlocked,
                        stars: 0, // TODO: Récupérer les vraies étoiles
                        localLevelNumber: localLevelNumber,
                        onTap: isUnlocked ? () => _playLevel(level) : () {},
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Construit les informations du monde
  Widget _buildWorldInfo(
      BuildContext context, AppLocalizations l10n, List<Level> levels) {
    final completedLevels = Provider.of<UserProvider>(context).completedLevels;
    final completedInWorld =
        levels.where((level) => completedLevels.contains(level.id)).length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getWorldColors(context),
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getWorldDescription(l10n),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progression
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progression',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: levels.isNotEmpty
                          ? completedInWorld / levels.length
                          : 0,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '$completedInWorld/${levels.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Vérifie si un niveau est déverrouillé
  bool _isLevelUnlocked(Level level, UserProvider userProvider) {
    // Utiliser GameProgressionProvider pour une logique cohérente
    final gameProgressionProvider =
        Provider.of<GameProgressionProvider>(context, listen: false);
    final isUnlocked = gameProgressionProvider.isLevelUnlocked(level.id);

    // Debug pour les niveaux problématiques
    if ((level.id == 11 || level.id == 12) && kDebugMode) {
      debugPrint('=== DEBUG WORLD LEVELS SCREEN ===');
      debugPrint('Level ${level.id} in world ${widget.world.id}');
      debugPrint('Is unlocked: $isUnlocked');
      debugPrint('UserProvider completed levels: ${userProvider.completedLevels}');
      debugPrint('================================');
    }

    return isUnlocked;
  }

  /// Joue un niveau
  void _playLevel(Level level) async {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    audioProvider.playButtonClick();

    // Vérifier si le joueur a des vies
    if (userProvider.lives <= 0) {
      _showNoLivesDialog(l10n);
      return;
    }

    // Démarrer le niveau (consomme une vie)
    final success = await gameProvider.startLevel(
      level,
      collectionProvider:
          Provider.of<CollectionProvider>(context, listen: false),
      userProvider: userProvider,
    );

    if (success) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const GameScreen(),
        ),
      );
    } else {
      _showNoLivesDialog(l10n);
    }
  }

  /// Affiche un dialog quand le joueur n'a pas de vies
  void _showNoLivesDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pas de vies !'),
        content: Text(
            'Vous n\'avez plus de vies. Attendez qu\'elles se régénèrent ou achetez-en dans la boutique.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Attendre'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ShopScreen(),
                ),
              );
            },
            child: Text('Boutique'),
          ),
        ],
      ),
    );
  }

  /// Récupère les couleurs du monde
  List<Color> _getWorldColors(BuildContext context) {
    final colorStrings = widget.world.colors;
    final colors = colorStrings.map((colorString) {
      final hex = colorString.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    }).toList();

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
    switch (widget.world.iconName) {
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
    switch (widget.world.nameKey) {
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
        return 'Monde ${widget.world.id}';
    }
  }

  /// Récupère la description traduite du monde
  String _getWorldDescription(AppLocalizations l10n) {
    switch (widget.world.descriptionKey) {
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
        return 'Description du monde ${widget.world.id}';
    }
  }
}
