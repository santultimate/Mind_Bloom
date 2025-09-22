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
        name: 'Rose Magique',
        description:
            'Une rose qui brille dans l\'obscurité et accorde des pouvoirs mystiques',
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
          description: 'Complétez 20 niveaux',
        ),
      ),
      Plant(
        id: 'lotus_cristal',
        name: 'Lotus de Cristal',
        description: 'Un lotus qui purifie l\'eau et augmente la fortune',
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
          description: 'Complétez 10 niveaux',
        ),
      ),
      Plant(
        id: 'tulipe_arc',
        name: 'Tulipe Arc-en-ciel',
        description: 'Une tulipe aux couleurs changeantes',
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
        name: 'Orchidée de Lune',
        description: 'Une orchidée qui fleurit la nuit',
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
        name: 'Tournesol Doré',
        description: 'Un tournesol qui suit le soleil',
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
          description: 'Complétez votre premier niveau',
        ),
      ),
      Plant(
        id: 'marguerite_etoile',
        name: 'Marguerite Étoilée',
        description:
            'Une marguerite qui brille comme une étoile et guide les débutants',
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
        name: 'Violette Mystique',
        description: 'Une violette qui révèle les secrets cachés du jardin',
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
          description: 'Complétez 3 niveaux',
        ),
      ),

      Plant(
        id: 'jasmin_eternel',
        name: 'Jasmin Éternel',
        description:
            'Un jasmin dont le parfum traverse les dimensions temporelles',
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
          description: 'Obtenez 3 étoiles sur 5 niveaux',
        ),
      ),

      Plant(
        id: 'petunia_cosmique',
        name: 'Pétunia Cosmique',
        description: 'Un pétunia qui puise son énergie dans les étoiles',
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
          description: 'Atteignez 50 000 points au total',
        ),
      ),

      Plant(
        id: 'lys_phoenix',
        name: 'Lys du Phénix',
        description:
            'Un lys légendaire qui renaît de ses cendres et accorde une seconde chance',
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
          description: 'Complétez 30 niveaux',
        ),
      ),

      Plant(
        id: 'cactus_temporel',
        name: 'Cactus Temporel',
        description:
            'Un cactus rare qui manipule le temps et prolonge les sessions de jeu',
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
          description: 'Faites 500 matches au total',
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
      if (kDebugMode) {
        print('Error loading collection progress: $e');
      }
    }
  }

  // Sauvegarder la progression
  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('plant_progress', json.encode(_plantProgress));
      await prefs.setString('plant_levels', json.encode(_plantLevels));
    } catch (e) {
      if (kDebugMode) {
        print('Error saving collection progress: $e');
      }
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
        name: plant.name,
        description: plant.description,
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
      case UnlockType.none:
        return 1.0;
    }

    return (currentValue / plant.unlockCondition.value).clamp(0.0, 1.0);
  }
}

// Modèles de données
class Plant {
  final String id;
  final String name;
  final String description;
  final int rarity; // 1-5 étoiles
  final List<PlantBonus> bonuses;
  final bool isUnlocked;
  final int level;
  final String imagePath;
  final PlantUnlockCondition unlockCondition;

  Plant({
    required this.id,
    required this.name,
    required this.description,
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
}
