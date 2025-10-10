#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

/// Script pour analyser et ajuster la difficulté des niveaux
/// Basé sur le ratio objectifs/mouvements disponibles

void main() async {
  print('🎯 Analyse de la faisabilité des niveaux...\n');

  final file = File('assets/data/world_levels.json');
  if (!await file.exists()) {
    print('❌ Fichier world_levels.json non trouvé');
    return;
  }

  final content = await file.readAsString();
  final data = json.decode(content);

  final worlds = data['worlds'] as Map<String, dynamic>;
  final List<Map<String, dynamic>> adjustments = [];

  for (final worldEntry in worlds.entries) {
    final worldId = worldEntry.key;
    final levels = worldEntry.value as List<dynamic>;

    print('🌍 $worldId:');

    for (final level in levels) {
      final levelData = level as Map<String, dynamic>;
      final levelId = levelData['id'];
      final maxMoves = levelData['maxMoves'] as int;
      final targetScore = levelData['targetScore'] as int?;
      final objectives = levelData['objectives'] as List<dynamic>;

      // Calculer la difficulté
      final difficulty = _calculateDifficulty(levelData);
      final feasibility =
          _calculateFeasibility(maxMoves, targetScore, objectives);

      print(
          '  Niveau $levelId: $maxMoves mouvements, Score: ${targetScore ?? "N/A"}, Feasibilité: ${feasibility.toStringAsFixed(2)}');

      // Proposer des ajustements si nécessaire
      final adjustments = _suggestAdjustments(levelData, feasibility);
      if (adjustments.isNotEmpty) {
        print('    🔧 Ajustements suggérés:');
        for (final adjustment in adjustments) {
          print('      - $adjustment');
        }
      }

      print('');
    }
  }

  // Générer un rapport détaillé
  await _generateReport(worlds);
}

/// Calcule la difficulté d'un niveau basée sur ses paramètres
double _calculateDifficulty(Map<String, dynamic> level) {
  final maxMoves = level['maxMoves'] as int;
  final targetScore = level['targetScore'] as int? ?? 0;
  final objectives = level['objectives'] as List<dynamic>;
  final gridSize = level['gridSize'] as int;

  double difficulty = 0;

  // Score par mouvement
  if (targetScore > 0 && maxMoves > 0) {
    difficulty += (targetScore / maxMoves) / 100; // Normaliser
  }

  // Nombre d'objectifs
  difficulty += objectives.length * 0.5;

  // Taille de la grille (plus grand = plus difficile)
  difficulty += (gridSize - 7) * 0.3;

  // Objectifs spécifiques
  for (final obj in objectives) {
    final objData = obj as Map<String, dynamic>;
    final type = objData['type'] as String;
    final target = objData['target'] as int;

    switch (type) {
      case 'collectTiles':
        difficulty += (target / maxMoves) * 2; // Tiles par mouvement
        break;
      case 'reachScore':
        difficulty += (target / maxMoves) / 200; // Score par mouvement
        break;
      case 'clearBoard':
        difficulty += 1.0; // Objectif difficile
        break;
    }
  }

  return difficulty;
}

