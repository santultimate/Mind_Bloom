import 'dart:convert';
import 'dart:io';

/// Script pour analyser les textes en dur dans le fichier des niveaux
void main() async {
  final file = File('../assets/data/world_levels.json');
  final contents = await file.readAsString();
  final json = jsonDecode(contents);
  
  final Map<String, dynamic> worlds = json['worlds'];
  final Set<String> levelNames = {};
  final Set<String> levelDescriptions = {};
  final Map<String, List<String>> namesByWorld = {};
  final Map<String, List<String>> descriptionsByWorld = {};
  
  print('🔍 Analyse des textes en dur dans les niveaux...\n');
  
  worlds.forEach((worldKey, levels) {
    final worldNumber = worldKey.split('_')[1];
    namesByWorld[worldNumber] = [];
    descriptionsByWorld[worldNumber] = [];
    
    print('📁 Monde $worldNumber:');
    
    for (final level in levels as List<dynamic>) {
      final name = level['name'] as String;
      final description = level['description'] as String;
      
      levelNames.add(name);
      levelDescriptions.add(description);
      namesByWorld[worldNumber]!.add(name);
      descriptionsByWorld[worldNumber]!.add(description);
      
      print('  • $name');
    }
    print('');
  });
  
  print('📊 Statistiques:');
  print('  • Nombre total de noms de niveaux: ${levelNames.length}');
  print('  • Nombre total de descriptions: ${levelDescriptions.length}');
  print('  • Nombre de mondes: ${worlds.length}');
  
  print('\n📝 Noms des niveaux uniques:');
  levelNames.forEach((name) => print('  • "$name"'));
  
  print('\n📝 Descriptions des niveaux uniques:');
  levelDescriptions.forEach((desc) => print('  • "$desc"'));
  
  // Générer les clés de traduction
  print('\n🔑 Clés de traduction suggérées:');
  print('\n// Noms des niveaux');
  int levelId = 1;
  worlds.forEach((worldKey, levels) {
    final worldNumber = worldKey.split('_')[1];
    print('\n// Monde $worldNumber');
    for (final level in levels as List<dynamic>) {
      final name = level['name'] as String;
      final key = 'level_${levelId}_name';
      print('"$key": "$name",');
      levelId++;
    }
  });
  
  print('\n// Descriptions des niveaux');
  levelId = 1;
  worlds.forEach((worldKey, levels) {
    final worldNumber = worldKey.split('_')[1];
    print('\n// Monde $worldNumber');
    for (final level in levels as List<dynamic>) {
      final description = level['description'] as String;
      final key = 'level_${levelId}_description';
      print('"$key": "$description",');
      levelId++;
    }
  });
  
  // Analyser les textes qui pourraient être des patterns
  print('\n🔍 Analyse des patterns dans les noms:');
  final namePatterns = <String, int>{};
  levelNames.forEach((name) {
    final words = name.split(' ');
    words.forEach((word) {
      namePatterns[word] = (namePatterns[word] ?? 0) + 1;
    });
  });
  
  namePatterns.entries
    .where((entry) => entry.value > 1)
    .toList()
  ..sort((a, b) => b.value.compareTo(a.value))
  ..forEach((entry) {
    print('  • "$entry.key": ${entry.value} occurrences');
  });
  
  print('\n🔍 Analyse des patterns dans les descriptions:');
  final descPatterns = <String, int>{};
  levelDescriptions.forEach((desc) {
    final words = desc.split(' ');
    words.forEach((word) {
      // Nettoyer les mots (enlever la ponctuation)
      final cleanWord = word.replaceAll(RegExp(r'[^\w]'), '').toLowerCase();
      if (cleanWord.length > 3) {
        descPatterns[cleanWord] = (descPatterns[cleanWord] ?? 0) + 1;
      }
    });
  });
  
  descPatterns.entries
    .where((entry) => entry.value > 2)
    .toList()
  ..sort((a, b) => b.value.compareTo(a.value))
  ..forEach((entry) {
    print('  • "$entry.key": ${entry.value} occurrences');
  });
}
