import 'dart:async';
import 'package:flutter/foundation.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.8),
                Colors.black.withValues(alpha: 0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
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
                    size: 20,
                  ),
                  const SizedBox(width: 6),

                  // Nombre de vies
                  Text(
                    '${userProvider.lives}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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
                        color: Colors.red.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.timer,
                            color: Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTime(userProvider.timeUntilNextLife),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // 🚀 BOUTON DE VIE GRATUITE VIA PUB - REVENUS MAXIMAUX
                  if (userProvider.lives == 0) ...[
                    const SizedBox(width: 2),
                    Container(
                      constraints: const BoxConstraints(
                        minWidth: 60,
                        maxWidth: 100,
                        minHeight: 25,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withValues(alpha: 0.8),
                            Colors.green.withValues(alpha: 0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.3),
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          // TODO: Implémenter la logique de publicité récompensée
                          // Commenté pour la version de production
                          // if (kDebugMode) {
                          //   print('Bouton de vie gratuite tapé');
                          // }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              AppLocalizations.of(context)!.freeLife,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
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
}
