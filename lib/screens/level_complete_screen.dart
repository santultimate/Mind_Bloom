import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/providers/ad_provider.dart';
import 'package:mind_bloom/providers/game_provider.dart';
import 'package:mind_bloom/providers/level_provider.dart';
import 'package:mind_bloom/providers/collection_provider.dart';
import 'package:mind_bloom/providers/world_provider.dart';
import 'package:mind_bloom/constants/admob_config.dart';
import 'package:mind_bloom/widgets/banner_ad_widget.dart';
import 'package:mind_bloom/widgets/rewarded_ad_button.dart';
import 'package:mind_bloom/screens/home_screen.dart';
import 'package:mind_bloom/screens/game_screen.dart';
import 'package:mind_bloom/models/level.dart';
import 'package:mind_bloom/models/world.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

class LevelCompleteScreen extends StatefulWidget {
  final bool won;
  final int stars;
  final int score;
  final int movesUsed;
  final Level currentLevel;

  const LevelCompleteScreen({
    Key? key,
    required this.won,
    required this.stars,
    required this.score,
    required this.movesUsed,
    required this.currentLevel,
  }) : super(key: key);

  @override
  State<LevelCompleteScreen> createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();

    // Jouer le son de victoire
    if (widget.won) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final audioProvider =
            Provider.of<AudioProvider>(context, listen: false);
        audioProvider.playSfx('audio/sfx/level_complete.wav');

        // Jouer le son d'étoiles gagnées
        if (widget.stars > 0) {
          Future.delayed(const Duration(milliseconds: 500), () {
            audioProvider.playStarEarned();
          });
        }

