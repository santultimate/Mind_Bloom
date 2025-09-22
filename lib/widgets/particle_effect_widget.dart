import 'dart:math';
import 'package:flutter/material.dart';

class ParticleEffectWidget extends StatefulWidget {
  final Offset position;
  final Color color;
  final VoidCallback? onComplete;
  final int comboSize; // Taille du combo pour adapter l'effet
  final String effectType; // Type d'effet : 'normal', 'big', 'mega', 'ultra'

  const ParticleEffectWidget({
    Key? key,
    required this.position,
    required this.color,
    this.onComplete,
    this.comboSize = 3,
    this.effectType = 'normal',
  }) : super(key: key);

  @override
  State<ParticleEffectWidget> createState() => _ParticleEffectWidgetState();
}

class _ParticleEffectWidgetState extends State<ParticleEffectWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _particlePositions;
  late List<Animation<double>> _particleScales;
  late List<Animation<double>> _particleOpacities;

  late int _particleCount;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _calculateParticleCount();
    _initializeAnimations();
  }

  void _calculateParticleCount() {
    switch (widget.effectType) {
      case 'normal':
        _particleCount = 8;
        break;
      case 'big':
        _particleCount = 16;
        break;
      case 'mega':
        _particleCount = 24;
        break;
      case 'ultra':
        _particleCount = 32;
        break;
      default:
        _particleCount = 8 + (widget.comboSize * 2);
    }
  }

  void _initializeAnimations() {
    // Durée adaptée au type d'effet
    Duration duration;
    switch (widget.effectType) {
      case 'normal':
        duration = const Duration(milliseconds: 800);
        break;
      case 'big':
        duration = const Duration(milliseconds: 1200);
        break;
      case 'mega':
        duration = const Duration(milliseconds: 1600);
        break;
      case 'ultra':
        duration = const Duration(milliseconds: 2000);
        break;
      default:
        duration = const Duration(milliseconds: 800);
    }

    _controller = AnimationController(
      duration: duration,
      vsync: this,
    );

    _particlePositions = List.generate(_particleCount, (index) {
      final angle = (index / _particleCount) * 2 * pi;

      // Distance adaptée au type d'effet
      double baseDistance;
      switch (widget.effectType) {
        case 'normal':
          baseDistance = 50.0;
          break;
        case 'big':
          baseDistance = 80.0;
          break;
        case 'mega':
          baseDistance = 120.0;
          break;
        case 'ultra':
          baseDistance = 160.0;
          break;
        default:
          baseDistance = 50.0;
      }

      final distance =
          baseDistance + _random.nextDouble() * (baseDistance * 0.6);
      final endOffset = Offset(
        cos(angle) * distance,
        sin(angle) * distance,
      );

      return Tween<Offset>(
        begin: Offset.zero,
        end: endOffset,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
    });

    _particleScales = List.generate(_particleCount, (index) {
      return Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ));
    });

    _particleOpacities = List.generate(_particleCount, (index) {
      return Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ));
    });

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
        return Stack(
          children: List.generate(_particleCount, (index) {
            return Positioned(
              left: widget.position.dx + _particlePositions[index].value.dx,
              top: widget.position.dy + _particlePositions[index].value.dy,
              child: Transform.scale(
                scale: _particleScales[index].value,
                child: Opacity(
                  opacity: _particleOpacities[index].value,
                  child: Container(
                    width: _getParticleSize(),
                    height: _getParticleSize(),
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.6),
                          blurRadius: _getParticleSize() * 0.5,
                          spreadRadius: _getParticleSize() * 0.125,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  double _getParticleSize() {
    switch (widget.effectType) {
      case 'normal':
        return 8.0;
      case 'big':
        return 12.0;
      case 'mega':
        return 16.0;
      case 'ultra':
        return 20.0;
      default:
        return 8.0;
    }
  }
}

class SparkleEffectWidget extends StatefulWidget {
  final Offset position;
  final Color color;
  final VoidCallback? onComplete;

  const SparkleEffectWidget({
    Key? key,
    required this.position,
    required this.color,
    this.onComplete,
  }) : super(key: key);

  @override
  State<SparkleEffectWidget> createState() => _SparkleEffectWidgetState();
}

class _SparkleEffectWidgetState extends State<SparkleEffectWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
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
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.position.dx - 20,
          top: widget.position.dy - 20,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value * 2 * pi,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.6),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
