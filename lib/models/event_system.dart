/// Système de gestion des événements avec planification annuelle
/// Évite les mises à jour fréquentes en prévoyant tous les événements de l'année
class EventSystem {
  /// Génère tous les événements de l'année en cours
  static Map<String, dynamic> generateAnnualEvents(int year) {
    return {
      'year': year,
      'events': _generateYearlyEvents(year),
      'special_dates': _generateSpecialDates(year),
      'seasonal_themes': _generateSeasonalThemes(year),
    };
  }

  /// Génère les événements saisonniers pour une année donnée
  static List<Map<String, dynamic>> _generateYearlyEvents(int year) {
    return [
      // ÉVÉNEMENTS DE PRINTEMPS (Mars - Mai)
      _createSpringEvent(year),
      _createEasterEvent(year),
      _createEarthDayEvent(year),

      // ÉVÉNEMENTS D'ÉTÉ (Juin - Août)
      _createSummerSolsticeEvent(year),
      _createIndependenceDayEvent(year),
      _createSummerFestivalEvent(year),

      // ÉVÉNEMENTS D'AUTOMNE (Septembre - Novembre)
      _createAutumnHarvestEvent(year),
      _createHalloweenEvent(year),
      _createThanksgivingEvent(year),

      // ÉVÉNEMENTS D'HIVER (Décembre - Février)
      _createWinterSolsticeEvent(year),
      _createChristmasEvent(year),
      _createNewYearEvent(year),
      _createValentineEvent(year),

      // ÉVÉNEMENTS SPÉCIAUX
      _createAnniversaryEvent(year),
      ..._createSpecialUpdateEvents(year),
    ];
  }

  /// Événement de printemps - Floraison
  static Map<String, dynamic> _createSpringEvent(int year) {
    final startDate = DateTime(year, 3, 20); // Équinoxe de printemps
    return {
      'id': 'spring_bloom_$year',
      'name_key': 'springBloom',
      'description_key': 'springBloomDescription',
      'start_date': startDate.toIso8601String(),
      'end_date': startDate.add(const Duration(days: 21)).toIso8601String(),
      'theme': 'spring',
      'type': 'seasonal',
      'priority': 1,
      'rewards': [
        {
          'type': 'plant',
          'item_id': 'rose_magique',
          'quantity': 1,
          'rarity': 5,
        },
        {
          'type': 'coins',
          'quantity': 500,
        },
        {
          'type': 'gems',
          'quantity': 50,
        },
      ],
      'challenges': [
        {
          'id': 'complete_levels_spring',
          'description_key': 'completeLevels',
          'description_params': {'target': 15},
          'target': 15,
          'reward': 200,
        },
        {
          'id': 'earn_stars_spring',
          'description_key': 'earnStars',
          'description_params': {'target': 45},
          'target': 45,
          'reward': 300,
        },
      ],
    };
  }

  /// Événement de Pâques
  static Map<String, dynamic> _createEasterEvent(int year) {
    // Calcul approximatif de Pâques (premier dimanche après la première pleine lune de printemps)
    final easterDate = _calculateEaster(year);
    return {
      'id': 'easter_$year',
      'name_key': 'easterEvent',
      'description_key': 'easterEventDescription',
      'start_date':
          easterDate.subtract(const Duration(days: 3)).toIso8601String(),
      'end_date': easterDate.add(const Duration(days: 4)).toIso8601String(),
      'theme': 'easter',
      'type': 'holiday',
      'priority': 2,
      'rewards': [
        {
          'type': 'plant',
          'item_id': 'oeuf_magique',
          'quantity': 1,
          'rarity': 4,
        },
        {
          'type': 'coins',
          'quantity': 300,
        },
      ],
      'challenges': [
        {
          'id': 'find_eggs',
          'description_key': 'collectTilesObjective',
          'description_params': {'count': 10, 'tileName': 'œuf magique'},
          'target': 10,
          'reward': 150,
        },
      ],
    };
  }

