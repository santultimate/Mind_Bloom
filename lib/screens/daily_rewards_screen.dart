import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/providers/rewards_provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

/// Écran des récompenses quotidiennes temporaire - Version simplifiée
class DailyRewardsScreen extends StatefulWidget {
  const DailyRewardsScreen({super.key});

  @override
  State<DailyRewardsScreen> createState() => _DailyRewardsScreenState();
}

class _DailyRewardsScreenState extends State<DailyRewardsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.dailyRewards),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<RewardsProvider>(
        builder: (context, rewardsProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // En-tête avec série
                _buildStreakHeader(rewardsProvider),

                const SizedBox(height: 30),

                // Récompense du jour
                _buildDailyReward(rewardsProvider),

                const SizedBox(height: 20),

                // Informations
                _buildInfoSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStreakHeader(RewardsProvider rewardsProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Série actuelle',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${rewardsProvider.dailyRewardStreak} jour${rewardsProvider.dailyRewardStreak > 1 ? 's' : ''}',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (rewardsProvider.dailyRewardStreak >= 7) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '🔥 Perfect streak!',
                style: TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDailyReward(RewardsProvider rewardsProvider) {
    if (rewardsProvider.dailyRewardClaimed) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.check_circle,
              size: 48,
              color: AppColors.success,
            ),
            SizedBox(height: 12),
            Text(
              'Récompense réclamée !',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Revenez demain pour une nouvelle récompense',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.card_giftcard,
            size: 48,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          const Text(
            'Récompense du jour',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRewardItem(Icons.monetization_on, AppColors.coins, '50+',
                  AppLocalizations.of(context)!.coins),
              _buildRewardItem(Icons.diamond, AppColors.gems, '2+',
                  AppLocalizations.of(context)!.gems),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _claimReward(rewardsProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'RÉCLAMER',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardItem(
      IconData icon, Color color, String amount, String label) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💡 Astuce',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Connectez-vous chaque jour pour maintenir votre série et obtenir des récompenses encore plus importantes !',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  void _claimReward(RewardsProvider rewardsProvider) async {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    audioProvider.playButtonClick();

    try {
      final reward = await rewardsProvider.claimDailyReward();

      if (reward.isNotEmpty) {
        // Ajouter les récompenses à l'utilisateur
        await userProvider.addCoins(reward['coins'] ?? 0);
        await userProvider.addGems(reward['gems'] ?? 0);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Récompense réclamée ! +${reward['coins']} pièces, +${reward['gems']} gemmes',
              ),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.claim_error),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
