import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/providers/event_provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';
// import 'package:mind_bloom/providers/collection_provider.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeEvents();
  }

  Future<void> _initializeEvents() async {
    try {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      await eventProvider.initialize();
    } catch (e) {
      // Gérer les erreurs silencieusement
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.events,
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
            onPressed: () {
              final audioProvider =
                  Provider.of<AudioProvider>(context, listen: false);
              audioProvider.playButtonClick();
              _showEventFilterDialog();
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: SafeArea(
        child: _isInitializing
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.loadingEvents,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : Consumer<EventProvider>(
                builder: (context, eventProvider, child) {
                  if (eventProvider.annualEventsData == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.loadingEvents,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final activeEvents = eventProvider.getActiveEvents();
                  final upcomingEvents = eventProvider.getUpcomingEvents();
                  final currentMonthEvents =
                      eventProvider.getCurrentMonthEvents();

                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _isInitializing = true;
                      });
                      await _initializeEvents();
                    },
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Bannière d'événement actif
                        if (activeEvents.isNotEmpty)
                          _buildActiveEventBanner(
                              activeEvents.first, eventProvider),

                        const SizedBox(height: 16),

                        // Événements actifs
                        if (activeEvents.isNotEmpty) ...[
                          _buildSectionHeader(
                              AppLocalizations.of(context)!.activeEvents,
                              Icons.event_available),
                          const SizedBox(height: 8),
                          ...activeEvents.map(
                              (event) => _buildEventCard(event, eventProvider)),
                          const SizedBox(height: 24),
                        ],

                        // Événements de ce mois
                        if (currentMonthEvents.isNotEmpty) ...[
                          _buildSectionHeader(
                              AppLocalizations.of(context)!.thisMonth,
                              Icons.calendar_month),
                          const SizedBox(height: 8),
                          ...currentMonthEvents.take(3).map(
                              (event) => _buildEventCard(event, eventProvider)),
                          const SizedBox(height: 24),
                        ],

                        // Événements à venir
                        if (upcomingEvents.isNotEmpty) ...[
                          _buildSectionHeader(
                              AppLocalizations.of(context)!.upcomingEvents,
                              Icons.schedule),
                          const SizedBox(height: 8),
                          ...upcomingEvents.take(5).map(
                              (event) => _buildEventCard(event, eventProvider)),
                          const SizedBox(height: 24),
                        ],

                        // Statistiques
                        _buildEventStatistics(eventProvider),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveEventBanner(
      Map<String, dynamic> event, EventProvider eventProvider) {
    final endDate = DateTime.parse(event['end_date']);
    final daysLeft = endDate.difference(DateTime.now()).inDays;
    final theme = event['theme'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getThemeColors(theme),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.event_available,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getEventName(context, event),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getEventDescription(context, event),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  daysLeft > 0
                      ? AppLocalizations.of(context)!.daysRemaining(daysLeft)
                      : AppLocalizations.of(context)!.lastDay,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _participateInEvent(event, eventProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.participate,
                  style: const TextStyle(
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

  Widget _buildEventCard(
      Map<String, dynamic> event, EventProvider eventProvider) {
    final startDate = DateTime.parse(event['start_date']);
    final endDate = DateTime.parse(event['end_date']);
    final now = DateTime.now();
    final isActive = now.isAfter(startDate) && now.isBefore(endDate);
    final isUpcoming = startDate.isAfter(now);
    final daysUntilStart = startDate.difference(now).inDays;
    final daysLeft = endDate.difference(now).inDays;
    final theme = event['theme'] as String;
    final challenges = event['challenges'] as List<dynamic>? ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isActive
              ? LinearGradient(
                  colors: _getThemeColors(theme),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive ? null : AppColors.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white.withValues(alpha: 0.2)
                          : AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getEventIcon(event['type'] as String),
                      color: isActive ? Colors.white : AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getEventName(context, event),
                          style: TextStyle(
                            color:
                                isActive ? Colors.white : AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getEventDescription(context, event),
                          style: TextStyle(
                            color: isActive
                                ? Colors.white.withValues(alpha: 0.8)
                                : AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white.withValues(alpha: 0.2)
                          : AppColors.accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isActive
                          ? (daysLeft > 0
                              ? AppLocalizations.of(context)!.daysLeft(daysLeft)
                              : AppLocalizations.of(context)!.lastDay)
                          : isUpcoming
                              ? AppLocalizations.of(context)!
                                  .inDays(daysUntilStart)
                              : AppLocalizations.of(context)!.finished,
                      style: TextStyle(
                        color: isActive ? Colors.white : AppColors.textPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (challenges.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!
                      .challengesCount(challenges.length),
                  style: TextStyle(
                    color: isActive ? Colors.white : AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...challenges
                    .take(2)
                    .map((challenge) => _buildChallengeProgress(
                          challenge,
                          event['id'] as String,
                          eventProvider,
                          isActive,
                        )),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  if (isActive) ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            _participateInEvent(event, eventProvider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.participate,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ] else if (isUpcoming) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: null,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: AppColors.primary.withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.comingSoon,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: null,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: AppColors.textSecondary
                                  .withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.finished,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeProgress(
    Map<String, dynamic> challenge,
    String eventId,
    EventProvider eventProvider,
    bool isActive,
  ) {
    final challengeId = challenge['id'] as String;
    final target = challenge['target'] as int;
    final progress = eventProvider.getChallengeProgress(eventId, challengeId);
    final isCompleted = progress >= target;
    final progressPercent =
        target > 0 ? (progress / target).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _getChallengeDescription(context, challenge),
                  style: TextStyle(
                    color: isActive
                        ? Colors.white.withValues(alpha: 0.9)
                        : AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ),
              Text(
                '$progress/$target',
                style: TextStyle(
                  color: isActive ? Colors.white : AppColors.textPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progressPercent,
            backgroundColor: isActive
                ? Colors.white.withValues(alpha: 0.2)
                : AppColors.primary.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
              isCompleted
                  ? Colors.green
                  : isActive
                      ? Colors.white
                      : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventStatistics(EventProvider eventProvider) {
    final stats = eventProvider.getEventStatistics();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.eventStatistics,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    AppLocalizations.of(context)!.events,
                    '${stats['total_events']}',
                    Icons.event,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    AppLocalizations.of(context)!.active,
                    '${stats['active_events']}',
                    Icons.event_available,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    AppLocalizations.of(context)!.challenges,
                    '${stats['challenges_completed']}',
                    Icons.emoji_events,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    AppLocalizations.of(context)!.rewards,
                    '${stats['rewards_claimed']}',
                    Icons.card_giftcard,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  void _showEventFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.filterEvents),
        content: Text(AppLocalizations.of(context)!.filterFeatureComingSoon),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  /// 🎁 AMÉLIORÉ: Ouvre un dialogue détaillé avec les challenges et récompenses
  void _participateInEvent(
      Map<String, dynamic> event, EventProvider eventProvider) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playButtonClick();

    // Ouvrir le dialogue de détails de l'événement
    _showEventDetailsDialog(event, eventProvider);
  }

  /// Affiche le dialogue de détails d'un événement avec les récompenses
  void _showEventDetailsDialog(
      Map<String, dynamic> event, EventProvider eventProvider) {
    final eventId = event['id'] as String;
    final challenges = event['challenges'] as List<dynamic>? ?? [];
    final rewards = event['rewards'] as List<dynamic>? ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(_getEventIcon(event['type'] as String),
                color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _getEventName(context, event),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getEventDescription(context, event),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              
              // Challenges
              Text(
                AppLocalizations.of(context)!.challenges,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ...challenges.map((challenge) {
                final challengeId = challenge['id'] as String;
                final progress =
                    eventProvider.getChallengeProgress(eventId, challengeId);
                final target = challenge['target'] as int;
                final isCompleted = progress >= target;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCompleted
                          ? AppColors.success
                          : AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isCompleted ? Icons.check_circle : Icons.circle_outlined,
                            color: isCompleted ? AppColors.success : AppColors.textSecondary,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getChallengeDescription(context, challenge),
                              style: TextStyle(
                                fontSize: 12,
                                color: isCompleted
                                    ? AppColors.success
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: target > 0 ? progress / target : 0,
                              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isCompleted ? AppColors.success : AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$progress/$target',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
              
              const SizedBox(height: 16),
              
              // Récompenses
              Text(
                AppLocalizations.of(context)!.rewards,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: rewards.map((reward) {
                  return _buildRewardChip(reward);
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.close),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _claimEventRewards(event, eventProvider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: Text(AppLocalizations.of(context)!.claim_rewards),
          ),
        ],
      ),
    );
  }

  /// Construit un chip de récompense
  Widget _buildRewardChip(Map<String, dynamic> reward) {
    final type = reward['type'] as String;
    final quantity = reward['quantity'] as int? ?? 1;
    final itemId = reward['item_id'] as String?;
    final rarity = reward['rarity'] as int? ?? 1;

    IconData icon;
    Color color;
    String label;

    switch (type) {
      case 'plant':
        icon = Icons.eco;
        color = _getRarityColor(rarity);
        label = itemId != null ? _getPlantName(itemId) : AppLocalizations.of(context)!.plant;
        break;
      case 'coins':
        icon = Icons.monetization_on;
        color = const Color(0xFFFFD700);
        label = '$quantity ${AppLocalizations.of(context)!.coins}';
        break;
      case 'gems':
        icon = Icons.diamond;
        color = const Color(0xFF9C27B0);
        label = '$quantity ${AppLocalizations.of(context)!.gems}';
        break;
      case 'lives':
        icon = Icons.favorite;
        color = const Color(0xFFF44336);
        label = '$quantity ${AppLocalizations.of(context)!.lives}';
        break;
      default:
        icon = Icons.card_giftcard;
        color = AppColors.primary;
        label = AppLocalizations.of(context)!.reward;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Obtient la couleur selon la rareté
  Color _getRarityColor(int rarity) {
    switch (rarity) {
      case 5:
        return const Color(0xFFFFD700); // Or (Légendaire)
      case 4:
        return const Color(0xFF9C27B0); // Violet (Épique)
      case 3:
        return const Color(0xFF2196F3); // Bleu (Rare)
      case 2:
        return const Color(0xFF4CAF50); // Vert (Peu commun)
      default:
        return const Color(0xFF9E9E9E); // Gris (Commun)
    }
  }

  /// Obtient le nom d'une plante depuis son ID
  String _getPlantName(String plantId) {
    final plantNames = {
      'rose_magique': 'Rose Magique',
      'lotus_cristal': 'Lotus de Cristal',
      'tulipe_arc': 'Tulipe Arc-en-ciel',
      'orchidee_lune': 'Orchidée de Lune',
      'tournesol_or': 'Tournesol Doré',
      'marguerite_etoile': 'Marguerite Étoilée',
      'violette_mystique': 'Violette Mystique',
      'jasmin_eternel': 'Jasmin Éternel',
      'petunia_cosmique': 'Pétunia Cosmique',
      'cactus_temporel': 'Cactus Temporel',
      'rose_eternelle': 'Rose Éternelle',
      'lotus_paradis': 'Lotus du Paradis',
      'tournesol_solaire': 'Tournesol Solaire',
      'nymphaea_mystique': 'Nymphaea Mystique',
      'lys_phoenix': 'Lys du Phénix',
      'orchidee_lunaire': 'Orchidée Lunaire',
      'cristal_vegetal': 'Cristal Végétal',
      'flamme_vegetale': 'Flamme Végétale',
      'glace_eternelle': 'Glace Éternelle',
      'arc_en_ciel_perdu': 'Arc-en-ciel Perdu',
    };
    return plantNames[plantId] ?? plantId;
  }

  /// 🎁 Réclame les récompenses d'un événement
  void _claimEventRewards(
      Map<String, dynamic> event, EventProvider eventProvider) async {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // final collectionProvider =
    //     Provider.of<CollectionProvider>(context, listen: false);

    final eventId = event['id'] as String;
    final challenges = event['challenges'] as List<dynamic>? ?? [];
    final rewards = event['rewards'] as List<dynamic>? ?? [];

    // Vérifier que tous les challenges sont complétés
    bool allCompleted = true;
    for (final challenge in challenges) {
      final challengeId = challenge['id'] as String;
      if (!eventProvider.isChallengeCompleted(eventId, challengeId)) {
        allCompleted = false;
        break;
      }
    }

    if (!allCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.complete_all_challenges),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Vérifier si les récompenses ont déjà été réclamées
    final eventProgress = eventProvider.getUserEventProgress(eventId);
    final rewardsClaimed = eventProgress['rewards_claimed'] as bool? ?? false;

    if (rewardsClaimed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.rewards_already_claimed),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Distribuer les récompenses
    for (final reward in rewards) {
      final type = reward['type'] as String;
      final quantity = reward['quantity'] as int? ?? 1;
      final itemId = reward['item_id'] as String?;

      switch (type) {
        case 'plant':
          if (itemId != null) {
            // 🌸 Débloquer la plante dans la collection
            // CollectionProvider gère automatiquement le déverrouillage
            if (kDebugMode) {
              debugPrint('🌸 Plante débloquée: $itemId');
            }
          }
          break;
        case 'coins':
          await userProvider.addCoins(quantity);
          break;
        case 'gems':
          await userProvider.addGems(quantity);
          break;
        case 'lives':
          for (int i = 0; i < quantity; i++) {
            await userProvider.refillLives();
          }
          break;
      }
    }

    // Marquer les récompenses comme réclamées
    await eventProvider.updateUserEventProgress(eventId, {
      ...eventProgress,
      'rewards_claimed': true,
      'claim_date': DateTime.now().toIso8601String(),
    });

    audioProvider.playLevelComplete(); // Son de victoire

    // Afficher le dialogue de récompenses
    _showRewardsClaimedDialog(rewards);
  }

  /// Affiche un dialogue magnifique pour montrer les récompenses obtenues
  void _showRewardsClaimedDialog(List<dynamic> rewards) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.card_giftcard,
                color: AppColors.success,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.congratulations,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.you_earned,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: rewards.map((reward) {
                return _buildRewardDisplay(reward);
              }).toList(),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Si la récompense inclut une plante, ouvrir la collection
              final hasPlant = rewards.any((r) => r['type'] == 'plant');
              if (hasPlant) {
                _navigateToCollection();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.awesome,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Affichage d'une récompense dans le dialogue
  Widget _buildRewardDisplay(Map<String, dynamic> reward) {
    final type = reward['type'] as String;
    final quantity = reward['quantity'] as int? ?? 1;
    final itemId = reward['item_id'] as String?;
    final rarity = reward['rarity'] as int? ?? 1;

    IconData icon;
    Color color;
    String label;
    String subtitle;

    switch (type) {
      case 'plant':
        icon = Icons.eco;
        color = _getRarityColor(rarity);
        label = itemId != null ? _getPlantName(itemId) : AppLocalizations.of(context)!.plant;
        subtitle = _getRarityName(rarity);
        break;
      case 'coins':
        icon = Icons.monetization_on;
        color = const Color(0xFFFFD700);
        label = '+$quantity';
        subtitle = AppLocalizations.of(context)!.coins;
        break;
      case 'gems':
        icon = Icons.diamond;
        color = const Color(0xFF9C27B0);
        label = '+$quantity';
        subtitle = AppLocalizations.of(context)!.gems;
        break;
      case 'lives':
        icon = Icons.favorite;
        color = const Color(0xFFF44336);
        label = '+$quantity';
        subtitle = AppLocalizations.of(context)!.lives;
        break;
      default:
        icon = Icons.card_giftcard;
        color = AppColors.primary;
        label = AppLocalizations.of(context)!.reward;
        subtitle = '';
    }

    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: color.withValues(alpha: 0.7),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Obtient le nom de la rareté
  String _getRarityName(int rarity) {
    switch (rarity) {
      case 5:
        return AppLocalizations.of(context)!.legendary;
      case 4:
        return AppLocalizations.of(context)!.epic;
      case 3:
        return AppLocalizations.of(context)!.rare;
      case 2:
        return AppLocalizations.of(context)!.uncommon;
      default:
        return AppLocalizations.of(context)!.common;
    }
  }

  /// Navigue vers l'écran de collection
  void _navigateToCollection() {
    // Cette navigation sera gérée par le parent (HomeScreen)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.check_your_collection),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.view,
          textColor: Colors.white,
          onPressed: () {
            // Navigation vers la collection
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  List<Color> _getThemeColors(String theme) {
    switch (theme) {
      case 'spring':
        return [const Color(0xFF4CAF50), const Color(0xFF8BC34A)];
      case 'summer':
        return [const Color(0xFFFF9800), const Color(0xFFFFC107)];
      case 'autumn':
        return [const Color(0xFFFF5722), const Color(0xFFFF9800)];
      case 'winter':
        return [const Color(0xFF2196F3), const Color(0xFF03A9F4)];
      case 'easter':
        return [const Color(0xFFE91E63), const Color(0xFFF06292)];
      case 'halloween':
        return [const Color(0xFF9C27B0), const Color(0xFF673AB7)];
      case 'christmas':
        return [const Color(0xFFF44336), const Color(0xFFE91E63)];
      case 'valentine':
        return [const Color(0xFFE91E63), const Color(0xFFF8BBD9)];
      default:
        return [AppColors.primary, AppColors.accent];
    }
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'seasonal':
        return Icons.wb_sunny;
      case 'holiday':
        return Icons.celebration;
      case 'special':
        return Icons.star;
      case 'update':
        return Icons.system_update;
      case 'awareness':
        return Icons.eco;
      default:
        return Icons.event;
    }
  }

  /// Obtient le nom traduit d'un événement
  String _getEventName(BuildContext context, Map<String, dynamic> event) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final nameKey = event['name_key'] as String?;

    if (nameKey != null) {
      switch (nameKey) {
        case 'springBloom':
          return l10n.springBloom;
        case 'easterEvent':
          return l10n.easterEvent;
        case 'earthDayEvent':
          return locale.languageCode == 'en' ? 'Earth Day' : 'Jour de la Terre';
        case 'summerSolstice':
          return l10n.summerSolstice;
        case 'independenceDayEvent':
          return locale.languageCode == 'en'
              ? 'Independence Day'
              : 'Fête Nationale';
        case 'summerFestivalEvent':
          return locale.languageCode == 'en'
              ? 'Summer Festival'
              : 'Festival d\'Été';
        case 'autumnHarvest':
          return locale.languageCode == 'en'
              ? 'Autumn Harvest'
              : 'Récolte d\'Automne';
        case 'halloweenEvent':
          return locale.languageCode == 'en' ? 'Halloween' : 'Halloween';
        case 'thanksgivingEvent':
          return locale.languageCode == 'en'
              ? 'Thanksgiving'
              : 'Action de Grâce';
        case 'winterSolstice':
          return locale.languageCode == 'en'
              ? 'Winter Solstice'
              : 'Solstice d\'Hiver';
        case 'christmasEvent':
          return locale.languageCode == 'en' ? 'Christmas' : 'Noël';
        case 'newYearEvent':
          return locale.languageCode == 'en' ? 'New Year' : 'Nouvel An';
        case 'valentineDay':
          return locale.languageCode == 'en'
              ? 'Valentine\'s Day'
              : 'Saint-Valentin';
        case 'birthdayEvent':
          return locale.languageCode == 'en' ? 'Birthday' : 'Anniversaire';
        case 'specialUpdateEvent':
          return locale.languageCode == 'en'
              ? 'Special Update'
              : 'Mise à Jour Spéciale';
        default:
          return event['name'] as String? ??
              (locale.languageCode == 'en' ? 'Event' : 'Événement');
      }
    }

    return event['name'] as String? ??
        (locale.languageCode == 'en' ? 'Event' : 'Événement');
  }

  /// Obtient la description traduite d'un événement
  String _getEventDescription(
      BuildContext context, Map<String, dynamic> event) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final descriptionKey = event['description_key'] as String?;

    if (descriptionKey != null) {
      switch (descriptionKey) {
        case 'springBloomDescription':
          return l10n.springBloomDescription;
        case 'easterEventDescription':
          return l10n.easterEventDescription;
        case 'earthDayEventDescription':
          return locale.languageCode == 'en'
              ? 'Protect nature with eco-friendly plants'
              : 'Protégez la nature avec des plantes écologiques';
        case 'summerSolsticeDescription':
          return l10n.summerSolsticeDescription;
        case 'independenceDayEventDescription':
          return locale.languageCode == 'en'
              ? 'Celebrate with patriotic plants'
              : 'Célébrez avec des plantes patriotiques';
        case 'summerFestivalEventDescription':
          return locale.languageCode == 'en'
              ? 'Grand summer festival with many rewards'
              : 'Grand festival estival avec de nombreuses récompenses';
        case 'autumnHarvestDescription':
          return locale.languageCode == 'en'
              ? 'Harvest the fruits of your work with autumn plants'
              : 'Récoltez les fruits de votre travail avec des plantes d\'automne';
        case 'halloweenEventDescription':
          return locale.languageCode == 'en'
              ? 'Mysterious plants and spooky rewards'
              : 'Plantes mystérieuses et récompenses effrayantes';
        case 'thanksgivingEventDescription':
          return locale.languageCode == 'en'
              ? 'Give thanks with gratitude plants'
              : 'Remerciez avec des plantes de gratitude';
        case 'winterSolsticeDescription':
          return locale.languageCode == 'en'
              ? 'Celebrate the shortest day with winter plants'
              : 'Célébrez le jour le plus court avec des plantes hivernales';
        case 'christmasEventDescription':
          return locale.languageCode == 'en'
              ? 'Gifts and Christmas plants for everyone'
              : 'Cadeaux et plantes de Noël pour tous';
        case 'newYearEventDescription':
          return locale.languageCode == 'en'
              ? 'Start the year with new plants'
              : 'Commencez l\'année avec de nouvelles plantes';
        case 'valentineDayDescription':
          return locale.languageCode == 'en'
              ? 'Love plants and romantic rewards'
              : 'Plantes d\'amour et récompenses romantiques';
        case 'birthdayEventDescription':
          return locale.languageCode == 'en'
              ? 'Celebrate one year of gaming with special rewards'
              : 'Célébrez un an de jeu avec des récompenses spéciales';
        case 'specialUpdateEventDescription':
          return locale.languageCode == 'en'
              ? 'New features and improvements'
              : 'Nouvelles fonctionnalités et améliorations';
        default:
          return event['description'] as String? ??
              (locale.languageCode == 'en'
                  ? 'Event description'
                  : 'Description de l\'événement');
      }
    }

    return event['description'] as String? ??
        (locale.languageCode == 'en'
            ? 'Event description'
            : 'Description de l\'événement');
  }

  /// Obtient la description traduite d'un défi
  String _getChallengeDescription(
      BuildContext context, Map<String, dynamic> challenge) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final descriptionKey = challenge['description_key'] as String?;
    final descriptionParams =
        challenge['description_params'] as Map<String, dynamic>?;

    if (descriptionKey != null && descriptionParams != null) {
      switch (descriptionKey) {
        case 'completeLevels':
          final target = descriptionParams['target'] as int? ?? 0;
          final levelType = descriptionParams['levelType'] as String?;
          if (levelType != null) {
            return locale.languageCode == 'en'
                ? 'Complete $target $levelType levels'
                : 'Terminez $target niveaux $levelType';
          }
          return l10n.completeLevels(target);
        case 'earnStars':
          final target = descriptionParams['target'] as int? ?? 0;
          return l10n.earnStars(target);
        case 'scorePoints':
          final target = descriptionParams['target'] as int? ?? 0;
          return l10n.scorePoints(target);
        case 'collectTilesObjective':
          final count = descriptionParams['count'] as int? ?? 0;
          final tileName = descriptionParams['tileName'] as String? ?? '';
          return l10n.collectTilesObjective(count, tileName);
        case 'completeActions':
          final target = descriptionParams['target'] as int? ?? 0;
          final actionType = descriptionParams['actionType'] as String? ?? '';
          return locale.languageCode == 'en'
              ? 'Complete $target $actionType actions'
              : 'Effectuez $target actions $actionType';
        case 'playConsecutiveDays':
          final target = descriptionParams['target'] as int? ?? 0;
          return locale.languageCode == 'en'
              ? 'Play for $target consecutive days'
              : 'Jouez $target jours consécutifs';
        case 'completeLevelsWithStars':
          final target = descriptionParams['target'] as int? ?? 0;
          final stars = descriptionParams['stars'] as int? ?? 0;
          return locale.languageCode == 'en'
              ? 'Complete $target levels with $stars stars'
              : 'Terminez $target niveaux avec $stars étoiles';
        case 'completeQuests':
          final target = descriptionParams['target'] as int? ?? 0;
          final questType = descriptionParams['questType'] as String? ?? '';
          return locale.languageCode == 'en'
              ? 'Complete $target $questType quests'
              : 'Terminez $target quêtes $questType';
        case 'collectItems':
          final target = descriptionParams['target'] as int? ?? 0;
          final itemType = descriptionParams['itemType'] as String? ?? '';
          return locale.languageCode == 'en'
              ? 'Collect $target $itemType items'
              : 'Collectez $target objets $itemType';
        case 'completeLevelsInDays':
          final target = descriptionParams['target'] as int? ?? 0;
          final days = descriptionParams['days'] as int? ?? 0;
          return locale.languageCode == 'en'
              ? 'Complete $target levels in $days days'
              : 'Terminez $target niveaux en $days jours';
        case 'giveGifts':
          final target = descriptionParams['target'] as int? ?? 0;
          return locale.languageCode == 'en'
              ? 'Give $target gifts'
              : 'Offrez $target cadeaux';
        case 'exploreNewFeatures':
          return locale.languageCode == 'en'
              ? 'Explore the new features'
              : 'Explorez les nouvelles fonctionnalités';
        default:
          return challenge['description'] as String? ??
              (locale.languageCode == 'en' ? 'Challenge' : 'Défi');
      }
    }

    return challenge['description'] as String? ??
        (locale.languageCode == 'en' ? 'Challenge' : 'Défi');
  }
}
