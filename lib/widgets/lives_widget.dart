import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/providers/game_provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

class LivesWidget extends StatefulWidget {
  final VoidCallback? onShuffle;
  final VoidCallback? onHint;

  const LivesWidget({
    super.key,
    this.onShuffle,
    this.onHint,
  });

  @override
  State<LivesWidget> createState() => _LivesWidgetState();
}

class _LivesWidgetState extends State<LivesWidget>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _blinkAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    ));

    // Mettre à jour l'interface toutes les secondes pour le timer
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GameProvider, UserProvider>(
      builder: (context, gameProvider, userProvider, child) {
        // Démarrer l'animation de clignotement si pas de mouvements possibles
        bool hasValidMoves = false;
        try {
          hasValidMoves = gameProvider.hasValidMoves();
        } catch (e) {
          hasValidMoves = false;
        }

        if (!hasValidMoves && gameProvider.canPlay) {
          _blinkController.repeat(reverse: true);
        } else {
          _blinkController.stop();
          _blinkController.reset();
        }
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Section des vies
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icône de cœur
                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 24,
                  ),
                  const SizedBox(width: 8),

                  // Nombre de vies
                  Text(
                    '${userProvider.lives}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Timer si pas de vies
                  if (userProvider.lives < userProvider.maxLives) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.timer,
                            color: Colors.blue,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTime(userProvider.timeUntilNextLife),
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Bouton pour regarder une pub et obtenir une vie
                  if (userProvider.lives == 0) ...[
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _showWatchAdDialog(context, userProvider),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.play_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Vie gratuite',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              // Section des boutons d'action
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Bouton Mélanger
                  if (widget.onShuffle != null)
                    _buildActionButton(
                      icon: Icons.refresh,
                      onTap: widget.onShuffle!,
                      shouldBlink: !hasValidMoves && gameProvider.canPlay,
                    ),

                  if (widget.onShuffle != null && widget.onHint != null)
                    const SizedBox(width: 8),

                  // Bouton Indice
                  if (widget.onHint != null)
                    _buildActionButton(
                      icon: Icons.lightbulb,
                      onTap: widget.onHint!,
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    bool shouldBlink = false,
  }) {
    Widget button = GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 18,
        ),
      ),
    );

    // Appliquer l'animation de clignotement si nécessaire
    if (shouldBlink) {
      return AnimatedBuilder(
        animation: _blinkAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _blinkAnimation.value,
            child: button,
          );
        },
      );
    }

    return button;
  }

  // Formater le temps restant
  String _formatTime(int seconds) {
    if (seconds <= 0) return '00:00';

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Afficher le dialogue pour regarder une publicité
  void _showWatchAdDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Vie Gratuite',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Regardez une publicité pour obtenir une vie gratuite !',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _watchAdForLife(userProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Regarder la Pub'),
            ),
          ],
        );
      },
    );
  }

  // Simuler le visionnage d'une publicité et donner une vie
  void _watchAdForLife(UserProvider userProvider) {
    // Simuler le visionnage d'une publicité
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Colors.green),
              const SizedBox(height: 16),
              const Text(
                'Publicité en cours...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );

    // Simuler la durée de la publicité (3 secondes)
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Fermer le dialogue de chargement

      // Donner une vie
      userProvider.addLives(1);

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vie obtenue ! Vous pouvez continuer à jouer.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }
}
