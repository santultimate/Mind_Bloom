import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mind_bloom/models/tile.dart';
import 'package:mind_bloom/utils/app_colors.dart';

class TileSwapAnimation extends StatefulWidget {
  final Tile tile1;
  final Tile tile2;
  final Widget child1;
  final Widget child2;
  final VoidCallback onComplete;
  final bool isVisible;
  final double tileSize;
  final double spacing;

  const TileSwapAnimation({
    Key? key,
    required this.tile1,
    required this.tile2,
    required this.child1,
    required this.child2,
    required this.onComplete,
    required this.tileSize,
    this.spacing = 3.0,
    this.isVisible = false,
  }) : super(key: key);

  @override
  State<TileSwapAnimation> createState() => _TileSwapAnimationState();
}

class _TileSwapAnimationState extends State<TileSwapAnimation>
    with TickerProviderStateMixin {
  late AnimationController _swapController;
  late AnimationController _glowController;
  late Animation<Offset> _tile1Animation;
  late Animation<Offset> _tile2Animation;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    if (widget.isVisible) {
      _startSwapAnimation();
    }
  }

  void _initializeAnimations() {
    // Animation principale de permutation - plus lente pour être plus visible
    _swapController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Animation de brillance - plus longue pour être plus visible
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Calculer la taille réelle des tuiles avec espacement
    final tileSizeWithSpacing = widget.tileSize + widget.spacing;

    // Animation de déplacement des tuiles - utiliser la taille réelle
    _tile1Animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(
        (widget.tile2.col - widget.tile1.col).toDouble() * tileSizeWithSpacing,
        (widget.tile2.row - widget.tile1.row).toDouble() * tileSizeWithSpacing,
      ),
    ).animate(CurvedAnimation(
      parent: _swapController,
      curve: Curves.easeInOutCubic,
    ));

    _tile2Animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(
        (widget.tile1.col - widget.tile2.col).toDouble() * tileSizeWithSpacing,
        (widget.tile1.row - widget.tile2.row).toDouble() * tileSizeWithSpacing,
      ),
    ).animate(CurvedAnimation(
      parent: _swapController,
      curve: Curves.easeInOutCubic,
    ));

    // Animation de brillance - plus intense
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Animation d'échelle - plus prononcée
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _swapController,
      curve: Curves.elasticOut,
    ));

    _swapController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
  }

  void _startSwapAnimation() {
    // Effet haptique plus fort
    HapticFeedback.heavyImpact();

    // Démarrer les animations avec séquence
    _glowController.forward().then((_) {
      _glowController.reverse();
    });

    // Délai avant de commencer l'animation principale pour la rendre plus visible
    Future.delayed(const Duration(milliseconds: 100), () {
      _swapController.forward();
    });
  }

  @override
  void didUpdateWidget(TileSwapAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _startSwapAnimation();
    }
  }

  @override
  void dispose() {
    _swapController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    // Calculer les positions absolues des tuiles dans la grille
    final tileSizeWithSpacing = widget.tileSize + widget.spacing;
    final tile1X = widget.tile1.col * tileSizeWithSpacing;
    final tile1Y = widget.tile1.row * tileSizeWithSpacing;
    final tile2X = widget.tile2.col * tileSizeWithSpacing;
    final tile2Y = widget.tile2.row * tileSizeWithSpacing;

    return Stack(
      children: [
        // Tuile 1 avec animation - positionnée absolument
        Positioned(
          left: tile1X,
          top: tile1Y,
          child: SizedBox(
            width: widget.tileSize,
            height: widget.tileSize,
            child: AnimatedBuilder(
              animation: Listenable.merge([_swapController, _glowController]),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    _tile1Animation.value.dx,
                    _tile1Animation.value.dy,
                  ),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          // Ombre principale plus intense
                          BoxShadow(
                            color: AppColors.primary
                                .withValues(alpha: _glowAnimation.value * 0.8),
                            blurRadius: 15 + _glowAnimation.value * 15,
                            spreadRadius: 3 + _glowAnimation.value * 3,
                          ),
                          // Ombre blanche pour effet de brillance
                          BoxShadow(
                            color: Colors.white
                                .withValues(alpha: _glowAnimation.value * 0.6),
                            blurRadius: 20 + _glowAnimation.value * 20,
                            spreadRadius: 2 + _glowAnimation.value * 2,
                          ),
                          // Ombre colorée selon le type de tuile
                          BoxShadow(
                            color: _getTileColor(widget.tile1.type)
                                .withValues(alpha: _glowAnimation.value * 0.4),
                            blurRadius: 25 + _glowAnimation.value * 25,
                            spreadRadius: 1 + _glowAnimation.value * 1,
                          ),
                        ],
                      ),
                      child: widget.child1,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Tuile 2 avec animation - positionnée absolument
        Positioned(
          left: tile2X,
          top: tile2Y,
          child: SizedBox(
            width: widget.tileSize,
            height: widget.tileSize,
            child: AnimatedBuilder(
              animation: Listenable.merge([_swapController, _glowController]),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    _tile2Animation.value.dx,
                    _tile2Animation.value.dy,
                  ),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          // Ombre principale plus intense
                          BoxShadow(
                            color: AppColors.primary
                                .withValues(alpha: _glowAnimation.value * 0.8),
                            blurRadius: 15 + _glowAnimation.value * 15,
                            spreadRadius: 3 + _glowAnimation.value * 3,
                          ),
                          // Ombre blanche pour effet de brillance
                          BoxShadow(
                            color: Colors.white
                                .withValues(alpha: _glowAnimation.value * 0.6),
                            blurRadius: 20 + _glowAnimation.value * 20,
                            spreadRadius: 2 + _glowAnimation.value * 2,
                          ),
                          // Ombre colorée selon le type de tuile
                          BoxShadow(
                            color: _getTileColor(widget.tile2.type)
                                .withValues(alpha: _glowAnimation.value * 0.4),
                            blurRadius: 25 + _glowAnimation.value * 25,
                            spreadRadius: 1 + _glowAnimation.value * 1,
                          ),
                        ],
                      ),
                      child: widget.child2,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Obtient la couleur associée au type de tuile pour l'effet de brillance
  Color _getTileColor(TileType type) {
    switch (type) {
      case TileType.flower:
        return Colors.pink;
      case TileType.leaf:
        return Colors.green;
      case TileType.crystal:
        return Colors.blue;
      case TileType.seed:
        return Colors.brown;
      case TileType.dew:
        return Colors.cyan;
      case TileType.sun:
        return Colors.orange;
      case TileType.moon:
        return Colors.purple;
      case TileType.gem:
        return Colors.teal;
    }
  }
}

/// Widget pour l'effet de sélection des tuiles
class TileSelectionEffect extends StatefulWidget {
  final Widget child;
  final bool isSelected;
  final VoidCallback? onTap;

  const TileSelectionEffect({
    Key? key,
    required this.child,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<TileSelectionEffect> createState() => _TileSelectionEffectState();
}

class _TileSelectionEffectState extends State<TileSelectionEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _selectionController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _selectionController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _selectionController,
      curve: Curves.easeInOut,
    ));

    if (widget.isSelected) {
      _selectionController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(TileSelectionEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _selectionController.repeat(reverse: true);
      HapticFeedback.selectionClick();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _selectionController.stop();
      _selectionController.reset();
    }
  }

  @override
  void dispose() {
    _selectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _selectionController,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isSelected ? _pulseAnimation.value : 1.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: widget.isSelected
                    ? [
                        // Ombre principale plus intense
                        BoxShadow(
                          color: AppColors.primary
                              .withValues(alpha: _glowAnimation.value * 0.9),
                          blurRadius: 20 + _glowAnimation.value * 20,
                          spreadRadius: 4 + _glowAnimation.value * 4,
                        ),
                        // Ombre blanche pour effet de brillance
                        BoxShadow(
                          color: Colors.white
                              .withValues(alpha: _glowAnimation.value * 0.6),
                          blurRadius: 25 + _glowAnimation.value * 25,
                          spreadRadius: 3 + _glowAnimation.value * 3,
                        ),
                        // Ombre colorée pour effet arc-en-ciel
                        BoxShadow(
                          color: Colors.cyan
                              .withValues(alpha: _glowAnimation.value * 0.4),
                          blurRadius: 30 + _glowAnimation.value * 30,
                          spreadRadius: 2 + _glowAnimation.value * 2,
                        ),
                      ]
                    : null,
                border: widget.isSelected
                    ? Border.all(
                        color: AppColors.primary.withValues(
                            alpha: 0.8 + _glowAnimation.value * 0.2),
                        width: 3 + _glowAnimation.value * 2,
                      )
                    : null,
              ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

/// Widget pour l'effet de prévisualisation des permutations
class SwapPreviewEffect extends StatefulWidget {
  final Widget child;
  final bool showPreview;
  final bool isValidMove;

  const SwapPreviewEffect({
    Key? key,
    required this.child,
    this.showPreview = false,
    this.isValidMove = false,
  }) : super(key: key);

  @override
  State<SwapPreviewEffect> createState() => _SwapPreviewEffectState();
}

class _SwapPreviewEffectState extends State<SwapPreviewEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _previewController;
  late Animation<double> _previewAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _previewController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _previewAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _previewController,
      curve: Curves.easeInOut,
    ));

    if (widget.showPreview) {
      _previewController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(SwapPreviewEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showPreview && !oldWidget.showPreview) {
      _previewController.repeat(reverse: true);
    } else if (!widget.showPreview && oldWidget.showPreview) {
      _previewController.stop();
      _previewController.reset();
    }
  }

  @override
  void dispose() {
    _previewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _previewController,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.showPreview ? _previewAnimation.value : 1.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: widget.showPreview
                  ? [
                      BoxShadow(
                        color: widget.isValidMove
                            ? Colors.green.withValues(alpha: 0.6)
                            : Colors.red.withValues(alpha: 0.6),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
              border: widget.showPreview
                  ? Border.all(
                      color: widget.isValidMove ? Colors.green : Colors.red,
                      width: 2,
                    )
                  : null,
            ),
            child: Opacity(
              opacity: widget.showPreview ? 0.7 : 1.0,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
