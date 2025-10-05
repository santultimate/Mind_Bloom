import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/models/world.dart';
import 'package:mind_bloom/providers/world_provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/widgets/world_card.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';
import 'package:mind_bloom/screens/world_levels_screen.dart';

/// Écran pour afficher et sélectionner les mondes
class WorldsScreen extends StatefulWidget {
  const WorldsScreen({super.key});

  @override
  State<WorldsScreen> createState() => _WorldsScreenState();
}

class _WorldsScreenState extends State<WorldsScreen> {
  World? _selectedWorld;

  @override
  void initState() {
    super.initState();
    _initializeWorlds();
  }

  /// Initialise les mondes
  Future<void> _initializeWorlds() async {
    final worldProvider = Provider.of<WorldProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await worldProvider.initialize(userProvider);

    // 🚀 CORRECTION: Sélectionner le monde en cours de progression par défaut
    final worlds = worldProvider.worlds;
    World? currentWorld;

    // Trouver le monde en cours de progression (le plus récent avec des niveaux non complétés)
    for (final world in worlds.reversed) {
      if (world.isUnlocked) {
        final lastCompletedLevel = userProvider.getWorldProgress(world.id);

        // Calculer le nombre de niveaux complétés dans ce monde
        final completedInWorld = lastCompletedLevel >= world.startLevel
            ? (lastCompletedLevel - world.startLevel + 1)
            : 0;
        final totalLevelsInWorld = world.levelCount;

        // Si le monde n'est pas complété à 100%, c'est le monde en cours
        if (completedInWorld < totalLevelsInWorld) {
          currentWorld = world;
          break;
        }
      }
    }

    // Si tous les mondes déverrouillés sont complétés, utiliser le dernier monde déverrouillé
    if (currentWorld == null) {
      final unlockedWorlds = worldProvider.getUnlockedWorlds();
      if (unlockedWorlds.isNotEmpty) {
        currentWorld = unlockedWorlds.last;
      }
    }

    // Utiliser le monde sélectionné par l'utilisateur s'il existe, sinon le monde en cours
    final selectedWorldId = userProvider.selectedWorldId;
    final userSelectedWorld = worlds.firstWhere(
      (world) => world.id == selectedWorldId && world.isUnlocked,
      orElse: () => currentWorld ?? worlds.first,
    );

    if (_selectedWorld == null) {
      setState(() {
        _selectedWorld = userSelectedWorld;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          l10n.worlds,
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
      body: Consumer2<WorldProvider, UserProvider>(
        builder: (context, worldProvider, userProvider, child) {
          if (!worldProvider.isInitialized) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              // Statistiques globales
              _buildGlobalStats(context, worldProvider, userProvider),

              // Liste des mondes
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _initializeWorlds(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: worldProvider.worlds.length,
                    itemBuilder: (context, index) {
                      final world = worldProvider.worlds[index];
                      return WorldCard(
                        world: world,
                        isSelected: _selectedWorld?.id == world.id,
                        onTap: () => _selectWorld(world),
                      );
                    },
                  ),
                ),
              ),

              // Bouton d'action
              if (_selectedWorld != null)
                _buildActionButton(context, _selectedWorld!),
            ],
          );
        },
      ),
    );
  }

  /// Construit les statistiques globales
  Widget _buildGlobalStats(BuildContext context, WorldProvider worldProvider,
      UserProvider userProvider) {
    final stats = worldProvider.getWorldStatistics(userProvider);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
          Text(
            l10n.globalProgress,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  '${stats['unlockedWorlds']}/${stats['totalWorlds']}',
                  l10n.worlds,
                  Icons.public,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  '${stats['completedLevels']}/${stats['totalLevels']}',
                  l10n.levels,
                  Icons.stairs,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  '${stats['overallProgress']}%',
                  l10n.completed,
                  Icons.check_circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: stats['overallProgress'] / 100,
            backgroundColor:
                Theme.of(context).colorScheme.outline.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit un élément de statistique
  Widget _buildStatItem(
      BuildContext context, String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
      ],
    );
  }

  /// Construit le bouton d'action
  Widget _buildActionButton(BuildContext context, World world) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: world.isUnlocked ? () => _enterWorld(world) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            world.isUnlocked
                ? '${l10n.enter} - ${_getWorldName(l10n, world)}'
                : '${l10n.locked}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// Sélectionne un monde
  void _selectWorld(World world) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      _selectedWorld = world;
    });

    // 🚀 CORRECTION: Mettre à jour le monde sélectionné dans UserProvider
    userProvider.setSelectedWorld(world.id);

    audioProvider.playButtonClick();
  }

  /// Entre dans un monde (navigation vers les niveaux)
  void _enterWorld(World world) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    audioProvider.playButtonClick();

    // Naviguer vers l'écran des niveaux du monde sélectionné
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorldLevelsScreen(world: world),
      ),
    );
  }

  /// Récupère le nom traduit du monde
  String _getWorldName(AppLocalizations l10n, World world) {
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
}
