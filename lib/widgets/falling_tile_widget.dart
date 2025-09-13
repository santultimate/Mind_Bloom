import 'package:flutter/material.dart';
import 'package:mind_bloom/models/tile.dart';

class FallingTileWidget extends StatefulWidget {
  final Tile tile;
  final double fromY;
  final double toY;
  final Duration duration;
  final VoidCallback? onComplete;

  const FallingTileWidget({
    super.key,
    required this.tile,
    required this.fromY,
    required this.toY,
    this.duration = const Duration(milliseconds: 300),
    this.onComplete,
  });

  @override
  State<FallingTileWidget> createState() => _FallingTileWidgetState();
}

class _FallingTileWidgetState extends State<FallingTileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: widget.fromY,
      end: widget.toY,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
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
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: widget.tile.col * 50.0, // Ajuster selon la taille des tuiles
          top: _animation.value,
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