  /// Événement Jour de la Terre
  static Map<String, dynamic> _createEarthDayEvent(int year) {
    final earthDay = DateTime(year, 4, 22);
    return {
      'id': 'earth_day_$year',
      'name_key': 'earthDayEvent',
      'description_key': 'earthDayEventDescription',
      'start_date':
          earthDay.subtract(const Duration(days: 2)).toIso8601String(),
      'end_date': earthDay.add(const Duration(days: 3)).toIso8601String(),
      'theme': 'eco',
      'type': 'awareness',
      'priority': 3,
      'rewards': [
        {
          'type': 'plant',
          'item_id': 'arbre_ecologique',
          'quantity': 1,
          'rarity': 3,
        },
        {
          'type': 'coins',
          'quantity': 200,
        },
      ],
      'challenges': [
        {
          'id': 'eco_actions',
          'description_key': 'completeActions',
          'description_params': {'target': 20, 'actionType': 'écologiques'},
          'target': 20,
          'reward': 100,
        },
      ],
    };
  }

  /// Événement Solstice d'Été
  static Map<String, dynamic> _createSummerSolsticeEvent(int year) {
    final solstice = DateTime(year, 6, 21);
    return {
      'id': 'summer_solstice_$year',
      'name_key': 'summerSolstice',
      'description_key': 'summerSolsticeDescription',
      'start_date':
          solstice.subtract(const Duration(days: 5)).toIso8601String(),
      'end_date': solstice.add(const Duration(days: 10)).toIso8601String(),
      'theme': 'summer',
      'type': 'seasonal',
      'priority': 1,
      'rewards': [
        {
          'type': 'plant',
          'item_id': 'tournesol_or',
          'quantity': 1,
          'rarity': 4,
        },
        {
          'type': 'coins',
          'quantity': 400,
        },
        {
          'type': 'gems',
          'quantity': 40,
        },
      ],
      'challenges': [
        {
          'id': 'score_points_summer',
          'description_key': 'scorePoints',
          'description_params': {'target': 75000},
          'target': 75000,
          'reward': 250,
        },
        {
          'id': 'sunny_days',
          'description_key': 'playConsecutiveDays',
          'description_params': {'target': 7},
          'target': 7,
          'reward': 200,
        },
      ],
    };
  }

  /// Événement Fête Nationale (adaptable selon le pays)
  static Map<String, dynamic> _createIndependenceDayEvent(int year) {
    final independenceDay = DateTime(year, 7, 4); // Adaptable
    return {
      'id': 'independence_day_$year',
      'name_key': 'independenceDayEvent',
      'description_key': 'independenceDayEventDescription',
      'start_date':
          independenceDay.subtract(const Duration(days: 2)).toIso8601String(),
      'end_date':
          independenceDay.add(const Duration(days: 3)).toIso8601String(),
      'theme': 'patriotic',
      'type': 'holiday',
      'priority': 2,
      'rewards': [
        {
          'type': 'plant',
          'item_id': 'fleur_patriotique',
          'quantity': 1,
          'rarity': 3,
        },
        {
          'type': 'coins',
          'quantity': 250,
        },
      ],
      'challenges': [
        {
          'id': 'patriotic_spirit',
          'description_key': 'completeLevelsWithStars',
          'description_params': {'target': 10, 'stars': 3},
          'target': 10,
          'reward': 150,
        },
      ],
    };
  }

  /// Festival d'Été
  static Map<String, dynamic> _createSummerFestivalEvent(int year) {
    final festivalStart = DateTime(year, 8, 1);
    return {
      'id': 'summer_festival_$year',
      'name_key': 'summerFestivalEvent',
      'description_key': 'summerFestivalEventDescription',
      'start_date': festivalStart.toIso8601String(),
      'end_date': festivalStart.add(const Duration(days: 14)).toIso8601String(),
      'theme': 'festival',
      'type': 'special',
      'priority': 1,
      'rewards': [
        {
          'type': 'plant',
          'item_id': 'plante_festival',
          'quantity': 1,
          'rarity': 5,
        },
        {
          'type': 'coins',
          'quantity': 1000,
        },
        {
          'type': 'gems',
          'quantity': 100,
        },
      ],
      'challenges': [
        {
          'id': 'festival_quests',
          'description_key': 'completeQuests',
          'description_params': {'target': 25, 'questType': 'festival'},
          'target': 25,
          'reward': 500,
        },
        {
          'id': 'festival_collection',
          'description_key': 'collectItems',
          'description_params': {'target': 50, 'itemType': 'festival'},
          'target': 50,
          'reward': 300,
        },
      ],
    };
  }