        // Afficher une publicité interstitielle après un délai
        _showInterstitialAdAfterDelay();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: _buildContent(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.won) {
      return _buildVictoryContent();
    } else {
      return _buildDefeatContent();
    }
  }

  Widget _buildVictoryContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône de victoire
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star,
                color: Colors.white,
                size: 40,
              ),
            ),

            const SizedBox(height: 20),

            // Titre
            Text(
              AppLocalizations.of(context)!
                  .levelCompleted(widget.currentLevel.id),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Étoiles avec critères
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        index < widget.stars ? Icons.star : Icons.star_border,
                        color: index < widget.stars
                            ? AppColors.gold
                            : AppColors.textSecondary,
                        size: 32,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  _getStarRatingText(widget.stars),
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Statistiques
            _buildStatistic(
                AppLocalizations.of(context)!.score, widget.score.toString()),
            _buildStatistic(AppLocalizations.of(context)!.movesUsed,
                '${widget.movesUsed}/${widget.currentLevel.maxMoves}'),

            const SizedBox(height: 24),

            // Improved rewards
            if (widget.stars > 0) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primary.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.rewardsClaimed,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Calcul des récompenses basé sur la logique du UserProvider
                    ...(_calculateRewards().map((reward) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                reward['icon'] as IconData,
                                color: reward['color'] as Color,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                reward['text'] as String,
                                style: TextStyle(
                                  color: reward['color'] as Color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ))).toList(),

                    // Bonus spéciaux
                    if (widget.stars == 3) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '🌟 ${AppLocalizations.of(context)!.perfectPerformance}',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],

                    // Milestone bonus
                    if (widget.currentLevel.id % 5 == 0) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '🎯 Niveau Milestone! Bonus spécial',
                          style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Boutons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _retryLevel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.restart),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextLevel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.nextLevel),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Bouton de partage de score
            if (widget.won)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton.icon(
                  onPressed: _shareScore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gems,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.share, size: 20),
                  label: Text(AppLocalizations.of(context)!.shareScore),
                ),
              ),

            TextButton(
              onPressed: _goToHome,
              child: Text(
                AppLocalizations.of(context)!.backToMenu,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),

            const SizedBox(height: 16),

            // 🚀 BOUTONS DE PUBLICITÉS RÉCOMPENSÉES - REVENUS MAXIMAUX
            const CoinsRewardedAdButton(),
            const SizedBox(height: 8),
            const GemsRewardedAdButton(),

            const SizedBox(height: 16),

            // Bannière publicitaire
            const LevelCompleteBannerAd(),
          ],
        ),
      ),
    );
  }

  Widget _buildDefeatContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône d'échec
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 40,
              ),
            ),

            const SizedBox(height: 20),

            // Titre
            Text(
              AppLocalizations.of(context)!.levelFailed(widget.currentLevel.id),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Text(
              AppLocalizations.of(context)!.youHaveUsedAllMoves,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Statistiques
            _buildStatistic(
                AppLocalizations.of(context)!.score, widget.score.toString()),
            _buildStatistic(AppLocalizations.of(context)!.movesUsed,
                '${widget.movesUsed}/${widget.currentLevel.maxMoves}'),

            const SizedBox(height: 24),

            // Boutons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _retryLevel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.restart),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _goToHome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.menu),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistic(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Retourne le texte descriptif pour le nombre d'étoiles obtenues
  String _getStarRatingText(int stars) {
    switch (stars) {
      case 3:
        return AppLocalizations.of(context)!.perfectPerformance;
      case 2:
        return 'Très bien ! Bonne performance';
      case 1:
        return 'Bien ! ${AppLocalizations.of(context)?.levelComplete ?? 'Level Complete'}';
      case 0:
        return 'À améliorer';
      default:
        return '';
    }
  }

  /// Calcule les récompenses obtenues pour l'affichage
  List<Map<String, dynamic>> _calculateRewards() {
    final rewards = <Map<String, dynamic>>[];

    // Calcul basé sur la logique du UserProvider
    int baseReward = 30 + (widget.currentLevel.id * 5);
    int starBonus = widget.stars * 20;
    int scoreBonus = (widget.score / 500).floor();
    int performanceBonus = 0;

    if (widget.stars == 3) {
      performanceBonus = widget.currentLevel.id * 15;
    } else if (widget.stars == 2) {
      performanceBonus = widget.currentLevel.id * 8;
    } else if (widget.stars == 1) {
      performanceBonus = widget.currentLevel.id * 3;
    }

    int totalCoins = baseReward + starBonus + scoreBonus + performanceBonus;

    // Bonus de milestone
    if (widget.currentLevel.id % 5 == 0) {
      totalCoins += widget.currentLevel.id * 10;
    }
    if (widget.currentLevel.id % 10 == 0) {
      totalCoins +=
          100; // Bonus supplémentaire pour les niveaux multiples de 10
    }

    // Pièces
    rewards.add({
      'icon': Icons.monetization_on,
      'color': AppColors.coins,
      'text': '+${AppLocalizations.of(context)!.coins(totalCoins)}',
    });

    // Gemmes
    int gems = 0;
    if (widget.stars == 3) gems += 2;
    if (widget.stars >= 2) gems += 1;
    if (widget.currentLevel.id % 5 == 0) gems += widget.currentLevel.id ~/ 5;
    if (widget.currentLevel.id % 10 == 0) gems += 5;

    if (gems > 0) {
      rewards.add({
        'icon': Icons.diamond,
        'color': AppColors.gems,
        'text': '+${AppLocalizations.of(context)!.gems(gems)}',
      });
    }

    // Expérience
    int experience = (widget.currentLevel.id * 2) +
        (widget.stars * 10) +
        (widget.score / 1000).floor();
    rewards.add({
      'icon': Icons.star_outline,
      'color': Colors.purple,
      'text': '+$experience XP',
    });

    return rewards;
  }

  void _retryLevel() async {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    audioProvider.playSfx('audio/sfx/button_click.wav');

    // Vérifier si le joueur a des vies
    if (userProvider.lives > 0) {
      // Le joueur a des vies, rejouer (vie déjà utilisée au début)
      // 🔧 CORRECTION: Réinitialiser complètement le jeu avant de redémarrer
      gameProvider.resetGame();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const GameScreen(),
        ),
      );
    } else {
      // Le joueur n'a pas de vies, proposer de regarder une vidéo
      _showWatchAdForLifeDialog();
    }
  }

  void _showWatchAdForLifeDialog() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.play_circle_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.watchAdForLife,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.watchAdForLifeDescription,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.earnOneLife,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _goToHome();
              },
              child: Text(
                l10n.cancel,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _watchAdForLife,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(l10n.watchAd),
            ),
          ],
        );
      },
    );
  }

  void _watchAdForLife() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final adProvider = Provider.of<AdProvider>(context, listen: false);
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    Navigator.of(context).pop(); // Fermer le dialog

    try {
      // Afficher une pub récompensée
      final rewarded = await adProvider.loadRewardedAd();
      if (rewarded != null) {
        await rewarded.show(
          onUserEarnedReward: (ad, reward) async {
            // L'utilisateur a regardé la pub, lui donner une vie
            await userProvider.addLives(1);

            // 🔧 CORRECTION: Réinitialiser complètement le jeu avant de redémarrer
            gameProvider.resetGame();

            // Rejouer le niveau
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const GameScreen(),
              ),
            );

            // Afficher un message de succès
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.lifeEarned),
                backgroundColor: Theme.of(context).colorScheme.primary,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      } else {
        // Pas de pub disponible, afficher un message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.noAdAvailable),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Erreur lors du chargement de la pub
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.adError),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _nextLevel() async {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final adProvider = Provider.of<AdProvider>(context, listen: false);
    final worldProvider = Provider.of<WorldProvider>(context, listen: false);

    audioProvider.playSfx('audio/sfx/button_click.wav');

    // Sauvegarder la progression
    await userProvider.completeLevel(
      widget.currentLevel.id,
      widget.stars,
      widget.score,
    );

    // Mettre à jour la série
    userProvider.updateStreak(true);

    // Mettre à jour les collections
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    // Calculer le nombre de matches (approximation basée sur le score)
    final estimatedMatches = (widget.score / 30).round();

    gameProvider.updateCollectionProgress(
      matches: estimatedMatches,
      perfectLevel: widget.stars == 3 ? 1 : null,
    );

    // Vérifier si on doit afficher une pub interstitielle
    if (adProvider.shouldShowInterstitialAd(widget.currentLevel.id)) {
      await adProvider.showInterstitialAd();
    }

    if (mounted) {
      // Vérifier si c'est le dernier niveau du jeu (niveau 100)
      if (widget.currentLevel.id == 100) {
        _showGameCompletionDialog();
        return;
      }

      // Vérifier si c'est la fin d'un monde (niveaux 10, 20, 30, 40, 50, 60, 70, 80, 90)
      final currentWorld =
          worldProvider.getWorldByLevel(widget.currentLevel.id);
      if (currentWorld != null &&
          widget.currentLevel.id == currentWorld.endLevel) {
        // C'est la fin d'un monde, afficher le dialogue de completion du monde
        _showWorldCompletionDialog(currentWorld);
        return;
      }

      // Vérifier si le niveau suivant est déverrouillé (dans le même monde)
      final nextLevelId = widget.currentLevel.id + 1;
      final isNextLevelUnlocked = userProvider.isLevelUnlocked(nextLevelId);

      if (isNextLevelUnlocked) {
        // Le niveau suivant est déverrouillé, naviguer vers le jeu
        final levelProvider =
            Provider.of<LevelProvider>(context, listen: false);

        // Déterminer le monde du niveau suivant
        final nextWorld = worldProvider.getWorldByLevel(nextLevelId);
        if (nextWorld != null) {
          final nextLevel = levelProvider.getLevel(nextWorld.id, nextLevelId);

          if (nextLevel != null) {
            // 🚀 CORRECTION: Mettre à jour le monde sélectionné vers le monde du niveau suivant
            await userProvider.setSelectedWorld(nextWorld.id);

            // Démarrer le niveau suivant
            final success = await gameProvider.startLevel(
              nextLevel,
              collectionProvider:
                  Provider.of<CollectionProvider>(context, listen: false),
              userProvider: userProvider,
            );

            if (success) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const GameScreen(),
                ),
              );
              return;
            }
          }
        }
      }

      // Si le niveau suivant n'est pas déverrouillé ou s'il y a une erreur,
      // retourner au menu principal
      audioProvider.playBackgroundMusic();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false,
      );
    }
  }

  // Nouvelle méthode pour afficher les publicités interstitielles après un délai
  void _showInterstitialAdAfterDelay() async {
    // Attendre le délai configuré après la fin du niveau pour laisser le temps à l'utilisateur de voir le résultat
    await Future.delayed(Duration(seconds: AdMobConfig.interstitialDelay));

    if (mounted) {
      final adProvider = Provider.of<AdProvider>(context, listen: false);

      // 🚀 AMÉLIORATION: Éviter les pubs lors des dialogues spéciaux
      // Vérifier si on est dans un dialogue de completion de monde ou de fin de jeu
      final worldProvider = Provider.of<WorldProvider>(context, listen: false);
      final currentWorld =
          worldProvider.getWorldByLevel(widget.currentLevel.id);

      // Ne pas afficher de pub si c'est la fin d'un monde (niveau 10, 20, 30, etc.)
      if (currentWorld != null &&
          widget.currentLevel.id == currentWorld.endLevel) {
        return; // Pas de pub lors de la completion d'un monde
      }

      // Afficher une publicité interstitielle si les conditions sont remplies
      if (adProvider
          .shouldShowInterstitialAdOnLevelComplete(widget.currentLevel.id)) {
        await adProvider.showInterstitialAd();
      }
    }
  }

  // Construire une icône de récompense moderne
  Widget _buildRewardIcon(IconData icon, Color color, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Obtenir le nom d'affichage du monde
  String _getWorldDisplayName(World world) {
    final l10n = AppLocalizations.of(context)!;

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
        return l10n.new_world;
    }
  }

  void _goToHome() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSfx('audio/sfx/button_click.wav');

    // Relancer la musique de fond
    audioProvider.playBackgroundMusic();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  // 🎯 NOUVELLE MÉTHODE: Afficher le dialogue de completion de monde
  void _showWorldCompletionDialog(World completedWorld) async {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final worldProvider = Provider.of<WorldProvider>(context, listen: false);
    final collectionProvider =
        Provider.of<CollectionProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    // Débloquer les objets rares liés à la completion de ce monde
    final newlyUnlockedPlants =
        await collectionProvider.onWorldCompleted(completedWorld.id);

    // Vérifier s'il y a un monde suivant à déverrouiller
    final nextWorldId = completedWorld.id + 1;
    final nextWorld = worldProvider.getWorldById(nextWorldId);
    final hasNextWorld =
        nextWorld != null && nextWorld.id <= 10; // Maximum 10 mondes

    // Jouer un son spécial pour la completion du monde
    audioProvider.playSfx('audio/sfx/level_complete.wav');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 600,
              maxWidth: 400,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface.withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Effet de particules animé (icône de célébration)
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: completedWorld.colors
                              .map((color) => Color(
                                  int.parse(color.replaceFirst('#', '0xff'))))
                              .toList(),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: completedWorld.colors
                                .map((color) => Color(
                                    int.parse(color.replaceFirst('#', '0xff'))))
                                .first
                                .withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Icône principale
                          const Icon(
                            Icons.emoji_events,
                            color: Colors.white,
                            size: 50,
                          ),
                          // Effet de brillance
                          Positioned(
                            top: 15,
                            left: 25,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Titre avec effet de dégradé
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: completedWorld.colors
                            .map((color) => Color(
                                int.parse(color.replaceFirst('#', '0xff'))))
                            .toList(),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        hasNextWorld
                            ? l10n.world_completed_title
                            : l10n.world_completed_only_title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Nom du monde complété avec effet glassmorphism
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: completedWorld.colors
                              .map((color) => Color(
                                  int.parse(color.replaceFirst('#', '0xff'))))
                              .toList(),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: completedWorld.colors
                                .map((color) => Color(
                                    int.parse(color.replaceFirst('#', '0xff'))))
                                .first
                                .withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getWorldDisplayName(completedWorld),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Message de félicitations
                    Text(
                      hasNextWorld
                          ? l10n.world_completed_message
                          : l10n.world_completed_only_message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.8),
                          ),
                      textAlign: TextAlign.center,
                    ),

                    // Afficher le nouveau monde déverrouillé si applicable
                    if (hasNextWorld) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.amber.withOpacity(0.2),
                              Colors.orange.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.amber.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.celebration,
                                color: Colors.amber, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n.new_world_unlocked(
                                    _getWorldDisplayName(nextWorld)),
                                style: TextStyle(
                                  color: Colors.amber.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // 🌟 Afficher les objets rares débloqués
                    if (newlyUnlockedPlants.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        l10n.rare_items_unlocked,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      ...newlyUnlockedPlants.map((plant) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: _getRarityColor(plant.rarity)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.asset(plant.imagePath,
                                      fit: BoxFit.contain),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  plant.name,
                                  style: TextStyle(
                                    color: _getRarityColor(plant.rarity),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],

                    const SizedBox(height: 20),

                    // Special rewards
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            l10n.completion_rewards,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildRewardIcon(Icons.diamond, AppColors.gems,
                                  '+${AppLocalizations.of(context)!.gems(10)}'),
                              _buildRewardIcon(
                                  Icons.monetization_on,
                                  AppColors.coins,
                                  '+${AppLocalizations.of(context)!.coins(200)}'),
                              _buildRewardIcon(
                                  Icons.star_outline, Colors.purple, '+100 XP'),
                            ],
                          ),
                          // Bonus de déverrouillage si applicable
                          if (hasNextWorld) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                l10n.unlock_bonus,
                                style: TextStyle(
                                  color: Colors.amber.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Boutons d'action
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Fermer le dialogue
                              _goToHome(); // Retourner au menu
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.backToMenu,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        if (hasNextWorld) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context)
                                    .pop(); // Fermer le dialogue

                                // Démarrer le premier niveau du monde suivant
                                final gameProvider = Provider.of<GameProvider>(
                                    context,
                                    listen: false);
                                final levelProvider =
                                    Provider.of<LevelProvider>(context,
                                        listen: false);
                                final collectionProvider =
                                    Provider.of<CollectionProvider>(context,
                                        listen: false);
                                final userProvider = Provider.of<UserProvider>(
                                    context,
                                    listen: false);

                                if (nextWorld != null) {
                                  // Mettre à jour le monde sélectionné
                                  await userProvider
                                      .setSelectedWorld(nextWorld.id);

                                  // Obtenir le premier niveau du nouveau monde
                                  final firstLevel = levelProvider.getLevel(
                                      nextWorld.id, nextWorld.startLevel);

                                  if (firstLevel != null) {
                                    final success =
                                        await gameProvider.startLevel(
                                      firstLevel,
                                      collectionProvider: collectionProvider,
                                      userProvider: userProvider,
                                    );

                                    if (success) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const GameScreen(),
                                        ),
                                      );
                                      return;
                                    }
                                  }
                                }

                                // Si erreur, retourner au menu
                                _goToHome();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Monde Suivant',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.arrow_forward, size: 18),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _shareScore() async {
    final l10n = AppLocalizations.of(context)!;
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSfx('audio/sfx/button_click.wav');

    try {
      // Créer le message de partage
      final shareMessage = l10n.shareScoreMessage(
        widget.score,
        widget.currentLevel.id,
      );

      // Copier le message dans le presse-papier
      await Clipboard.setData(ClipboardData(text: shareMessage));

      // Afficher un message de succès
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.shareScoreSuccess),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // En cas d'erreur, afficher un message d'erreur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.shareScoreError),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showGameCompletionDialog() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    audioProvider.playSfx('audio/sfx/level_complete.wav');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Container(
            constraints: const BoxConstraints(
              maxHeight: 600,
              maxWidth: 400,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icône de célébration finale
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber, Colors.orange, Colors.red],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Titre principal
                  Text(
                    '🏆 HALL OF FAME 🏆',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Nom du joueur
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.purple, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      userProvider.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Sous-titre
                  Text(
                    'Master of Mind Bloom',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Message de félicitations
                  Text(
                    'Congratulations! You have successfully completed all 100 levels of Mind Bloom and mastered every challenge with excellence!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.8),
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Final rewards
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Final Rewards',
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildRewardIcon(
                                Icons.diamond, Colors.blue, '+50 Gems'),
                            _buildRewardIcon(Icons.monetization_on,
                                Colors.green, '+1000 Coins'),
                            _buildRewardIcon(
                                Icons.star_outline, Colors.purple, '+500 XP'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Message final
                  Text(
                    'Thank you for playing Mind Bloom! You are a true puzzle master!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.8),
                          fontStyle: FontStyle.italic,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _goToHome();
              },
              child: Text(
                'Back to Menu',
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();

                // Ajouter les récompenses finales
                await userProvider.addGems(50);
                await userProvider.addCoins(1000);
                await userProvider.addExperience(500);

                // Partager l'accomplissement
                _shareGameCompletion();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.share, size: 20),
              label: const Text('Share & Continue'),
            ),
          ],
        );
      },
    );
  }

  // Partager l'accomplissement du jeu
  void _shareGameCompletion() async {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    audioProvider.playSfx('audio/sfx/button_click.wav');

    try {
      // Créer le message de partage
      final shareMessage = '''🏆 MIND BLOOM HALL OF FAME 🏆

${userProvider.username}
Master of Mind Bloom

I have completed all 100 levels of Mind Bloom! 🌟

Come and take up the challenge and discover this amazing puzzle game! 

#MindBloom #PuzzleGame #Achievement #Gaming''';

      // Copier le message dans le presse-papier
      await Clipboard.setData(ClipboardData(text: shareMessage));

      // Afficher un message de succès
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('🎉 Achievement copied! Share your success!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Share',
              textColor: Colors.white,
              onPressed: () {
                // Ici vous pourriez ajouter la logique pour ouvrir les réseaux sociaux
                // ou utiliser le package share_plus pour un partage natif
              },
            ),
          ),
        );
      }
    } catch (e) {
      // En cas d'erreur, afficher un message d'erreur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error during sharing'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // 🌟 MÉTHODE: Obtenir la couleur de rareté pour les objets rares
  Color _getRarityColor(int rarity) {
    switch (rarity) {
      case 1:
        return Colors.grey;
      case 2:
        return Colors.green;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.orange;
      case 6: // Rareté spéciale pour le monde final
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
