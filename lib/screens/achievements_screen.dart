import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  String _selectedCategory = 'all';
  List<Achievement> _achievements = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generateAchievements();
  }

  void _generateAchievements() {
    // Récupérer les données utilisateur pour calculer la progression
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final completedLevels = userProvider.completedLevels.length;
    final totalScore = userProvider.totalScore;
    final currentStreak = userProvider.currentStreak;
    final bestScore = userProvider.bestScore;
    final bestCombo = userProvider.bestCombo;
    final perfectLevels = userProvider.perfectLevels;
    final shareCount = userProvider.shareCount;

    _achievements = [
      // Succès de progression - Répartis tout au long du parcours
      Achievement(
        id: 'first_level',
        title: AppLocalizations.of(context)!.firstSteps,
        description: AppLocalizations.of(context)!.firstStepsDescription,
        progress: completedLevels >= 1 ? 1 : 0,
        target: 1,
        isUnlocked: completedLevels >= 1,
        reward: 50,
        category: 'progression',
        icon: Icons.flag,
        color: AppColors.primary,
      ),
      Achievement(
        id: 'level_5',
        title: 'Premier Jardinier',
        description: 'Terminez 5 niveaux pour prouver votre détermination',
        progress: completedLevels >= 5 ? 5 : completedLevels,
        target: 5,
        isUnlocked: completedLevels >= 5,
        reward: 100,
        category: 'progression',
        icon: Icons.eco,
        color: AppColors.primary,
      ),
      Achievement(
        id: 'level_10',
        title: AppLocalizations.of(context)!.confirmedBeginner,
        description: AppLocalizations.of(context)!.confirmedBeginnerDescription,
        progress: completedLevels >= 10 ? 10 : completedLevels,
        target: 10,
        isUnlocked: completedLevels >= 10,
        reward: 150,
        category: 'progression',
        icon: Icons.trending_up,
        color: AppColors.primary,
      ),
      Achievement(
        id: 'level_20',
        title: 'Jardinier Expérimenté',
        description:
            'Terminez 20 niveaux pour devenir un jardinier expérimenté',
        progress: completedLevels >= 20 ? 20 : completedLevels,
        target: 20,
        isUnlocked: completedLevels >= 20,
        reward: 250,
        category: 'progression',
        icon: Icons.local_florist,
        color: AppColors.success,
      ),
      Achievement(
        id: 'level_35',
        title: 'Maître Jardinier',
        description: 'Terminez 35 niveaux pour devenir un maître jardinier',
        progress: completedLevels >= 35 ? 35 : completedLevels,
        target: 35,
        isUnlocked: completedLevels >= 35,
        reward: 400,
        category: 'progression',
        icon: Icons.emoji_events,
        color: AppColors.gold,
      ),
      Achievement(
        id: 'level_50',
        title: 'Maître des Mondes',
        description: 'Terminez 50 niveaux pour devenir un maître des mondes',
        progress: completedLevels >= 50 ? 50 : completedLevels,
        target: 50,
        isUnlocked: completedLevels >= 50,
        reward: 500,
        category: 'progression',
        icon: Icons.emoji_events,
        color: AppColors.gold,
      ),
      Achievement(
        id: 'level_75',
        title: 'Légende Vivante',
        description: 'Terminez 75 niveaux pour devenir une légende vivante',
        progress: completedLevels >= 75 ? 75 : completedLevels,
        target: 75,
        isUnlocked: completedLevels >= 75,
        reward: 750,
        category: 'progression',
        icon: Icons.emoji_events,
        color: AppColors.gold,
      ),
      Achievement(
        id: 'level_100',
        title: 'Champion Suprême',
        description:
            'Terminez tous les 100 niveaux pour devenir le champion suprême',
        progress: completedLevels >= 100 ? 100 : completedLevels,
        target: 100,
        isUnlocked: completedLevels >= 100,
        reward: 1000,
        category: 'progression',
        icon: Icons.emoji_events,
        color: AppColors.gold,
      ),
      Achievement(
        id: 'perfect_level',
        title: AppLocalizations.of(context)!.perfectionist,
        description: AppLocalizations.of(context)!.perfectionistDescription,
        progress: 1,
        target: 1,
        isUnlocked: true,
        reward: 75,
        category: 'progression',
        icon: Icons.star,
        color: AppColors.gold,
      ),
      Achievement(
        id: 'perfect_5',
        title: 'Perfectionniste Confirmé',
        description: 'Terminez 5 niveaux avec 3 étoiles',
        progress: perfectLevels >= 5 ? 5 : perfectLevels,
        target: 5,
        isUnlocked: perfectLevels >= 5,
        reward: 200,
        category: 'progression',
        icon: Icons.star,
        color: AppColors.gold,
      ),
      Achievement(
        id: 'perfect_15',
        title: 'Maître de la Perfection',
        description: 'Terminez 15 niveaux avec 3 étoiles',
        progress: perfectLevels >= 15 ? 15 : perfectLevels,
        target: 15,
        isUnlocked: perfectLevels >= 15,
        reward: 500,
        category: 'progression',
        icon: Icons.emoji_events,
        color: AppColors.gold,
      ),
      Achievement(
        id: 'perfect_30',
        title: 'Perfection Absolue',
        description: 'Terminez 30 niveaux avec 3 étoiles',
        progress: perfectLevels >= 30 ? 30 : perfectLevels,
        target: 30,
        isUnlocked: perfectLevels >= 30,
        reward: 750,
        category: 'progression',
        icon: Icons.emoji_events,
        color: AppColors.gold,
      ),
      Achievement(
        id: 'perfect_50',
        title: 'Légende de la Perfection',
        description: 'Terminez 50 niveaux avec 3 étoiles',
        progress: perfectLevels >= 50 ? 50 : perfectLevels,
        target: 50,
        isUnlocked: perfectLevels >= 50,
        reward: 1000,
        category: 'progression',
        icon: Icons.emoji_events,
        color: AppColors.gold,
      ),

      // Succès de score - Progression graduelle
      Achievement(
        id: 'score_1000',
        title: AppLocalizations.of(context)!.scorer,
        description: AppLocalizations.of(context)!.scorerDescription,
        progress: 1,
        target: 1,
        isUnlocked: true,
        reward: 50,
        category: 'score',
        icon: Icons.score,
        color: AppColors.success,
      ),
      Achievement(
        id: 'score_3000',
        title: 'Scoreur Talentueux',
        description: 'Obtenez un score de 3000 points dans un niveau',
        progress: bestScore >= 3000 ? 1 : 0,
        target: 1,
        isUnlocked: bestScore >= 3000,
        reward: 100,
        category: 'score',
        icon: Icons.score,
        color: AppColors.success,
      ),
      Achievement(
        id: 'score_5000',
        title: AppLocalizations.of(context)!.scoreMaster,
        description: AppLocalizations.of(context)!.scoreMasterDescription,
        progress: bestScore >= 5000 ? 1 : 0,
        target: 1,
        isUnlocked: bestScore >= 5000,
        reward: 200,
        category: 'score',
        icon: Icons.score,
        color: AppColors.success,
      ),
      Achievement(
        id: 'total_score_50k',
        title: 'Accumulateur de Points',
        description: 'Accumulez 50 000 points au total',
        progress: totalScore >= 50000 ? 50000 : totalScore,
        target: 50000,
        isUnlocked: totalScore >= 50000,
        reward: 300,
        category: 'score',
        icon: Icons.analytics,
        color: AppColors.success,
      ),
      Achievement(
        id: 'total_score_100k',
        title: AppLocalizations.of(context)!.accumulator,
        description: AppLocalizations.of(context)!.accumulatorDescription,
        progress: totalScore >= 100000 ? 100000 : totalScore,
        target: 100000,
        isUnlocked: totalScore >= 100000,
        reward: 500,
        category: 'score',
        icon: Icons.analytics,
        color: AppColors.success,
      ),
      Achievement(
        id: 'total_score_250k',
        title: 'Maître des Scores',
        description: 'Accumulez 250 000 points au total',
        progress: totalScore >= 250000 ? 250000 : totalScore,
        target: 250000,
        isUnlocked: totalScore >= 250000,
        reward: 750,
        category: 'score',
        icon: Icons.analytics,
        color: AppColors.success,
      ),
      Achievement(
        id: 'total_score_500k',
        title: 'Légende des Scores',
        description: 'Accumulez 500 000 points au total',
        progress: totalScore >= 500000 ? 500000 : totalScore,
        target: 500000,
        isUnlocked: totalScore >= 500000,
        reward: 1000,
        category: 'score',
        icon: Icons.analytics,
        color: AppColors.success,
      ),

      // Succès de collection - Progression naturelle
      Achievement(
        id: 'first_plant',
        title: AppLocalizations.of(context)!.beginnerBotanist,
        description: AppLocalizations.of(context)!.beginnerBotanistDescription,
        progress: 1,
        target: 1,
        isUnlocked: true,
        reward: 100,
        category: 'collection',
        icon: Icons.eco,
        color: AppColors.primary,
      ),
      Achievement(
        id: 'plant_collector',
        title: AppLocalizations.of(context)!.collector,
        description: AppLocalizations.of(context)!.collectorDescription,
        progress: 3,
        target: 5,
        isUnlocked: false,
        reward: 250,
        category: 'collection',
        icon: Icons.collections,
        color: AppColors.primary,
      ),
      Achievement(
        id: 'rare_plant',
        title: AppLocalizations.of(context)!.rarityHunter,
        description: AppLocalizations.of(context)!.rarityHunterDescription,
        progress: 0,
        target: 1,
        isUnlocked: false,
        reward: 500,
        category: 'collection',
        icon: Icons.diamond,
        color: AppColors.gold,
      ),

      // Succès de jeu - Répartis selon la progression
      Achievement(
        id: 'combo_5',
        title: AppLocalizations.of(context)!.comboMaster,
        description: AppLocalizations.of(context)!.comboMasterDescription,
        progress: 1,
        target: 1,
        isUnlocked: true,
        reward: 75,
        category: 'game',
        icon: Icons.flash_on,
        color: AppColors.accent,
      ),
      Achievement(
        id: 'combo_8',
        title: 'Maître des Combos',
        description: 'Créez un combo de 8 tuiles ou plus',
        progress: bestCombo >= 8 ? 1 : 0,
        target: 1,
        isUnlocked: bestCombo >= 8,
        reward: 150,
        category: 'game',
        icon: Icons.flash_on,
        color: AppColors.accent,
      ),
      Achievement(
        id: 'combo_10',
        title: AppLocalizations.of(context)!.legendaryCombo,
        description: AppLocalizations.of(context)!.legendaryComboDescription,
        progress: bestCombo >= 10 ? 1 : 0,
        target: 1,
        isUnlocked: bestCombo >= 10,
        reward: 300,
        category: 'game',
        icon: Icons.flash_on,
        color: AppColors.accent,
      ),
      Achievement(
        id: 'no_moves_left',
        title: AppLocalizations.of(context)!.saver,
        description: AppLocalizations.of(context)!.saverDescription,
        progress: 0,
        target: 1,
        isUnlocked: false,
        reward: 150,
        category: 'game',
        icon: Icons.save,
        color: AppColors.secondary,
      ),
      Achievement(
        id: 'streak_5',
        title: 'Série de Victoires',
        description: 'Gagnez 5 niveaux consécutifs',
        progress: currentStreak >= 5 ? 5 : currentStreak,
        target: 5,
        isUnlocked: currentStreak >= 5,
        reward: 200,
        category: 'game',
        icon: Icons.trending_up,
        color: AppColors.accent,
      ),
      Achievement(
        id: 'streak_10',
        title: 'Série Légendaire',
        description: 'Gagnez 10 niveaux consécutifs',
        progress: currentStreak >= 10 ? 10 : currentStreak,
        target: 10,
        isUnlocked: currentStreak >= 10,
        reward: 400,
        category: 'game',
        icon: Icons.emoji_events,
        color: AppColors.gold,
      ),

      // Succès sociaux - Progression naturelle
      Achievement(
        id: 'daily_login',
        title: AppLocalizations.of(context)!.loyal,
        description: AppLocalizations.of(context)!.loyalDescription,
        progress: 3,
        target: 7,
        isUnlocked: false,
        reward: 200,
        category: 'social',
        icon: Icons.calendar_today,
        color: AppColors.primary,
      ),
      Achievement(
        id: 'share_score',
        title: AppLocalizations.of(context)!.sharer,
        description: AppLocalizations.of(context)!.sharerDescription,
        progress: shareCount >= 3 ? 3 : shareCount,
        target: 3,
        isUnlocked: shareCount >= 3,
        reward: 100,
        category: 'social',
        icon: Icons.share,
        color: AppColors.secondary,
      ),
      Achievement(
        id: 'share_achievements',
        title: AppLocalizations.of(context)!.shareAchievements,
        description: AppLocalizations.of(context)!.shareAchievementsDescription,
        progress: shareCount >= 5 ? 5 : shareCount,
        target: 5,
        isUnlocked: shareCount >= 5,
        reward: 200,
        category: 'social',
        icon: Icons.share,
        color: AppColors.primary,
      ),
      Achievement(
        id: 'social_butterfly',
        title: AppLocalizations.of(context)!.socialButterfly,
        description: AppLocalizations.of(context)!.socialButterflyDescription,
        progress: shareCount >= 10 ? 10 : shareCount,
        target: 10,
        isUnlocked: shareCount >= 10,
        reward: 500,
        category: 'social',
        icon: Icons.people,
        color: AppColors.gold,
      ),

      // Succès de mondes - Nouveaux achievements pour les 10 mondes
      Achievement(
        id: 'world_1_complete',
        title: 'Maître du Jardin',
        description: 'Terminez tous les niveaux du Jardin des Débuts',
        progress: completedLevels >= 10 ? 10 : completedLevels,
        target: 10,
        isUnlocked: completedLevels >= 10,
        reward: 200,
        category: 'worlds',
        icon: Icons.eco,
        color: AppColors.primary,
      ),
      Achievement(
        id: 'world_3_complete',
        title: 'Explorateur de la Forêt',
        description: 'Terminez tous les niveaux de la Forêt Lunaire',
        progress: completedLevels >= 30
            ? 10
            : (completedLevels >= 21 ? completedLevels - 20 : 0),
        target: 10,
        isUnlocked: completedLevels >= 30,
        reward: 300,
        category: 'worlds',
        icon: Icons.nightlight_round,
        color: AppColors.primary,
      ),
      Achievement(
        id: 'world_5_complete',
        title: 'Conquérant des Montagnes',
        description: 'Terminez tous les niveaux des Montagnes Mystiques',
        progress: completedLevels >= 50
            ? 10
            : (completedLevels >= 41 ? completedLevels - 40 : 0),
        target: 10,
        isUnlocked: completedLevels >= 50,
        reward: 400,
        category: 'worlds',
        icon: Icons.landscape,
        color: AppColors.success,
      ),
      Achievement(
        id: 'world_7_complete',
        title: 'Survivant des Terres Brûlantes',
        description: 'Terminez tous les niveaux des Terres Volcaniques',
        progress: completedLevels >= 70
            ? 10
            : (completedLevels >= 61 ? completedLevels - 60 : 0),
        target: 10,
        isUnlocked: completedLevels >= 70,
        reward: 500,
        category: 'worlds',
        icon: Icons.local_fire_department,
        color: AppColors.accent,
      ),
      Achievement(
        id: 'world_10_complete',
        title: 'Champion Céleste',
        description: 'Terminez tous les niveaux du Jardin Céleste',
        progress: completedLevels >= 100
            ? 10
            : (completedLevels >= 91 ? completedLevels - 90 : 0),
        target: 10,
        isUnlocked: completedLevels >= 100,
        reward: 1000,
        category: 'worlds',
        icon: Icons.star,
        color: AppColors.gold,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final unlockedCount = _achievements.where((a) => a.isUnlocked).length;
    final totalRewards = _achievements
        .where((a) => a.isUnlocked)
        .fold(0, (sum, a) => sum + a.reward);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.success,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          // Bouton de partage global des achievements
          IconButton(
            onPressed: _shareAllAchievements,
            icon: const Icon(
              Icons.share,
              color: AppColors.primary,
            ),
            tooltip: AppLocalizations.of(context)!.shareMyAchievements,
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistiques
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatistic(
                      AppLocalizations.of(context)!.success,
                      '$unlockedCount/${_achievements.length}',
                      Icons.emoji_events,
                      AppColors.gold,
                    ),
                    _buildStatistic(
                      AppLocalizations.of(context)!.rewards,
                      '$totalRewards ${AppLocalizations.of(context)!.coins(0).replaceAll('0 ', '')}',
                      Icons.monetization_on,
                      AppColors.coins,
                    ),
                    _buildStatistic(
                      AppLocalizations.of(context)!.progress,
                      '${((unlockedCount / _achievements.length) * 100).toInt()}%',
                      Icons.trending_up,
                      AppColors.success,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Bouton de partage global
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _shareAllAchievements,
                    icon: const Icon(Icons.share, size: 18),
                    label:
                        Text(AppLocalizations.of(context)!.shareMyAchievements),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filtres de catégorie
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  'all',
                  'progression',
                  'score',
                  'collection',
                  'game',
                  'social',
                  'worlds',
                ].map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      label: Text(_getCategoryLabel(category)),
                      backgroundColor: AppColors.surface,
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Liste des succès
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _getFilteredAchievements().length,
              itemBuilder: (context, index) {
                return _buildAchievementCard(_getFilteredAchievements()[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'all':
        return AppLocalizations.of(context)!.all;
      case 'progression':
        return AppLocalizations.of(context)!.progression;
      case 'score':
        return AppLocalizations.of(context)!.score;
      case 'collection':
        return AppLocalizations.of(context)!.collection;
      case 'game':
        return AppLocalizations.of(context)!.game;
      case 'social':
        return AppLocalizations.of(context)!.social;
      case 'worlds':
        return 'Mondes';
      default:
        return category;
    }
  }

  List<Achievement> _getFilteredAchievements() {
    if (_selectedCategory == 'all') {
      return _achievements;
    }
    return _achievements
        .where((achievement) => achievement.category == _selectedCategory)
        .toList();
  }

  Widget _buildStatistic(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    final progress = achievement.progress / achievement.target;
    final isCompleted = achievement.isUnlocked;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isCompleted
              ? LinearGradient(
                  colors: [
                    achievement.color.withValues(alpha: 0.1),
                    achievement.color.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: InkWell(
          onTap: () => _showAchievementDetails(achievement),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icône
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? achievement.color.withValues(alpha: 0.2)
                        : AppColors.textSecondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    achievement.icon,
                    color: isCompleted
                        ? achievement.color
                        : AppColors.textSecondary,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 16),

                // Contenu
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              achievement.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                          ),
                          if (isCompleted)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.completed,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement.description,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Progression
                      if (!isCompleted) ...[
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: AppColors.textSecondary
                                    .withValues(alpha: 0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  achievement.color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${achievement.progress}/${achievement.target}',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 8),

                      // Récompense et actions
                      Row(
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: AppColors.coins,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '+${achievement.reward} ${AppLocalizations.of(context)!.coins(0).replaceAll('0 ', '')}',
                            style: TextStyle(
                              color: AppColors.coins,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          // Bouton de partage pour les achievements débloqués
                          if (achievement.isUnlocked)
                            IconButton(
                              onPressed: () => _shareAchievement(achievement),
                              icon: Icon(
                                Icons.share,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              tooltip:
                                  AppLocalizations.of(context)!.shareThisBadge,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          const SizedBox(width: 8),
                          Text(
                            _getCategoryLabel(achievement.category),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAchievementDetails(Achievement achievement) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSfx('audio/sfx/button_click.wav');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // En-tête
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: achievement.isUnlocked
                          ? achievement.color.withValues(alpha: 0.2)
                          : AppColors.textSecondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      achievement.icon,
                      color: achievement.isUnlocked
                          ? achievement.color
                          : AppColors.textSecondary,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievement.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: achievement.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getCategoryLabel(achievement.category),
                            style: TextStyle(
                              color: achievement.color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Description
              Text(
                AppLocalizations.of(context)!.description,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                achievement.description,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              // Progression
              if (!achievement.isUnlocked) ...[
                Text(
                  AppLocalizations.of(context)!.progress,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: achievement.progress / achievement.target,
                        backgroundColor:
                            AppColors.textSecondary.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          achievement.color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${achievement.progress}/${achievement.target}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              // Récompense
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.coins.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.coins.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.coins.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.monetization_on,
                        color: AppColors.coins,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.reward,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '+${achievement.reward} ${AppLocalizations.of(context)!.coins(0).replaceAll('0 ', '')}',
                            style: TextStyle(
                              color: AppColors.coins,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (achievement.isUnlocked)
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 24,
                      ),
                  ],
                ),
              ),

              const Spacer(),

              // Boutons d'action
              if (achievement.isUnlocked) ...[
                // Bouton de partage
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _shareAchievement(achievement),
                    icon: const Icon(Icons.share, size: 18),
                    label: Text(AppLocalizations.of(context)!.shareThisBadge),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Bouton principal
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: achievement.isUnlocked
                      ? () => _claimReward(achievement)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: achievement.isUnlocked
                        ? AppColors.success
                        : AppColors.textSecondary.withValues(alpha: 0.3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    achievement.isUnlocked
                        ? AppLocalizations.of(context)!.rewardClaimed
                        : AppLocalizations.of(context)!.inProgress,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _claimReward(Achievement achievement) {
    // TODO: Implémenter la réclamation des récompenses
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!
            .rewardClaimedMessage(achievement.title)),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _shareAchievement(Achievement achievement) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';

    audioProvider.playSfx('audio/sfx/button_click.wav');

    // Incrémenter le compteur de partages
    userProvider.incrementShareCount();

    // Créer le texte de partage bilingue
    final shareText = isFrench
        ? '''
🏆 ${achievement.title} - Mind Bloom

${achievement.description}

👤 Joueur: ${userProvider.username}
⭐ Niveau: ${userProvider.level}
🎯 Niveaux terminés: ${userProvider.levelsCompleted}
🏆 Meilleure série: ${userProvider.bestStreak}

💎 Récompense: +${achievement.reward} pièces

Peux-tu débloquer ce badge aussi ? 🌱

#MindBloom #Badge #Achievement #PuzzleGame
'''
        : '''
🏆 ${achievement.title} - Mind Bloom

${achievement.description}

👤 Player: ${userProvider.username}
⭐ Level: ${userProvider.level}
🎯 Levels completed: ${userProvider.levelsCompleted}
🏆 Best streak: ${userProvider.bestStreak}

💎 Reward: +${achievement.reward} coins

Can you unlock this badge too? 🌱

#MindBloom #Badge #Achievement #PuzzleGame
''';

    // Partager l'achievement
    Share.share(
      shareText,
      subject: '🏆 ${achievement.title} - Mind Bloom',
    );

    // Afficher une confirmation bilingue
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(AppLocalizations.of(context)!.badgeShared(achievement.title)),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareAllAchievements() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';

    audioProvider.playSfx('audio/sfx/button_click.wav');

    final unlockedAchievements =
        _achievements.where((a) => a.isUnlocked).toList();
    final totalRewards =
        unlockedAchievements.fold(0, (sum, a) => sum + a.reward);

    // Créer le texte de partage global bilingue
    final shareText = isFrench
        ? '''
🏆 Mes Achievements - Mind Bloom

🎯 Progression: ${unlockedAchievements.length}/${_achievements.length} badges débloqués
💎 Récompenses totales: $totalRewards pièces
⭐ Niveau: ${userProvider.level}
🎮 Niveaux terminés: ${userProvider.levelsCompleted}
🏆 Meilleure série: ${userProvider.bestStreak}

${unlockedAchievements.isNotEmpty ? '🏅 Derniers badges débloqués:' : '🚀 Commence ton aventure !'}

${unlockedAchievements.take(5).map((a) => '• ${a.title}').join('\n')}

${unlockedAchievements.length > 5 ? '... et ${unlockedAchievements.length - 5} autres !' : ''}

Peux-tu me battre ? 🌱

#MindBloom #Achievements #PuzzleGame #Competition
'''
        : '''
🏆 My Achievements - Mind Bloom

🎯 Progress: ${unlockedAchievements.length}/${_achievements.length} badges unlocked
💎 Total rewards: $totalRewards coins
⭐ Level: ${userProvider.level}
🎮 Levels completed: ${userProvider.levelsCompleted}
🏆 Best streak: ${userProvider.bestStreak}

${unlockedAchievements.isNotEmpty ? '🏅 Latest badges unlocked:' : '🚀 Start your adventure!'}

${unlockedAchievements.take(5).map((a) => '• ${a.title}').join('\n')}

${unlockedAchievements.length > 5 ? '... and ${unlockedAchievements.length - 5} more!' : ''}

Can you beat me? 🌱

#MindBloom #Achievements #PuzzleGame #Competition
''';

    // Partager tous les achievements
    Share.share(
      shareText,
      subject: isFrench
          ? '🏆 Mes Achievements - Mind Bloom'
          : '🏆 My Achievements - Mind Bloom',
    );

    // Afficher une confirmation bilingue
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.achievementsShared),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final int progress;
  final int target;
  final bool isUnlocked;
  final int reward;
  final String category;
  final IconData icon;
  final Color color;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.target,
    required this.isUnlocked,
    required this.reward,
    required this.category,
    required this.icon,
    required this.color,
  });
}
