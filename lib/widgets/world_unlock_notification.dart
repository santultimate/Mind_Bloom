import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/models/world.dart';
import 'package:mind_bloom/providers/user_provider.dart';

/// Widget pour afficher une notification de déverrouillage de monde
class WorldUnlockNotification extends StatefulWidget {
  final World world;
  final VoidCallback onDismiss;

  const WorldUnlockNotification({
    super.key,
    required this.world,
    required this.onDismiss,
  });

  @override
  State<WorldUnlockNotification> createState() =>
      _WorldUnlockNotificationState();
}

class _WorldUnlockNotificationState extends State<WorldUnlockNotification>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();

    // Auto-dismiss après 4 secondes
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  void _navigateToNewWorld() {
    // Changer le monde sélectionné vers le nouveau monde déverrouillé
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setSelectedWorld(widget.world.id);

    // Naviguer vers l'écran d'accueil pour afficher le nouveau monde
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildNotification(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotification() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.world.colors.map((color) {
            return Color(int.parse('FF$color', radix: 16));
          }).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
          // Icône du monde
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.public,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(height: 16),

          // Titre
          const Text(
            '🎉 Nouveau Monde Débloqué!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Message d'aide
          const Text(
            'Vous avez complété 100% du monde précédent!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Nom du monde
          Text(
            _getWorldName(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Description
          Text(
            _getWorldDescription(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 16),

          // Boutons d'action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Bouton pour aller au nouveau monde
              GestureDetector(
                onTap: () {
                  _dismiss();
                  // Naviguer vers le nouveau monde déverrouillé
                  _navigateToNewWorld();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Explorer',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Bouton pour continuer
              GestureDetector(
                onTap: _dismiss,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(25),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: const Text(
                    'Plus tard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getWorldName() {
    switch (widget.world.nameKey) {
      case 'world_garden_beginnings':
        return 'Jardin des Débuts';
      case 'world_valley_flowers':
        return 'Vallée des Fleurs';
      case 'world_lunar_forest':
        return 'Forêt Lunaire';
      case 'world_solar_meadow':
        return 'Prairie Solaire';
      case 'world_crystal_caverns':
        return 'Cavernes de Cristal';
      case 'world_mystic_swamps':
        return 'Marécages Mystiques';
      case 'world_burning_lands':
        return 'Terres Brûlantes';
      case 'world_eternal_glacier':
        return 'Glacier Éternel';
      case 'world_lost_rainbow':
        return 'Arc-en-Ciel Perdu';
      case 'world_celestial_garden':
        return 'Jardin Céleste';
      default:
        return 'Monde ${widget.world.id}';
    }
  }

  String _getWorldDescription() {
    switch (widget.world.descriptionKey) {
      case 'world_garden_beginnings_description':
        return 'Commencez votre aventure dans ce jardin magique';
      case 'world_valley_flowers_description':
        return 'Explorez une vallée remplie de fleurs colorées';
      case 'world_lunar_forest_description':
        return 'Découvrez les mystères de la forêt sous la lune';
      case 'world_solar_meadow_description':
        return 'Baignez-vous dans la lumière du soleil';
      case 'world_crystal_caverns_description':
        return 'Plongez dans les profondeurs cristallines';
      case 'world_mystic_swamps_description':
        return 'Naviguez dans les marécages mystérieux';
      case 'world_burning_lands_description':
        return 'Survivez aux terres ardentes';
      case 'world_eternal_glacier_description':
        return 'Bravez le froid éternel du glacier';
      case 'world_lost_rainbow_description':
        return 'Retrouvez les couleurs perdues de l\'arc-en-ciel';
      case 'world_celestial_garden_description':
        return 'Atteignez le jardin céleste ultime';
      default:
        return 'Un nouveau monde vous attend !';
    }
  }
}
