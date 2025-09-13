import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mind_bloom/models/tile.dart';

class GameAnimations {
  // Durées des animations
  static const Duration tileSwapDuration = Duration(milliseconds: 300);
  static const Duration tileEliminationDuration = Duration(milliseconds: 500);
  static const Duration tileFallDuration = Duration(milliseconds: 400);
  static const Duration tileSpawnDuration = Duration(milliseconds: 300);
  static const Duration matchHighlightDuration = Duration(milliseconds: 200);
  static const Duration scorePopupDuration = Duration(milliseconds: 800);
  static const Duration comboDelay = Duration(milliseconds: 150);

  // Animation controllers
  static Map<int, AnimationController> tileControllers = {};
  static Map<int, Animation<double>> tileAnimations = {};
  static Map<int, Animation<Offset>> tileFallAnimations = {};
  static Map<int, Animation<double>> tileScaleAnimations = {};

  // États d'animation des tuiles
  static Map<int, TileAnimationState> tileStates = {};

  // Callbacks pour les animations
  static Function()? onAnimationComplete;
  static Function(List<Tile>)? onMatchEliminated;
  static Function(int)? onScorePopup;

  // Initialiser les animations pour une tuile
  static void initializeTileAnimations(TickerProvider vsync, Tile tile) {
    final controller = AnimationController(
      duration: tileSwapDuration,
      vsync: vsync,
    );

    tileControllers[tile.id] = controller;
    tileAnimations[tile.id] = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    tileStates[tile.id] = TileAnimationState.idle;
  }

  // Animation d'échange de tuiles
  static Future<void> animateTileSwap(Tile tile1, Tile tile2) async {
    final controller1 = tileControllers[tile1.id];
    final controller2 = tileControllers[tile2.id];

    if (controller1 == null || controller2 == null) return;

    tileStates[tile1.id] = TileAnimationState.swapping;
    tileStates[tile2.id] = TileAnimationState.swapping;

    // Animation de scale pour l'effet de "pop"
    final scaleAnimation1 = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: controller1,
      curve: Curves.elasticOut,
    ));

    final scaleAnimation2 = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: controller2,
      curve: Curves.elasticOut,
    ));

    tileScaleAnimations[tile1.id] = scaleAnimation1;
    tileScaleAnimations[tile2.id] = scaleAnimation2;

    // Lancer les animations
    await Future.wait([
      controller1.forward().then((_) => controller1.reverse()),
      controller2.forward().then((_) => controller2.reverse()),
    ]);

    tileStates[tile1.id] = TileAnimationState.idle;
    tileStates[tile2.id] = TileAnimationState.idle;
  }

  // Animation d'élimination des matches
  static Future<void> animateMatchElimination(List<List<Tile>> matches) async {
    final allTiles = matches.expand((match) => match).toList();

    // Animation de highlight avant élimination
    await _animateMatchHighlight(allTiles);

    // Animation d'élimination avec effet de particules
    await _animateElimination(allTiles);

    // Callback pour l'élimination
    onMatchEliminated?.call(allTiles);
  }

  // Animation de highlight des matches
  static Future<void> _animateMatchHighlight(List<Tile> tiles) async {
    final controllers = tiles
        .map((tile) => tileControllers[tile.id])
        .whereType<AnimationController>()
        .toList();

    for (final controller in controllers) {
      tileStates[tiles.first.id] = TileAnimationState.highlighting;

      // Animation de pulsation
      final pulseAnimation = Tween<double>(
        begin: 1.0,
        end: 1.3,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));

      tileScaleAnimations[tiles.first.id] = pulseAnimation;
    }

    // Lancer l'animation de highlight
    await Future.wait(controllers.map((c) => c.forward()));

    // Retour à la taille normale
    await Future.wait(controllers.map((c) => c.reverse()));
  }

  // Animation d'élimination avec effets visuels
  static Future<void> _animateElimination(List<Tile> tiles) async {
    final controllers = tiles
        .map((tile) => tileControllers[tile.id])
        .whereType<AnimationController>()
        .toList();

    for (final tile in tiles) {
      tileStates[tile.id] = TileAnimationState.eliminating;

      final controller = tileControllers[tile.id];
      if (controller == null) continue;

      // Animation de rotation et fade out
      final eliminationAnimation = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInBack,
      ));

      tileAnimations[tile.id] = eliminationAnimation;
    }

    // Lancer l'animation d'élimination
    await Future.wait(controllers.map((c) => c.forward()));
  }

  // Animation de chute des tuiles
  static Future<void> animateTileFall(Map<int, int> fallDistances) async {
    final futures = <Future<void>>[];

    for (final entry in fallDistances.entries) {
      final tileId = entry.key;
      final distance = entry.value;
      final controller = tileControllers[tileId];

      if (controller == null || distance <= 0) continue;

      tileStates[tileId] = TileAnimationState.falling;

      // Animation de chute avec effet de gravité
      final fallAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(0, distance.toDouble()),
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ));

      tileFallAnimations[tileId] = fallAnimation;

      futures.add(controller.forward().then((_) {
        tileStates[tileId] = TileAnimationState.idle;
      }));
    }

    await Future.wait(futures);
  }

  // Animation d'apparition des nouvelles tuiles
  static Future<void> animateTileSpawn(List<Tile> newTiles) async {
    final futures = <Future<void>>[];

    for (final tile in newTiles) {
      final controller = tileControllers[tile.id];
      if (controller == null) continue;

      tileStates[tile.id] = TileAnimationState.spawning;

      // Animation d'apparition avec effet de bounce
      final spawnAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));

      tileScaleAnimations[tile.id] = spawnAnimation;

      futures.add(controller.forward().then((_) {
        tileStates[tile.id] = TileAnimationState.idle;
      }));
    }

    await Future.wait(futures);
  }

  // Animation de popup de score
  static Future<void> animateScorePopup(int score, Offset position) async {
    onScorePopup?.call(score);
    await Future.delayed(scorePopupDuration);
  }

  // Animation de combo
  static Future<void> animateCombo(int comboCount) async {
    // Animation spéciale pour les combos
    await Future.delayed(comboDelay * comboCount);
  }

  // Animation de victoire
  static Future<void> animateVictory() async {
    // Animation de célébration
    await Future.delayed(const Duration(seconds: 2));
  }

  // Animation de défaite
  static Future<void> animateDefeat() async {
    // Animation de défaite
    await Future.delayed(const Duration(seconds: 1));
  }

  // Nettoyer les animations
  static void dispose() {
    for (final controller in tileControllers.values) {
      controller.dispose();
    }
    tileControllers.clear();
    tileAnimations.clear();
    tileFallAnimations.clear();
    tileScaleAnimations.clear();
    tileStates.clear();
  }

  // Obtenir l'état d'animation d'une tuile
  static TileAnimationState getTileState(int tileId) {
    return tileStates[tileId] ?? TileAnimationState.idle;
  }

  // Obtenir l'animation d'une tuile
  static Animation<double>? getTileAnimation(int tileId) {
    return tileAnimations[tileId];
  }

  // Obtenir l'animation de chute d'une tuile
  static Animation<Offset>? getTileFallAnimation(int tileId) {
    return tileFallAnimations[tileId];
  }

  // Obtenir l'animation de scale d'une tuile
  static Animation<double>? getTileScaleAnimation(int tileId) {
    return tileScaleAnimations[tileId];
  }
}

// États d'animation des tuiles
enum TileAnimationState {
  idle,
  swapping,
  highlighting,
  eliminating,
  falling,
  spawning,
}
