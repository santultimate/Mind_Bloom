import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/models/tile.dart';
import 'package:mind_bloom/utils/game_animations.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/providers/game_provider.dart';

class AnimatedTileWidget extends StatefulWidget {
  final Tile tile;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isMatched;
  final double size;

  const AnimatedTileWidget({
    Key? key,
    required this.tile,
    this.onTap,
    this.isSelected = false,
    this.isMatched = false,
    required this.size,
  }) : super(key: key);

  @override
  State<AnimatedTileWidget> createState() => _AnimatedTileWidgetState();
}

class _AnimatedTileWidgetState extends State<AnimatedTileWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _hintController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _fallAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _hintAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    GameAnimations.initializeTileAnimations(this, widget.tile);
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _hintController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _fallAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _hintAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hintController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(AnimatedTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Mettre à jour les animations basées sur l'état
    _updateAnimations();
  }

  void _updateAnimations() {
    final tileState = GameAnimations.getTileState(widget.tile.id);
    final scaleAnimation = GameAnimations.getTileScaleAnimation(widget.tile.id);
    final fallAnimation = GameAnimations.getTileFallAnimation(widget.tile.id);
    final tileAnimation = GameAnimations.getTileAnimation(widget.tile.id);

    switch (tileState) {
      case TileAnimationState.swapping:
        _animateSwap();
        break;
      case TileAnimationState.highlighting:
        _animateHighlight();
        break;
      case TileAnimationState.eliminating:
        _animateElimination();
        break;
      case TileAnimationState.falling:
        if (fallAnimation != null) {
          _fallAnimation = fallAnimation;
        }
        break;
      case TileAnimationState.spawning:
        _animateSpawn();
        break;
      case TileAnimationState.idle:
        _resetAnimations();
        break;
    }

    if (scaleAnimation != null) {
      _scaleAnimation = scaleAnimation;
    }

    if (tileAnimation != null) {
      _opacityAnimation = tileAnimation;
    }
  }

  void _animateSwap() {
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    _controller.forward().then((_) => _controller.reverse());
  }

  void _animateHighlight() {
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  void _animateElimination() {
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInBack,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInBack,
    ));

    _controller.forward();
  }

  void _animateSpawn() {
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  void _resetAnimations() {
    _controller.stop();
    _controller.reset();
  }

  @override
  void dispose() {
    _controller.dispose();
    _hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final isHintTile =
            gameProvider.currentHint?.contains(widget.tile) ?? false;

        // Démarrer l'animation d'indice si c'est une tuile d'indice
        if (isHintTile && !_hintController.isAnimating) {
          _hintController.repeat(reverse: true);
        } else if (!isHintTile && _hintController.isAnimating) {
          _hintController.stop();
          _hintController.reset();
        }

        return AnimatedBuilder(
          animation: Listenable.merge([_controller, _hintController]),
          builder: (context, child) {
            return Transform.translate(
              offset: _fallAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value * 2 * 3.14159,
                  child: Opacity(
                    opacity: _opacityAnimation.value.clamp(0.0, 1.0),
                    child: GestureDetector(
                      onTap: widget.onTap,
                      child: Container(
                        width: widget.size,
                        height: widget.size,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: _getTileColor(),
                          boxShadow: _getTileShadows(),
                          border: _getTileBorder(),
                        ),
                        child: Stack(
                          children: [
                            // Contenu principal de la tuile
                            Center(
                              child: _buildTileContent(),
                            ),

                            // Effet de glow pour les matches
                            if (widget.isMatched ||
                                GameAnimations.getTileState(widget.tile.id) ==
                                    TileAnimationState.highlighting)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getTileColor().withValues(
                                          alpha: 0.6 * _glowAnimation.value),
                                      blurRadius: 10 * _glowAnimation.value,
                                      spreadRadius: 2 * _glowAnimation.value,
                                    ),
                                  ],
                                ),
                              ),

                            // Effet de sélection
                            if (widget.isSelected)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.white.withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),

                            // Effet d'indice
                            if (isHintTile)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.yellow,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.yellow.withValues(
                                          alpha: 0.8 * _hintAnimation.value),
                                      blurRadius: 12 * _hintAnimation.value,
                                      spreadRadius: 2 * _hintAnimation.value,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.lightbulb,
                                    color: Colors.yellow.withValues(
                                        alpha: _hintAnimation.value),
                                    size: widget.size * 0.3,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTileContent() {
    switch (widget.tile.type) {
      case TileType.flower:
        return Icon(
          Icons.local_florist,
          color: Colors.white,
          size: widget.size * 0.5,
        );
      case TileType.leaf:
        return Icon(
          Icons.eco,
          color: Colors.white,
          size: widget.size * 0.5,
        );
      case TileType.crystal:
        return Icon(
          Icons.diamond,
          color: Colors.white,
          size: widget.size * 0.5,
        );
      case TileType.seed:
        return Icon(
          Icons.grain,
          color: Colors.white,
          size: widget.size * 0.5,
        );
      case TileType.dew:
        return Icon(
          Icons.water_drop,
          color: Colors.white,
          size: widget.size * 0.5,
        );
      case TileType.sun:
        return Icon(
          Icons.wb_sunny,
          color: Colors.white,
          size: widget.size * 0.5,
        );
      case TileType.moon:
        return Icon(
          Icons.nightlight_round,
          color: Colors.white,
          size: widget.size * 0.5,
        );
      case TileType.gem:
        return Icon(
          Icons.workspace_premium,
          color: Colors.white,
          size: widget.size * 0.5,
        );
    }
  }

  Color _getTileColor() {
    switch (widget.tile.type) {
      case TileType.flower:
        return AppColors.tileFlower;
      case TileType.leaf:
        return AppColors.tileLeaf;
      case TileType.crystal:
        return AppColors.tileCrystal;
      case TileType.seed:
        return AppColors.tileSeed;
      case TileType.dew:
        return AppColors.tileDew;
      case TileType.sun:
        return AppColors.tileSun;
      case TileType.moon:
        return AppColors.tileMoon;
      case TileType.gem:
        return AppColors.tileGem;
    }
  }

  List<BoxShadow> _getTileShadows() {
    final baseColor = _getTileColor();
    final tileState = GameAnimations.getTileState(widget.tile.id);

    List<BoxShadow> shadows = [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];

    // Ajouter des effets spéciaux selon l'état
    switch (tileState) {
      case TileAnimationState.highlighting:
        shadows.add(BoxShadow(
          color: baseColor.withValues(alpha: 0.6),
          blurRadius: 8,
          spreadRadius: 2,
        ));
        break;
      case TileAnimationState.eliminating:
        shadows.add(BoxShadow(
          color: baseColor.withValues(alpha: 0.8),
          blurRadius: 12,
          spreadRadius: 4,
        ));
        break;
      default:
        break;
    }

    return shadows;
  }

  Border? _getTileBorder() {
    if (widget.isSelected) {
      return Border.all(
        color: Colors.white,
        width: 2,
      );
    }
    return null;
  }
}
