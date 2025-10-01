import 'dart:io';
import 'dart:convert';

/// Script pour générer les mondes 4 et 5 manquants
/// et compléter la collection à 100 niveaux (10 mondes × 10 niveaux)

void main() async {
  print('🎮 GÉNÉRATION DES MONDES MANQUANTS');
  print('===================================\n');

  try {
    // Charger les données existantes
    final file = File('assets/data/world_levels.json');
    final jsonString = await file.readAsString();
    final data = jsonDecode(jsonString);

    final worlds = data['worlds'] as Map<String, dynamic>;

    // Générer le monde 4 - Forêt Enchantée
    print('🌲 Génération du Monde 4 - Forêt Enchantée...');
    worlds['world_4'] = _generateWorld4Levels();

    // Générer le monde 5 - Montagnes Mystiques
    print('⛰️ Génération du Monde 5 - Montagnes Mystiques...');
    worlds['world_5'] = _generateWorld5Levels();

    // Mettre à jour les métadonnées
    data['totalLevels'] = 100;
    data['worldsCount'] = 10;
    data['generatedAt'] = DateTime.now().toIso8601String();

    // Sauvegarder le fichier mis à jour
    final updatedJson = jsonEncode(data);
    await file.writeAsString(updatedJson);

    print('\n✅ GÉNÉRATION TERMINÉE !');
    print('========================');
    print('Monde 4 ajouté: 10 niveaux');
    print('Monde 5 ajouté: 10 niveaux');
    print('Total des mondes: 10');
    print('Total des niveaux: 100');

    // Vérification finale
    print('\n🔍 VÉRIFICATION FINALE :');
    worlds.forEach((worldId, levels) {
      final levelList = levels as List<dynamic>;
      print('$worldId: ${levelList.length} niveaux');
    });
  } catch (e) {
    print('❌ Erreur lors de la génération: $e');
  }
}

