import 'package:flutter/foundation.dart';

/// Modèle représentant un monde dans le jeu
class World {
  final int id;
  final String nameKey; // Clé de traduction pour le nom
  final String descriptionKey; // Clé de traduction pour la description
  final String theme;
  final List<String> colors; // Couleurs principales du thème
  final String iconName; // Nom de l'icône
  final int startLevel; // Premier niveau du monde
  final int endLevel; // Dernier niveau du monde
  final List<String> tileTypes; // Types de tuiles privilégiés
  final bool isUnlocked;

  const World({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.theme,
    required this.colors,
    required this.iconName,
    required this.startLevel,
    required this.endLevel,
    required this.tileTypes,
    this.isUnlocked = false,
  });

  /// Nombre de niveaux dans ce monde
  int get levelCount => endLevel - startLevel + 1;

  /// Vérifie si un niveau appartient à ce monde
  bool containsLevel(int levelId) {
    return levelId >= startLevel && levelId <= endLevel;
  }

  /// Copie avec des valeurs modifiées
  World copyWith({
    int? id,
    String? nameKey,
    String? descriptionKey,
    String? theme,
    List<String>? colors,
    String? iconName,
    int? startLevel,
    int? endLevel,
    List<String>? tileTypes,
    bool? isUnlocked,
  }) {
    return World(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      theme: theme ?? this.theme,
      colors: colors ?? this.colors,
      iconName: iconName ?? this.iconName,
      startLevel: startLevel ?? this.startLevel,
      endLevel: endLevel ?? this.endLevel,
      tileTypes: tileTypes ?? this.tileTypes,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}

/// Énumération des thèmes de mondes
enum WorldTheme {
  garden, // Jardin
  valley, // Vallée
  forest, // Forêt
  meadow, // Prairie
  cavern, // Caverne
  swamp, // Marécage
  volcano, // Volcan
  glacier, // Glacier
  rainbow, // Arc-en-ciel
  celestial, // Céleste
}

/// Générateur de mondes prédéfinis
class WorldGenerator {
  static const List<World> predefinedWorlds = [
    World(
      id: 1,
      nameKey: 'world_garden_beginnings',
      descriptionKey: 'world_garden_beginnings_description',
      theme: 'garden',
      colors: ['#8FBC8F', '#90EE90', '#9ACD32'], // Verts tendres
      iconName: 'seedling',
      startLevel: 1,
      endLevel: 10,
      tileTypes: ['seed', 'leaf', 'dew'],
      isUnlocked: true,
    ),
    World(
      id: 2,
      nameKey: 'world_valley_flowers',
      descriptionKey: 'world_valley_flowers_description',
      theme: 'valley',
      colors: ['#FF69B4', '#DA70D6', '#FFB6C1'], // Roses et violets
      iconName: 'flower',
      startLevel: 11,
      endLevel: 20,
      tileTypes: ['flower', 'sun', 'leaf'],
      isUnlocked: false,
    ),
    World(
      id: 3,
      nameKey: 'world_lunar_forest',
      descriptionKey: 'world_lunar_forest_description',
      theme: 'forest',
      colors: ['#4169E1', '#9370DB', '#8A2BE2'], // Bleus et violets
      iconName: 'nightlight_round',
      startLevel: 21,
      endLevel: 30,
      tileTypes: ['moon', 'crystal', 'gem'],
      isUnlocked: false,
    ),
    World(
      id: 4,
      nameKey: 'world_solar_meadow',
      descriptionKey: 'world_solar_meadow_description',
      theme: 'meadow',
      colors: ['#FFD700', '#FFA500', '#FF8C00'], // Jaunes et oranges
      iconName: 'wb_sunny',
      startLevel: 31,
      endLevel: 40,
      tileTypes: ['sun', 'gem', 'flower'],
      isUnlocked: false,
    ),
    World(
      id: 5,
      nameKey: 'world_crystal_caverns',
      descriptionKey: 'world_crystal_caverns_description',
      theme: 'cavern',
      colors: ['#00CED1', '#40E0D0', '#AFEEEE'], // Turquoise et cristaux
      iconName: 'diamond',
      startLevel: 41,
      endLevel: 50,
      tileTypes: ['crystal', 'gem', 'dew'],
      isUnlocked: false,
    ),
    World(
      id: 6,
      nameKey: 'world_mystic_swamps',
      descriptionKey: 'world_mystic_swamps_description',
      theme: 'swamp',
      colors: ['#20B2AA', '#48CAE4', '#90E0EF'], // Bleus-verts
      iconName: 'water_drop',
      startLevel: 51,
      endLevel: 60,
      tileTypes: ['dew', 'leaf', 'crystal'],
      isUnlocked: false,
    ),
    World(
      id: 7,
      nameKey: 'world_burning_lands',
      descriptionKey: 'world_burning_lands_description',
      theme: 'volcano',
      colors: ['#DC143C', '#FF4500', '#FF6347'], // Rouges et oranges
      iconName: 'local_fire_department',
      startLevel: 61,
      endLevel: 70,
      tileTypes: ['sun', 'gem', 'flower'],
      isUnlocked: false,
    ),
    World(
      id: 8,
      nameKey: 'world_eternal_glacier',
      descriptionKey: 'world_eternal_glacier_description',
      theme: 'glacier',
      colors: ['#B0E0E6', '#E0FFFF', '#F0F8FF'], // Blancs et bleus glacés
      iconName: 'ac_unit',
      startLevel: 71,
      endLevel: 80,
      tileTypes: ['crystal', 'moon', 'dew'],
      isUnlocked: false,
    ),
    World(
      id: 9,
      nameKey: 'world_lost_rainbow',
      descriptionKey: 'world_lost_rainbow_description',
      theme: 'rainbow',
      colors: [
        '#FF1493',
        '#00BFFF',
        '#32CD32',
        '#FFD700'
      ], // Toutes les couleurs
      iconName: 'palette',
      startLevel: 81,
      endLevel: 90,
      tileTypes: ['flower', 'sun', 'moon', 'gem'],
      isUnlocked: false,
    ),
    World(
      id: 10,
      nameKey: 'world_celestial_garden',
      descriptionKey: 'world_celestial_garden_description',
      theme: 'celestial',
      colors: ['#FFD700', '#C0C0C0', '#87CEEB'], // Or, argent, ciel
      iconName: 'star',
      startLevel: 91,
      endLevel: 100,
      tileTypes: ['gem', 'sun', 'moon', 'crystal'],
      isUnlocked: false,
    ),
  ];

  /// Récupère tous les mondes
  static List<World> getAllWorlds() {
    return List.from(predefinedWorlds);
  }

  /// Récupère un monde par son ID
  static World? getWorldById(int worldId) {
    try {
      return predefinedWorlds.firstWhere((world) => world.id == worldId);
    } catch (e) {
      return null;
    }
  }

  /// Récupère le monde contenant un niveau donné
  static World? getWorldByLevel(int levelId) {
    return predefinedWorlds.cast<World?>().firstWhere(
          (world) => world?.containsLevel(levelId) ?? false,
          orElse: () => null,
        );
  }

  /// Récupère les mondes déverrouillés
  static List<World> getUnlockedWorlds(List<int> completedLevels) {
    return predefinedWorlds.where((world) {
      if (world.id == 1) return true; // Premier monde toujours déverrouillé

      // Un monde est déverrouillé si le dernier niveau du monde précédent est complété
      final previousWorld = getWorldById(world.id - 1);
      if (previousWorld == null) return false;

      // Vérifier si le dernier niveau du monde précédent est complété
      final lastLevelOfPreviousWorld = previousWorld.endLevel;
      final isUnlocked = completedLevels.contains(lastLevelOfPreviousWorld);

      // Debug réduit pour éviter le spam
      if (kDebugMode && world.id <= 3) {
        debugPrint('=== DEBUG WORLD UNLOCK ===');
        debugPrint('World ${world.id} unlocked: $isUnlocked');
        debugPrint('Last level of previous world ($lastLevelOfPreviousWorld) completed: ${completedLevels.contains(lastLevelOfPreviousWorld)}');
        debugPrint('Completed levels: $completedLevels');
        debugPrint('==========================');
      }

      return isUnlocked;
    }).toList();
  }

  /// Met à jour l'état de déverrouillage des mondes
  static List<World> updateWorldUnlockStatus(
      List<World> worlds, List<int> completedLevels) {
    return worlds.map((world) {
      final unlockedWorlds = getUnlockedWorlds(completedLevels);
      final isUnlocked =
          unlockedWorlds.any((unlocked) => unlocked.id == world.id);
      return world.copyWith(isUnlocked: isUnlocked);
    }).toList();
  }
}
