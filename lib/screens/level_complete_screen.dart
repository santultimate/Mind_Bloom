import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/providers/ad_provider.dart';
import 'package:mind_bloom/providers/collection_provider.dart';
import 'package:mind_bloom/widgets/banner_ad_widget.dart';
import 'package:mind_bloom/screens/home_screen.dart';
import 'package:mind_bloom/screens/game_screen.dart';
import 'package:mind_bloom/models/level.dart';

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
      margin: const EdgeInsets.all(32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
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
            'Niveau ${widget.currentLevel.id} Terminé !',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Étoiles
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Icon(
                index < widget.stars ? Icons.star : Icons.star_border,
                color: index < widget.stars
                    ? AppColors.gold
                    : AppColors.textSecondary,
                size: 32,
              );
            }),
          ),

          const SizedBox(height: 20),

          // Statistiques
          _buildStatistic('Score', widget.score.toString()),
          _buildStatistic('Coups utilisés',
              '${widget.movesUsed}/${widget.currentLevel.maxMoves}'),

          const SizedBox(height: 24),

          // Récompenses
          if (widget.stars > 0) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: AppColors.coins,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+${widget.stars * 10} pièces',
                    style: TextStyle(
                      color: AppColors.coins,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
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
                  child: const Text('Recommencer'),
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
                  child: const Text('Niveau suivant'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          TextButton(
            onPressed: _goToHome,
            child: Text(
              'Retour au menu',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),

          const SizedBox(height: 16),

          // Bannière publicitaire
          const LevelCompleteBannerAd(),
        ],
      ),
    );
  }

  Widget _buildDefeatContent() {
    return Container(
      margin: const EdgeInsets.all(32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
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
            'Niveau ${widget.currentLevel.id} Échoué',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Text(
            'Vous avez utilisé tous vos coups !',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Statistiques
          _buildStatistic('Score', widget.score.toString()),
          _buildStatistic('Coups utilisés',
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
                  child: const Text('Recommencer'),
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
                  child: const Text('Menu'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _retryLevel() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSfx('audio/sfx/button_click.wav');

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const GameScreen(),
      ),
    );
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
    final collectionProvider =
        Provider.of<CollectionProvider>(context, listen: false);
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
    // Attendre 3 secondes après la fin du niveau pour laisser le temps à l'utilisateur de voir le résultat
    await Future.delayed(const Duration(seconds: 3));

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
}
