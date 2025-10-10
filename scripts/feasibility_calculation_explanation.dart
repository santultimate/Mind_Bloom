#!/usr/bin/env dart

/// EXPLICATION DÉTAILLÉE DE LA MÉTHODE DE CALCUL DU TAUX DE RÉUSSITE (FAISABILITÉ)
///
/// Le taux de réussite est calculé sur une échelle de 0.0 à 1.0 où :
/// - 0.0 = Impossible à réussir
/// - 1.0 = Très facile à réussir
/// - 0.5 = Équilibré (difficile mais faisable)

void main() {
  print('📊 MÉTHODE DE CALCUL DU TAUX DE RÉUSSITE DÉTAILLÉE\n');

  print('🎯 ÉCHELLE DE FAISABILITÉ :');
  print('  0.0 - 0.2 : Très difficile (niveau boss extrême)');
  print('  0.2 - 0.4 : Difficile (défi significatif)');
  print('  0.4 - 0.6 : Équilibré (difficile mais faisable) ← OBJECTIF');
  print('  0.6 - 0.8 : Facile (accessible)');
  print('  0.8 - 1.0 : Très facile (tutoriel)\n');

  print('🔢 FORMULE DE CALCUL :');
  print('  Faisabilité = 1.0 - Pénalités');
  print('  Pénalités = PénalitéScore + PénalitéObjectifs\n');

  print('📈 PÉNALITÉS POUR LE SCORE (points par mouvement) :');
  print('  > 400 points/mouvement : -0.4 (40% de pénalité)');
  print('  > 300 points/mouvement : -0.3 (30% de pénalité)');
  print('  > 250 points/mouvement : -0.2 (20% de pénalité)');
  print('  > 200 points/mouvement : -0.1 (10% de pénalité)');
  print('  < 200 points/mouvement : 0 (aucune pénalité)\n');

  print('🎯 PÉNALITÉS POUR LES OBJECTIFS DE COLLECTE (tuiles par mouvement) :');
  print('  > 3.0 tuiles/mouvement : -0.5 (50% de pénalité)');
  print('  > 2.5 tuiles/mouvement : -0.4 (40% de pénalité)');
  print('  > 2.0 tuiles/mouvement : -0.3 (30% de pénalité)');
  print('  > 1.5 tuiles/mouvement : -0.2 (20% de pénalité)');
  print('  > 1.0 tuiles/mouvement : -0.1 (10% de pénalité)');
  print('  < 1.0 tuiles/mouvement : 0 (aucune pénalité)\n');

  print('📝 EXEMPLES DE CALCUL :\n');

  // Exemple 1 : Niveau facile
  print('🌱 EXEMPLE 1 - NIVEAU FACILE :');
  print('  - 20 mouvements, 3000 points');
  print('  - Objectif : collecter 15 flowers');
  print('  - Score/mouvement : 3000 ÷ 20 = 150 points/mouvement');
  print('  - Tuiles/mouvement : 15 ÷ 20 = 0.75 tuiles/mouvement');
  print('  - Pénalité score : 0 (150 < 200)');
  print('  - Pénalité objectif : 0 (0.75 < 1.0)');
  print('  - FAISABILITÉ = 1.0 - 0 - 0 = 1.0 (très facile)\n');

  // Exemple 2 : Niveau équilibré
  print('⚖️ EXEMPLE 2 - NIVEAU ÉQUILIBRÉ :');
  print('  - 25 mouvements, 5000 points');
  print('  - Objectif : collecter 35 flowers');
  print('  - Score/mouvement : 5000 ÷ 25 = 200 points/mouvement');
  print('  - Tuiles/mouvement : 35 ÷ 25 = 1.4 tuiles/mouvement');
  print('  - Pénalité score : 0 (200 = 200)');
  print('  - Pénalité objectif : -0.1 (1.4 > 1.0)');
  print('  - FAISABILITÉ = 1.0 - 0 - 0.1 = 0.9 (facile)\n');

  // Exemple 3 : Niveau difficile
  print('🔥 EXEMPLE 3 - NIVEAU DIFFICILE :');
  print('  - 20 mouvements, 6000 points');
  print('  - Objectif : collecter 50 flowers');
  print('  - Score/mouvement : 6000 ÷ 20 = 300 points/mouvement');
  print('  - Tuiles/mouvement : 50 ÷ 20 = 2.5 tuiles/mouvement');
  print('  - Pénalité score : -0.3 (300 > 250)');
  print('  - Pénalité objectif : -0.4 (2.5 = 2.5)');
  print('  - FAISABILITÉ = 1.0 - 0.3 - 0.4 = 0.3 (difficile)\n');

  // Exemple 4 : Niveau boss
  print('👑 EXEMPLE 4 - NIVEAU BOSS :');
  print('  - 25 mouvements, 4500 points');
  print('  - Objectifs : 35 flowers + 35 crystals');
  print('  - Score/mouvement : 4500 ÷ 25 = 180 points/mouvement');
  print('  - Tuiles/mouvement : (35 + 35) ÷ 25 = 2.8 tuiles/mouvement');
  print('  - Pénalité score : 0 (180 < 200)');
  print('  - Pénalité objectif : -0.4 (2.8 > 2.5)');
  print(
      '  - FAISABILITÉ = 1.0 - 0 - 0.4 = 0.6 (équilibré - objectif atteint!)\n');

  print('🎯 OBJECTIFS DÉFINIS :');
  print('  - Niveaux normaux : 0.5 - 0.8 (équilibré à facile)');
  print('  - Niveaux boss : 0.6 (difficile mais faisable)');
  print('  - Niveaux tutoriel : 0.8 - 1.0 (très facile)\n');

  print('📊 INTERPRÉTATION DES RÉSULTATS :');
  print('  - 0.9+ : Le joueur réussit facilement, peut-être trop simple');
  print('  - 0.7-0.9 : Niveau accessible, bonne progression');
  print('  - 0.5-0.7 : Niveau équilibré, défi approprié');
  print('  - 0.3-0.5 : Niveau difficile, défi significatif');
  print('  - 0.0-0.3 : Niveau très difficile, risque de frustration\n');

  print('🔧 AJUSTEMENTS AUTOMATIQUES :');
  print('  Si faisabilité < 0.4 : Réduire score et objectifs');
  print('  Si faisabilité > 0.8 : Augmenter légèrement la difficulté');
  print('  Si faisabilité = 0.6 : Parfait pour un niveau boss!\n');

  print('✅ CONCLUSION :');
  print('  Cette méthode garantit une progression équilibrée où chaque');
  print('  niveau représente un défi approprié selon sa position dans');
  print('  la progression du jeu.');
}

