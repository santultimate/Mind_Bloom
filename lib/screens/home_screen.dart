import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/providers/game_provider.dart';
import 'package:mind_bloom/providers/world_provider.dart';
import 'package:mind_bloom/providers/level_provider.dart';
import 'package:mind_bloom/providers/collection_provider.dart';
import 'package:mind_bloom/models/level.dart';
import 'package:mind_bloom/models/world.dart';
import 'package:mind_bloom/screens/game_screen.dart';
import 'package:mind_bloom/screens/events_screen.dart';
import 'package:mind_bloom/screens/shop_screen.dart';
import 'package:mind_bloom/screens/collection_screen.dart';
import 'package:mind_bloom/screens/achievements_screen.dart';
import 'package:mind_bloom/screens/profile_screen.dart';
import 'package:mind_bloom/screens/worlds_screen.dart';
import 'package:mind_bloom/screens/settings_screen.dart';
import 'package:mind_bloom/widgets/level_card.dart';
import 'package:mind_bloom/widgets/status_bar.dart';
import 'package:mind_bloom/widgets/banner_ad_widget.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  World? _currentWorld;
  List<Level> _currentWorldLevels = [];

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCurrentWorld();
  }

  /// Charge le monde en cours et ses niveaux
  Future<void> _loadCurrentWorld() async {
    final worldProvider = Provider.of<WorldProvider>(context, listen: false);
    final levelProvider = Provider.of<LevelProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Initialiser les providers si nécessaire
    if (!worldProvider.isInitialized) {
      await worldProvider.initialize(userProvider);
    }
    if (!levelProvider.isInitialized) {
      await levelProvider.initialize();
    }

    // Déterminer le monde en cours basé sur la progression du joueur
    final currentWorldId = _getCurrentWorldId(userProvider);
    final worlds = worldProvider.worlds;

    _currentWorld = worlds.firstWhere(
      (world) => world.id == currentWorldId,
      orElse: () => worlds.first,
    );

    // Charger les niveaux du monde en cours avec traduction
    if (_currentWorld != null) {
      final locale = Localizations.localeOf(context);
      final levels = levelProvider.getWorldLevelsWithTranslation(
          _currentWorld!.id, locale);
      if (levels != null) {
        setState(() {
          _currentWorldLevels = levels;
        });
      }
    }
  }

  /// Détermine l'ID du monde en cours basé sur la progression du joueur
  int _getCurrentWorldId(UserProvider userProvider) {
    final completedLevels = userProvider.completedLevels;

    // Trouver le dernier niveau complété pour déterminer le monde
    if (completedLevels.isEmpty) {
      return 1; // Premier monde si aucun niveau complété
    }

    // Calculer le monde basé sur le dernier niveau complété
    final lastCompletedLevel = completedLevels.reduce((a, b) => a > b ? a : b);
    final worldId = ((lastCompletedLevel - 1) ~/ 10) + 1;

    // S'assurer qu'on ne dépasse pas le nombre de mondes disponibles
    return worldId.clamp(1, 10);
  }

  /// Construit l'en-tête du monde en cours
  Widget _buildCurrentWorldHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_currentWorld == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Text(
          l10n.world,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getWorldIcon(),
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getWorldName(l10n),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
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

          // Progression du monde
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              final completedInWorld = _currentWorldLevels
                  .where((level) => userProvider.completedLevels
                      .contains(level.id + (_currentWorld!.id - 1) * 10))
                  .length;

              return Row(
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
                          value: _currentWorldLevels.isNotEmpty
                              ? completedInWorld / _currentWorldLevels.length
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
                    '$completedInWorld/${_currentWorldLevels.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// Récupère les couleurs du monde en cours
  List<Color> _getWorldColors(BuildContext context) {
    if (_currentWorld == null) {
      return [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.primary.withOpacity(0.7),
      ];
    }

    final colorStrings = _currentWorld!.colors;
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

  /// Récupère l'icône du monde en cours
  IconData _getWorldIcon() {
    if (_currentWorld == null) return Icons.public;

    switch (_currentWorld!.iconName) {
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

  /// Récupère le nom traduit du monde en cours
  String _getWorldName(AppLocalizations l10n) {
    if (_currentWorld == null) return 'Monde';

    switch (_currentWorld!.nameKey) {
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
        return 'Monde ${_currentWorld!.id}';
    }
  }

  /// Récupère la description traduite du monde en cours
  String _getWorldDescription(AppLocalizations l10n) {
    if (_currentWorld == null) return 'Description du monde';

    switch (_currentWorld!.descriptionKey) {
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
        return 'Description du monde ${_currentWorld!.id}';
    }
  }

  /// Vérifie si un niveau est déverrouillé
  bool _isLevelUnlocked(Level level, UserProvider userProvider) {
    if (_currentWorld == null) return false;

    // Le premier niveau du premier monde est toujours déverrouillé
    if (_currentWorld!.id == 1 && level.id == 1) return true;

    // Pour les autres niveaux, vérifier si le niveau précédent est complété
    if (level.id == 1) {
      // Premier niveau d'un monde : vérifier si le dernier niveau du monde précédent est complété
      final previousWorldLastLevel = (_currentWorld!.id - 1) * 10;
      return userProvider.completedLevels.contains(previousWorldLastLevel);
    } else {
      // Niveau suivant : vérifier si le niveau précédent est complété
      final currentLevelGlobalId = level.id + (_currentWorld!.id - 1) * 10;
      return userProvider.completedLevels.contains(currentLevelGlobalId - 1);
    }
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

  /// Joue la musique de fond
  void _playBackgroundMusic() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playMusic('assets/audio/music/background_music.mp3');
  }

  /// Navigation adaptative qui s'ajuste selon la taille de l'écran
  Widget _buildAdaptiveNavigation() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        // Pour les très petits écrans (< 360px), utiliser une navigation compacte
        if (screenWidth < 360) {
          return _buildCompactNavigation();
        }
        // Pour les petits écrans (360-480px), utiliser une navigation en 2 lignes
        else if (screenWidth < 480) {
          return _buildTwoRowNavigation();
        }
        // Pour les écrans moyens et grands, utiliser la navigation normale
        else {
          return _buildNormalNavigation();
        }
      },
    );
  }

  /// Navigation compacte pour très petits écrans
  Widget _buildCompactNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCompactNavButton(Icons.home, 0),
        _buildCompactNavButton(Icons.public, 1),
        _buildCompactNavButton(Icons.event, 2),
        _buildCompactNavButton(Icons.shopping_bag, 3),
        _buildCompactNavButton(Icons.collections, 4),
        _buildCompactNavButton(Icons.emoji_events, 5),
        _buildCompactNavButton(Icons.person, 6),
        _buildCompactNavButton(Icons.settings, 7),
      ],
    );
  }

  /// Navigation en deux lignes pour petits écrans
  Widget _buildTwoRowNavigation() {
    return Column(
      children: [
        // Première ligne : Home, Worlds, Events
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(
              icon: Icons.home,
              label: AppLocalizations.of(context)!.home,
              isSelected: _currentIndex == 0,
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            _buildNavButton(
              icon: Icons.public,
              label: AppLocalizations.of(context)!.worlds ?? 'Mondes',
              isSelected: _currentIndex == 1,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WorldsScreen(),
                  ),
                );
              },
            ),
            _buildNavButton(
              icon: Icons.event,
              label: AppLocalizations.of(context)!.events,
              isSelected: _currentIndex == 2,
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EventsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Deuxième ligne : Shop, Collection, Achievements, Profile, Settings
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(
              icon: Icons.shopping_bag,
              label: AppLocalizations.of(context)!.shop,
              isSelected: _currentIndex == 3,
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ShopScreen(),
                  ),
                );
              },
            ),
            _buildNavButton(
              icon: Icons.collections,
              label: AppLocalizations.of(context)!.collection,
              isSelected: _currentIndex == 4,
              onTap: () {
                setState(() {
                  _currentIndex = 4;
                });
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CollectionScreen(),
                  ),
                );
              },
            ),
            _buildNavButton(
              icon: Icons.emoji_events,
              label: AppLocalizations.of(context)!.achievements,
              isSelected: _currentIndex == 5,
              onTap: () {
                setState(() {
                  _currentIndex = 5;
                });
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AchievementsScreen(),
                  ),
                );
              },
            ),
            _buildNavButton(
              icon: Icons.person,
              label: AppLocalizations.of(context)!.profile,
              isSelected: _currentIndex == 6,
              onTap: () {
                setState(() {
                  _currentIndex = 6;
                });
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
            _buildNavButton(
              icon: Icons.settings,
              label: AppLocalizations.of(context)!.settings,
              isSelected: _currentIndex == 7,
              onTap: () {
                setState(() {
                  _currentIndex = 7;
                });
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Navigation normale pour écrans moyens et grands
  Widget _buildNormalNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavButton(
          icon: Icons.home,
          label: AppLocalizations.of(context)!.home,
          isSelected: _currentIndex == 0,
          onTap: () {
            setState(() {
              _currentIndex = 0;
            });
          },
        ),
        _buildNavButton(
          icon: Icons.public,
          label: AppLocalizations.of(context)!.worlds ?? 'Mondes',
          isSelected: _currentIndex == 1,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const WorldsScreen(),
              ),
            );
          },
        ),
        _buildNavButton(
          icon: Icons.event,
          label: AppLocalizations.of(context)!.events,
          isSelected: _currentIndex == 2,
          onTap: () {
            setState(() {
              _currentIndex = 2;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EventsScreen(),
              ),
            );
          },
        ),
        _buildNavButton(
          icon: Icons.shopping_bag,
          label: AppLocalizations.of(context)!.shop,
          isSelected: _currentIndex == 3,
          onTap: () {
            setState(() {
              _currentIndex = 3;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ShopScreen(),
              ),
            );
          },
        ),
        _buildNavButton(
          icon: Icons.collections,
          label: AppLocalizations.of(context)!.collection,
          isSelected: _currentIndex == 4,
          onTap: () {
            setState(() {
              _currentIndex = 4;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CollectionScreen(),
              ),
            );
          },
        ),
        _buildNavButton(
          icon: Icons.emoji_events,
          label: AppLocalizations.of(context)!.achievements,
          isSelected: _currentIndex == 5,
          onTap: () {
            setState(() {
              _currentIndex = 5;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AchievementsScreen(),
              ),
            );
          },
        ),
        _buildNavButton(
          icon: Icons.person,
          label: AppLocalizations.of(context)!.profile,
          isSelected: _currentIndex == 6,
          onTap: () {
            setState(() {
              _currentIndex = 6;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          },
        ),
        _buildNavButton(
          icon: Icons.settings,
          label: AppLocalizations.of(context)!.settings,
          isSelected: _currentIndex == 7,
          onTap: () {
            setState(() {
              _currentIndex = 7;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Construit un bouton de navigation normal
  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 10, // Texte plus petit pour économiser l'espace
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Construit un bouton de navigation compact (icône seulement)
  Widget _buildCompactNavButton(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });

        // Navigation vers les écrans appropriés
        switch (index) {
          case 1: // Worlds
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const WorldsScreen(),
              ),
            );
            break;
          case 2: // Events
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EventsScreen(),
              ),
            );
            break;
          case 3: // Shop
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ShopScreen(),
              ),
            );
            break;
          case 4: // Collection
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CollectionScreen(),
              ),
            );
            break;
          case 5: // Achievements
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AchievementsScreen(),
              ),
            );
            break;
          case 6: // Profile
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
            break;
          case 7: // Settings
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
            break;
          case 0: // Home - reste sur la page actuelle
          default:
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: _currentIndex == index
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          size: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Barre de statut
            const StatusBar(),

            // Titre de la section avec le monde en cours
            _buildCurrentWorldHeader(context),

            // Contenu principal avec les niveaux
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: _currentWorldLevels.length,
                itemBuilder: (context, index) {
                  final level = _currentWorldLevels[index];
                  final userProvider = Provider.of<UserProvider>(context);
                  final globalLevelId = level.id + (_currentWorld!.id - 1) * 10;
                  final isUnlocked = _isLevelUnlocked(level, userProvider);
                  final stars = userProvider.getLevelStars(globalLevelId);

                  return LevelCard(
                    level: level,
                    isUnlocked: isUnlocked,
                    stars: stars,
                    onTap: () {
                      if (isUnlocked) {
                        _playLevel(level);
                      }
                    },
                  );
                },
              ),
            ),

            // Bannière publicitaire
            const BannerAdWidget(placement: 'home'),

            // Barre de navigation adaptative pour petits écrans
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: _buildAdaptiveNavigation(),
            ),
          ],
        ),
      ),
    );
  }
}
