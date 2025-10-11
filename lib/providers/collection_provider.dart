import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CollectionProvider extends ChangeNotifier {
  List<Plant> _plants = [];
  Map<String, int> _plantProgress =
      {}; // Progression pour débloquer les plantes
  Map<String, int> _plantLevels = {}; // Niveaux des plantes débloquées

  List<Plant> get plants => _plants;
  Map<String, int> get plantProgress => _plantProgress;
  Map<String, int> get plantLevels => _plantLevels;

  // Getters pour les statistiques
  int get totalPlants => _plants.length;
  int get unlockedPlants => _plants.where((p) => p.isUnlocked).length;
  int get totalRarity =>
      _plants.where((p) => p.isUnlocked && p.rarity >= 4).length;
  int get totalLevels =>
      _plants.fold(0, (sum, p) => sum + (p.isUnlocked ? p.level : 0));

  CollectionProvider() {
    _initializePlants();
    _loadProgress();
  }

  void _initializePlants() {
    _plants = [
      Plant(
        id: 'rose_magique',
        nameKey: 'plant_rose_magique_name',
        descriptionKey: 'plant_rose_magique_description',
        rarity: 5,
        bonuses: [
          PlantBonus(type: BonusType.extraMoves, value: 3), // Augmenté
          PlantBonus(type: BonusType.scoreMultiplier, value: 1.5), // Augmenté
          PlantBonus(
              type: BonusType.coinMultiplier, value: 1.3), // Nouveau bonus
        ],
        isUnlocked: _plantLevels.containsKey('rose_magique'),
        level: _plantLevels['rose_magique'] ?? 0,
        imagePath: 'assets/images/plants/rose_magique.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.levelsCompleted,
          value: 20,
          description: 'Complete 20 levels',
        ),
      ),
      Plant(
        id: 'lotus_cristal',
        nameKey: 'plant_lotus_cristal_name',
        descriptionKey: 'plant_lotus_cristal_description',
        rarity: 4,
        bonuses: [
          PlantBonus(type: BonusType.extraMoves, value: 2), // Augmenté
          PlantBonus(type: BonusType.coinMultiplier, value: 1.25), // Augmenté
          PlantBonus(type: BonusType.extraLives, value: 1), // Nouveau bonus
        ],
        isUnlocked: _plantLevels.containsKey('lotus_cristal'),
        level: _plantLevels['lotus_cristal'] ?? 0,
        imagePath: 'assets/images/plants/lotus_cristal.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.levelsCompleted,
          value: 10,
          description: 'Complete 10 levels',
        ),
      ),
      Plant(
        id: 'tulipe_arc',
        nameKey: 'plant_tulipe_arc_name',
        descriptionKey: 'plant_tulipe_arc_description',
        rarity: 3,
        bonuses: [
          PlantBonus(type: BonusType.scoreMultiplier, value: 1.1),
        ],
        isUnlocked: _plantLevels.containsKey('tulipe_arc'),
        level: _plantLevels['tulipe_arc'] ?? 0,
        imagePath: 'assets/images/plants/tulipe_arc.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.matches,
          value: 50,
          description: 'Faites 50 matches',
        ),
      ),
      Plant(
        id: 'orchidee_lune',
        nameKey: 'plant_orchidee_lune_name',
        descriptionKey: 'plant_orchidee_lune_description',
        rarity: 4,
        bonuses: [
          PlantBonus(type: BonusType.extraLives, value: 1),
        ],
        isUnlocked: _plantLevels.containsKey('orchidee_lune'),
        level: _plantLevels['orchidee_lune'] ?? 0,
        imagePath: 'assets/images/plants/orchidee_lune.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.perfectLevels,
          value: 3,
          description: '3 niveaux parfaits (3 étoiles)',
        ),
      ),
      Plant(
        id: 'tournesol_or',
        nameKey: 'plant_tournesol_or_name',
        descriptionKey: 'plant_tournesol_or_description',
        rarity: 2,
        bonuses: [
          PlantBonus(type: BonusType.coinMultiplier, value: 1.05),
        ],
        isUnlocked: _plantLevels.containsKey('tournesol_or'),
        level: _plantLevels['tournesol_or'] ?? 0,
        imagePath: 'assets/images/plants/tournesol_or.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.levelsCompleted,
          value: 1,
          description: 'Complete your first level',
        ),
      ),
      Plant(
        id: 'marguerite_etoile',
        nameKey: 'plant_marguerite_etoile_name',
        descriptionKey: 'plant_marguerite_etoile_description',
        rarity: 1,
        bonuses: [
          PlantBonus(
              type: BonusType.coinMultiplier,
              value: 1.05), // Petit bonus pour commencer
        ],
        isUnlocked: true, // Toujours débloquée
        level: _plantLevels['marguerite_etoile'] ?? 1,
        imagePath: 'assets/images/plants/marguerite_etoile.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.none,
          value: 0,
          description: 'Débloquée dès le début',
        ),
      ),

      // Nouvelles plantes pour enrichir le gameplay
      Plant(
        id: 'violette_mystique',
        nameKey: 'plant_violette_mystique_name',
        descriptionKey: 'plant_violette_mystique_description',
        rarity: 2,
        bonuses: [
          PlantBonus(type: BonusType.extraMoves, value: 1),
          PlantBonus(type: BonusType.scoreMultiplier, value: 1.1),
        ],
        isUnlocked: _plantLevels.containsKey('violette_mystique'),
        level: _plantLevels['violette_mystique'] ?? 0,
        imagePath: 'assets/images/plants/violette_mystique.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.levelsCompleted,
          value: 3,
          description: 'Complete 3 levels',
        ),
      ),

      Plant(
        id: 'jasmin_eternel',
        nameKey: 'plant_jasmin_eternel_name',
        descriptionKey: 'plant_jasmin_eternel_description',
        rarity: 3,
        bonuses: [
          PlantBonus(type: BonusType.extraLives, value: 1),
          PlantBonus(type: BonusType.coinMultiplier, value: 1.15),
        ],
        isUnlocked: _plantLevels.containsKey('jasmin_eternel'),
        level: _plantLevels['jasmin_eternel'] ?? 0,
        imagePath: 'assets/images/plants/jasmin_eternel.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.perfectLevels,
          value: 5,
          description: 'Get 3 stars on 5 levels',
        ),
      ),

      Plant(
        id: 'petunia_cosmique',
        nameKey: 'plant_petunia_cosmique_name',
        descriptionKey: 'plant_petunia_cosmique_description',
        rarity: 4,
        bonuses: [
          PlantBonus(type: BonusType.extraMoves, value: 2),
          PlantBonus(type: BonusType.scoreMultiplier, value: 1.3),
          PlantBonus(type: BonusType.coinMultiplier, value: 1.2),
        ],
        isUnlocked: _plantLevels.containsKey('petunia_cosmique'),
        level: _plantLevels['petunia_cosmique'] ?? 0,
        imagePath: 'assets/images/plants/petunia_cosmique.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.score,
          value: 50000,
          description: 'Reach 50,000 total points',
        ),
      ),

      Plant(
        id: 'lys_phoenix',
        nameKey: 'plant_lys_phoenix_name',
        descriptionKey: 'plant_lys_phoenix_description',
        rarity: 5,
        bonuses: [
          PlantBonus(type: BonusType.extraMoves, value: 4),
          PlantBonus(type: BonusType.scoreMultiplier, value: 1.6),
          PlantBonus(type: BonusType.extraLives, value: 2),
          PlantBonus(type: BonusType.coinMultiplier, value: 1.4),
        ],
        isUnlocked: _plantLevels.containsKey('lys_phoenix'),
        level: _plantLevels['lys_phoenix'] ?? 0,
        imagePath: 'assets/images/plants/lys_phoenix.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.levelsCompleted,
          value: 30,
          description: 'Complete 30 levels',
        ),
      ),

      Plant(
        id: 'cactus_temporel',
        nameKey: 'plant_cactus_temporel_name',
        descriptionKey: 'plant_cactus_temporel_description',
        rarity: 4,
        bonuses: [
          PlantBonus(type: BonusType.extraLives, value: 3),
          PlantBonus(type: BonusType.extraMoves, value: 2),
        ],
        isUnlocked: _plantLevels.containsKey('cactus_temporel'),
        level: _plantLevels['cactus_temporel'] ?? 0,
        imagePath: 'assets/images/plants/cactus_temporel.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.matches,
          value: 500,
          description: 'Make 500 total matches',
        ),
      ),

      // 🌟 OBJETS RARES SPÉCIFIQUES AUX MONDES 🌟

      // Monde 1 - Garden of Beginnings
      Plant(
        id: 'rose_eternelle',
        nameKey: 'plant_rose_eternelle_name',
        descriptionKey: 'plant_rose_eternelle_description',
        rarity: 4,
        bonuses: [
          PlantBonus(type: BonusType.extraMoves, value: 3),
          PlantBonus(type: BonusType.scoreMultiplier, value: 1.2),
          PlantBonus(type: BonusType.extraLives, value: 1),
        ],
        isUnlocked: _plantLevels.containsKey('rose_eternelle'),
        level: _plantLevels['rose_eternelle'] ?? 0,
        imagePath: 'assets/images/plants/rose_eternelle.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.worldCompleted,
          value: 1,
          description: 'Complete World 1 - Garden of Beginnings',
        ),
      ),

      // Monde 2 - Valley of Flowers
      Plant(
        id: 'lotus_paradis',
        nameKey: 'plant_lotus_paradis_name',
        descriptionKey: 'plant_lotus_paradis_description',
        rarity: 4,
        bonuses: [
          PlantBonus(type: BonusType.scoreMultiplier, value: 1.3),
          PlantBonus(type: BonusType.coinMultiplier, value: 1.25),
          PlantBonus(type: BonusType.extraMoves, value: 2),
        ],
        isUnlocked: _plantLevels.containsKey('lotus_paradis'),
        level: _plantLevels['lotus_paradis'] ?? 0,
        imagePath: 'assets/images/plants/lotus_paradis.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.worldCompleted,
          value: 2,
          description: 'Complete World 2 - Valley of Flowers',
        ),
      ),

      // Monde 3 - Lunar Forest
      Plant(
        id: 'orchidee_lunaire',
        nameKey: 'plant_orchidee_lunaire_name',
        descriptionKey: 'plant_orchidee_lunaire_description',
        rarity: 5,
        bonuses: [
          PlantBonus(type: BonusType.extraMoves, value: 4),
          PlantBonus(type: BonusType.scoreMultiplier, value: 1.4),
          PlantBonus(type: BonusType.coinMultiplier, value: 1.3),
          PlantBonus(type: BonusType.extraLives, value: 2),
        ],
        isUnlocked: _plantLevels.containsKey('orchidee_lunaire'),
        level: _plantLevels['orchidee_lunaire'] ?? 0,
        imagePath: 'assets/images/plants/orchidee_lunaire.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.worldCompleted,
          value: 3,
          description: 'Complete World 3 - Lunar Forest',
        ),
      ),

      // Monde 4 - Solar Meadow
      Plant(
        id: 'tournesol_solaire',
        nameKey: 'plant_tournesol_solaire_name',
        descriptionKey: 'plant_tournesol_solaire_description',
        rarity: 4,
        bonuses: [
          PlantBonus(type: BonusType.scoreMultiplier, value: 1.35),
          PlantBonus(type: BonusType.coinMultiplier, value: 1.3),
          PlantBonus(type: BonusType.extraMoves, value: 3),
        ],
        isUnlocked: _plantLevels.containsKey('tournesol_solaire'),
        level: _plantLevels['tournesol_solaire'] ?? 0,
        imagePath: 'assets/images/plants/tournesol_solaire.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.worldCompleted,
          value: 4,
          description: 'Complete World 4 - Solar Meadow',
        ),
      ),

      // Monde 5 - Crystal Caverns
      Plant(
        id: 'cristal_vegetal',
        nameKey: 'plant_cristal_vegetal_name',
        descriptionKey: 'plant_cristal_vegetal_description',
        rarity: 5,
        bonuses: [
          PlantBonus(type: BonusType.extraMoves, value: 5),
          PlantBonus(type: BonusType.scoreMultiplier, value: 1.5),
          PlantBonus(type: BonusType.coinMultiplier, value: 1.4),
          PlantBonus(type: BonusType.extraLives, value: 2),
        ],
        isUnlocked: _plantLevels.containsKey('cristal_vegetal'),
        level: _plantLevels['cristal_vegetal'] ?? 0,
        imagePath: 'assets/images/plants/cristal_vegetal.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.worldCompleted,
          value: 5,
          description: 'Complete World 5 - Crystal Caverns',
        ),
      ),

      // Monde 6 - Mystic Swamps
      Plant(
        id: 'nymphaea_mystique',
        nameKey: 'plant_nymphaea_mystique_name',
        descriptionKey: 'plant_nymphaea_mystique_description',
        rarity: 4,
        bonuses: [
          PlantBonus(type: BonusType.extraLives, value: 3),
          PlantBonus(type: BonusType.scoreMultiplier, value: 1.25),
          PlantBonus(type: BonusType.coinMultiplier, value: 1.2),
        ],
        isUnlocked: _plantLevels.containsKey('nymphaea_mystique'),
        level: _plantLevels['nymphaea_mystique'] ?? 0,
        imagePath: 'assets/images/plants/nymphaea_mystique.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.worldCompleted,
          value: 6,
          description: 'Complete World 6 - Mystic Swamps',
        ),
      ),

      // Monde 7 - Burning Lands
      Plant(
        id: 'flamme_vegetale',
        nameKey: 'plant_flamme_vegetale_name',
        descriptionKey: 'plant_flamme_vegetale_description',
        rarity: 5,
        bonuses: [
          PlantBonus(type: BonusType.scoreMultiplier, value: 1.6),
          PlantBonus(type: BonusType.extraMoves, value: 4),
          PlantBonus(type: BonusType.coinMultiplier, value: 1.35),
        ],
        isUnlocked: _plantLevels.containsKey('flamme_vegetale'),
        level: _plantLevels['flamme_vegetale'] ?? 0,
        imagePath: 'assets/images/plants/flamme_vegetale.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.worldCompleted,
          value: 7,
          description: 'Complete World 7 - Burning Lands',
        ),
      ),

      // Monde 8 - Eternal Glacier
      Plant(
        id: 'glace_eternelle',
        nameKey: 'plant_glace_eternelle_name',
        descriptionKey: 'plant_glace_eternelle_description',
        rarity: 5,
        bonuses: [
          PlantBonus(type: BonusType.extraLives, value: 4),
          PlantBonus(type: BonusType.extraMoves, value: 3),
          PlantBonus(type: BonusType.scoreMultiplier, value: 1.3),
        ],
        isUnlocked: _plantLevels.containsKey('glace_eternelle'),
        level: _plantLevels['glace_eternelle'] ?? 0,
        imagePath: 'assets/images/plants/glace_eternelle.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.worldCompleted,
          value: 8,
          description: 'Complete World 8 - Eternal Glacier',
        ),
      ),

      // Monde 9 - Lost Rainbow
      Plant(
        id: 'arc_en_ciel_perdu',
        nameKey: 'plant_arc_en_ciel_perdu_name',
        descriptionKey: 'plant_arc_en_ciel_perdu_description',
        rarity: 5,
        bonuses: [
          PlantBonus(type: BonusType.scoreMultiplier, value: 1.7),
          PlantBonus(type: BonusType.coinMultiplier, value: 1.5),
          PlantBonus(type: BonusType.extraMoves, value: 5),
          PlantBonus(type: BonusType.extraLives, value: 3),
        ],
        isUnlocked: _plantLevels.containsKey('arc_en_ciel_perdu'),
        level: _plantLevels['arc_en_ciel_perdu'] ?? 0,
        imagePath: 'assets/images/plants/arc_en_ciel_perdu.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.worldCompleted,
          value: 9,
          description: 'Complete World 9 - Lost Rainbow',
        ),
      ),

      // Monde 10 - Celestial Garden (Final Boss)
      Plant(
        id: 'jardin_celeste',
        nameKey: 'plant_jardin_celeste_name',
        descriptionKey: 'plant_jardin_celeste_description',
        rarity: 6, // Rareté spéciale pour le monde final
        bonuses: [
          PlantBonus(type: BonusType.scoreMultiplier, value: 2.0),
          PlantBonus(type: BonusType.coinMultiplier, value: 1.8),
          PlantBonus(type: BonusType.extraMoves, value: 6),
          PlantBonus(type: BonusType.extraLives, value: 5),
        ],
        isUnlocked: _plantLevels.containsKey('jardin_celeste'),
        level: _plantLevels['jardin_celeste'] ?? 0,
        imagePath: 'assets/images/plants/jardin_celeste.png',
        unlockCondition: PlantUnlockCondition(
          type: UnlockType.worldCompleted,
          value: 10,
          description: 'Complete World 10 - Celestial Garden',
        ),
      ),
    ];
  }

  // Charger la progression depuis SharedPreferences
  Future<void> _loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = prefs.getString('plant_progress');
      final levelsJson = prefs.getString('plant_levels');

      if (progressJson != null) {
        _plantProgress = Map<String, int>.from(json.decode(progressJson));
      }

      if (levelsJson != null) {
        _plantLevels = Map<String, int>.from(json.decode(levelsJson));
      }

      // Mettre à jour le statut des plantes
      _updatePlantStatus();
      notifyListeners();
    } catch (e) {
      // Commenté pour la version de production
      // if (kDebugMode) {
      //   debugPrint('Error loading collection progress: $e');
      // }
    }
  }

  // Sauvegarder la progression
  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('plant_progress', json.encode(_plantProgress));
      await prefs.setString('plant_levels', json.encode(_plantLevels));
    } catch (e) {
      // Commenté pour la version de production
      // if (kDebugMode) {
      //   debugPrint('Error saving collection progress: $e');
      // }
    }
  }

  // Mettre à jour le statut des plantes
  void _updatePlantStatus() {
    for (int i = 0; i < _plants.length; i++) {
      final plant = _plants[i];
      final isUnlocked = _plantLevels.containsKey(plant.id);
      final level = _plantLevels[plant.id] ?? 0;

      _plants[i] = Plant(
        id: plant.id,
        nameKey: plant.nameKey,
        descriptionKey: plant.descriptionKey,
        rarity: plant.rarity,
        bonuses: plant.bonuses,
        isUnlocked: isUnlocked,
        level: level,
        imagePath: plant.imagePath,
        unlockCondition: plant.unlockCondition,
      );
    }
  }

  // Mettre à jour la progression basée sur les actions du jeu
  Future<void> updateProgress({
    int? score,
    int? levelsCompleted,
    int? matches,
    int? perfectLevels,
  }) async {
    bool hasChanges = false;

    // Mettre à jour la progression pour chaque type
    if (score != null) {
      _plantProgress['total_score'] =
          (_plantProgress['total_score'] ?? 0) + score;
      hasChanges = true;
    }

    if (levelsCompleted != null) {
      _plantProgress['levels_completed'] =
          (_plantProgress['levels_completed'] ?? 0) + levelsCompleted;
      hasChanges = true;
    }

    if (matches != null) {
      _plantProgress['total_matches'] =
          (_plantProgress['total_matches'] ?? 0) + matches;
      hasChanges = true;
    }

    if (perfectLevels != null) {
      _plantProgress['perfect_levels'] =
          (_plantProgress['perfect_levels'] ?? 0) + perfectLevels;
      hasChanges = true;
    }

    if (hasChanges) {
      // Vérifier les déblocages
      _checkUnlocks();
      await _saveProgress();
      notifyListeners();
    }
  }

  // Vérifier les déblocages de plantes
  void _checkUnlocks() {
    for (final plant in _plants) {
      if (!plant.isUnlocked) {
        bool shouldUnlock = false;

        switch (plant.unlockCondition.type) {
          case UnlockType.score:
            shouldUnlock = (_plantProgress['total_score'] ?? 0) >=
                plant.unlockCondition.value;
            break;
          case UnlockType.levelsCompleted:
            shouldUnlock = (_plantProgress['levels_completed'] ?? 0) >=
                plant.unlockCondition.value;
            break;
          case UnlockType.matches:
            shouldUnlock = (_plantProgress['total_matches'] ?? 0) >=
                plant.unlockCondition.value;
            break;
          case UnlockType.perfectLevels:
            shouldUnlock = (_plantProgress['perfect_levels'] ?? 0) >=
                plant.unlockCondition.value;
            break;
          case UnlockType.worldCompleted:
            shouldUnlock = (_plantProgress['worlds_completed'] ?? 0) >=
                plant.unlockCondition.value;
            break;
          case UnlockType.none:
            shouldUnlock = true;
            break;
        }

        if (shouldUnlock) {
          _plantLevels[plant.id] = 1; // Niveau 1 par défaut
          _updatePlantStatus();
        }
      }
    }
  }

  // Améliorer une plante
  Future<void> upgradePlant(String plantId) async {
    if (_plantLevels.containsKey(plantId)) {
      _plantLevels[plantId] = (_plantLevels[plantId] ?? 1) + 1;
      _updatePlantStatus();
      await _saveProgress();
      notifyListeners();
    }
  }

  // Obtenir les bonus actifs de toutes les plantes
  Map<BonusType, double> getActiveBonuses() {
    Map<BonusType, double> bonuses = {};

    for (final plant in _plants) {
      if (plant.isUnlocked && plant.level > 0) {
        for (final bonus in plant.bonuses) {
          final currentValue = bonuses[bonus.type] ?? 0.0;
          bonuses[bonus.type] = currentValue + (bonus.value * plant.level);
        }
      }
    }

    return bonuses;
  }

  // Obtenir une plante par ID
  Plant? getPlantById(String id) {
    try {
      return _plants.firstWhere((plant) => plant.id == id);
    } catch (e) {
      return null;
    }
  }

  // Obtenir les plantes par rareté
  List<Plant> getPlantsByRarity(int rarity) {
    return _plants.where((plant) => plant.rarity == rarity).toList();
  }

  // Obtenir les plantes débloquées
  List<Plant> getUnlockedPlants() {
    return _plants.where((plant) => plant.isUnlocked).toList();
  }

  // Obtenir les plantes verrouillées
  List<Plant> getLockedPlants() {
    return _plants.where((plant) => !plant.isUnlocked).toList();
  }

  // Obtenir la progression pour débloquer une plante
  double getUnlockProgress(String plantId) {
    final plant = getPlantById(plantId);
    if (plant == null || plant.isUnlocked) return 1.0;

    int currentValue = 0;
    switch (plant.unlockCondition.type) {
      case UnlockType.score:
        currentValue = _plantProgress['total_score'] ?? 0;
        break;
      case UnlockType.levelsCompleted:
        currentValue = _plantProgress['levels_completed'] ?? 0;
        break;
      case UnlockType.matches:
        currentValue = _plantProgress['total_matches'] ?? 0;
        break;
      case UnlockType.perfectLevels:
        currentValue = _plantProgress['perfect_levels'] ?? 0;
        break;
      case UnlockType.worldCompleted:
        currentValue = _plantProgress['worlds_completed'] ?? 0;
        break;
      case UnlockType.none:
        return 1.0;
    }

    return (currentValue / plant.unlockCondition.value).clamp(0.0, 1.0);
  }

  // 🌟 NOUVELLE MÉTHODE: Débloquer les objets rares après completion d'un monde
  Future<List<Plant>> onWorldCompleted(int worldId) async {
    final List<Plant> newlyUnlockedPlants = [];

    // Mettre à jour le compteur de mondes complétés
    final currentWorldsCompleted = _plantProgress['worlds_completed'] ?? 0;
    if (worldId > currentWorldsCompleted) {
      _plantProgress['worlds_completed'] = worldId;
      await _saveProgress();
    }

    // Vérifier toutes les plantes qui peuvent être débloquées
    for (int i = 0; i < _plants.length; i++) {
      final plant = _plants[i];

      // Vérifier si cette plante doit être débloquée par la completion de ce monde
      if (!plant.isUnlocked &&
          plant.unlockCondition.type == UnlockType.worldCompleted &&
          plant.unlockCondition.value == worldId) {
        // Débloquer la plante
        _plantLevels[plant.id] = 1; // Niveau 1 par défaut

        // Créer une nouvelle instance de la plante débloquée
        final unlockedPlant = Plant(
          id: plant.id,
          nameKey: plant.nameKey,
          descriptionKey: plant.descriptionKey,
          rarity: plant.rarity,
          bonuses: plant.bonuses,
          isUnlocked: true,
          level: 1,
          imagePath: plant.imagePath,
          unlockCondition: plant.unlockCondition,
        );

        // Remplacer dans la liste
        _plants[i] = unlockedPlant;
        newlyUnlockedPlants.add(unlockedPlant);

        if (kDebugMode) {
          debugPrint(
              '🌟 [CollectionProvider] Objet rare débloqué: ${plant.id} (Monde $worldId)');
        }
      }
    }

    // Sauvegarder les changements
    if (newlyUnlockedPlants.isNotEmpty) {
      await _saveProgress();
      notifyListeners();
    }

    return newlyUnlockedPlants;
  }

  // Méthode pour obtenir les plantes rares spécifiques à un monde
  List<Plant> getWorldRarePlants(int worldId) {
    return _plants
        .where((plant) =>
            plant.unlockCondition.type == UnlockType.worldCompleted &&
            plant.unlockCondition.value == worldId)
        .toList();
  }

  // Méthode pour vérifier si un monde a des objets rares débloqués
  bool hasWorldRarePlantsUnlocked(int worldId) {
    final worldPlants = getWorldRarePlants(worldId);
    return worldPlants.any((plant) => plant.isUnlocked);
  }
}

// Modèles de données
class Plant {
  final String id;
  final String nameKey;
  final String descriptionKey;
  final int rarity; // 1-5 étoiles
  final List<PlantBonus> bonuses;
  final bool isUnlocked;
  final int level;
  final String imagePath;
  final PlantUnlockCondition unlockCondition;

  Plant({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.rarity,
    required this.bonuses,
    required this.isUnlocked,
    required this.level,
    required this.imagePath,
    required this.unlockCondition,
  });
}

class PlantBonus {
  final BonusType type;
  final double value;

  PlantBonus({
    required this.type,
    required this.value,
  });
}

class PlantUnlockCondition {
  final UnlockType type;
  final int value;
  final String description;

  PlantUnlockCondition({
    required this.type,
    required this.value,
    required this.description,
  });
}

enum BonusType {
  extraMoves,
  scoreMultiplier,
  coinMultiplier,
  extraLives,
}

enum UnlockType {
  none,
  score,
  levelsCompleted,
  matches,
  perfectLevels,
  worldCompleted, // Nouveau type pour les mondes complétés
}
