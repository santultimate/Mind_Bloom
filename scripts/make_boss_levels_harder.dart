#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

/// Script pour rendre les derniers niveaux de chaque monde plus difficiles
/// Ces "boss levels" doivent être des défis pour mériter le passage au monde suivant

void main() async {
  print('🔥 Création des niveaux boss difficiles...\n');

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

      final adjustedBossLevel = _makeBossLevelHarder(bossLevel, worldId);
      final adjustments = _getAdjustmentsList(bossLevel, adjustedBossLevel);
      if (adjustments.isNotEmpty) {
        levels[9] = adjustedBossLevel; // Mettre à jour le niveau boss
        bossLevelsAdjusted++;
        print('  ✅ Ajustements appliqués: ${adjustments.join(', ')}');
      }

      // Afficher les stats finales du boss level
      final maxMoves = bossLevel['maxMoves'] as int;
      final targetScore = bossLevel['targetScore'] as int?;
      final objectives = bossLevel['objectives'] as List<dynamic>;

      print(
          '  📊 Stats finales: $maxMoves mouvements, Score: ${targetScore ?? "N/A"}');
      print('  🎯 Objectifs:');
      for (final obj in objectives) {
        final objData = obj as Map<String, dynamic>;
        if (objData['type'] == 'collectTiles') {
          print('    - Collecter ${objData['target']} ${objData['tileType']}');
        } else if (objData['type'] == 'reachScore') {
          print('    - Atteindre ${objData['target']} points');
        }
      }
      print('');
    }
  }

  if (bossLevelsAdjusted > 0) {
    // Sauvegarder les modifications
    final updatedContent = json.encode(data);
    await file.writeAsString(updatedContent);
    print(
        '💾 $bossLevelsAdjusted niveaux boss ont été rendus plus difficiles et sauvegardés');
  } else {
    print('✨ Tous les niveaux boss sont déjà suffisamment difficiles');
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

  // Comparer les objectifs existants
  for (int i = 0;
      i < originalObjectives.length && i < adjustedObjectives.length;
      i++) {
    final originalObj = originalObjectives[i] as Map<String, dynamic>;
    final adjustedObj = adjustedObjectives[i] as Map<String, dynamic>;

    if (originalObj['target'] != adjustedObj['target']) {
      adjustments.add(
          '${adjustedObj['tileType'] ?? 'Objectif'}: ${originalObj['target']} → ${adjustedObj['target']}');
    }
  }

  // Vérifier les nouveaux objectifs ajoutés
  if (adjustedObjectives.length > originalObjectives.length) {
    adjustments.add(
        '${adjustedObjectives.length - originalObjectives.length} nouvel objectif(s) ajouté(s)');
  }

  if (original['rewards'] != adjusted['rewards']) {
    adjustments.add('Récompenses augmentées');
  }

  return adjustments;
}

