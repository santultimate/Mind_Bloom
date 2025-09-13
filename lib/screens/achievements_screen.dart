import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/providers/audio_provider.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  String _selectedCategory = 'Tous';

  final List<Achievement> _achievements = [
    // Succès de progression
    Achievement(
      id: 'first_level',
      title: 'Premier Pas',
      description: 'Terminez votre premier niveau',
      progress: 1,
      target: 1,
      isUnlocked: true,
      reward: 50,
      category: 'Progression',
      icon: Icons.flag,
      color: AppColors.primary,
    ),
    Achievement(
      id: 'level_10',
      title: 'Débutant Confirmé',
      description: 'Terminez 10 niveaux',
      progress: 7,
      target: 10,
      isUnlocked: false,
      reward: 100,
      category: 'Progression',
      icon: Icons.trending_up,
      color: AppColors.primary,
    ),
    Achievement(
      id: 'level_50',
      title: 'Expert en Herbe',
      description: 'Terminez 50 niveaux',
      progress: 7,
      target: 50,
      isUnlocked: false,
      reward: 500,
      category: 'Progression',
      icon: Icons.emoji_events,
      color: AppColors.gold,
    ),
    Achievement(
      id: 'perfect_level',
      title: 'Perfectionniste',
      description: 'Obtenez 3 étoiles sur un niveau',
      progress: 1,
      target: 1,
      isUnlocked: true,
      reward: 75,
      category: 'Progression',
      icon: Icons.star,
      color: AppColors.gold,
    ),

    // Succès de score
    Achievement(
      id: 'score_1000',
      title: 'Scoreur',
      description: 'Marquez 1,000 points en un niveau',
      progress: 1,
      target: 1,
      isUnlocked: true,
      reward: 50,
      category: 'Score',
      icon: Icons.score,
      color: AppColors.success,
    ),
    Achievement(
      id: 'score_5000',
      title: 'Maître du Score',
      description: 'Marquez 5,000 points en un niveau',
      progress: 0,
      target: 1,
      isUnlocked: false,
      reward: 200,
      category: 'Score',
      icon: Icons.score,
      color: AppColors.success,
    ),
    Achievement(
      id: 'total_score_100k',
      title: 'Accumulateur',
      description: 'Marquez un total de 100,000 points',
      progress: 25000,
      target: 100000,
      isUnlocked: false,
      reward: 300,
      category: 'Score',
      icon: Icons.analytics,
      color: AppColors.success,
    ),

    // Succès de collection
    Achievement(
      id: 'first_plant',
      title: 'Botaniste Débutant',
      description: 'Débloquez votre première plante',
      progress: 1,
      target: 1,
      isUnlocked: true,
      reward: 100,
      category: 'Collection',
      icon: Icons.eco,
      color: AppColors.primary,
    ),
    Achievement(
      id: 'plant_collector',
      title: 'Collectionneur',
      description: 'Débloquez 5 plantes',
      progress: 3,
      target: 5,
      isUnlocked: false,
      reward: 250,
      category: 'Collection',
      icon: Icons.collections,
      color: AppColors.primary,
    ),
    Achievement(
      id: 'rare_plant',
      title: 'Chasseur de Raretés',
      description: 'Débloquez une plante 4 étoiles ou plus',
      progress: 0,
      target: 1,
      isUnlocked: false,
      reward: 500,
      category: 'Collection',
      icon: Icons.diamond,
      color: AppColors.gold,
    ),

    // Succès de jeu
    Achievement(
      id: 'combo_5',
      title: 'Combo Master',
      description: 'Faites un combo de 5 tuiles',
      progress: 1,
      target: 1,
      isUnlocked: true,
      reward: 75,
      category: 'Jeu',
      icon: Icons.flash_on,
      color: AppColors.accent,
    ),
    Achievement(
      id: 'combo_10',
      title: 'Combo Légendaire',
      description: 'Faites un combo de 10 tuiles',
      progress: 0,
      target: 1,
      isUnlocked: false,
      reward: 300,
      category: 'Jeu',
      icon: Icons.flash_on,
      color: AppColors.accent,
    ),
    Achievement(
      id: 'no_moves_left',
      title: 'Économiseur',
      description: 'Terminez un niveau avec plus de 5 coups restants',
      progress: 0,
      target: 1,
      isUnlocked: false,
      reward: 150,
      category: 'Jeu',
      icon: Icons.save,
      color: AppColors.secondary,
    ),

    // Succès sociaux
    Achievement(
      id: 'daily_login',
      title: 'Fidèle',
      description: 'Connectez-vous 7 jours de suite',
      progress: 3,
      target: 7,
      isUnlocked: false,
      reward: 200,
      category: 'Social',
      icon: Icons.calendar_today,
      color: AppColors.primary,
    ),
    Achievement(
      id: 'share_score',
      title: 'Partageur',
      description: 'Partagez votre score 3 fois',
      progress: 0,
      target: 3,
      isUnlocked: false,
      reward: 100,
      category: 'Social',
      icon: Icons.share,
      color: AppColors.secondary,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unlockedCount = _achievements.where((a) => a.isUnlocked).length;
    final totalRewards = _achievements
        .where((a) => a.isUnlocked)
        .fold(0, (sum, a) => sum + a.reward);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Succès',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatistic(
                  'Succès',
                  '$unlockedCount/${_achievements.length}',
                  Icons.emoji_events,
                  AppColors.gold,
                ),
                _buildStatistic(
                  'Récompenses',
                  '$totalRewards pièces',
                  Icons.monetization_on,
                  AppColors.coins,
                ),
                _buildStatistic(
                  'Progression',
                  '${((unlockedCount / _achievements.length) * 100).toInt()}%',
                  Icons.trending_up,
                  AppColors.success,
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
                  'Tous',
                  'Progression',
                  'Score',
                  'Collection',
                  'Jeu',
                  'Social',
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
                      label: Text(category),
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

  List<Achievement> _getFilteredAchievements() {
    if (_selectedCategory == 'Tous') {
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
                              child: const Text(
                                'TERMINÉ',
                                style: TextStyle(
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

                      // Récompense
                      Row(
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: AppColors.coins,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '+${achievement.reward} pièces',
                            style: TextStyle(
                              color: AppColors.coins,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            achievement.category,
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
                            achievement.category,
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
                'Description',
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
                  'Progression',
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
                            'Récompense',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '+${achievement.reward} pièces',
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

              // Bouton d'action
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
                        ? 'Récompense réclamée'
                        : 'En cours...',
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
        content: Text('Récompense de ${achievement.title} réclamée !'),
        backgroundColor: AppColors.success,
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
