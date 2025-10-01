#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

/// Script pour ajuster automatiquement les niveaux trop difficiles ou trop faciles

void main() async {
  print('🔧 Ajustement automatique des niveaux...\n');

  final file = File('assets/data/world_levels.json');
  if (!await file.exists()) {
    print('❌ Fichier world_levels.json non trouvé');
    return;
  }

  final content = await file.readAsString();
  final data = json.decode(content);

  final worlds = data['worlds'] as Map<String, dynamic>;
  int adjustmentsCount = 0;

  for (final worldEntry in worlds.entries) {
    final worldId = worldEntry.key;
    final levels = worldEntry.value as List<dynamic>;

    print('🌍 Ajustement de $worldId:');

    for (int i = 0; i < levels.length; i++) {
      final level = levels[i] as Map<String, dynamic>;
      final levelId = level['id'];

      final adjustedLevel = _adjustLevel(level);
      final adjustments = _getAdjustmentsList(level, adjustedLevel);
      if (adjustments.isNotEmpty) {
        levels[i] = adjustedLevel; // Mettre à jour le niveau
        adjustmentsCount++;
        print('  ✅ Niveau $levelId ajusté: ${adjustments.join(', ')}');
      }
    }
  }

  if (adjustmentsCount > 0) {
    // Sauvegarder les modifications
    final updatedContent = json.encode(data);
    await file.writeAsString(updatedContent);
    print('\n💾 $adjustmentsCount niveaux ont été ajustés et sauvegardés');
  } else {
    print(
        '\n✨ Aucun ajustement nécessaire - tous les niveaux sont bien équilibrés');
  }
}

/// Compare deux niveaux et retourne la liste des ajustements
List<String> _getAdjustmentsList(
    Map<String, dynamic> original, Map<String, dynamic> adjusted) {
  final List<String> adjustments = [];

  if (original['maxMoves'] != adjusted['maxMoves']) {
    adjustments
        .add('Mouvements: ${original['maxMoves']} → ${adjusted['maxMoves']}');
  }

  if (original['targetScore'] != adjusted['targetScore']) {
    adjustments
        .add('Score: ${original['targetScore']} → ${adjusted['targetScore']}');
  }

  final originalObjectives = original['objectives'] as List<dynamic>;
  final adjustedObjectives = adjusted['objectives'] as List<dynamic>;

  for (int i = 0; i < originalObjectives.length; i++) {
    final originalObj = originalObjectives[i] as Map<String, dynamic>;
    final adjustedObj = adjustedObjectives[i] as Map<String, dynamic>;

    if (originalObj['target'] != adjustedObj['target']) {
      adjustments.add(
          '${adjustedObj['tileType']}: ${originalObj['target']} → ${adjustedObj['target']}');
    }
  }

  return adjustments;
}

/// Ajuste un niveau individuel si nécessaire
Map<String, dynamic> _adjustLevel(Map<String, dynamic> level) {
  // Créer une copie profonde du niveau
  final adjustedLevel = Map<String, dynamic>.from(level);

  final maxMoves = level['maxMoves'] as int;
  final targetScore = level['targetScore'] as int?;
  final objectives = level['objectives'] as List<dynamic>;

  // Ajuster le score si trop élevé par mouvement
  if (targetScore != null && targetScore > 0) {
    final scorePerMove = targetScore / maxMoves;
    if (scorePerMove > 300) {
      final newScore = (maxMoves * 250).round();
      adjustedLevel['targetScore'] = newScore;
    } else if (scorePerMove < 100) {
      final newScore = (maxMoves * 150).round();
      adjustedLevel['targetScore'] = newScore;
    }
  }

  // Ajuster les objectifs de collecte
  final adjustedObjectives = <Map<String, dynamic>>[];
  for (final obj in objectives) {
    final adjustedObj = Map<String, dynamic>.from(obj);
    final type = obj['type'] as String;
    final target = obj['target'] as int;

    if (type == 'collectTiles') {
      final tilesPerMove = target / maxMoves;

      // Trop difficile (plus de 2.5 tuiles par mouvement)
      if (tilesPerMove > 2.5) {
        final newTarget = (maxMoves * 2.0).round();
        adjustedObj['target'] = newTarget;
      }
      // Trop facile (moins de 1.0 tuile par mouvement)
      else if (tilesPerMove < 1.0 && maxMoves > 15) {
        final newTarget = (maxMoves * 1.2).round();
        adjustedObj['target'] = newTarget;
      }
    }

    adjustedObjectives.add(adjustedObj);
  }
  adjustedLevel['objectives'] = adjustedObjectives;

  // Ajuster le nombre de mouvements si nécessaire
  if (maxMoves < 12 && objectives.length > 1) {
    adjustedLevel['maxMoves'] = maxMoves + 3;
  }

  return adjustedLevel;
}

/// Calcule la faisabilité d'un niveau
double _calculateFeasibility(
    int maxMoves, int? targetScore, List<dynamic> objectives) {
  double feasibility = 1.0;

  // Score par mouvement
  if (targetScore != null && targetScore > 0) {
    final scorePerMove = targetScore / maxMoves;
    if (scorePerMove > 300) {
      feasibility -= 0.3;
    } else if (scorePerMove > 200) {
      feasibility -= 0.2;
    } else if (scorePerMove > 150) {
      feasibility -= 0.1;
    }
  }

  // Objectifs de collecte
  for (final obj in objectives) {
    final objData = obj as Map<String, dynamic>;
    final type = objData['type'] as String;
    final target = objData['target'] as int;

    if (type == 'collectTiles') {
      final tilesPerMove = target / maxMoves;
      if (tilesPerMove > 2.5) {
        feasibility -= 0.4;
      } else if (tilesPerMove > 2.0) {
        feasibility -= 0.3;
      } else if (tilesPerMove > 1.5) {
        feasibility -= 0.2;
      } else if (tilesPerMove > 1.0) {
        feasibility -= 0.1;
      }
    }
  }

  return feasibility.clamp(0.0, 1.0);
}