/// Génère les niveaux pour le Monde 4 - Forêt Enchantée
List<Map<String, dynamic>> _generateWorld4Levels() {
  return [
    {
      "id": 1,
      "worldId": 4,
      "name": "Entrée Mystique",
      "description":
          "Pénétrez dans cette forêt ancienne emplie de magie et de mystères",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 16,
      "targetScore": 2200,
      "objectives": [
        {"type": "collectTiles", "tileType": "leaf", "target": 22}
      ],
      "energyCost": 1,
      "rewards": ["coins:35", "experience:25"]
    },
    {
      "id": 2,
      "worldId": 4,
      "name": "Sous-Bois Magique",
      "description":
          "Explorez les profondeurs de la forêt où la magie prend vie",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 17,
      "targetScore": 2400,
      "objectives": [
        {"type": "collectTiles", "tileType": "leaf", "target": 24},
        {"type": "collectTiles", "tileType": "dew", "target": 18}
      ],
      "energyCost": 1,
      "rewards": ["coins:40", "gems:1", "experience:30"]
    },
    {
      "id": 3,
      "worldId": 4,
      "name": "Champignons Lumineux",
      "description":
          "Découvrez les champignons magiques qui éclairent les sentiers",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 18,
      "targetScore": 2600,
      "objectives": [
        {"type": "collectTiles", "tileType": "crystal", "target": 20}
      ],
      "energyCost": 1,
      "rewards": ["coins:45", "experience:35"]
    },
    {
      "id": 4,
      "worldId": 4,
      "name": "Clairière Enchantée",
      "description":
          "Trouvez la clairière où se cachent les plus beaux trésors",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 19,
      "targetScore": 2800,
      "objectives": [
        {"type": "collectTiles", "tileType": "flower", "target": 20},
        {"type": "collectTiles", "tileType": "crystal", "target": 18}
      ],
      "energyCost": 1,
      "rewards": ["coins:50", "experience:40"]
    },
    {
      "id": 5,
      "worldId": 4,
      "name": "Arbres Anciens",
      "description":
          "Communiez avec les arbres millénaires de cette forêt sacrée",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 20,
      "targetScore": 3000,
      "objectives": [
        {"type": "collectTiles", "tileType": "seed", "target": 25},
        {"type": "reachScore", "target": 3000}
      ],
      "energyCost": 1,
      "rewards": ["coins:55", "gems:1", "experience:45"]
    },
    {
      "id": 6,
      "worldId": 4,
      "name": "Ruines Elfiques",
      "description":
          "Explorez les anciennes ruines elfiques perdues dans la forêt",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 21,
      "targetScore": 3200,
      "objectives": [
        {"type": "collectTiles", "tileType": "gem", "target": 22}
      ],
      "energyCost": 1,
      "rewards": ["coins:60", "experience:50"]
    },
    {
      "id": 7,
      "worldId": 4,
      "name": "Fontaine Magique",
      "description": "Découvrez la source de magie qui alimente toute la forêt",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 22,
      "targetScore": 3400,
      "objectives": [
        {"type": "collectTiles", "tileType": "dew", "target": 28},
        {"type": "collectTiles", "tileType": "crystal", "target": 20}
      ],
      "energyCost": 1,
      "rewards": ["coins:65", "gems:1", "experience:55"]
    },
    {
      "id": 8,
      "worldId": 4,
      "name": "Grotte Secrète",
      "description":
          "Pénétrez dans la grotte secrète où reposent les cristaux anciens",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 23,
      "targetScore": 3600,
      "objectives": [
        {"type": "collectTiles", "tileType": "crystal", "target": 30},
        {"type": "collectTiles", "tileType": "gem", "target": 20}
      ],
      "energyCost": 1,
      "rewards": ["coins:70", "experience:60"]
    },
    {
      "id": 9,
      "worldId": 4,
      "name": "Sanctuaire Perdu",
      "description": "Trouvez le sanctuaire perdu des gardiens de la forêt",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 24,
      "targetScore": 3800,
      "objectives": [
        {"type": "collectTiles", "tileType": "leaf", "target": 26},
        {"type": "collectTiles", "tileType": "flower", "target": 24},
        {"type": "collectTiles", "tileType": "crystal", "target": 22}
      ],
      "energyCost": 1,
      "rewards": ["coins:75", "gems:1", "experience:65"]
    },
    {
      "id": 10,
      "worldId": 4,
      "name": "Cœur de la Forêt",
      "description": "Atteignez le cœur magique de la forêt enchantée",
      "difficulty": "boss",
      "gridSize": 8,
      "maxMoves": 20,
      "targetScore": 3420,
      "objectives": [
        {"type": "collectTiles", "tileType": "leaf", "target": 32},
        {"type": "collectTiles", "tileType": "crystal", "target": 32},
        {"type": "collectTiles", "tileType": "gem", "target": 32}
      ],
      "energyCost": 1,
      "rewards": ["coins:92", "gems:2", "experience:80"],
      "isBossLevel": true
    }
  ];
}

