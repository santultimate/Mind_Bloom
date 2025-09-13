import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mind_bloom/models/tile.dart';
import 'package:mind_bloom/constants/app_colors.dart';

class TileWidget extends StatelessWidget {
  final Tile tile;
  final VoidCallback onTap;

  const TileWidget({
    super.key,
    required this.tile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: _getTileColor(),
          borderRadius: BorderRadius.circular(8),
          border: _getBorder(),
          boxShadow: _getShadow(),
        ),
        child: Center(
          child: _buildTileContent(),
        ),
      ).animate().scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
            duration: const Duration(milliseconds: 300),
            curve: Curves.elasticOut,
          ),
    );
  }

  Color _getTileColor() {
    switch (tile.state) {
      case TileState.normal:
        return Color(tile.color);
      case TileState.selected:
        return Color(tile.color).withValues(alpha: 0.8);
      case TileState.matched:
        return AppColors.gold;
      case TileState.special:
        return AppColors.accent;
      case TileState.blocked:
        return AppColors.textLight;
      case TileState.swapping:
        return Color(tile.color).withValues(alpha: 0.6);
    }
  }

  Border? _getBorder() {
    switch (tile.state) {
      case TileState.selected:
        return Border.all(
          color: Colors.white,
          width: 3,
        );
      case TileState.special:
        return Border.all(
          color: AppColors.gold,
          width: 2,
        );
      default:
        return null;
    }
  }

  List<BoxShadow>? _getShadow() {
    switch (tile.state) {
      case TileState.selected:
        return [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ];
      case TileState.special:
        return [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.5),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ];
      default:
        return null;
    }
  }

  Widget _buildTileContent() {
    if (tile.isBlocked) {
      return const Icon(
        Icons.block,
        color: Colors.white,
        size: 20,
      );
    }

    if (tile.isSpecial) {
      return _buildSpecialTile();
    }

    return _buildNormalTile();
  }

  Widget _buildNormalTile() {
    IconData icon;
    Color iconColor = Colors.white;

    switch (tile.type) {
      case TileType.flower:
        icon = Icons.local_florist;
        break;
      case TileType.leaf:
        icon = Icons.eco;
        break;
      case TileType.crystal:
        icon = Icons.diamond;
        break;
      case TileType.seed:
        icon = Icons.grain;
        break;
      case TileType.dew:
        icon = Icons.water_drop;
        break;
      case TileType.sun:
        icon = Icons.wb_sunny;
        break;
      case TileType.moon:
        icon = Icons.nightlight_round;
        break;
      case TileType.gem:
        icon = Icons.star;
        break;
    }

    return Icon(
      icon,
      color: iconColor,
      size: 24,
    );
  }

  Widget _buildSpecialTile() {
    // Pour les tuiles spéciales, on peut ajouter des effets visuels
    return Stack(
      children: [
        _buildNormalTile(),
        if (tile.isSpecial)
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.gold,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
