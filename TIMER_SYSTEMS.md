# Systèmes de Minuteurs dans Mind Bloom

## Problème Identifié
Il y avait une confusion entre deux systèmes de minuteurs différents dans l'application :

## 1. Minuteur de Jeu (GameProvider)
- **Variable** : `_timeLeft` dans `GameProvider`
- **Fichier** : `lib/providers/game_provider.dart`
- **Fonction** : Temps restant pour terminer le niveau actuel
- **Affichage** : Dans `GameHeader` (en-tête du jeu)
- **Icône** : `Icons.timer`
- **Couleur** : Bleu/Accent (rouge si < 60 secondes)
- **Label** : "Temps"

## 2. Minuteur de Régénération des Vies (UserProvider)
- **Variable** : `_timeUntilNextLife` dans `UserProvider`
- **Fichier** : `lib/providers/user_provider.dart`
- **Fonction** : Temps jusqu'à la prochaine régénération de vie
- **Affichage** : Dans `LivesWidget` (widget des vies)
- **Icône** : `Icons.schedule`
- **Couleur** : Orange
- **Label** : "Prochaine vie"

## Solutions Appliquées

### 1. Distinction Visuelle
- **Minuteur de jeu** : Icône `timer` avec label "Temps"
- **Minuteur de régénération** : Icône `schedule` avec label "Prochaine vie"

### 2. Couleurs Différentes
- **Minuteur de jeu** : Bleu/Accent (rouge si critique)
- **Minuteur de régénération** : Orange

### 3. Commentaires dans le Code
Ajout de commentaires explicatifs dans les deux providers pour clarifier le rôle de chaque minuteur.

### 4. Amélioration de l'Interface
- Ajout de labels explicites sous les minuteurs
- Utilisation d'icônes distinctes
- Mise en forme différente pour chaque type de minuteur

## Fichiers Modifiés
1. `lib/widgets/game_header.dart` - Amélioration de l'affichage du minuteur de jeu
2. `lib/widgets/lives_widget.dart` - Amélioration de l'affichage du minuteur de régénération
3. `lib/providers/game_provider.dart` - Ajout de commentaires explicatifs
4. `lib/providers/user_provider.dart` - Ajout de commentaires explicatifs

## Résultat
Les utilisateurs peuvent maintenant facilement distinguer entre :
- Le temps restant pour terminer le niveau (minuteur de jeu)
- Le temps jusqu'à la prochaine régénération de vie (minuteur de régénération)

