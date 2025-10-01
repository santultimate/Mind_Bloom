import 'dart:convert';
import 'dart:io';

/// Script pour générer les traductions des niveaux
void main() async {
  final file = File('assets/data/world_levels.json');
  final contents = await file.readAsString();
  final json = jsonDecode(contents);
  
  final Map<String, dynamic> worlds = json['worlds'];
  
  print('🌍 Génération des traductions des niveaux...\n');
  
  // Générer les traductions françaises
  await _generateFrenchTranslations(worlds);
  
  // Générer les traductions anglaises
  await _generateEnglishTranslations(worlds);
  
  print('✅ Traductions générées avec succès !');
}

/// Génère les traductions françaises
Future<void> _generateFrenchTranslations(Map<String, dynamic> worlds) async {
  final frenchFile = File('lib/l10n/level_translations_fr.dart');
  final buffer = StringBuffer();
  
  buffer.writeln('// Traductions françaises des niveaux');
  buffer.writeln('// Généré automatiquement - Ne pas modifier manuellement');
  buffer.writeln();
  buffer.writeln('const Map<String, String> levelTranslationsFr = {');
  
  int levelId = 1;
  worlds.forEach((worldKey, levels) {
    buffer.writeln('  // Monde ${worldKey.split('_')[1]}');
    for (final level in levels as List<dynamic>) {
      final name = level['name'] as String;
      final description = level['description'] as String;
      
      buffer.writeln('  "level_${levelId}_name": "$name",');
      buffer.writeln('  "level_${levelId}_description": "$description",');
      levelId++;
    }
    buffer.writeln();
  });
  
  buffer.writeln('};');
  
  await frenchFile.writeAsString(buffer.toString());
  print('📝 Traductions françaises générées dans lib/l10n/level_translations_fr.dart');
}

/// Génère les traductions anglaises
Future<void> _generateEnglishTranslations(Map<String, dynamic> worlds) async {
  final englishFile = File('lib/l10n/level_translations_en.dart');
  final buffer = StringBuffer();
  
  buffer.writeln('// Traductions anglaises des niveaux');
  buffer.writeln('// Généré automatiquement - Ne pas modifier manuellement');
  buffer.writeln();
  buffer.writeln('const Map<String, String> levelTranslationsEn = {');
  
  int levelId = 1;
  worlds.forEach((worldKey, levels) {
    buffer.writeln('  // World ${worldKey.split('_')[1]}');
    for (final level in levels as List<dynamic>) {
      final name = level['name'] as String;
      final description = level['description'] as String;
      
      // Traduire le nom
      final translatedName = _translateLevelName(name);
      buffer.writeln('  "level_${levelId}_name": "$translatedName",');
      
      // Traduire la description
      final translatedDescription = _translateLevelDescription(description);
      buffer.writeln('  "level_${levelId}_description": "$translatedDescription",');
      levelId++;
    }
    buffer.writeln();
  });
  
  buffer.writeln('};');
  
  await englishFile.writeAsString(buffer.toString());
  print('📝 Traductions anglaises générées dans lib/l10n/level_translations_en.dart');
}

