import 'package:flutter/material.dart';
import 'package:mind_bloom/models/tile.dart';

class EliminationAnimationWidget extends StatefulWidget {
  final Tile tile;
  final Duration duration;
  final VoidCallback? onComplete;

  const EliminationAnimationWidget({
    super.key,
    required this.tile,
    this.duration = const Duration(milliseconds: 500),
    this.onComplete,
  });

  @override
  State<EliminationAnimationWidget> createState() =>
      _EliminationAnimationWidgetState();
}

class _EliminationAnimationWidgetState extends State<EliminationAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInBack,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 3.14159,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(widget.tile.color),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(widget.tile.color).withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _getTileSymbol(widget.tile.type),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getTileSymbol(TileType type) {
    switch (type) {
      case TileType.flower:
        return '🌸';
      case TileType.leaf:
        return '🍃';
      case TileType.crystal:
        return '💎';
      case TileType.seed:
        return '🌱';
      case TileType.dew:
        return '💧';
      case TileType.sun:
        return '☀️';
      case TileType.moon:
        return '🌙';
      case TileType.gem:
        return '💠';
    }
  }
}