  /// Récolte d'Automne
  static Map<String, dynamic> _createAutumnHarvestEvent(int year) {
    final harvestStart = DateTime(year, 9, 22); // Équinoxe d'automne
    return {
      'id': 'autumn_harvest_$year',
      'name_key': 'autumnHarvest',
      'description_key': 'autumnHarvestDescription',
      'start_date': harvestStart.toIso8601String(),
      'end_date': harvestStart.add(const Duration(days: 21)).toIso8601String(),
      'theme': 'autumn',
      'type': 'seasonal',
      'priority': 1,
      'rewards': [
        {
          'type': 'plant',
          'item_id': 'lotus_cristal',
          'quantity': 1,
          'rarity': 4,
        },
        {
          'type': 'coins',
          'quantity': 600,
        },
        {
          'type': 'gems',
          'quantity': 60,
        },
      ],
      'challenges': [
        {
          'id': 'harvest_collection',
          'description_key': 'collectTilesObjective',
          'description_params': {'count': 30, 'tileName': 'plantes d\'automne'},
          'target': 30,
          'reward': 200,
        },
        {
          'id': 'autumn_score',
          'description_key': 'scorePoints',
          'description_params': {'target': 100000},
          'target': 100000,
          'reward': 300,
        },
      ],
    };
  }

  /// Événement Halloween
  static Map<String, dynamic> _createHalloweenEvent(int year) {
    final halloween = DateTime(year, 10, 31);
    return {
      'id': 'halloween_$year',
      'name_key': 'halloweenEvent',
      'description_key': 'halloweenEventDescription',
      'start_date':
          halloween.subtract(const Duration(days: 7)).toIso8601String(),
      'end_date': halloween.add(const Duration(days: 3)).toIso8601String(),
      'theme': 'halloween',
      'type': 'holiday',
      'priority': 2,
      'rewards': [
        {
          'type': 'plant',
          'item_id': 'plante_mystique',
          'quantity': 1,
          'rarity': 5,
        },
        {
          'type': 'coins',
          'quantity': 400,
        },
        {
          'type': 'gems',
          'quantity': 50,
        },
      ],
      'challenges': [
        {
          'id': 'spooky_levels',
          'description_key': 'completeLevels',
          'description_params': {'target': 20, 'levelType': 'mystérieux'},
          'target': 20,
          'reward': 250,
        },
        {
          'id': 'trick_or_treat',
          'description_key': 'collectTilesObjective',
          'description_params': {'count': 15, 'tileName': 'bonbons magiques'},
          'target': 15,
          'reward': 150,
        },
      ],
    };
  }

  /// Événement Thanksgiving
  static Map<String, dynamic> _createThanksgivingEvent(int year) {
    // Thanksgiving: 4ème jeudi de novembre
    final thanksgiving = _calculateThanksgiving(year);
    return {
      'id': 'thanksgiving_$year',
      'name_key': 'thanksgivingEvent',
      'description_key': 'thanksgivingEventDescription',
      'start_date':
          thanksgiving.subtract(const Duration(days: 3)).toIso8601String(),
      'end_date': thanksgiving.add(const Duration(days: 4)).toIso8601String(),
      'theme': 'gratitude',
      'type': 'holiday',
      'priority': 2,
      'rewards': [
        {
          'type': 'plant',
          'item_id': 'plante_gratitude',
          'quantity': 1,
          'rarity': 3,
        },
        {
          'type': 'coins',
          'quantity': 300,
        },
      ],
      'challenges': [
        {
          'id': 'grateful_actions',
          'description_key': 'completeActions',
          'description_params': {'target': 15, 'actionType': 'gratitude'},
          'target': 15,
          'reward': 100,
        },
      ],
    };
  }

