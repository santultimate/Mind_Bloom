#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

/// Script pour calculer la faisabilité détaillée d'un niveau spécifique

void main(List<String> args) async {
  if (args.length < 2) {
    print('Usage: dart calculate_level_feasibility.dart <world_id> <level_id>');
    print('Exemple: dart calculate_level_feasibility.dart world_1 8');
    return;
  }

  final worldId = args[0];
  final levelId = int.tryParse(args[1]);

  if (levelId == null) {
    print('❌ Level ID doit être un nombre');
    return;
  }

  print('🔍 Calcul de faisabilité pour $worldId - Niveau $levelId\n');

  final file = File('assets/data/world_levels.json');
  if (!await file.exists()) {
    print('❌ Fichier world_levels.json non trouvé');
    return;
  }

  final content = await file.readAsString();
  final data = json.decode(content);

  final worlds = data['worlds'] as Map<String, dynamic>;
  final worldLevels = worlds[worldId];

  if (worldLevels == null) {
    print('❌ Monde $worldId non trouvé');
    return;
  }

  final levels = worldLevels as List<dynamic>;
  final level = levels.firstWhere(
    (l) => l['id'] == levelId,
    orElse: () => null,
  );

  if (level == null) {
    print('❌ Niveau $levelId non trouvé dans $worldId');
    return;
  }

  final levelData = level as Map<String, dynamic>;
  final feasibility = calculateDetailedFeasibility(
    levelData: levelData,
    showDetails: true,
  );

  print('\n📊 RÉSUMÉ :');
  print('  Faisabilité : ${feasibility.toStringAsFixed(2)}');
  print('  Interprétation : ${_getInterpretation(feasibility)}');
}

/// Calcule la faisabilité détaillée d'un niveau
double calculateDetailedFeasibility({
  required Map<String, dynamic> levelData,
  bool showDetails = false,
}) {
  final maxMoves = levelData['maxMoves'] as int;
  final targetScore = levelData['targetScore'] as int? ?? 0;
  final objectives = levelData['objectives'] as List<dynamic>;

  if (showDetails) {
    print('🎮 INFORMATIONS DU NIVEAU :');
    print('  Nom : ${levelData['name']}');
    print('  Monde : ${levelData['worldId']}');
    print('  Mouvements : $maxMoves');
    print('  Score cible : $targetScore');
    print('  Objectifs : ${objectives.length}');
    print('');

    print('🎯 OBJECTIFS DÉTAILLÉS :');
    for (int i = 0; i < objectives.length; i++) {
      final obj = objectives[i] as Map<String, dynamic>;
      final type = obj['type'] as String;
      final target = obj['target'] as int;

      if (type == 'collectTiles') {
        final tileType = obj['tileType'] as String;
        final tilesPerMove = target / maxMoves;
        print(
            '  ${i + 1}. Collecter $target $tileType (${tilesPerMove.toStringAsFixed(1)}/mouvement)');
      } else if (type == 'reachScore') {
        final scorePerMove = target / maxMoves;
        print(
            '  ${i + 1}. Atteindre $target points (${scorePerMove.toStringAsFixed(1)}/mouvement)');
      } else {
        print('  ${i + 1}. $type : $target');
      }
    }
    print('');
  }

  double feasibility = 1.0;

  // Calcul pénalité score
  if (targetScore > 0) {
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
      print('📈 CALCUL SCORE :');
      print('  Score total : $targetScore');
      print('  Mouvements : $maxMoves');
      print('  Score/mouvement : ${scorePerMove.toStringAsFixed(1)}');
      print('  Pénalité score : $scorePenalty');
      print('');
    }

    feasibility -= scorePenalty;
  }

  // Calcul pénalité objectifs
  double maxObjectivePenalty = 0;

  if (showDetails) {
    print('🎯 CALCUL OBJECTIFS :');
  }

  for (final obj in objectives) {
    final objData = obj as Map<String, dynamic>;
    final type = objData['type'] as String;
    final target = objData['target'] as int;

    if (type == 'collectTiles') {
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

      maxObjectivePenalty =
          maxObjectivePenalty > objPenalty ? maxObjectivePenalty : objPenalty;

      if (showDetails) {
        final tileType = objData['tileType'] as String;
        print(
            '  $tileType : $target tuiles (${tilesPerMove.toStringAsFixed(1)}/mouvement) → Pénalité : $objPenalty');
      }
    } else if (type == 'reachScore') {
      final scorePerMove = target / maxMoves;
      double objPenalty = 0;

      if (scorePerMove > 400) {
        objPenalty = 0.4;
      } else if (scorePerMove > 300) {
        objPenalty = 0.3;
      } else if (scorePerMove > 250) {
        objPenalty = 0.2;
      } else if (scorePerMove > 200) {
        objPenalty = 0.1;
      }

      maxObjectivePenalty =
          maxObjectivePenalty > objPenalty ? maxObjectivePenalty : objPenalty;

      if (showDetails) {
        print(
            '  Score objectif : $target points (${scorePerMove.toStringAsFixed(1)}/mouvement) → Pénalité : $objPenalty');
      }
    }
  }

  if (showDetails) {
    print('  Pénalité objectifs max : $maxObjectivePenalty');
    print('');
  }

  feasibility -= maxObjectivePenalty;

  // Résultat final
  feasibility = feasibility.clamp(0.0, 1.0);

  if (showDetails) {
    print('🧮 CALCUL FINAL :');
    print('  Faisabilité de base : 1.0');
    print('  Pénalités totales : ${(1.0 - feasibility).toStringAsFixed(2)}');
    print('  FAISABILITÉ FINALE : ${feasibility.toStringAsFixed(2)}');
  }

  return feasibility;
}

/// Interprète la faisabilité
String _getInterpretation(double feasibility) {
  if (feasibility >= 0.9) return 'Très facile (tutoriel)';
  if (feasibility >= 0.8) return 'Facile (accessible)';
  if (feasibility >= 0.6) return 'Équilibré (bon défi)';
  if (feasibility >= 0.4) return 'Difficile (défi significatif)';
  if (feasibility >= 0.2) return 'Très difficile (boss level)';
  return 'Extrêmement difficile (impossible)';
}

