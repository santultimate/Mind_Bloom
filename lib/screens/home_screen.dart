import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:mind_bloom/screens/daily_rewards_screen.dart';
import 'package:mind_bloom/providers/daily_rewards_provider.dart';
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
      _loadLevelsFromJSON();
    }
  }

  void _generateLevels() {
    // Générer 50 niveaux avec difficulté progressive
    for (int i = 1; i <= 50; i++) {
      // Debug pour tous les niveaux
      if (kDebugMode) {
        print('=== DEBUG LEVEL $i GENERATION ===');
      }
      // Calculer la difficulté progressive
      final difficulty = _calculateLevelDifficulty(i);
      final targetCount = _calculateTargetCount(i, difficulty);
      final maxMoves = _calculateMaxMoves(i, difficulty);
      final gridSize = _calculateGridSize(i, difficulty);

      // Créer des objectifs multiples pour augmenter la durée
      final objectives =
          _generateMultipleObjectives(i, difficulty, targetCount);

      // Debug pour tous les niveaux
      if (kDebugMode) {
        print('Level $i - Difficulty: $difficulty');
        print('Level $i - Target Count: $targetCount');
        print('Level $i - Max Moves: $maxMoves');
        print('Level $i - Grid Size: $gridSize');
        print('Level $i - Objectives: ${objectives.length}');
        for (int j = 0; j < objectives.length; j++) {
          print(
              '  Objective $j: ${objectives[j].type} - ${objectives[j].tileType} - ${objectives[j].target}');
        }
        print('=====================================');
      }

      _levels.add(Level(
        id: i,
        name: '${AppLocalizations.of(context)!.level} $i',
        description: 'Collect multiple tile types',
        difficulty: difficulty,
        gridSize: gridSize,
        maxMoves: maxMoves,
        targetScore: _calculateTargetScore(i, difficulty),
        objectives: objectives,
        initialGrid:
            List.generate(gridSize, (i) => List.generate(gridSize, (j) => -1)),
        blockers: List.generate(
            gridSize, (i) => List.generate(gridSize, (j) => false)),
        jelly: List.generate(
            gridSize, (i) => List.generate(gridSize, (j) => false)),
        specialRules: {},
        energyCost: 1,
        rewards: ['coins:${(i * 2).clamp(10, 100)}'],
      ));
    }

    // Validation de tous les niveaux générés
    if (kDebugMode) {
      _validateAllLevels();
    }
  }

  /// Charge les niveaux depuis le fichier JSON
  void _loadLevelsFromJSON() async {
    if (kDebugMode) {
      print('=== DEBUG: _loadLevelsFromJSON() appelée ===');
    }
    try {
      // Charger les niveaux depuis le fichier JSON
      if (kDebugMode) {
        print('=== DEBUG: Chargement du fichier assets/data/levels.json ===');
      }
      final String response =
          await rootBundle.loadString('assets/data/levels.json');
      if (kDebugMode) {
        print(
            '=== DEBUG: Fichier JSON chargé avec succès (${response.length} caractères) ===');
      }
      final Map<String, dynamic> jsonData = json.decode(response);
      final List<dynamic> levelsData = jsonData['levels'];

      if (kDebugMode) {
        print(
            '=== DEBUG: ${levelsData.length} niveaux trouvés dans le JSON ===');
      }

      _levels.clear();

      for (final levelData in levelsData) {
        final level = _parseLevelFromJson(levelData);
        _levels.add(level);

        // Debug pour chaque niveau chargé
        if (kDebugMode) {
          print('=== DEBUG LEVEL ${level.id} LOADED ===');
          print('Level ${level.id} - Difficulty: ${level.difficulty}');
          print('Level ${level.id} - Grid Size: ${level.gridSize}');
          print('Level ${level.id} - Max Moves: ${level.maxMoves}');
          print('Level ${level.id} - Objectives: ${level.objectives.length}');
          for (int j = 0; j < level.objectives.length; j++) {
            print(
                '  Objective $j: ${level.objectives[j].type} - ${level.objectives[j].tileType} - ${level.objectives[j].target}');
          }
          print('=====================================');
        }
      }

      // Debug pour tous les niveaux
      if (kDebugMode) {
        print('=== VALIDATION DE TOUS LES NIVEAUX ===');
        print('✅ TOUS LES NIVEAUX SONT CORRECTEMENT CHARGÉS DEPUIS JSON');
        print('=========================================');
      }

      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print('=== DEBUG: ERREUR lors du chargement des niveaux: $e ===');
        print('=== DEBUG: Stack trace: ${StackTrace.current} ===');
      }
      // Fallback: générer les niveaux si le JSON échoue
      if (kDebugMode) {
        print('=== DEBUG: Fallback vers _generateLevels() ===');
      }
      _generateLevels();
    }
  }

  /// Parse un niveau depuis les données JSON
  Level _parseLevelFromJson(Map<String, dynamic> json) {
    // Parser la difficulté
    LevelDifficulty difficulty;
    switch (json['difficulty']) {
      case 'easy':
        difficulty = LevelDifficulty.easy;
        break;
      case 'medium':
        difficulty = LevelDifficulty.medium;
        break;
      case 'hard':
        difficulty = LevelDifficulty.hard;
        break;
      case 'expert':
        difficulty = LevelDifficulty.expert;
        break;
      default:
        difficulty = LevelDifficulty.easy;
    }

    // Parser les objectifs
    List<LevelObjective> objectives = [];
    if (json['objectives'] != null) {
      for (final objectiveJson in json['objectives']) {
        LevelObjectiveType type;
        switch (objectiveJson['type']) {
          case 'collectTiles':
            type = LevelObjectiveType.collectTiles;
            break;
          case 'clearBlockers':
            type = LevelObjectiveType.clearBlockers;
            break;
          case 'reachScore':
            type = LevelObjectiveType.reachScore;
            break;
          case 'freeCreature':
            type = LevelObjectiveType.freeCreature;
            break;
          case 'clearJelly':
            type = LevelObjectiveType.clearJelly;
            break;
          default:
            type = LevelObjectiveType.collectTiles;
        }

        TileType? tileType;
        if (objectiveJson['tileType'] != null) {
          switch (objectiveJson['tileType']) {
            case 'flower':
              tileType = TileType.flower;
              break;
            case 'leaf':
              tileType = TileType.leaf;
              break;
            case 'crystal':
              tileType = TileType.crystal;
              break;
            case 'seed':
              tileType = TileType.seed;
              break;
            case 'dew':
              tileType = TileType.dew;
              break;
            case 'sun':
              tileType = TileType.sun;
              break;
            case 'moon':
              tileType = TileType.moon;
              break;
            case 'gem':
              tileType = TileType.gem;
              break;
            default:
              tileType = null;
          }
        }

        objectives.add(LevelObjective(
          type: type,
          tileType: tileType,
          target: objectiveJson['target'] ?? 0,
        ));
      }
    }

    // Parser les récompenses
    List<String> rewards = [];
    if (json['rewards'] != null) {
      rewards = List<String>.from(json['rewards']);
    }

    // Créer le niveau
    return Level(
      id: json['id'] ?? 1,
      name: json['name'] ??
          '${AppLocalizations.of(context)?.level ?? 'Level'} ${json['id'] ?? 1}',
      description: json['description'] ?? 'Description par défaut',
      difficulty: difficulty,
      gridSize: json['gridSize'] ?? 7,
      maxMoves: json['maxMoves'] ?? 20,
      targetScore: json['targetScore'] ?? 1000,
      objectives: objectives,
      initialGrid: List.generate(
        json['gridSize'] ?? 7,
        (i) => List.generate(json['gridSize'] ?? 7, (j) => -1),
      ),
      blockers: List.generate(
        json['gridSize'] ?? 7,
        (i) => List.generate(json['gridSize'] ?? 7, (j) => false),
      ),
      jelly: List.generate(
        json['gridSize'] ?? 7,
        (i) => List.generate(json['gridSize'] ?? 7, (j) => false),
      ),
      specialRules: json['specialRules'] ?? {},
      energyCost: json['energyCost'] ?? 1,
      rewards: rewards,
    );
  }

  /// Valide que tous les niveaux sont correctement générés
  void _validateAllLevels() {
    print('=== VALIDATION DE TOUS LES NIVEAUX ===');
    int errors = 0;

    for (int i = 0; i < _levels.length; i++) {
      final level = _levels[i];
      final levelId = level.id;

      // Vérifier que l'ID correspond à l'index
      if (levelId != i + 1) {
        print('ERREUR: Level ${i + 1} a un ID incorrect: $levelId');
        errors++;
      }

      // Vérifier la difficulté
      final expectedDifficulty = _calculateLevelDifficulty(levelId);
      if (level.difficulty != expectedDifficulty) {
        print(
            'ERREUR: Level $levelId - Difficulté incorrecte: ${level.difficulty} vs $expectedDifficulty');
        errors++;
      }

      // Vérifier la taille de grille
      final expectedGridSize = _calculateGridSize(levelId, level.difficulty);
      if (level.gridSize != expectedGridSize) {
        print(
            'ERREUR: Level $levelId - Taille de grille incorrecte: ${level.gridSize} vs $expectedGridSize');
        errors++;
      }

      // Vérifier les mouvements
      final expectedMoves = _calculateMaxMoves(levelId, level.difficulty);
      if (level.maxMoves != expectedMoves) {
        print(
            'ERREUR: Level $levelId - Mouvements incorrects: ${level.maxMoves} vs $expectedMoves');
        errors++;
      }

      // Vérifier les objectifs
      if (level.objectives.isEmpty) {
        print('ERREUR: Level $levelId - Aucun objectif');
        errors++;
      }

      // Vérifier que la grille initiale est correcte
      if (level.initialGrid.length != level.gridSize) {
        print('ERREUR: Level $levelId - Grille initiale incorrecte');
        errors++;
      }
    }

    if (errors == 0) {
      print('✅ TOUS LES NIVEAUX SONT CORRECTEMENT GÉNÉRÉS');
    } else {
      print('❌ $errors ERREURS TROUVÉES DANS LA GÉNÉRATION DES NIVEAUX');
    }
    print('==========================================');
  }

  /// Calcule la difficulté d'un niveau basée sur son ID
  LevelDifficulty _calculateLevelDifficulty(int levelId) {
    if (levelId <= 10) return LevelDifficulty.easy;
    if (levelId <= 25) return LevelDifficulty.medium;
    if (levelId <= 40) return LevelDifficulty.hard;
    return LevelDifficulty.expert;
  }

  /// Génère des objectifs multiples pour augmenter la complexité
  List<LevelObjective> _generateMultipleObjectives(
      int levelId, LevelDifficulty difficulty, int baseTarget) {
    final objectives = <LevelObjective>[];
    const tileTypes = TileType.values;

    // Nombre d'objectifs basé sur la difficulté
    int objectiveCount;
    switch (difficulty) {
      case LevelDifficulty.easy:
        objectiveCount = 1;
        break;
      case LevelDifficulty.medium:
        objectiveCount = 2;
        break;
      case LevelDifficulty.hard:
        objectiveCount = 3;
        break;
      case LevelDifficulty.expert:
        objectiveCount = 4;
        break;
    }

    // Créer les objectifs
    for (int i = 0; i < objectiveCount; i++) {
      final tileType = tileTypes[(levelId + i) % tileTypes.length];
      final targetCount = (baseTarget / objectiveCount).round() + (i * 5);

      objectives.add(LevelObjective(
        type: LevelObjectiveType.collectTiles,
        tileType: tileType,
        target: targetCount,
        current: 0,
      ));
    }

    return objectives;
  }

  /// Calcule le score cible basé sur le niveau et la difficulté
  int _calculateTargetScore(int levelId, LevelDifficulty difficulty) {
    int baseScore;

    switch (difficulty) {
      case LevelDifficulty.easy:
        baseScore = 1000 + (levelId * 200);
        break;
      case LevelDifficulty.medium:
        baseScore = 2000 + (levelId * 300);
        break;
      case LevelDifficulty.hard:
        baseScore = 3000 + (levelId * 400);
        break;
      case LevelDifficulty.expert:
        baseScore = 5000 + (levelId * 500);
        break;
    }

    return baseScore;
  }

  /// Calcule le nombre de tuiles à collecter basé sur le niveau et la difficulté
  int _calculateTargetCount(int levelId, LevelDifficulty difficulty) {
    int baseCount = 25; // Augmenté de 8 à 25

    switch (difficulty) {
      case LevelDifficulty.easy:
        baseCount = 25 + (levelId * 2); // Augmenté de 1 à 2
        break;
      case LevelDifficulty.medium:
        baseCount = 35 + (levelId * 2.5).round(); // Augmenté de 1.5 à 2.5
        break;
      case LevelDifficulty.hard:
        baseCount = 45 + (levelId * 3).round(); // Augmenté de 2 à 3
        break;
      case LevelDifficulty.expert:
        baseCount = 60 + (levelId * 3.5).round(); // Augmenté de 2.5 à 3.5
        break;
    }

    return baseCount.clamp(25, 150); // Augmenté de 8-50 à 25-150
  }

  /// Calcule le nombre maximum de mouvements basé sur le niveau et la difficulté
  int _calculateMaxMoves(int levelId, LevelDifficulty difficulty) {
    // 🚀 MOUVEMENTS DRASTIQUEMENT RÉDUITS POUR PLUS DE CHALLENGE
    int baseMoves = 12; // Réduit de 50 à 12

    switch (difficulty) {
      case LevelDifficulty.easy:
        baseMoves = 12 + (levelId * 0.5).round(); // Réduit de 50+ à 12+
        break;
      case LevelDifficulty.medium:
        baseMoves = 15 + (levelId * 0.8).round(); // Réduit de 45+ à 15+
        break;
      case LevelDifficulty.hard:
        baseMoves = 18 + (levelId * 1.0).round(); // Réduit de 40+ à 18+
        break;
      case LevelDifficulty.expert:
        baseMoves = 20 + (levelId * 1.2).round(); // Réduit de 35+ à 20+
        break;
    }

    return baseMoves.clamp(10, 35); // Réduit de 35-100 à 10-35
  }

  /// Calcule la taille de la grille basée sur le niveau et la difficulté
  int _calculateGridSize(int levelId, LevelDifficulty difficulty) {
    switch (difficulty) {
      case LevelDifficulty.easy:
        return 7; // Augmenté de 6x6 à 7x7 pour plus de complexité
      case LevelDifficulty.medium:
        return levelId <= 15 ? 7 : 8; // Transition plus rapide vers 8x8
      case LevelDifficulty.hard:
        return 8; // Augmenté de 7x7 à 8x8
      case LevelDifficulty.expert:
        return levelId <= 30 ? 8 : 9; // Transition vers 9x9 pour les experts
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

                  // Bouton récompenses quotidiennes avec notification
                  Consumer<DailyRewardsProvider>(
                    builder: (context, dailyRewards, child) {
                      return Stack(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DailyRewardsScreen(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.card_giftcard,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                          ),
                          if (dailyRewards.canClaimDailyReward())
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

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

            // 🚀 BANNIÈRE PUBLICITAIRE - REVENUS CONTINUS
            const HomeBannerAd(),
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