  /// Solstice d'Hiver
  static Map<String, dynamic> _createWinterSolsticeEvent(int year) {
    final solstice = DateTime(year, 12, 21);
    return {
      'id': 'winter_solstice_$year',
      'name_key': 'winterSolstice',
      'description':
          'Célébrez la nuit la plus longue avec des plantes hivernales',
      'start_date':
          solstice.subtract(const Duration(days: 5)).toIso8601String(),
      'end_date': solstice.add(const Duration(days: 10)).toIso8601String(),
      'theme': 'winter',
      'type': 'seasonal',
      'priority': 1,
      'rewards': [
        {
          'type': 'plant',
          'item_id': 'cristal_glace',
          'quantity': 1,
          'rarity': 4,
        },
        {
          'type': 'coins',
          'quantity': 500,
        },
        {
          'type': 'gems',
          'quantity': 50,
        },
      ],
      'challenges': [
        {
          'id': 'winter_wonderland',
          'description_key': 'completeLevels',
          'description_params': {'target': 20, 'levelType': 'hivernaux'},
          'target': 20,
          'reward': 200,
        },
        {
          'id': 'snow_collection',
          'description_key': 'collectTilesObjective',
          'description_params': {'count': 25, 'tileName': 'flocons de neige'},
          'target': 25,
          'reward': 150,
        },
      ],
    };
  }

  /// Événement Noël
  static Map<String, dynamic> _createChristmasEvent(int year) {
    final christmas = DateTime(year, 12, 25);
    return {
      'id': 'christmas_$year',
      'name_key': 'christmasEvent',
      'description_key': 'christmasEventDescription',
      'start_date':
          christmas.subtract(const Duration(days: 10)).toIso8601String(),
      'end_date': christmas.add(const Duration(days: 5)).toIso8601String(),
      'theme': 'christmas',
      'type': 'holiday',
      'priority': 1,
      'rewards': [
        {
          'type': 'plant',
          'item_id': 'sapin_magique',
          'quantity': 1,
          'rarity': 5,
        },
        {
          'type': 'coins',
          'quantity': 1000,
        },
        {
          'type': 'gems',
          'quantity': 100,
        },
      ],
      'challenges': [
        {
          'id': 'christmas_spirit',
          'description_key': 'completeLevels',
          'description_params': {'target': 30, 'levelType': 'Noël'},
          'target': 30,
          'reward': 400,
        },
        {
          'id': 'gift_giving',
          'description_key': 'giveGifts',
          'description_params': {'target': 10},
          'target': 10,
          'reward': 200,
        },
      ],
    };
  }

  /// Événement Nouvel An
  static Map<String, dynamic> _createNewYearEvent(int year) {
    final newYear = DateTime(year + 1, 1, 1);
    return {
      'id': 'new_year_${year + 1}',
      'name_key': 'newYearEvent',
      'description_key': 'newYearEventDescription',
      'start_date': DateTime(year, 12, 30).toIso8601String(),
      'end_date': newYear.add(const Duration(days: 7)).toIso8601String(),
      'theme': 'new_year',
      'type': 'holiday',
      'priority': 1,
      'rewards': [
        {
          'type': 'plant',
          'item_id': 'plante_nouvelle_annee',
          'quantity': 1,
          'rarity': 4,
        },
        {
          'type': 'coins',
          'quantity': 500,
        },
        {
          'type': 'gems',
          'quantity': 75,
        },
      ],
      'challenges': [
        {
          'id': 'new_year_resolution',
          'description_key': 'completeLevelsInDays',
          'description_params': {'target': 25, 'days': 7},
          'target': 25,
          'reward': 300,
        },
        {
          'id': 'fresh_start',
          'description_key': 'earnStars',
          'description_params': {'target': 50},
          'target': 50,
          'reward': 250,
        },
      ],
    };
  }

