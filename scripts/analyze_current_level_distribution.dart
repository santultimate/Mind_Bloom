import 'dart:io';
import 'dart:convert';

/// Script pour analyser la distribution actuelle des niveaux par monde
/// et identifier les niveaux manquants

void main() async {
  print('🔍 ANALYSE DE LA DISTRIBUTION ACTUELLE DES NIVEAUX');
  print('==================================================\n');

  try {
    // Charger les données des niveaux
    final file = File('assets/data/world_levels.json');
    final jsonString = await file.readAsString();
    final data = jsonDecode(jsonString);

    final worlds = data['worlds'] as Map<String, dynamic>;

    print('📊 DISTRIBUTION ACTUELLE PAR MONDE :');
    print('===================================\n');

    int totalLevels = 0;
    final Map<String, int> worldCounts = {};

    worlds.forEach((worldId, levels) {
      final levelList = levels as List<dynamic>;
      final count = levelList.length;
      worldCounts[worldId] = count;
      totalLevels += count;

      print('🌍 $worldId: $count niveaux');

      // Afficher les IDs des niveaux pour vérifier
      final levelIds = levelList.map((level) => level['id'] as int).toList();
      levelIds.sort();
      print('   IDs: ${levelIds.join(', ')}');

      // Vérifier s'il manque des niveaux dans la séquence
      final missingIds = <int>[];
      for (int i = 1; i <= 10; i++) {
        if (!levelIds.contains(i)) {
          missingIds.add(i);
        }
      }

      if (missingIds.isNotEmpty) {
        print('   ⚠️  MANQUANTS: ${missingIds.join(', ')}');
      } else {
        print('   ✅ Complet (1-10)');
      }
      print('');
    });

    print('📈 RÉSUMÉ :');
    print('===========');
    print('Total des mondes: ${worlds.length}');
    print('Total des niveaux: $totalLevels');
    print('Objectif: ${worlds.length * 10} niveaux (10 par monde)');
    print('Manquants: ${(worlds.length * 10) - totalLevels} niveaux');

    print('\n🎯 MONDES QUI ONT BESOIN DE PLUS DE NIVEAUX :');
    print('==============================================');

    worlds.forEach((worldId, levels) {
      final currentCount = worldCounts[worldId]!;
      final needed = 10 - currentCount;

      if (needed > 0) {
        print(
            '$worldId: $currentCount/10 niveaux - Besoin de $needed niveau(s) supplémentaire(s)');
      } else if (needed == 0) {
        print('$worldId: ✅ Complet (10/10)');
      } else {
        print('$worldId: ⚠️  Trop de niveaux ($currentCount/10)');
      }
    });
  } catch (e) {
    print('❌ Erreur lors de l\'analyse: $e');
  }
}






