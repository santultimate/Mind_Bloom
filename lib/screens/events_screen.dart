import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/providers/audio_provider.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final List<SeasonalEvent> _events = [
    SeasonalEvent(
      id: 'spring_bloom',
      name: 'Floraison de Printemps',
      description: 'Célébrez le renouveau avec des fleurs magiques',
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 10)),
      theme: 'spring',
      rewards: [
        EventReward(
          type: RewardType.plant,
          itemId: 'rose_magique',
          quantity: 1,
          rarity: 5,
        ),
        EventReward(
          type: RewardType.coins,
          quantity: 500,
        ),
        EventReward(
          type: RewardType.gems,
          quantity: 50,
        ),
      ],
      challenges: [
        EventChallenge(
          id: 'complete_levels',
          description: 'Terminez 10 niveaux',
          target: 10,
          progress: 7,
          reward: 100,
        ),
        EventChallenge(
          id: 'earn_stars',
          description: 'Gagnez 30 étoiles',
          target: 30,
          progress: 18,
          reward: 200,
        ),
        EventChallenge(
          id: 'use_boosters',
          description: 'Utilisez 5 boosters',
          target: 5,
          progress: 3,
          reward: 150,
        ),
      ],
      isActive: true,
    ),
    SeasonalEvent(
      id: 'summer_solstice',
      name: 'Solstice d\'Été',
      description: 'Profitez du soleil avec des plantes ensoleillées',
      startDate: DateTime.now().add(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 30)),
      theme: 'summer',
      rewards: [
        EventReward(
          type: RewardType.plant,
          itemId: 'tournesol_or',
          quantity: 1,
          rarity: 4,
        ),
        EventReward(
          type: RewardType.coins,
          quantity: 300,
        ),
      ],
      challenges: [
        EventChallenge(
          id: 'score_points',
          description: 'Marquez 50,000 points',
          target: 50000,
          progress: 0,
          reward: 250,
        ),
      ],
      isActive: false,
    ),
    SeasonalEvent(
      id: 'autumn_harvest',
      name: 'Récolte d\'Automne',
      description: 'Récoltez les fruits de vos efforts',
      startDate: DateTime.now().add(const Duration(days: 45)),
      endDate: DateTime.now().add(const Duration(days: 60)),
      theme: 'autumn',
      rewards: [
        EventReward(
          type: RewardType.plant,
          itemId: 'lotus_cristal',
          quantity: 1,
          rarity: 5,
        ),
      ],
      challenges: [],
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Événements',
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
          // Bannière d'événement actif
          if (_events.any((e) => e.isActive))
            _buildActiveEventBanner(_events.firstWhere((e) => e.isActive)),

          // Liste des événements
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _events.length,
              itemBuilder: (context, index) {
                return _buildEventCard(_events[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveEventBanner(SeasonalEvent event) {
    final daysLeft = event.endDate.difference(DateTime.now()).inDays;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.accent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.event,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ÉVÉNEMENT ACTIF',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      event.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            event.description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: Colors.white.withValues(alpha: 0.8),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '$daysLeft jours restants',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _showEventDetails(event),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Participer',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(SeasonalEvent event) {
    final isActive = event.isActive;
    final daysUntilStart = event.startDate.difference(DateTime.now()).inDays;
    final daysLeft = event.endDate.difference(DateTime.now()).inDays;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.accent.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: InkWell(
          onTap: () => _showEventDetails(event),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary.withValues(alpha: 0.2)
                            : AppColors.textSecondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getEventIcon(event.theme),
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          Text(
                            isActive
                                ? '$daysLeft jours restants'
                                : 'Commence dans $daysUntilStart jours',
                            style: TextStyle(
                              color: isActive
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'ACTIF',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  event.description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 12),

                // Récompenses
                if (event.rewards.isNotEmpty) ...[
                  Text(
                    'Récompenses',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: event.rewards.take(3).map((reward) {
                      return _buildRewardChip(reward);
                    }).toList(),
                  ),
                  if (event.rewards.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '+${event.rewards.length - 3} autres',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],

                const SizedBox(height: 12),

                // Progression des défis
                if (isActive && event.challenges.isNotEmpty) ...[
                  Text(
                    'Progression',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ...event.challenges.map((challenge) {
                    return _buildChallengeProgress(challenge);
                  }),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRewardChip(EventReward reward) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getRewardColor(reward.type).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getRewardColor(reward.type).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getRewardIcon(reward.type),
            color: _getRewardColor(reward.type),
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            _getRewardText(reward),
            style: TextStyle(
              color: _getRewardColor(reward.type),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeProgress(EventChallenge challenge) {
    final progress = challenge.progress / challenge.target;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  challenge.description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                '${challenge.progress}/${challenge.target}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.textSecondary.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 1.0 ? AppColors.success : AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.monetization_on,
                color: AppColors.coins,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                '+${challenge.reward}',
                style: TextStyle(
                  color: AppColors.coins,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (progress >= 1.0) ...[
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'TERMINÉ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  IconData _getEventIcon(String theme) {
    switch (theme) {
      case 'spring':
        return Icons.local_florist;
      case 'summer':
        return Icons.wb_sunny;
      case 'autumn':
        return Icons.eco;
      case 'winter':
        return Icons.ac_unit;
      default:
        return Icons.event;
    }
  }

  IconData _getRewardIcon(RewardType type) {
    switch (type) {
      case RewardType.coins:
        return Icons.monetization_on;
      case RewardType.gems:
        return Icons.diamond;
      case RewardType.plant:
        return Icons.eco;
      case RewardType.booster:
        return Icons.rocket_launch;
    }
  }

  Color _getRewardColor(RewardType type) {
    switch (type) {
      case RewardType.coins:
        return AppColors.coins;
      case RewardType.gems:
        return AppColors.gold;
      case RewardType.plant:
        return AppColors.primary;
      case RewardType.booster:
        return AppColors.accent;
    }
  }

  String _getRewardText(EventReward reward) {
    switch (reward.type) {
      case RewardType.coins:
        return '${reward.quantity} pièces';
      case RewardType.gems:
        return '${reward.quantity} gemmes';
      case RewardType.plant:
        return 'Plante ${reward.rarity}★';
      case RewardType.booster:
        return '${reward.quantity} boosters';
    }
  }

  void _showEventDetails(SeasonalEvent event) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSfx('audio/sfx/button_click.wav');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getEventIcon(event.theme),
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                        Text(
                          '${event.startDate.day}/${event.startDate.month} - ${event.endDate.day}/${event.endDate.month}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
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
                event.description,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              // Récompenses
              Text(
                'Récompenses',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: event.rewards.length,
                  itemBuilder: (context, index) {
                    return _buildRewardItem(event.rewards[index]);
                  },
                ),
              ),

              // Défis
              if (event.challenges.isNotEmpty) ...[
                Text(
                  'Défis',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: event.challenges.length,
                    itemBuilder: (context, index) {
                      return _buildChallengeItem(event.challenges[index]);
                    },
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Bouton d'action
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      event.isActive ? () => _participateInEvent(event) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: event.isActive
                        ? AppColors.primary
                        : AppColors.textSecondary.withValues(alpha: 0.3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    event.isActive ? 'Participer' : 'Bientôt disponible',
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

  Widget _buildRewardItem(EventReward reward) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getRewardColor(reward.type).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getRewardColor(reward.type).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getRewardColor(reward.type).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getRewardIcon(reward.type),
              color: _getRewardColor(reward.type),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getRewardText(reward),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                if (reward.type == RewardType.plant)
                  Text(
                    'Plante rare ${reward.rarity} étoiles',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeItem(EventChallenge challenge) {
    final progress = challenge.progress / challenge.target;
    final isCompleted = progress >= 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.textSecondary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color:
                    isCompleted ? AppColors.success : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  challenge.description,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${challenge.progress}/${challenge.target}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.textSecondary.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              isCompleted ? AppColors.success : AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.monetization_on,
                color: AppColors.coins,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '+${challenge.reward} pièces',
                style: TextStyle(
                  color: AppColors.coins,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (isCompleted)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(8),
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
        ],
      ),
    );
  }

  void _participateInEvent(SeasonalEvent event) {
    // TODO: Implémenter la participation aux événements
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Participation à ${event.name} en cours...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

class SeasonalEvent {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String theme;
  final List<EventReward> rewards;
  final List<EventChallenge> challenges;
  final bool isActive;

  SeasonalEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.theme,
    required this.rewards,
    required this.challenges,
    required this.isActive,
  });
}

class EventReward {
  final RewardType type;
  final String? itemId;
  final int quantity;
  final int? rarity;

  EventReward({
    required this.type,
    this.itemId,
    required this.quantity,
    this.rarity,
  });
}

class EventChallenge {
  final String id;
  final String description;
  final int target;
  final int progress;
  final int reward;

  EventChallenge({
    required this.id,
    required this.description,
    required this.target,
    required this.progress,
    required this.reward,
  });
}

enum RewardType {
  coins,
  gems,
  plant,
  booster,
}