/// Génère les niveaux pour le Monde 5 - Montagnes Mystiques
List<Map<String, dynamic>> _generateWorld5Levels() {
  return [
    {
      "id": 1,
      "worldId": 5,
      "name": "Sentier Escarpé",
      "description": "Commencez l'ascension de ces montagnes mystérieuses",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 17,
      "targetScore": 2300,
      "objectives": [
        {"type": "collectTiles", "tileType": "sun", "target": 20}
      ],
      "energyCost": 1,
      "rewards": ["coins:40", "experience:30"]
    },
    {
      "id": 2,
      "worldId": 5,
      "name": "Plateau Venté",
      "description": "Naviguez sur ce plateau balayé par les vents de montagne",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 18,
      "targetScore": 2500,
      "objectives": [
        {"type": "collectTiles", "tileType": "sun", "target": 22},
        {"type": "collectTiles", "tileType": "crystal", "target": 18}
      ],
      "energyCost": 1,
      "rewards": ["coins:45", "gems:1", "experience:35"]
    },
    {
      "id": 3,
      "worldId": 5,
      "name": "Sommet Enneigé",
      "description":
          "Atteignez le sommet enneigé où brillent les cristaux de glace",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 19,
      "targetScore": 2700,
      "objectives": [
        {"type": "collectTiles", "tileType": "crystal", "target": 24}
      ],
      "energyCost": 1,
      "rewards": ["coins:50", "experience:40"]
    },
    {
      "id": 4,
      "worldId": 5,
      "name": "Grotte de Glace",
      "description": "Explorez la grotte de glace aux reflets cristallins",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 20,
      "targetScore": 2900,
      "objectives": [
        {"type": "collectTiles", "tileType": "moon", "target": 20},
        {"type": "collectTiles", "tileType": "crystal", "target": 20}
      ],
      "energyCost": 1,
      "rewards": ["coins:55", "experience:45"]
    },
    {
      "id": 5,
      "worldId": 5,
      "name": "Aigle Doré",
      "description": "Observez l'aigle doré planant au-dessus des cimes",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 21,
      "targetScore": 3100,
      "objectives": [
        {"type": "collectTiles", "tileType": "sun", "target": 26},
        {"type": "reachScore", "target": 3100}
      ],
      "energyCost": 1,
      "rewards": ["coins:60", "gems:1", "experience:50"]
    },
    {
      "id": 6,
      "worldId": 5,
      "name": "Mine Abandonnée",
      "description":
          "Explorez cette ancienne mine où reposent des gemmes précieuses",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 22,
      "targetScore": 3300,
      "objectives": [
        {"type": "collectTiles", "tileType": "gem", "target": 24}
      ],
      "energyCost": 1,
      "rewards": ["coins:65", "experience:55"]
    },
    {
      "id": 7,
      "worldId": 5,
      "name": "Lac de Montagne",
      "description": "Découvrez ce lac de montagne aux eaux cristallines",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 23,
      "targetScore": 3500,
      "objectives": [
        {"type": "collectTiles", "tileType": "dew", "target": 26},
        {"type": "collectTiles", "tileType": "moon", "target": 22}
      ],
      "energyCost": 1,
      "rewards": ["coins:70", "gems:1", "experience:60"]
    },
    {
      "id": 8,
      "worldId": 5,
      "name": "Cascade Céleste",
      "description": "Admirez cette cascade qui semble tomber du ciel",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 24,
      "targetScore": 3700,
      "objectives": [
        {"type": "collectTiles", "tileType": "dew", "target": 30},
        {"type": "collectTiles", "tileType": "sun", "target": 24}
      ],
      "energyCost": 1,
      "rewards": ["coins:75", "experience:65"]
    },
    {
      "id": 9,
      "worldId": 5,
      "name": "Temple Perdu",
      "description":
          "Découvrez le temple perdu des anciens gardiens des montagnes",
      "difficulty": "medium",
      "gridSize": 8,
      "maxMoves": 25,
      "targetScore": 3900,
      "objectives": [
        {"type": "collectTiles", "tileType": "sun", "target": 28},
        {"type": "collectTiles", "tileType": "moon", "target": 26},
        {"type": "collectTiles", "tileType": "gem", "target": 24}
      ],
      "energyCost": 1,
      "rewards": ["coins:80", "gems:1", "experience:70"]
    },
    {
      "id": 10,
      "worldId": 5,
      "name": "Pic Suprême",
      "description": "Atteignez le pic suprême des montagnes mystiques",
      "difficulty": "boss",
      "gridSize": 8,
      "maxMoves": 21,
      "targetScore": 3600,
      "objectives": [
        {"type": "collectTiles", "tileType": "sun", "target": 30},
        {"type": "collectTiles", "tileType": "crystal", "target": 30},
        {"type": "collectTiles", "tileType": "moon", "target": 30}
      ],
      "energyCost": 1,
      "rewards": ["coins:96", "gems:2", "experience:84"],
      "isBossLevel": true
    }
  ];
}

