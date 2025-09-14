import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/providers/game_provider.dart';
import 'package:mind_bloom/providers/collection_provider.dart';
import 'package:mind_bloom/models/level.dart';
import 'package:mind_bloom/models/tile.dart';
import 'package:mind_bloom/screens/game_screen.dart';
import 'package:mind_bloom/screens/settings_screen.dart';
import 'package:mind_bloom/screens/events_screen.dart';
import 'package:mind_bloom/screens/shop_screen.dart';
import 'package:mind_bloom/screens/collection_screen.dart';
import 'package:mind_bloom/screens/achievements_screen.dart';
import 'package:mind_bloom/screens/profile_screen.dart';
import 'package:mind_bloom/screens/about_screen.dart';
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
  final List<Level> _levels = [];
  final int _currentWorld = 1;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_levels.isEmpty) {
      _generateLevels();
    }
  }

  void _generateLevels() {
    // Générer 50 niveaux avec difficulté progressive
    for (int i = 1; i <= 50; i++) {
      const tileTypes = TileType.values;
      final randomTile = tileTypes[i % tileTypes.length];

      // Calculer la difficulté progressive
      final difficulty = _calculateLevelDifficulty(i);
      final targetCount = _calculateTargetCount(i, difficulty);
      final maxMoves = _calculateMaxMoves(i, difficulty);
      final gridSize = _calculateGridSize(i, difficulty);

      _levels.add(Level.simple(
        id: i,
        name: '${AppLocalizations.of(context)!.level} $i',
        targetTile: randomTile,
        targetCount: targetCount,
        maxMoves: maxMoves,
        gridSize: gridSize,
      ));
    }
  }

  /// Calcule la difficulté d'un niveau basée sur son ID
  LevelDifficulty _calculateLevelDifficulty(int levelId) {
    if (levelId <= 10) return LevelDifficulty.easy;
    if (levelId <= 25) return LevelDifficulty.medium;
    if (levelId <= 40) return LevelDifficulty.hard;
    return LevelDifficulty.expert;
  }

  /// Calcule le nombre de tuiles à collecter basé sur le niveau et la difficulté
  int _calculateTargetCount(int levelId, LevelDifficulty difficulty) {
    int baseCount = 8;

    switch (difficulty) {
      case LevelDifficulty.easy:
        baseCount = 8 + (levelId * 1);
        break;
      case LevelDifficulty.medium:
        baseCount = 12 + (levelId * 1.5).round();
        break;
      case LevelDifficulty.hard:
        baseCount = 18 + (levelId * 2).round();
        break;
      case LevelDifficulty.expert:
        baseCount = 25 + (levelId * 2.5).round();
        break;
    }

    return baseCount.clamp(8, 50);
  }

  /// Calcule le nombre maximum de mouvements basé sur le niveau et la difficulté
  int _calculateMaxMoves(int levelId, LevelDifficulty difficulty) {
    int baseMoves = 20;

    switch (difficulty) {
      case LevelDifficulty.easy:
        baseMoves = 25 + (levelId * 1);
        break;
      case LevelDifficulty.medium:
        baseMoves = 20 + (levelId * 0.8).round();
        break;
      case LevelDifficulty.hard:
        baseMoves = 18 + (levelId * 0.6).round();
        break;
      case LevelDifficulty.expert:
        baseMoves = 15 + (levelId * 0.5).round();
        break;
    }

    return baseMoves.clamp(15, 40);
  }

  /// Calcule la taille de la grille basée sur le niveau et la difficulté
  int _calculateGridSize(int levelId, LevelDifficulty difficulty) {
    switch (difficulty) {
      case LevelDifficulty.easy:
        return 6; // Grille 6x6 pour les débutants
      case LevelDifficulty.medium:
        return levelId <= 20 ? 6 : 7; // Transition vers 7x7
      case LevelDifficulty.hard:
        return 7; // Grille 7x7 pour les niveaux difficiles
      case LevelDifficulty.expert:
        return levelId <= 45 ? 7 : 8; // Transition vers 8x8 pour les experts
    }
  }

  void _playBackgroundMusic() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playMainMenuMusic();
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

            // Titre de la section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.world} $_currentWorld',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    },
                    icon: Icon(Icons.info_outline,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6)),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                    icon: Icon(Icons.settings,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6)),
                  ),
                ],
              ),
            ),

            // Grille des niveaux
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: _levels.length,
                itemBuilder: (context, index) {
                  final level = _levels[index];
                  final userProvider = Provider.of<UserProvider>(context);
                  final isUnlocked = userProvider.isLevelUnlocked(level.id);
                  final stars = userProvider.getLevelStars(level.id);

                  return LevelCard(
                    level: level,
                    isUnlocked: isUnlocked,
                    stars: stars,
                    onTap: () => _startLevel(level),
                  );
                },
              ),
            ),

            // Bannière publicitaire
            const HomeBannerAd(),

            // Barre de navigation
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    icon: Icons.event,
                    label: AppLocalizations.of(context)!.events,
                    isSelected: _currentIndex == 1,
                    onTap: () {
                      setState(() {
                        _currentIndex = 1;
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
                    isSelected: _currentIndex == 2,
                    onTap: () {
                      setState(() {
                        _currentIndex = 2;
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
                    isSelected: _currentIndex == 3,
                    onTap: () {
                      setState(() {
                        _currentIndex = 3;
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
                    isSelected: _currentIndex == 4,
                    onTap: () {
                      setState(() {
                        _currentIndex = 4;
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
                    isSelected: _currentIndex == 5,
                    onTap: () {
                      setState(() {
                        _currentIndex = 5;
                      });
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }

  void _startLevel(Level level) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    // Vérifier si le joueur a des vies
    if (userProvider.lives <= 0) {
      _showNoLivesDialog();
      return;
    }

    // Vérifier si le niveau est débloqué
    if (!userProvider.isLevelUnlocked(level.id)) {
      _showLevelLockedDialog();
      return;
    }

    // Utiliser une vie
    userProvider.useLife();

    // Jouer un son
    audioProvider.playButtonClick();

    // Initialiser le niveau avec les collections
    final collectionProvider =
        Provider.of<CollectionProvider>(context, listen: false);
    gameProvider.startLevel(level, collectionProvider: collectionProvider);

    // Naviguer vers l'écran de jeu
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const GameScreen(),
      ),
    );
  }

  void _showNoLivesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.noMoreLives),
        content: Text(AppLocalizations.of(context)!.noMoreLivesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.wait),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Ouvrir la boutique
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ShopScreen(),
                ),
              );
            },
            child: Text(AppLocalizations.of(context)!.buy),
          ),
        ],
      ),
    );
  }

  void _showLevelLockedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.levelLocked),
        content: Text(AppLocalizations.of(context)!.levelLockedMessage),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }
}
