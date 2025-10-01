import 'dart:io';
import 'dart:convert';

/// Script pour corriger les niveaux problématiques identifiés

void main() async {
  print('🔧 CORRECTION DES NIVEAUX PROBLÉMATIQUES');
  print('========================================\n');

  try {
    // Charger les données des niveaux
    final file = File('assets/data/world_levels.json');
    final jsonString = await file.readAsString();
    final data = jsonDecode(jsonString);

    final worlds = data['worlds'] as Map<String, dynamic>;

    // Corriger le niveau 10 du monde 4 (trop difficile)
    print('🔧 Correction du Monde 4, Niveau 10 - Cœur de la Forêt...');
    final world4Levels = worlds['world_4'] as List<dynamic>;
    final level10World4 = world4Levels.firstWhere((level) => level['id'] == 10);
    level10World4['maxMoves'] = 25; // Augmenter les coups de 20 à 25
    level10World4['targetScore'] = 3000; // Réduire le score de 3420 à 3000

    // Corriger le niveau 4 du monde 5 (trop facile)
    print('🔧 Correction du Monde 5, Niveau 4 - Grotte de Glace...');
    final world5Levels = worlds['world_5'] as List<dynamic>;
    final level4World5 = world5Levels.firstWhere((level) => level['id'] == 4);
    level4World5['maxMoves'] = 18; // Réduire les coups de 20 à 18
    level4World5['targetScore'] = 3200; // Augmenter le score de 2900 à 3200

    // Sauvegarder les corrections
    final updatedJson = jsonEncode(data);
    await file.writeAsString(updatedJson);

    print('\n✅ CORRECTIONS APPLIQUÉES !');
    print('============================');
    print('Monde 4, Niveau 10: Coups 20→25, Score 3420→3000');
    print('Monde 5, Niveau 4: Coups 20→18, Score 2900→3200');

    // Vérification rapide
    print('\n📊 VÉRIFICATION RAPIDE :');
    print(
        'Monde 4, Niveau 10 - Faisabilité: ${_calculateFeasibility(level10World4).toStringAsFixed(2)}');
    print(
        'Monde 5, Niveau 4 - Faisabilité: ${_calculateFeasibility(level4World5).toStringAsFixed(2)}');
  } catch (e) {
    print('❌ Erreur lors de la correction: $e');
  }
}

/// Calcule la faisabilité d'un niveau (version simplifiée)
double _calculateFeasibility(Map<String, dynamic> level) {
  double feasibility = 1.0;

  final maxMoves = level['maxMoves'] as int;
  final targetScore = level['targetScore'] as int?;
  final objectives = level['objectives'] as List<dynamic>;

  // Pénalité pour le score
  if (targetScore != null && targetScore > 0) {
    final scorePerMove = targetScore / maxMoves;
    if (scorePerMove > 400)
      feasibility -= 0.5;
    else if (scorePerMove > 300)
      feasibility -= 0.4;
    else if (scorePerMove > 250)
      feasibility -= 0.3;
    else if (scorePerMove > 200)
      feasibility -= 0.2;
    else if (scorePerMove > 150) feasibility -= 0.1;
  }

  // Pénalité pour les objectifs de collecte
  for (final obj in objectives) {
    final type = obj['type'] as String;
    if (type == 'collectTiles') {
      final target = obj['target'] as int;
      final tilesPerMove = target / maxMoves;
      if (tilesPerMove > 3.0)
        feasibility -= 0.5;
      else if (tilesPerMove > 2.5)
        feasibility -= 0.4;
      else if (tilesPerMove > 2.0)
        feasibility -= 0.3;
      else if (tilesPerMove > 1.5)
        feasibility -= 0.2;
      else if (tilesPerMove > 1.0) feasibility -= 0.1;
    }
  }

  return feasibility.clamp(0.0, 1.0);
}