/// Rend un niveau boss plus difficile
Map<String, dynamic> _makeBossLevelHarder(
    Map<String, dynamic> level, String worldId) {
  // Créer une copie profonde du niveau
  final adjustedLevel = Map<String, dynamic>.from(level);

  // Augmenter la difficulté selon le monde
  final worldNumber = int.tryParse(worldId.split('_').last) ?? 1;
  final difficultyMultiplier =
      1.0 + (worldNumber * 0.15); // Plus difficile pour les mondes avancés

  final maxMoves = level['maxMoves'] as int;
  final targetScore = level['targetScore'] as int?;
  final objectives = level['objectives'] as List<dynamic>;

  // 1. Réduire le nombre de mouvements (plus difficile)
  final newMaxMoves = (maxMoves * 0.85).round().clamp(15, maxMoves - 2);
  adjustedLevel['maxMoves'] = newMaxMoves;

  // 2. Augmenter significativement le score requis
  if (targetScore != null && targetScore > 0) {
    final newTargetScore = (targetScore * difficultyMultiplier * 1.3).round();
    adjustedLevel['targetScore'] = newTargetScore;
  }

  // 3. Augmenter les objectifs de collecte
  final adjustedObjectives = <Map<String, dynamic>>[];
  for (final obj in objectives) {
    final adjustedObj = Map<String, dynamic>.from(obj);
    final type = obj['type'] as String;
    final target = obj['target'] as int;

    if (type == 'collectTiles') {
      // Augmenter de 20-40% selon le monde
      final increasePercent = 0.2 + (worldNumber * 0.02);
      final newTarget = (target * (1 + increasePercent)).round();
      adjustedObj['target'] = newTarget;
    } else if (type == 'reachScore') {
      final newTarget = (target * difficultyMultiplier * 1.2).round();
      adjustedObj['target'] = newTarget;
    }

    adjustedObjectives.add(adjustedObj);
  }

  // 4. Ajouter un objectif bonus pour les mondes avancés (mondes 3+)
  if (worldNumber >= 3 && adjustedObjectives.length < 3) {
    final bonusObjective = _createBonusObjective(worldNumber, newMaxMoves);
    if (bonusObjective != null) {
      adjustedObjectives.add(bonusObjective);
    }
  }

  adjustedLevel['objectives'] = adjustedObjectives;

  // 5. Ajuster les récompenses pour refléter la difficulté
  final rewards = level['rewards'] as List<dynamic>? ?? [];
  if (rewards.isNotEmpty) {
    final enhancedRewards = <String>[];
    for (final reward in rewards) {
      final rewardStr = reward as String;
      if (rewardStr.startsWith('coins:')) {
        final currentCoins = int.tryParse(rewardStr.split(':').last) ?? 0;
        final newCoins = (currentCoins * difficultyMultiplier).round();
        enhancedRewards.add('coins:$newCoins');
      } else if (rewardStr.startsWith('experience:')) {
        final currentExp = int.tryParse(rewardStr.split(':').last) ?? 0;
        final newExp = (currentExp * difficultyMultiplier).round();
        enhancedRewards.add('experience:$newExp');
      } else {
        enhancedRewards.add(rewardStr);
      }
    }
    adjustedLevel['rewards'] = enhancedRewards;
  }

  // 6. Marquer comme niveau boss
  adjustedLevel['isBossLevel'] = true;
  adjustedLevel['difficulty'] = 'boss';

  return adjustedLevel;
}

/// Crée un objectif bonus pour les niveaux boss avancés
Map<String, dynamic>? _createBonusObjective(int worldNumber, int maxMoves) {
  final List<String> tileTypes = [
    'flower',
    'leaf',
    'crystal',
    'seed',
    'dew',
    'sun',
    'moon',
    'gem'
  ];
  final randomTileType = tileTypes[(worldNumber * 7) % tileTypes.length];

  // Objectif bonus : collecter des tuiles spéciales
  return {
    'type': 'collectTiles',
    'tileType': randomTileType,
    'target':
        (maxMoves * 1.8).round(), // Plus difficile que les objectifs normaux
  };
}

/// Calcule la nouvelle faisabilité d'un niveau boss
double _calculateBossFeasibility(Map<String, dynamic> level) {
  final maxMoves = level['maxMoves'] as int;
  final targetScore = level['targetScore'] as int?;
  final objectives = level['objectives'] as List<dynamic>;

  double feasibility = 1.0;

  // Pour les niveaux boss, on accepte une faisabilité plus faible (0.3-0.5)
  // Car ils sont censés être difficiles

  // Score par mouvement (plus strict pour les boss)
  if (targetScore != null && targetScore > 0) {
    final scorePerMove = targetScore / maxMoves;
    if (scorePerMove > 400) {
      feasibility -= 0.4;
    } else if (scorePerMove > 300) {
      feasibility -= 0.3;
    } else if (scorePerMove > 250) {
      feasibility -= 0.2;
    }
  }

  // Objectifs de collecte (plus strict)
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
      }
    }
  }

  return feasibility.clamp(0.2, 1.0); // Min 0.2 pour les boss levels
}
