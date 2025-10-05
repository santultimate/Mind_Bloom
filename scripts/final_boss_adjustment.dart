#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

/// Script pour ajuster définitivement les niveaux boss à faisabilité 0.35

void main() async {
  print('🎯 Ajustement final des niveaux boss à faisabilité 0.35...\n');

  final file = File('assets/data/world_levels.json');
  if (!await file.exists()) {
    print('❌ Fichier world_levels.json non trouvé');
    return;
  }

  final content = await file.readAsString();
  final data = json.decode(content);

  final worlds = data['worlds'] as Map<String, dynamic>;
  int bossLevelsAdjusted = 0;

  for (final worldEntry in worlds.entries) {
    final worldId = worldEntry.key;
    final levels = worldEntry.value as List<dynamic>;

    // Le niveau 10 est le boss level de chaque monde
    if (levels.length >= 10) {
      final bossLevel =
          levels[9] as Map<String, dynamic>; // Index 9 = niveau 10
      final levelId = bossLevel['id'];

      print('🌍 ${worldId} - Niveau $levelId (BOSS LEVEL):');

      // Calculer la faisabilité actuelle
      final currentFeasibility = _calculateFeasibility(bossLevel);
      print(
          '  📊 Faisabilité actuelle: ${currentFeasibility.toStringAsFixed(2)}');

      if ((currentFeasibility - 0.35).abs() > 0.05) {
        final adjustedBossLevel = _adjustToExactFeasibility(bossLevel, 0.35);
        final adjustments = _getAdjustmentsList(bossLevel, adjustedBossLevel);

        if (adjustments.isNotEmpty) {
          levels[9] = adjustedBossLevel;
          bossLevelsAdjusted++;

          final newFeasibility = _calculateFeasibility(adjustedBossLevel);
          print('  ✅ Ajustements appliqués: ${adjustments.join(', ')}');
          print(
              '  📊 Nouvelle faisabilité: ${newFeasibility.toStringAsFixed(2)}');
        }
      } else {
        print('  ✨ Faisabilité déjà correcte');
      }

      print('');
    }
  }

  if (bossLevelsAdjusted > 0) {
    // Sauvegarder les modifications
    final updatedContent = json.encode(data);
    await file.writeAsString(updatedContent);
    print('💾 $bossLevelsAdjusted niveaux boss ont été ajustés et sauvegardés');
  } else {
    print('✨ Tous les niveaux boss ont déjà une faisabilité correcte');
  }
}

/// Calcule la faisabilité d'un niveau
double _calculateFeasibility(Map<String, dynamic> level) {
  final maxMoves = level['maxMoves'] as int;
  final targetScore = level['targetScore'] as int?;
  final objectives = level['objectives'] as List<dynamic>;

  double feasibility = 1.0;

  // Score par mouvement
  if (targetScore != null && targetScore > 0) {
    final scorePerMove = targetScore / maxMoves;
    if (scorePerMove > 400) {
      feasibility -= 0.4;
    } else if (scorePerMove > 300) {
      feasibility -= 0.3;
    } else if (scorePerMove > 250) {
      feasibility -= 0.2;
    } else if (scorePerMove > 200) {
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
      if (tilesPerMove > 3.0) {
        feasibility -= 0.5;
      } else if (tilesPerMove > 2.5) {
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

/// Ajuste un niveau pour atteindre exactement la faisabilité cible
Map<String, dynamic> _adjustToExactFeasibility(
    Map<String, dynamic> level, double targetFeasibility) {
  final adjustedLevel = Map<String, dynamic>.from(level);

  final maxMoves = level['maxMoves'] as int;
  final targetScore = level['targetScore'] as int?;
  final objectives = level['objectives'] as List<dynamic>;

  // Stratégie d'ajustement agressive pour atteindre exactement 0.35

  // 1. Réduire significativement le score si trop élevé
  if (targetScore != null && targetScore > 0) {
    final scorePerMove = targetScore / maxMoves;
    if (scorePerMove > 250) {
      // Réduire le score pour avoir ~200 points par mouvement
      final newScore = (maxMoves * 200).round();
      adjustedLevel['targetScore'] = newScore;
    }
  }

  // 2. Réduire significativement les objectifs de collecte
  final adjustedObjectives = <Map<String, dynamic>>[];
  for (final obj in objectives) {
    final adjustedObj = Map<String, dynamic>.from(obj);
    final type = obj['type'] as String;
    final target = obj['target'] as int;

    if (type == 'collectTiles') {
      final tilesPerMove = target / maxMoves;
      if (tilesPerMove > 1.8) {
        // Réduire pour avoir ~1.6 tuiles par mouvement
        final newTarget = (maxMoves * 1.6).round();
        adjustedObj['target'] = newTarget;
      }
    } else if (type == 'reachScore') {
      final scorePerMove = target / maxMoves;
      if (scorePerMove > 200) {
        // Réduire pour avoir ~180 points par mouvement
        final newTarget = (maxMoves * 180).round();
        adjustedObj['target'] = newTarget;
      }
    }

    adjustedObjectives.add(adjustedObj);
  }

  adjustedLevel['objectives'] = adjustedObjectives;

  // 3. Ajuster les mouvements si nécessaire
  final newFeasibility = _calculateFeasibility(adjustedLevel);
  if (newFeasibility < targetFeasibility - 0.05) {
    // Encore trop difficile, ajouter plus de mouvements
    adjustedLevel['maxMoves'] = maxMoves + 3;
  } else if (newFeasibility > targetFeasibility + 0.05) {
    // Trop facile, retirer quelques mouvements
    adjustedLevel['maxMoves'] = (maxMoves - 2).clamp(18, maxMoves);
  }

  return adjustedLevel;
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

  // Comparer les objectifs existants
  for (int i = 0;
      i < originalObjectives.length && i < adjustedObjectives.length;
      i++) {
    final originalObj = originalObjectives[i] as Map<String, dynamic>;
    final adjustedObj = adjustedObjectives[i] as Map<String, dynamic>;

    if (originalObj['target'] != adjustedObj['target']) {
      final tileType = adjustedObj['tileType'] ?? 'Objectif';
      adjustments.add(
          '$tileType: ${originalObj['target']} → ${adjustedObj['target']}');
    }
  }

  return adjustments;
}







