import 'package:mind_bloom/models/special_combination.dart';

class ScoringSystem {
  // Calculer le score pour une combinaison
  static int calculateScore(SpecialCombination combination, int comboCount) {
    int baseScore = combination.baseScore;
    int multiplier = combination.scoreMultiplier;

    // Bonus de combo
    int comboBonus = comboCount > 1 ? (comboCount - 1) * 100 : 0;

    // Bonus de taille
    int sizeBonus =
        combination.tiles.length > 3 ? (combination.tiles.length - 3) * 50 : 0;

    // Bonus de type spécial
    int specialBonus = _getSpecialBonus(combination.type);

    return (baseScore * multiplier + comboBonus + sizeBonus + specialBonus)
        .round();
  }

  // Obtenir le bonus spécial selon le type
  static int _getSpecialBonus(SpecialCombinationType type) {
    switch (type) {
      case SpecialCombinationType.horizontal:
      case SpecialCombinationType.vertical:
        return 0;
      case SpecialCombinationType.lShape:
        return 200;
      case SpecialCombinationType.tShape:
        return 300;
      case SpecialCombinationType.plusShape:
        return 500;
      case SpecialCombinationType.fiveInLine:
        return 1000;
      case SpecialCombinationType.cross:
        return 1500;
    }
  }

  // Calculer le score total pour plusieurs combinaisons
  static int calculateTotalScore(
      List<SpecialCombination> combinations, int comboCount) {
    int totalScore = 0;

    for (final combination in combinations) {
      totalScore += calculateScore(combination, comboCount);
    }

    return totalScore;
  }

  // Obtenir le multiplicateur de combo
  static double getComboMultiplier(int comboCount) {
    if (comboCount <= 1) return 1.0;
    if (comboCount <= 3) return 1.5;
    if (comboCount <= 5) return 2.0;
    if (comboCount <= 7) return 2.5;
    return 3.0;
  }

  // Calculer les étoiles selon le score
  static int calculateStars(int score, int targetScore) {
    if (score >= targetScore * 1.5) return 3; // 150% du score cible
    if (score >= targetScore * 1.0) return 2; // 100% du score cible
    if (score >= targetScore * 0.5) return 1; // 50% du score cible
    return 0;
  }

  // Obtenir la description du score
  static String getScoreDescription(int score) {
    if (score >= 10000) return 'Légendaire!';
    if (score >= 5000) return 'Incroyable!';
    if (score >= 2000) return 'Excellent!';
    if (score >= 1000) return 'Très bien!';
    if (score >= 500) return 'Bien!';
    return 'Correct';
  }

  // Calculer le bonus de temps restant
  static int calculateTimeBonus(int timeRemaining, int maxTime) {
    if (timeRemaining <= 0) return 0;

    double timeRatio = timeRemaining / maxTime;
    return (timeRatio * 500).round();
  }

  // Calculer le bonus de mouvements restants
  static int calculateMovesBonus(int movesRemaining, int maxMoves) {
    if (movesRemaining <= 0) return 0;

    double movesRatio = movesRemaining / maxMoves;
    return (movesRatio * 200).round();
  }
}