  /// Événement Saint-Valentin
  static Map<String, dynamic> _createValentineEvent(int year) {
    final valentine = DateTime(year, 2, 14);
    return {
      'id': 'valentine_$year',
      'name_key': 'valentineDay',
      'description_key': 'valentineDayDescription',
      'start_date':
          valentine.subtract(const Duration(days: 5)).toIso8601String(),
      'end_date': valentine.add(const Duration(days: 5)).toIso8601String(),
      'theme': 'valentine',
      'type': 'holiday',
      'priority': 2,
      'rewards': [
        {
          'type': 'plant',
          'item_id': 'rose_amour',
          'quantity': 1,
          'rarity': 4,
        },
        {
          'type': 'coins',
          'quantity': 350,
        },
        {
          'type': 'gems',
          'quantity': 40,
        },
      ],
      'challenges': [
        {
          'id': 'love_quests',
          'description_key': 'completeQuests',
          'description_params': {'target': 15, 'questType': 'amour'},
          'target': 15,
          'reward': 200,
        },
        {
          'id': 'heart_collection',
          'description_key': 'collectTilesObjective',
          'description_params': {'count': 20, 'tileName': 'cœurs'},
          'target': 20,
          'reward': 150,
        },
      ],
    };
  }

  /// Événement Anniversaire de l'App
  static Map<String, dynamic> _createAnniversaryEvent(int year) {
    // Supposons que l'app est sortie le 15 mars
    final anniversary = DateTime(year, 3, 15);
    return {
      'id': 'anniversary_$year',
      'name_key': 'birthdayEvent',
      'description_key': 'birthdayEventDescription',
      'start_date':
          anniversary.subtract(const Duration(days: 7)).toIso8601String(),
      'end_date': anniversary.add(const Duration(days: 7)).toIso8601String(),
      'theme': 'anniversary',
      'type': 'special',
      'priority': 1,
      'rewards': [
        {
          'type': 'plant',
          'item_id': 'plante_anniversaire',
          'quantity': 1,
          'rarity': 5,
        },
        {
          'type': 'coins',
          'quantity': 2000,
        },
        {
          'type': 'gems',
          'quantity': 200,
        },
      ],
      'challenges': [
        {
          'id': 'anniversary_celebration',
          'description_key': 'completeLevels',
          'description_params': {'target': 50},
          'target': 50,
          'reward': 500,
        },
        {
          'id': 'loyalty_reward',
          'description_key': 'playConsecutiveDays',
          'description_params': {'target': 14},
          'target': 14,
          'reward': 300,
        },
      ],
    };
  }

  /// Événements Mise à Jour Spéciale
  static List<Map<String, dynamic>> _createSpecialUpdateEvents(int year) {
    // Événements de mise à jour (4 fois par an)
    final updates = [
      DateTime(year, 3, 1), // Printemps
      DateTime(year, 6, 1), // Été
      DateTime(year, 9, 1), // Automne
      DateTime(year, 12, 1), // Hiver
    ];

    return updates
        .map((date) => {
              'id': 'update_${date.month}_$year',
              'name_key': 'specialUpdateEvent',
              'description_key': 'specialUpdateEventDescription',
              'start_date': date.toIso8601String(),
              'end_date': date.add(const Duration(days: 14)).toIso8601String(),
              'theme': 'update',
              'type': 'update',
              'priority': 3,
              'rewards': [
                {
                  'type': 'coins',
                  'quantity': 300,
                },
                {
                  'type': 'gems',
                  'quantity': 30,
                },
              ],
              'challenges': [
                {
                  'id': 'explore_new_features',
                  'description_key': 'exploreNewFeatures',
                  'target': 5,
                  'reward': 100,
                },
              ],
            })
        .toList();
  }

