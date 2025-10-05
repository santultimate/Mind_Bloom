#!/usr/bin/env python3
"""
Script pour générer les niveaux des mondes 6-10
"""

import json
import random

# Noms et descriptions des mondes 6-10
worlds_data = {
    6: {
        "name": "Marécages Mystiques",
        "theme": "mystic_swamps",
        "tile_types": ["dew", "leaf", "crystal"],
        "colors": ["#20B2AA", "#48CAE4", "#90E0EF"],
        "icon": "water_drop",
        "difficulty": "hard"
    },
    7: {
        "name": "Terres Ardentes", 
        "theme": "burning_lands",
        "tile_types": ["sun", "gem", "flower"],
        "colors": ["#DC143C", "#FF4500", "#FF6347"],
        "icon": "local_fire_department",
        "difficulty": "hard"
    },
    8: {
        "name": "Glacier Éternel",
        "theme": "eternal_glacier", 
        "tile_types": ["crystal", "moon", "dew"],
        "colors": ["#B0E0E6", "#E0FFFF", "#F0F8FF"],
        "icon": "ac_unit",
        "difficulty": "expert"
    },
    9: {
        "name": "Arc-en-Ciel Perdu",
        "theme": "lost_rainbow",
        "tile_types": ["flower", "sun", "moon", "gem"],
        "colors": ["#FF1493", "#00BFFF", "#32CD32", "#FFD700"],
        "icon": "palette", 
        "difficulty": "expert"
    },
    10: {
        "name": "Jardin Céleste",
        "theme": "celestial_garden",
        "tile_types": ["gem", "sun", "moon", "crystal"],
        "colors": ["#FFD700", "#C0C0C0", "#87CEEB"],
        "icon": "star",
        "difficulty": "expert"
    }
}

