# Debug du Niveau 7 - Génération du Gameplay

## Problème à Vérifier
Le gameplay du niveau 7 est-il correctement généré ?

## Paramètres Attendus pour le Niveau 7

### 1. Classification de Difficulté
- **ID** : 7
- **Difficulté** : `LevelDifficulty.easy` (car levelId <= 10)
- **Groupe** : Niveaux faciles (1-10)

### 2. Paramètres Calculés
- **Grid Size** : 7x7 (difficulté easy)
- **Max Moves** : 50 + (7 * 2) = 64 mouvements
- **Target Count** : 25 + (7 * 2) = 39 tuiles à collecter
- **Time Left** : 600 secondes (10 minutes)

### 3. Objectifs
- **Nombre d'objectifs** : 1 (difficulté easy)
- **Type** : `LevelObjectiveType.collectTiles`
- **Tuile cible** : Basée sur `TileType.values[(7 + 0) % TileType.values.length]`
- **Cible** : 39 tuiles

## Tests de Debug Ajoutés

### 1. Génération du Niveau
```dart
// Dans _generateLevels()
if (i == 7 && kDebugMode) {
  print('=== DEBUG LEVEL 7 GENERATION ===');
  print('Level 7 - Difficulty: $difficulty');
  print('Level 7 - Target Count: $targetCount');
  print('Level 7 - Max Moves: $maxMoves');
  print('Level 7 - Grid Size: $gridSize');
  print('Level 7 - Objectives: ${objectives.length}');
}
```

### 2. Initialisation du Gameplay
```dart
// Dans GameProvider.startLevel()
if (level.id == 7 && kDebugMode) {
  print('=== DEBUG LEVEL 7 GAMEPLAY ===');
  print('Starting Level 7 with:');
  print('  Grid Size: ${level.gridSize}');
  print('  Max Moves: ${level.maxMoves}');
  print('  Time Left: ${_calculateTimeForLevel(level)}');
  print('  Objectives: ${level.objectives.length}');
}
```

### 3. Génération de la Grille
```dart
// Affichage de la grille générée
if (level.id == 7 && kDebugMode) {
  print('Level 7 Grid Generated:');
  for (int row = 0; row < _grid.length; row++) {
    String rowStr = '';
    for (int col = 0; col < _grid[row].length; col++) {
      if (_grid[row][col] != null) {
        rowStr += '${_grid[row][col]!.type.name[0].toUpperCase()} ';
      } else {
        rowStr += 'X ';
      }
    }
    print('  Row $row: $rowStr');
  }
}
```

## Comment Tester

### 1. Mode Debug
1. Lancez l'application en mode debug
2. Cliquez sur l'icône de bug (🐛) dans l'écran d'accueil
3. Vérifiez les logs dans la console pour le niveau 7

### 2. Test Manuel
1. Débloquez le niveau 7 (bouton debug)
2. Lancez le niveau 7
3. Vérifiez que la grille se génère correctement
4. Vérifiez les objectifs et paramètres

### 3. Vérifications Attendues
- ✅ Grille 7x7 générée
- ✅ 64 mouvements disponibles
- ✅ 1 objectif de collecte
- ✅ 10 minutes de temps
- ✅ Aucun match initial dans la grille

## Fichiers Modifiés
1. `lib/screens/home_screen.dart` - Logs de génération du niveau 7
2. `lib/providers/game_provider.dart` - Logs de gameplay du niveau 7
3. `LEVEL_7_DEBUG.md` - Cette documentation

## Résultats Attendus
Le niveau 7 devrait être généré avec :
- Une grille 7x7 sans matches initiaux
- 64 mouvements maximum
- 1 objectif de collecte de tuiles
- 10 minutes de temps
- Difficulté "easy"