/// Traduit le nom d'un niveau en anglais
String _translateLevelName(String frenchName) {
  final translations = {
    'Premiers Pas': 'First Steps',
    'Graines de Vie': 'Seeds of Life',
    'Feuilles Tendres': 'Tender Leaves',
    'Rosée Matinale': 'Morning Dew',
    'Première Floraison': 'First Bloom',
    'Harmonie du Jardin': 'Garden Harmony',
    'Gouttes de Rosée': 'Dew Drops',
    'Jardin en Fleurs': 'Blooming Garden',
    'Abondance Naturelle': 'Natural Abundance',
    'Maître du Jardin': 'Garden Master',
    
    'Vallée Colorée': 'Colorful Valley',
    'Épanouissement': 'Blooming',
    'Éclat Solaire': 'Solar Radiance',
    'Palette de Couleurs': 'Color Palette',
    'Chaleur Bienfaisante': 'Beneficial Warmth',
    'Mélange Harmonieux': 'Harmonious Mix',
    'Rayons Dorés': 'Golden Rays',
    'Fleurs Éclatantes': 'Brilliant Flowers',
    'Vallée en Fleurs': 'Flowering Valley',
    'Maître des Couleurs': 'Color Master',
    
    'Lueur Lunaire': 'Lunar Glow',
    'Cristaux de Nuit': 'Night Crystals',
    'Mystère Nocturne': 'Nocturnal Mystery',
    'Gemmes Précieuses': 'Precious Gems',
    'Clair de Lune': 'Moonlight',
    'Cristaux Enchantés': 'Enchanted Crystals',
    'Trésors Nocturnes': 'Nocturnal Treasures',
    'Forêt Mystique': 'Mystic Forest',
    'Lune d\'Argent': 'Silver Moon',
    'Maître de la Nuit': 'Master of Night',
    
    'Rosée Mystique': 'Mystic Dew',
    'Eaux Troubles': 'Troubled Waters',
    'Marécage Enchanté': 'Enchanted Swamp',
    'Brouillard Magique': 'Magical Mist',
    'Nénuphars Perdus': 'Lost Water Lilies',
    'Sérénité Aquatique': 'Aquatic Serenity',
    'Reflets d\'Eau': 'Water Reflections',
    'Profondeurs Légendaires': 'Legendary Depths',
    'Vapeurs Mystiques': 'Mystic Vapors',
    'Harmonie Aquatique': 'Aquatic Harmony',
    
    'Lave Ardente': 'Burning Lava',
    'Terres Brûlantes': 'Burning Lands',
    'Volcan Actif': 'Active Volcano',
    'Flamme Éternelle': 'Eternal Flame',
    'Cendres Volcaniques': 'Volcanic Ash',
    'Chaleur Extrême': 'Extreme Heat',
    'Éruption Magmatique': 'Magmatic Eruption',
    'Feu Infernal': 'Infernal Fire',
    'Cratère Explosif': 'Explosive Crater',
    'Pouvoir Volcanique': 'Volcanic Power',
    
    'Glace Pure': 'Pure Ice',
    'Cristaux de Glace': 'Ice Crystals',
    'Blizzard Éternel': 'Eternal Blizzard',
    'Reflets Glacés': 'Icy Reflections',
    'Tempête de Neige': 'Snowstorm',
    'Froid Polaire': 'Polar Cold',
    'Aurore Boréale': 'Northern Lights',
    'Cristaux Givrés': 'Frosted Crystals',
    'Vent Glacial': 'Icy Wind',
    'Perfection Glacée': 'Icy Perfection',
    
    'Arc Perdu': 'Lost Arc',
    'Couleurs Dispersées': 'Scattered Colors',
    'Spectre Magique': 'Magical Spectrum',
    'Prisme Brisé': 'Broken Prism',
    'Palette Céleste': 'Celestial Palette',
    'Teintes Perdues': 'Lost Tints',
    'Mirage Coloré': 'Colorful Mirage',
    'Spectre Enchanté': 'Enchanted Spectrum',
    'Couleurs Éternelles': 'Eternal Colors',
    'Harmonie Chromatique': 'Chromatic Harmony',
    
    'Étoiles Fleuries': 'Flowering Stars',
    'Jardin Céleste': 'Celestial Garden',
    'Constellation Vivante': 'Living Constellation',
    'Cosmos Bloom': 'Cosmos Bloom',
    'Galaxie Florale': 'Floral Galaxy',
    'Univers Végétal': 'Vegetal Universe',
    'Nébuleuse Enchantée': 'Enchanted Nebula',
    'Système Solaire Bloom': 'Solar System Bloom',
    'Voie Lactée Magique': 'Magical Milky Way',
    'Infini Céleste': 'Celestial Infinity',
  };
  
  return translations[frenchName] ?? frenchName;
}

