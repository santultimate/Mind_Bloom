import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/providers/ad_provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';

class RewardedAdButton extends StatefulWidget {
  final String rewardType; // 'lives', 'coins', 'gems', 'booster'
  final int rewardAmount;
  final String title;
  final String description;
  final IconData icon;
  final Color? color;
  final VoidCallback? onRewardEarned;

  const RewardedAdButton({
    super.key,
    required this.rewardType,
    required this.rewardAmount,
    required this.title,
    required this.description,
    required this.icon,
    this.color,
    this.onRewardEarned,
  });

  @override
  State<RewardedAdButton> createState() => _RewardedAdButtonState();
}

class _RewardedAdButtonState extends State<RewardedAdButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AdProvider>(
      builder: (context, adProvider, child) {
        // Si les pubs sont désactivées, ne pas afficher le bouton
        if (!adProvider.adsEnabled) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _showRewardedAd,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(widget.icon),
            label: Text(
              _isLoading ? 'Chargement...' : widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color ?? AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
          ),
        );
      },
    );
  }

  Future<void> _showRewardedAd() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final adProvider = Provider.of<AdProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    try {
      final success = await adProvider.showRewardedAd(
        onReward: () {
          _giveReward(userProvider, audioProvider);
        },
        rewardType: widget.rewardType,
      );

      if (success) {
        // Récompense donnée dans le callback
        if (widget.onRewardEarned != null) {
          widget.onRewardEarned!();
        }
      } else {
        _showErrorDialog('Impossible de charger la publicité');
      }
    } catch (e) {
      _showErrorDialog('Erreur lors de l\'affichage de la publicité');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _giveReward(UserProvider userProvider, AudioProvider audioProvider) {
    switch (widget.rewardType) {
      case 'lives':
        userProvider.addLives(widget.rewardAmount);
        audioProvider.playSfx('audio/sfx/star_earned.wav');
        break;
      case 'coins':
        userProvider.addCoins(widget.rewardAmount);
        audioProvider.playSfx('audio/sfx/coin_collect.wav');
        break;
      case 'gems':
        userProvider.addGems(widget.rewardAmount);
        audioProvider.playSfx('audio/sfx/gem_collect.wav');
        break;
      case 'booster':
        // TODO: Ajouter le booster au stock
        audioProvider.playSfx('audio/sfx/power_up.wav');
        break;
    }

    // Afficher un message de succès
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Récompense obtenue !'),
        content: Text(
            'Vous avez gagné ${widget.rewardAmount} ${_getRewardName()} !'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _getRewardName() {
    switch (widget.rewardType) {
      case 'lives':
        return widget.rewardAmount > 1 ? 'vies' : 'vie';
      case 'coins':
        return widget.rewardAmount > 1 ? 'pièces' : 'pièce';
      case 'gems':
        return widget.rewardAmount > 1 ? 'gemmes' : 'gemme';
      case 'booster':
        return 'booster';
      default:
        return 'récompense';
    }
  }
}

// Boutons spécialisés pour différents types de récompenses

class FreeLivesButton extends StatelessWidget {
  final VoidCallback? onRewardEarned;

  const FreeLivesButton({super.key, this.onRewardEarned});

  @override
  Widget build(BuildContext context) {
    return RewardedAdButton(
      rewardType: 'lives',
      rewardAmount: 1,
      title: 'Vie Gratuite',
      description: 'Regardez une publicité pour obtenir une vie gratuite',
      icon: Icons.favorite,
      color: AppColors.error,
      onRewardEarned: onRewardEarned,
    );
  }
}

class FreeCoinsButton extends StatelessWidget {
  final VoidCallback? onRewardEarned;

  const FreeCoinsButton({super.key, this.onRewardEarned});

  @override
  Widget build(BuildContext context) {
    return RewardedAdButton(
      rewardType: 'coins',
      rewardAmount: 50,
      title: '50 Pièces Gratuites',
      description: 'Regardez une publicité pour obtenir 50 pièces',
      icon: Icons.monetization_on,
      color: AppColors.coins,
      onRewardEarned: onRewardEarned,
    );
  }
}

class FreeGemsButton extends StatelessWidget {
  final VoidCallback? onRewardEarned;

  const FreeGemsButton({super.key, this.onRewardEarned});

  @override
  Widget build(BuildContext context) {
    return RewardedAdButton(
      rewardType: 'gems',
      rewardAmount: 5,
      title: '5 Gemmes Gratuites',
      description: 'Regardez une publicité pour obtenir 5 gemmes',
      icon: Icons.diamond,
      color: AppColors.gems,
      onRewardEarned: onRewardEarned,
    );
  }
}
