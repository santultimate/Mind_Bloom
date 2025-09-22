import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/screens/tutorial_screen.dart';
import 'package:mind_bloom/screens/settings_screen.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            onPressed: _showSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // En-tête du profil
                _buildProfileHeader(userProvider),

                const SizedBox(height: 24),

                // Statistiques principales
                _buildMainStats(userProvider),

                const SizedBox(height: 24),

                // Statistiques détaillées
                _buildDetailedStats(userProvider),

                const SizedBox(height: 24),

                // Actions rapides
                _buildQuickActions(),

                const SizedBox(height: 24),

                // Réalisations récentes
                _buildRecentAchievements(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserProvider userProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.accent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 3,
              ),
            ),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 50,
            ),
          ),

          const SizedBox(height: 16),

          // Nom d'utilisateur
          Text(
            userProvider.username,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Niveau
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.trending_up,
                color: Colors.white.withValues(alpha: 0.8),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.userLevel(userProvider.level),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Barre d'expérience
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _getExperienceProgress(userProvider),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '${userProvider.experience} XP',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStats(UserProvider userProvider) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            AppLocalizations.of(context)!.completedLevels,
            userProvider.completedLevels.length.toString(),
            Icons.flag,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            AppLocalizations.of(context)!.bestStreak,
            userProvider.bestStreak.toString(),
            Icons.local_fire_department,
            AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            AppLocalizations.of(context)!.lives,
            '${userProvider.lives}/${userProvider.maxLives}',
            Icons.favorite,
            AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedStats(UserProvider userProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.detailedStats,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 16),
          _buildStatRow(AppLocalizations.of(context)!.totalCoins,
              '${userProvider.coins}', Icons.monetization_on, AppColors.coins),
          _buildStatRow(
              AppLocalizations.of(context)!.gems(0).replaceAll('0 ', ''),
              '${userProvider.gems}',
              Icons.diamond,
              AppColors.gold),
          _buildStatRow(
              AppLocalizations.of(context)!.currentStreak,
              '${userProvider.currentStreak}',
              Icons.local_fire_department,
              AppColors.accent),
          _buildStatRow(AppLocalizations.of(context)!.starsEarned,
              _getTotalStars(userProvider), Icons.star, AppColors.gold),
          _buildStatRow(
              AppLocalizations.of(context)!.highestLevel,
              _getHighestLevel(userProvider),
              Icons.trending_up,
              AppColors.success),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.quickActions,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            AppLocalizations.of(context)!.reviewTutorial,
            Icons.school,
            AppColors.primary,
            _showTutorial,
          ),
          _buildActionButton(
            AppLocalizations.of(context)!.resetData,
            Icons.refresh,
            AppColors.warning,
            _showResetDialog,
          ),
          _buildActionButton(
            AppLocalizations.of(context)!.shareProfile,
            Icons.share,
            AppColors.secondary,
            _shareProfile,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAchievements() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.recentAchievements,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 16),
          _buildAchievementItem(
            AppLocalizations.of(context)!.firstLevelCompleted,
            AppLocalizations.of(context)!.daysAgo(2),
            Icons.flag,
            AppColors.success,
          ),
          _buildAchievementItem(
            AppLocalizations.of(context)!.threeStarsObtained,
            AppLocalizations.of(context)!.dayAgo,
            Icons.star,
            AppColors.gold,
          ),
          _buildAchievementItem(
            AppLocalizations.of(context)!.streakOfFive,
            AppLocalizations.of(context)!.today,
            Icons.local_fire_department,
            AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String title, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementItem(
      String title, String date, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getExperienceProgress(UserProvider userProvider) {
    // Calculer la progression vers le niveau suivant
    final experienceForNextLevel = userProvider.level * 100;
    if (experienceForNextLevel == 0) return 0.0; // Éviter la division par zéro
    return (userProvider.experience % experienceForNextLevel) /
        experienceForNextLevel;
  }

  String _getTotalStars(UserProvider userProvider) {
    final totalStars =
        userProvider.levelStars.values.fold(0, (sum, stars) => sum + stars);
    return totalStars.toString();
  }

  String _getHighestLevel(UserProvider userProvider) {
    if (userProvider.completedLevels.isEmpty) return '1';
    final highestLevel =
        userProvider.completedLevels.reduce((a, b) => a > b ? a : b);
    return highestLevel.toString();
  }

  void _showSettings() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSfx('audio/sfx/button_click.wav');

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _showTutorial() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSfx('audio/sfx/button_click.wav');

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TutorialScreen(),
      ),
    );
  }

  void _showResetDialog() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSfx('audio/sfx/button_click.wav');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.resetDataTitle),
        content: Text(AppLocalizations.of(context)!.resetDataMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetUserData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(AppLocalizations.of(context)!.reset),
          ),
        ],
      ),
    );
  }

  void _resetUserData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.resetUserData();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.dataReset),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _shareProfile() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    audioProvider.playSfx('audio/sfx/button_click.wav');

    // Créer le texte de partage
    final shareText = '''
🌟 ${l10n.profile} - Mind Bloom

👤 ${l10n.username}: ${userProvider.username}
⭐ ${l10n.level}: ${userProvider.level}
🎯 ${l10n.levelsCompleted}: ${userProvider.levelsCompleted}
🏆 ${l10n.bestStreak}: ${userProvider.bestStreak}
💎 ${l10n.totalCoins}: ${userProvider.coins}
💜 ${l10n.lives}: ${userProvider.lives}

${l10n.shareProfileMessage}

#MindBloom #PuzzleGame #Match3
''';

    // Partager le profil
    Share.share(
      shareText,
      subject: '${l10n.profile} - Mind Bloom',
    );
  }
}
