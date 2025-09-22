import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/providers/ad_provider.dart';
import 'package:mind_bloom/providers/game_provider.dart';
import 'package:mind_bloom/constants/admob_config.dart';
import 'package:mind_bloom/widgets/banner_ad_widget.dart';
import 'package:mind_bloom/widgets/rewarded_ad_button.dart';
import 'package:mind_bloom/screens/home_screen.dart';
import 'package:mind_bloom/screens/game_screen.dart';
import 'package:mind_bloom/models/level.dart';
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

            // Récompenses améliorées
            if (widget.stars > 0) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.1),
                      AppColors.primary.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Récompenses obtenues',
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
                          color: AppColors.gold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '🌟 Performance Parfaite! Bonus x2',
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
                          color: Colors.purple.withValues(alpha: 0.2),
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
        return 'Excellent ! Performance parfaite';
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
      'text': '+$totalCoins Pièces',
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
        'text': '+$gems Gemmes',
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

    audioProvider.playSfx('audio/sfx/button_click.wav');

    // Vérifier si le joueur a des vies
    if (userProvider.lives > 0) {
      // Le joueur a des vies, rejouer (vie déjà utilisée au début)
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

    // Aller au niveau suivant ou au menu
    // final nextLevelId = widget.currentLevel.id + 1;

    // Pour l'instant, retourner au menu principal
    // TODO: Implémenter la navigation vers le niveau suivant
    if (mounted) {
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

      // Afficher une publicité interstitielle si les conditions sont remplies
      if (adProvider
          .shouldShowInterstitialAdOnLevelComplete(widget.currentLevel.id)) {
        await adProvider.showInterstitialAd();
      }
    }
  }

  void _goToHome() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSfx('audio/sfx/button_click.wav');

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
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
}
