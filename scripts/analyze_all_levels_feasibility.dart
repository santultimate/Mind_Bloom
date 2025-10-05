import 'dart:io';
import 'dart:convert';

/// Script pour analyser la faisabilité de tous les niveaux
/// et identifier les incohérences dans la difficulté

void main() async {
  print('🔍 Analyse de faisabilité de tous les niveaux');
  print('============================================\n');

  try {
    // Charger les données des niveaux
    final file = File('assets/data/world_levels.json');
    final jsonString = await file.readAsString();
    final data = jsonDecode(jsonString);

    final worlds = data['worlds'] as Map<String, dynamic>;
    final List<Map<String, dynamic>> allLevels = [];

    // Collecter tous les niveaux
    worlds.forEach((worldId, levels) {
      final levelList = levels as List<dynamic>;
      for (final level in levelList) {
        final levelData = level as Map<String, dynamic>;
        levelData['worldId'] = worldId;
        allLevels.add(levelData);
      }
    });

    print('📊 STATISTIQUES GÉNÉRALES :');
    print('Total des niveaux : ${allLevels.length}');
    print('Nombre de mondes : ${worlds.length}\n');

    // Analyser chaque monde
    final Map<String, List<Map<String, dynamic>>> worldAnalysis = {};

    for (final level in allLevels) {
      final worldId = level['worldId'] as String;
      final feasibility = _calculateFeasibility(level);
      final analysis = _analyzeLevel(level);

      level['feasibility'] = feasibility;
      level['analysis'] = analysis;

      worldAnalysis.putIfAbsent(worldId, () => []);
      worldAnalysis[worldId]!.add(level);
    }

    // Afficher l'analyse par monde
    for (final entry in worldAnalysis.entries) {
      final worldId = entry.key;
      final levels = entry.value;

      print('🌍 $worldId (${levels.length} niveaux) :');
      print('-' * 50);

      for (final level in levels) {
        final id = level['id'] as int;
        final name = level['name'] as String;
        final feasibility = level['feasibility'] as double;
        final analysis = level['analysis'] as Map<String, dynamic>;

        final status = _getFeasibilityStatus(feasibility);
        print('Niveau $id: $name');
        print('  Faisabilité: ${feasibility.toStringAsFixed(2)} ($status)');
        print('  Coups: ${level['maxMoves']}, Score: ${level['targetScore']}');
        print('  Points/coup: ${analysis['scorePerMove'].toStringAsFixed(1)}');
        print('  Objectifs: ${analysis['objectivesCount']}');
        print('  ${analysis['difficulty']}');

        if (feasibility < 0.3 || feasibility > 0.9) {
          print('  ⚠️  ATTENTION: Niveau déséquilibré !');
        }
        print('');
      }

      // Statistiques du monde
      final avgFeasibility = levels
              .map((l) => l['feasibility'] as double)
              .reduce((a, b) => a + b) /
          levels.length;
      final problematicLevels = levels
          .where((l) =>
              (l['feasibility'] as double) < 0.3 ||
              (l['feasibility'] as double) > 0.9)
          .length;

      print('📈 Moyenne faisabilité: ${avgFeasibility.toStringAsFixed(2)}');
      print('⚠️  Niveaux problématiques: $problematicLevels/${levels.length}');
      print('\n' + '=' * 60 + '\n');
    }

    // Identifier les niveaux les plus problématiques
    print('🚨 NIVEAUX LES PLUS PROBLÉMATIQUES :');
    print('===================================\n');

    final allLevelsWithFeasibility = allLevels
        .map((level) => {
              'level': level,
              'feasibility': level['feasibility'] as double,
              'worldId': level['worldId'] as String,
            })
        .toList();

    // Trier par faisabilité (plus problématiques en premier)
    allLevelsWithFeasibility.sort((a, b) =>
        (a['feasibility'] as double).compareTo(b['feasibility'] as double));

    print('🔴 TRÈS DIFFICILES (faisabilité < 0.3) :');
    final veryHard = allLevelsWithFeasibility
        .where((l) => (l['feasibility'] as double) < 0.3)
        .toList();
    for (final item in veryHard.take(10)) {
      final level = item['level'] as Map<String, dynamic>;
      final feasibility = item['feasibility'] as double;
      final worldId = item['worldId'] as String;
      print(
          '  ${worldId.toUpperCase()} Niveau ${level['id']}: ${level['name']} (${feasibility.toStringAsFixed(2)})');
    }

    print('\n🟢 TRÈS FACILES (faisabilité > 0.9) :');
    final veryEasy = allLevelsWithFeasibility
        .where((l) => (l['feasibility'] as double) > 0.9)
        .toList();
    for (final item in veryEasy.take(10)) {
      final level = item['level'] as Map<String, dynamic>;
      final feasibility = item['feasibility'] as double;
      final worldId = item['worldId'] as String;
      print(
          '  ${worldId.toUpperCase()} Niveau ${level['id']}: ${level['name']} (${feasibility.toStringAsFixed(2)})');
    }

    // Recommandations
    print('\n💡 RECOMMANDATIONS :');
    print('===================');
    print('• Faisabilité idéale: 0.4 - 0.7');
    print('• Niveaux boss: 0.3 - 0.5 (plus difficiles)');
    print('• Niveaux tutoriel: 0.6 - 0.8');
    print('• Niveaux normaux: 0.4 - 0.6');

    final totalProblematic = veryHard.length + veryEasy.length;
    print('\n📊 RÉSUMÉ :');
    print('Niveaux très difficiles: ${veryHard.length}');
    print('Niveaux très faciles: ${veryEasy.length}');
    print(
        'Total problématiques: $totalProblematic/${allLevels.length} (${(totalProblematic / allLevels.length * 100).toStringAsFixed(1)}%)');
  } catch (e) {
    print('❌ Erreur lors de l\'analyse: $e');
  }
}

/// Calcule la faisabilité d'un niveau (0.0 = impossible, 1.0 = très facile)
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

  // Bonus pour les niveaux boss
  if (level['isBossLevel'] == true) {
    feasibility -= 0.1; // Les boss sont plus difficiles
  }

  return feasibility.clamp(0.0, 1.0);
}

/// Analyse détaillée d'un niveau
Map<String, dynamic> _analyzeLevel(Map<String, dynamic> level) {
  final maxMoves = level['maxMoves'] as int;
  final targetScore = level['targetScore'] as int?;
  final objectives = level['objectives'] as List<dynamic>;

  final scorePerMove = targetScore != null ? targetScore / maxMoves : 0.0;
  final objectivesCount = objectives.length;

  String difficulty = 'Équilibré';
  if (scorePerMove > 250)
    difficulty = 'Très difficile';
  else if (scorePerMove > 200)
    difficulty = 'Difficile';
  else if (scorePerMove > 150)
    difficulty = 'Modéré';
  else if (scorePerMove > 100)
    difficulty = 'Facile';
  else if (scorePerMove > 0) difficulty = 'Très facile';

  return {
    'scorePerMove': scorePerMove,
    'objectivesCount': objectivesCount,
    'difficulty': difficulty,
  };
}

/// Détermine le statut de faisabilité
String _getFeasibilityStatus(double feasibility) {
  if (feasibility < 0.2)
    return 'IMPOSSIBLE';
  else if (feasibility < 0.3)
    return 'TRÈS DIFFICILE';
  else if (feasibility < 0.4)
    return 'DIFFICILE';
  else if (feasibility < 0.6)
    return 'ÉQUILIBRÉ';
  else if (feasibility < 0.8)
    return 'FACILE';
  else
    return 'TRÈS FACILE';
}