def generate_level(world_id, level_id, world_data):
    """Génère un niveau pour un monde donné"""
    
    difficulty = world_data["difficulty"]
    tile_types = world_data["tile_types"]
    
    # Configuration selon la difficulté
    if difficulty == "hard":
        grid_size = 8
        energy_cost = 2
        base_moves = 20
        base_score = 3000
    else:  # expert
        grid_size = 9
        energy_cost = 3
        base_moves = 22
        base_score = 3500
    
    # Générer les objectifs - ÉVITER LA REDONDANCE
    num_objectives = 2 if difficulty == "hard" else 3
    objectives = []
    used_tile_types = set()  # Éviter les doublons
    
    # Calculer la cible selon le type de tuile
    base_targets = {
        "flower": 25, "leaf": 28, "crystal": 20, "seed": 30,
        "dew": 22, "sun": 18, "moon": 15, "gem": 12
    }
    
    for i in range(num_objectives):
        # Choisir un type de tuile non utilisé
        available_tiles = [t for t in tile_types if t not in used_tile_types]
        
        if not available_tiles:
            # Si tous les types sont utilisés, utiliser les types disponibles
            available_tiles = tile_types.copy()
        
        tile_type = available_tiles[i % len(available_tiles)]
        used_tile_types.add(tile_type)
        
        target = base_targets.get(tile_type, 20) + (level_id * 2)
        
        objectives.append({
            "type": "collectTiles",
            "tileType": tile_type,
            "target": target
        })
    
    # Ajouter un objectif de score pour les niveaux difficiles
    if difficulty == "expert" and level_id > 7:
        objectives.append({
            "type": "reachScore",
            "target": base_score + (level_id * 200)
        })
    
    # Calculer les mouvements et le score
    max_moves = base_moves + level_id
    target_score = base_score + (level_id * 300)
    
    # Générer les récompenses
    coins = 50 + (level_id * 5)
    experience = 40 + (level_id * 4)
    gems = 1 if level_id % 3 == 0 else 0
    
    rewards = [f"coins:{coins}", f"experience:{experience}"]
    if gems > 0:
        rewards.append(f"gems:{gems}")
    
    # Générer le nom et la description
    level_names = {
        "mystic_swamps": [
            "Rosée Mystique", "Eaux Troubles", "Marécage Enchanté", 
            "Brouillard Magique", "Nénuphars Perdus", "Sérénité Aquatique",
            "Reflets d'Eau", "Profondeurs Légendaires", "Vapeurs Mystiques", "Harmonie Aquatique"
        ],
        "burning_lands": [
            "Lave Ardente", "Terres Brûlantes", "Volcan Actif", 
            "Flamme Éternelle", "Cendres Volcaniques", "Chaleur Extrême",
            "Éruption Magmatique", "Feu Infernal", "Cratère Explosif", "Pouvoir Volcanique"
        ],
        "eternal_glacier": [
            "Glace Pure", "Cristaux de Glace", "Blizzard Éternel", 
            "Reflets Glacés", "Tempête de Neige", "Froid Polaire",
            "Aurore Boréale", "Cristaux Givrés", "Vent Glacial", "Perfection Glacée"
        ],
        "lost_rainbow": [
            "Arc Perdu", "Couleurs Dispersées", "Spectre Magique", 
            "Prisme Brisé", "Palette Céleste", "Teintes Perdues",
            "Mirage Coloré", "Spectre Enchanté", "Couleurs Éternelles", "Harmonie Chromatique"
        ],
        "celestial_garden": [
            "Étoiles Fleuries", "Jardin Céleste", "Constellation Vivante", 
            "Cosmos Bloom", "Galaxie Florale", "Univers Végétal",
            "Nébuleuse Enchantée", "Système Solaire Bloom", "Voie Lactée Magique", "Infini Céleste"
        ]
    }
    
    theme = world_data["theme"]
    name = level_names[theme][level_id - 1]
    
    descriptions = {
        "mystic_swamps": "Naviguez dans les eaux troubles de ce marécage mystique et collectez",
        "burning_lands": "Survivez à la chaleur intense de ces terres volcaniques et récupérez", 
        "eternal_glacier": "Bravez le froid glacial de cette étendue blanche et collectez",
        "lost_rainbow": "Retrouvez les couleurs perdues de cet arc-en-ciel légendaire et récupérez",
        "celestial_garden": "Explorez ce jardin où les étoiles fleurissent et collectez"
    }
    
    description = descriptions[theme]
    objectives_text = ", ".join([f"{obj['target']} {obj['tileType']}" for obj in objectives[:2]])
    description += f" {objectives_text}"
    
    return {
        "id": level_id,
        "worldId": world_id,
        "name": name,
        "description": description,
        "difficulty": difficulty,
        "gridSize": grid_size,
        "maxMoves": max_moves,
        "targetScore": target_score,
        "objectives": objectives,
        "energyCost": energy_cost,
        "rewards": rewards
    }

def main():
    """Génère les niveaux pour les mondes 6-10"""
    
    # Charger le fichier existant
    with open('assets/data/world_levels.json', 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Générer les mondes 6-10
    for world_id in range(6, 11):
        world_key = f"world_{world_id}"
        world_data = worlds_data[world_id]
        
        levels = []
        for level_id in range(1, 11):
            level = generate_level(world_id, level_id, world_data)
            levels.append(level)
        
        data["worlds"][world_key] = levels
        print(f"✅ Monde {world_id} ({world_data['name']}): 10 niveaux générés")
    
    # Mettre à jour les métadonnées
    data["totalLevels"] = 100
    data["worldsCount"] = 10
    
    # Sauvegarder le fichier
    with open('assets/data/world_levels.json', 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    
    print(f"\n🎉 Génération terminée !")
    print(f"📊 Total: {data['totalLevels']} niveaux dans {data['worldsCount']} mondes")
    print(f"💾 Fichier sauvegardé: assets/data/world_levels.json")

if __name__ == "__main__":
    main()