/// Calcule la faisabilité (0 = impossible, 1 = très facile)
double _calculateFeasibility(
    int maxMoves, int? targetScore, List<dynamic> objectives) {
  double feasibility = 1.0;

  // Score par mouvement (plus de 300 points par mouvement = difficile)
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

/// Suggère des ajustements pour améliorer la faisabilité
List<String> _suggestAdjustments(
    Map<String, dynamic> level, double feasibility) {
  final List<String> suggestions = [];
  final maxMoves = level['maxMoves'] as int;
  final targetScore = level['targetScore'] as int?;
  final objectives = level['objectives'] as List<dynamic>;

  if (feasibility < 0.3) {
    suggestions.add('Niveau très difficile - considérer réduire les objectifs');
  } else if (feasibility < 0.5) {
    suggestions.add('Niveau difficile - ajustements recommandés');
  }

  // Ajustements pour le score
  if (targetScore != null && targetScore > 0) {
    final scorePerMove = targetScore / maxMoves;
    if (scorePerMove > 300) {
      final suggestedScore = (maxMoves * 200).round();
      suggestions.add('Réduire targetScore de $targetScore à $suggestedScore');
    }
  }

  // Ajustements pour les objectifs de collecte
  for (final obj in objectives) {
    final objData = obj as Map<String, dynamic>;
    final type = objData['type'] as String;
    final target = objData['target'] as int;

    if (type == 'collectTiles') {
      final tilesPerMove = target / maxMoves;
      if (tilesPerMove > 2.0) {
        final suggestedTarget = (maxMoves * 1.5).round();
        suggestions
            .add('Réduire objectif collectTiles de $target à $suggestedTarget');
      }
    }
  }

  // Ajustements pour les mouvements
  if (maxMoves < 15 && objectives.length > 2) {
    suggestions
        .add('Augmenter maxMoves à ${maxMoves + 5} pour plus de mouvements');
  }

  return suggestions;
}

/// Génère un rapport détaillé avec recommandations
Future<void> _generateReport(Map<String, dynamic> worlds) async {
  print('\n📊 RAPPORT DÉTAILLÉ DE FAISABILITÉ\n');

  final List<Map<String, dynamic>> problematicLevels = [];
  final List<Map<String, dynamic>> easyLevels = [];

  for (final worldEntry in worlds.entries) {
    final worldId = worldEntry.key;
    final levels = worldEntry.value as List<dynamic>;

    for (final level in levels) {
      final levelData = level as Map<String, dynamic>;
      final feasibility = _calculateFeasibility(
        levelData['maxMoves'] as int,
        levelData['targetScore'] as int?,
        levelData['objectives'] as List<dynamic>,
      );

      if (feasibility < 0.4) {
        problematicLevels.add({
          'world': worldId,
          'level': levelData,
          'feasibility': feasibility,
        });
      } else if (feasibility > 0.8) {
        easyLevels.add({
          'world': worldId,
          'level': levelData,
          'feasibility': feasibility,
        });
      }
    }
  }

  // Niveaux problématiques
  if (problematicLevels.isNotEmpty) {
    print('🚨 NIVEAUX TRÈS DIFFICILES (feasibilité < 0.4):');
    for (final item in problematicLevels) {
      final level = item['level'] as Map<String, dynamic>;
      final feasibility = item['feasibility'] as double;
      print(
          '  ${item['world']} - Niveau ${level['id']}: ${feasibility.toStringAsFixed(2)}');
    }
    print('');
  }

  // Niveaux trop faciles
  if (easyLevels.isNotEmpty) {
    print('😴 NIVEAUX TROP FACILES (feasibilité > 0.8):');
    for (final item in easyLevels) {
      final level = item['level'] as Map<String, dynamic>;
      final feasibility = item['feasibility'] as double;
      print(
          '  ${item['world']} - Niveau ${level['id']}: ${feasibility.toStringAsFixed(2)}');
    }
    print('');
  }

  // Statistiques globales
  int totalLevels = 0;
  double totalFeasibility = 0;

  for (final worldEntry in worlds.entries) {
    final levels = worldEntry.value as List<dynamic>;
    for (final level in levels) {
      final levelData = level as Map<String, dynamic>;
      totalFeasibility += _calculateFeasibility(
        levelData['maxMoves'] as int,
        levelData['targetScore'] as int?,
        levelData['objectives'] as List<dynamic>,
      );
      totalLevels++;
    }
  }

  final averageFeasibility = totalFeasibility / totalLevels;

  print('📈 STATISTIQUES GLOBALES:');
  print('  Total des niveaux: $totalLevels');
  print('  Faisabilité moyenne: ${averageFeasibility.toStringAsFixed(2)}');
  print('  Niveaux problématiques: ${problematicLevels.length}');
  print('  Niveaux trop faciles: ${easyLevels.length}');

  if (averageFeasibility < 0.5) {
    print(
        '\n⚠️  ATTENTION: La faisabilité moyenne est faible. Considérer des ajustements globaux.');
  }
}








