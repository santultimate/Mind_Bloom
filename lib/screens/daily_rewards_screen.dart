import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/providers/daily_rewards_provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';

class DailyRewardsScreen extends StatefulWidget {
  const DailyRewardsScreen({super.key});

  @override
  State<DailyRewardsScreen> createState() => _DailyRewardsScreenState();
}

class _DailyRewardsScreenState extends State<DailyRewardsScreen>
    with TickerProviderStateMixin {
  late AnimationController _claimController;
  late Animation<double> _claimAnimation;

  @override
  void initState() {
    super.initState();
    _claimController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _claimAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _claimController,
      curve: Curves.elasticInOut,
    ));
  }

  @override
  void dispose() {
    _claimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Récompenses Quotidiennes',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      body: Consumer<DailyRewardsProvider>(
        builder: (context, dailyRewards, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // En-tête avec information sur la série
                _buildStreakHeader(dailyRewards),

                const SizedBox(height: 20),

                // Grille des récompenses pour 7 jours
                _buildRewardsGrid(dailyRewards),

                const SizedBox(height: 30),

                // Bouton de réclamation ou timer
                _buildClaimSection(dailyRewards),

                const SizedBox(height: 20),

                // Informations supplémentaires
                _buildInfoSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStreakHeader(DailyRewardsProvider dailyRewards) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.local_fire_department,
            color: AppColors.primary,
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            'Série Actuelle',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${dailyRewards.consecutiveDays} jour${dailyRewards.consecutiveDays > 1 ? 's' : ''}',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (dailyRewards.consecutiveDays >= 7) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '🏆 Série Légendaire !',
                style: TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRewardsGrid(DailyRewardsProvider dailyRewards) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.7,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: 7,
      itemBuilder: (context, index) {
        final day = index + 1;
        final reward = dailyRewards.rewardCycle[day]!;
        final isCurrentDay = (dailyRewards.consecutiveDays % 7) + 1 == day;
        final isPastDay = dailyRewards.consecutiveDays >= day;
        final isFutureDay = dailyRewards.consecutiveDays < day - 1;

        return _buildRewardCard(reward, isCurrentDay, isPastDay, isFutureDay);
      },
    );
  }

  Widget _buildRewardCard(
      DailyReward reward, bool isCurrentDay, bool isPastDay, bool isFutureDay) {
    Color cardColor;
    Color textColor;
    IconData statusIcon;

    if (isPastDay) {
      cardColor = AppColors.success.withValues(alpha: 0.1);
      textColor = AppColors.success;
      statusIcon = Icons.check_circle;
    } else if (isCurrentDay) {
      cardColor = AppColors.primary.withValues(alpha: 0.2);
      textColor = AppColors.primary;
      statusIcon = Icons.star;
    } else {
      cardColor = Colors.grey.withValues(alpha: 0.1);
      textColor = Colors.grey;
      statusIcon = Icons.lock;
    }

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: textColor.withValues(alpha: 0.3),
          width: isCurrentDay ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            color: textColor,
            size: 12,
          ),
          const SizedBox(height: 1),
          Text(
            'J${reward.day}',
            style: TextStyle(
              color: textColor,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 1),
          if (reward.coins > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.monetization_on, color: AppColors.coins, size: 8),
                const SizedBox(width: 1),
                Text(
                  '${reward.coins}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
          if (reward.gems > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.diamond, color: AppColors.gems, size: 8),
                const SizedBox(width: 1),
                Text(
                  '${reward.gems}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
          if (reward.lives > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite, color: Colors.red, size: 8),
                const SizedBox(width: 1),
                Text(
                  '${reward.lives}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildClaimSection(DailyRewardsProvider dailyRewards) {
    if (dailyRewards.canClaimDailyReward()) {
      final currentReward = dailyRewards.getCurrentDayReward();

      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Récompense du Jour ${currentReward.day}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentReward.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (currentReward.coins > 0)
                      _buildRewardItem(Icons.monetization_on,
                          '${currentReward.coins}', AppColors.coins),
                    if (currentReward.gems > 0)
                      _buildRewardItem(Icons.diamond, '${currentReward.gems}',
                          AppColors.gems),
                    if (currentReward.lives > 0)
                      _buildRewardItem(
                          Icons.favorite, '${currentReward.lives}', Colors.red),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _claimAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _claimAnimation.value,
                child: ElevatedButton(
                  onPressed: () => _claimReward(dailyRewards),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Réclamer !',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    } else {
      // Afficher le timer jusqu'à la prochaine récompense
      final timeUntilNext = dailyRewards.getTimeUntilNextReward();

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.access_time,
              color: Colors.grey,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              'Récompense déjà réclamée',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Prochaine récompense dans :',
              style: TextStyle(
                color: Colors.grey.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatDuration(timeUntilNext),
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildRewardItem(IconData icon, String amount, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
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
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comment ça marche ?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoItem('📅',
              'Connectez-vous chaque jour pour réclamer votre récompense'),
          _buildInfoItem('🔥',
              'Plus votre série est longue, meilleures sont les récompenses'),
          _buildInfoItem('🏆', 'Le 7ème jour offre une récompense légendaire'),
          _buildInfoItem('⏰', 'Les récompenses se réinitialisent à minuit'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _claimReward(DailyRewardsProvider dailyRewards) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    final reward = await dailyRewards.claimDailyReward();
    if (reward != null) {
      // Animer le bouton
      _claimController.forward().then((_) {
        _claimController.reverse();
      });

      // Jouer des sons
      audioProvider.playLevelComplete();

      // Donner les récompenses
      if (reward.coins > 0) {
        await userProvider.addCoins(reward.coins);
      }
      if (reward.gems > 0) {
        await userProvider.addGems(reward.gems);
      }
      if (reward.lives > 0) {
        await userProvider.addLives(reward.lives);
      }

      // Sons spéciaux pour les récompenses importantes
      if (reward.isSpecial) {
        Future.delayed(const Duration(milliseconds: 500), () {
          audioProvider.playMilestone();
        });
      }

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Récompense réclamée ! +${reward.coins} pièces, +${reward.gems} gemmes, +${reward.lives} vies',
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
