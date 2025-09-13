import 'package:mind_bloom/models/tile.dart';

enum SpecialCombinationType {
  horizontal, // 3+ en ligne horizontale
  vertical, // 3+ en ligne verticale
  lShape, // Forme en L
  tShape, // Forme en T
  plusShape, // Forme en +
  fiveInLine, // 5 en ligne (power-up)
  cross, // Croix (power-up)
}

class SpecialCombination {
  final SpecialCombinationType type;
  final List<Tile> tiles;
  final int scoreMultiplier;
  final String description;

  SpecialCombination({
    required this.type,
    required this.tiles,
    required this.scoreMultiplier,
    required this.description,
  });

  // Calculer le score de base
  int get baseScore => tiles.length * 100;

  // Calculer le score avec multiplicateur
  int get totalScore => (baseScore * scoreMultiplier).round();

  // Vérifier si c'est un power-up
  bool get isPowerUp =>
      type == SpecialCombinationType.fiveInLine ||
      type == SpecialCombinationType.cross;

  // Obtenir le type de power-up généré
  PowerUpType? get powerUpType {
    switch (type) {
      case SpecialCombinationType.fiveInLine:
        return PowerUpType.lineBomb;
      case SpecialCombinationType.cross:
        return PowerUpType.crossBomb;
      default:
        return null;
    }
  }
}

enum PowerUpType {
  lineBomb, // Bombe en ligne
  crossBomb, // Bombe en croix
  colorBomb, // Bombe de couleur
  lightning, // Éclair
}

class PowerUp {
  final PowerUpType type;
  final Tile? targetTile; // Tuile cible pour certains power-ups
  final int radius; // Rayon d'effet

  PowerUp({
    required this.type,
    this.targetTile,
    this.radius = 1,
  });

  // Obtenir la description du power-up
  String get description {
    switch (type) {
      case PowerUpType.lineBomb:
        return 'Bombe en ligne';
      case PowerUpType.crossBomb:
        return 'Bombe en croix';
      case PowerUpType.colorBomb:
        return 'Bombe de couleur';
      case PowerUpType.lightning:
        return 'Éclair';
    }
  }

  // Obtenir l'icône du power-up
  String get icon {
    switch (type) {
      case PowerUpType.lineBomb:
        return '💥';
      case PowerUpType.crossBomb:
        return '❌';
      case PowerUpType.colorBomb:
        return '🌈';
      case PowerUpType.lightning:
        return '⚡';
    }
  }
}