/// Traduit la description d'un niveau en anglais
String _translateLevelDescription(String frenchDescription) {
  // Traductions de base
  final baseTranslations = {
    'Commencez votre aventure dans ce jardin paisible où les premières graines de votre voyage prennent vie': 'Begin your adventure in this peaceful garden where the first seeds of your journey come to life',
    'Plantez les premières graines de votre jardin magique': 'Plant the first seeds of your magical garden',
    'Observez les premières feuilles qui émergent de la terre': 'Watch the first leaves emerging from the earth',
    'Récoltez la rosée précieuse qui nourrit vos jeunes plantes': 'Harvest the precious dew that nourishes your young plants',
    'Admirez la première fleur qui s\'épanouit dans votre jardin': 'Admire the first flower blooming in your garden',
    'Créez l\'harmonie parfaite entre graines, feuilles et fleurs': 'Create perfect harmony between seeds, leaves and flowers',
    'Collectez les perles de rosée qui brillent au lever du soleil': 'Collect the dew pearls that shine at sunrise',
    'Transformez votre jardin en un véritable paradis floral': 'Transform your garden into a true floral paradise',
    'Récoltez les fruits de votre patience et de votre travail': 'Harvest the fruits of your patience and work',
    'Démontrez votre maîtrise des éléments fondamentaux du jardinage': 'Demonstrate your mastery of fundamental gardening elements',
    
    'Explorez une vallée colorée où fleurissent les plus belles créations de la nature': 'Explore a colorful valley where nature\'s most beautiful creations bloom',
    'Laissez les fleurs s\'épanouir dans toute leur splendeur': 'Let the flowers bloom in all their splendor',
    'Baignez-vous dans la lumière dorée du soleil': 'Bathe in the golden light of the sun',
    'Créez une symphonie de couleurs avec fleurs et feuilles': 'Create a symphony of colors with flowers and leaves',
    'Profitez de la chaleur bienfaisante qui favorise la croissance': 'Enjoy the beneficial warmth that promotes growth',
    'Mélangez les couleurs avec des feuilles et des graines': 'Mix colors with leaves and seeds',
    'Capturez l\'énergie du soleil dans votre jardin': 'Capture the energy of the sun in your garden',
    'Admirez les fleurs les plus éclatantes de la vallée': 'Admire the most brilliant flowers of the valley',
    'Transformez cette vallée en un véritable jardin d\'Eden': 'Transform this valley into a true Garden of Eden',
    'Démontrez votre maîtrise de l\'art floral et des couleurs': 'Demonstrate your mastery of floral art and colors',
    
    'Plongez dans l\'obscurité mystérieuse de cette forêt baignée par la lumière lunaire': 'Dive into the mysterious darkness of this forest bathed in lunar light',
    'Découvrez les cristaux qui brillent dans l\'obscurité de la forêt': 'Discover the crystals that shine in the forest darkness',
    'Explorez les secrets cachés dans l\'ombre des arbres anciens': 'Explore the secrets hidden in the shadow of ancient trees',
    'Récupérez les gemmes rares qui se cachent dans les profondeurs': 'Retrieve the rare gems hidden in the depths',
    'Baignez-vous dans la douce lumière argentée de la lune': 'Bathe in the gentle silvery light of the moon',
    'Découvrez la puissance des cristaux enchantés': 'Discover the power of enchanted crystals',
    'Récupérez les trésors qui ne se révèlent que la nuit': 'Retrieve the treasures that only reveal themselves at night',
    'Naviguez dans les méandres de cette forêt emplie de magie': 'Navigate the meanders of this magic-filled forest',
    'Admirez la lune dans toute sa splendeur argentée': 'Admire the moon in all its silvery splendor',
    'Démontrez votre maîtrise des éléments nocturnes et mystiques': 'Demonstrate your mastery of nocturnal and mystical elements',
  };
  
  // Si c'est une traduction de base, l'utiliser
  if (baseTranslations.containsKey(frenchDescription)) {
    return baseTranslations[frenchDescription]!;
  }
  
  // Sinon, faire une traduction générique pour les descriptions avec objectifs
  if (frenchDescription.contains('collectez') || frenchDescription.contains('récupérez')) {
    return _translateObjectiveDescription(frenchDescription);
  }
  
  return frenchDescription; // Fallback
}

/// Traduit une description avec objectifs
String _translateObjectiveDescription(String frenchDescription) {
  String result = frenchDescription;
  
  // Traductions des parties communes
  result = result.replaceAll('Naviguez dans les eaux troubles de ce marécage mystique et', 'Navigate the troubled waters of this mystic swamp and');
  result = result.replaceAll('Survivez à la chaleur intense de ces terres volcaniques et', 'Survive the intense heat of these volcanic lands and');
  result = result.replaceAll('Bravez le froid glacial de cette étendue blanche et', 'Brave the icy cold of this white expanse and');
  result = result.replaceAll('Retrouvez les couleurs perdues de cet arc-en-ciel légendaire et', 'Recover the lost colors of this legendary rainbow and');
  result = result.replaceAll('Explorez ce jardin où les étoiles fleurissent et', 'Explore this garden where stars bloom and');
  
  // Traductions des objectifs
  result = result.replaceAll('collectez', 'collect');
  result = result.replaceAll('récupérez', 'retrieve');
  
  // Traductions des types de tuiles
  result = result.replaceAll('dew', 'dew');
  result = result.replaceAll('leaf', 'leaf');
  result = result.replaceAll('sun', 'sun');
  result = result.replaceAll('gem', 'gem');
  result = result.replaceAll('crystal', 'crystal');
  result = result.replaceAll('moon', 'moon');
  result = result.replaceAll('flower', 'flower');
  
  return result;
}
