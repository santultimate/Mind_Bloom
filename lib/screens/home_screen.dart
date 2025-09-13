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
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/widgets/level_card.dart';
import 'package:mind_bloom/widgets/status_bar.dart';
import 'package:mind_bloom/widgets/banner_ad_widget.dart';

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
    _generateLevels();
    _playBackgroundMusic();
  }

  void _generateLevels() {
    // Générer 50 niveaux pour commencer
    for (int i = 1; i <= 50; i++) {
      const tileTypes = TileType.values;
      final randomTile = tileTypes[i % tileTypes.length];

      _levels.add(Level.simple(
        id: i,
        name: 'Niveau $i',
        targetTile: randomTile,
        targetCount: 10 + (i * 2),
        maxMoves: 20 + (i * 2),
      ));
    }
  }

  void _playBackgroundMusic() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playMainMenuMusic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                    'Monde $_currentWorld',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.textPrimary,
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
                    icon: const Icon(Icons.info_outline,
                        color: AppColors.textSecondary),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings,
                        color: AppColors.textSecondary),
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
              decoration: const BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
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
                    label: 'Accueil',
                    isSelected: _currentIndex == 0,
                    onTap: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                  ),
                  _buildNavButton(
                    icon: Icons.event,
                    label: 'Événements',
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
                    label: 'Boutique',
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
                    label: 'Collection',
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
                    label: 'Succès',
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
                    label: 'Profil',
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
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.textSecondary,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color:
                      isSelected ? AppColors.primary : AppColors.textSecondary,
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
        title: const Text('Plus de vies !'),
        content: const Text(
            'Vous n\'avez plus de vies. Regardez une publicité pour en obtenir une gratuite, attendez qu\'elles se rechargent ou achetez-en plus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Attendre'),
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
            child: const Text('Acheter'),
          ),
        ],
      ),
    );
  }

  void _showLevelLockedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Niveau verrouillé'),
        content: const Text(
            'Vous devez compléter le niveau précédent pour débloquer celui-ci.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