  /// Génère les dates spéciales de l'année
  static Map<String, dynamic> _generateSpecialDates(int year) {
    return {
      'equinoxes': {
        'spring': DateTime(year, 3, 20).toIso8601String(),
        'autumn': DateTime(year, 9, 22).toIso8601String(),
      },
      'solstices': {
        'summer': DateTime(year, 6, 21).toIso8601String(),
        'winter': DateTime(year, 12, 21).toIso8601String(),
      },
      'holidays': {
        'easter': _calculateEaster(year).toIso8601String(),
        'thanksgiving': _calculateThanksgiving(year).toIso8601String(),
        'christmas': DateTime(year, 12, 25).toIso8601String(),
        'new_year': DateTime(year + 1, 1, 1).toIso8601String(),
        'valentine': DateTime(year, 2, 14).toIso8601String(),
        'halloween': DateTime(year, 10, 31).toIso8601String(),
      },
    };
  }

  /// Génère les thèmes saisonniers
  static Map<String, dynamic> _generateSeasonalThemes(int year) {
    return {
      'spring': {
        'colors': ['#4CAF50', '#8BC34A', '#CDDC39'],
        'plants': ['rose_magique', 'tulipe_arc_en_ciel', 'jonquille_dorée'],
        'music': 'spring_theme.mp3',
      },
      'summer': {
        'colors': ['#FF9800', '#FFC107', '#FFEB3B'],
        'plants': ['tournesol_or', 'lilas_parfumé', 'lavande_violette'],
        'music': 'summer_theme.mp3',
      },
      'autumn': {
        'colors': ['#FF5722', '#FF9800', '#FFC107'],
        'plants': ['lotus_cristal', 'érable_rouge', 'champignon_magique'],
        'music': 'autumn_theme.mp3',
      },
      'winter': {
        'colors': ['#2196F3', '#03A9F4', '#00BCD4'],
        'plants': ['cristal_glace', 'sapin_magique', 'rose_des_neiges'],
        'music': 'winter_theme.mp3',
      },
    };
  }

  /// Calcule la date de Pâques pour une année donnée
  static DateTime _calculateEaster(int year) {
    // Algorithme de Gauss pour calculer Pâques
    final a = year % 19;
    final b = year ~/ 100;
    final c = year % 100;
    final d = b ~/ 4;
    final e = b % 4;
    final f = (b + 8) ~/ 25;
    final g = (b - f + 1) ~/ 3;
    final h = (19 * a + b - d - g + 15) % 30;
    final i = c ~/ 4;
    final k = c % 4;
    final l = (32 + 2 * e + 2 * i - h - k) % 7;
    final m = (a + 11 * h + 22 * l) ~/ 451;
    final month = (h + l - 7 * m + 114) ~/ 31;
    final day = ((h + l - 7 * m + 114) % 31) + 1;

    return DateTime(year, month, day);
  }

  /// Calcule Thanksgiving (4ème jeudi de novembre)
  static DateTime _calculateThanksgiving(int year) {
    final november1 = DateTime(year, 11, 1);
    final firstThursday =
        november1.add(Duration(days: (4 - november1.weekday) % 7));
    return firstThursday.add(const Duration(days: 21)); // 4ème jeudi
  }

  /// Vérifie si les événements de l'année sont à jour
  static bool isEventsDataUpToDate(int currentYear) {
    // Cette méthode devrait vérifier si les données d'événements
    // sont présentes et correspondent à l'année en cours
    return true; // Implémentation simplifiée
  }

  /// Obtient les événements actifs pour une date donnée
  static List<Map<String, dynamic>> getActiveEvents(
    List<Map<String, dynamic>> events,
    DateTime date,
  ) {
    return events.where((event) {
      final startDate = DateTime.parse(event['start_date']);
      final endDate = DateTime.parse(event['end_date']);
      return date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  /// Obtient les événements à venir
  static List<Map<String, dynamic>> getUpcomingEvents(
    List<Map<String, dynamic>> events,
    DateTime date,
  ) {
    return events.where((event) {
      final startDate = DateTime.parse(event['start_date']);
      return startDate.isAfter(date);
    }).toList();
  }
}
