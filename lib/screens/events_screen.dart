import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/providers/event_provider.dart';
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

  void _participateInEvent(
      Map<String, dynamic> event, EventProvider eventProvider) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playButtonClick();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!
            .participatingInEvent(_getEventName(context, event))),
        backgroundColor: AppColors.primary,
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