/// Fonction de calcul détaillée avec logs
double calculateDetailedFeasibility({
  required int maxMoves,
  required int targetScore,
  required List<Map<String, dynamic>> objectives,
  bool showDetails = false,
}) {
  if (showDetails) {
    print('🔍 CALCUL DÉTAILLÉ :');
    print('  Mouvements : $maxMoves');
    print('  Score cible : $targetScore');
    print('  Objectifs : ${objectives.length}');
  }

  double feasibility = 1.0;

  // Calcul pénalité score
  final scorePerMove = targetScore / maxMoves;
  double scorePenalty = 0;

  if (scorePerMove > 400) {
    scorePenalty = 0.4;
  } else if (scorePerMove > 300) {
    scorePenalty = 0.3;
  } else if (scorePerMove > 250) {
    scorePenalty = 0.2;
  } else if (scorePerMove > 200) {
    scorePenalty = 0.1;
  }

  if (showDetails) {
    print('  Score/mouvement : ${scorePerMove.toStringAsFixed(1)}');
    print('  Pénalité score : $scorePenalty');
  }

  // Calcul pénalité objectifs
  double objectivePenalty = 0;
  for (final obj in objectives) {
    if (obj['type'] == 'collectTiles') {
      final target = obj['target'] as int;
      final tilesPerMove = target / maxMoves;

      double objPenalty = 0;
      if (tilesPerMove > 3.0) {
        objPenalty = 0.5;
      } else if (tilesPerMove > 2.5) {
        objPenalty = 0.4;
      } else if (tilesPerMove > 2.0) {
        objPenalty = 0.3;
      } else if (tilesPerMove > 1.5) {
        objPenalty = 0.2;
      } else if (tilesPerMove > 1.0) {
        objPenalty = 0.1;
      }

      objectivePenalty =
          objectivePenalty > objPenalty ? objectivePenalty : objPenalty;

      if (showDetails) {
        print(
            '  ${obj['tileType']}/mouvement : ${tilesPerMove.toStringAsFixed(1)}');
        print('  Pénalité ${obj['tileType']} : $objPenalty');
      }
    }
  }

  if (showDetails) {
    print('  Pénalité objectifs max : $objectivePenalty');
  }

  // Calcul final
  feasibility = 1.0 - scorePenalty - objectivePenalty;
  feasibility = feasibility.clamp(0.0, 1.0);

  if (showDetails) {
    print('  FAISABILITÉ FINALE : ${feasibility.toStringAsFixed(2)}');
    print('');
  }

  return feasibility;
}








