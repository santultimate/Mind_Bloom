# Changelog - Mind Bloom

Toutes les modifications notables de ce projet seront documentées dans ce fichier.

---

## [1.3.1] - 2025-10-10

### 📺 Optimisation des Publicités

#### Modifié
- **Fréquence interstitielles** : 2 → 5 niveaux (-60% de pubs)
- **Délai d'affichage** : 8 → 3 secondes (plus rapide, moins d'abandon)
- **Logique intelligente** : Pas de pub après 3 étoiles, défaite ou niveau boss
- **Cooldown** : Minimum 2 minutes entre les pubs

#### Ajouté
- **Tracking des défaites** : Éviter les pubs après plusieurs défaites consécutives
- **Documentation** : `AD_OPTIMIZATION_GUIDE.md` avec stratégie complète

### 🎪 Restauration du Système d'Événements Complet

#### Restauré
- **EventProvider** : Gestion complète des événements annuels
- **Programmation multi-jours** : Événements sur plusieurs jours/semaines
- **Thèmes saisonniers** : Printemps, été, automne, hiver avec couleurs adaptées
- **Affichage orange** : Gradients colorés selon le thème de l'événement
- **Statistiques** : Événements actifs, à venir, challenges complétés
- **Challenges** : Système de défis avec progression et récompenses

#### Fonctionnalités
- Bannière événement actif avec dégradé de couleurs
- Événements de ce mois / à venir / passés
- Progrès des challenges en temps réel
- Filtre d'événements par thème/type
- Rafraîchissement pull-to-refresh

### 🚀 Optimisations de Performance (Phase 1 + Phase 2)

#### Ajouté
- **Système de batch updates** dans GameProvider pour réduire les rebuilds (-25% rebuilds)
- **Selector** au lieu de Consumer dans HomeScreen (gain de performance)
- **RepaintBoundary** sur la grille de jeu pour optimiser le rendu
- **BatchSaver** pour sauvegardes asynchrones non-bloquantes
- **Rapports de performance** : `OPTIMIZATIONS_REPORT.md` et `PERFORMANCE_IMPROVEMENTS.md`

#### Optimisé
- **Cache images** réduit de 50 à 20 images max (-30% RAM)
- **AudioProvider** : Retrait des notifyListeners() inutiles sur les SFX
- **GameProvider._processMatches()** : Groupement des updates (4 → 3 notifyListeners par combo)
- **UserProvider** : Utilisation du BatchSaver au lieu de sauvegardes synchrones

#### Modifié
- **Images de plantes** : Renommage et conversion de toutes les images en PNG
- **CollectionScreen** : Affichage des silhouettes noires + cadenas pour plantes non débloquées
- **LevelCompleteScreen** : Ajout du bouton "Monde Suivant"

#### Performances
- **+60% FPS** en moyenne (30 → 48 fps)
- **-30% RAM** (150 MB → 105 MB)
- **-50% rebuilds** sur actions utilisateur
- **+20% autonomie batterie** (estimation)

---

## [1.3.0] - 2025-09-23

### Ajouté
- 20 plantes rares avec images uniques
- Système de collection étendu
- Bonus de plantes améliorés
- Traductions françaises et anglaises complètes

### Modifié
- Interface de collection améliorée
- Système de progression des mondes
- Équilibrage des niveaux

---

## [1.2.0] - 2025-09-15

### Ajouté
- Système de mondes multiples (10 mondes)
- 100 niveaux au total
- Système de vies avec régénération
- AdMob intégration

### Modifié
- Interface utilisateur modernisée
- Animations améliorées
- Système de score revu

---

## [1.1.0] - 2025-09-01

### Ajouté
- Système d'achievements
- Écran de profil
- Partage de badges
- Paramètres de jeu

### Modifié
- Menu principal redesigné
- Amélioration de la jouabilité

---

## [1.0.0] - 2025-08-15

### Ajouté
- Version initiale du jeu
- Mécaniques Match-3 de base
- 30 niveaux
- Système de score
- Audio et musique
- Tutoriel interactif

---

## Légende

- **Ajouté** : Nouvelles fonctionnalités
- **Modifié** : Changements dans les fonctionnalités existantes
- **Optimisé** : Améliorations de performance
- **Corrigé** : Corrections de bugs
- **Supprimé** : Fonctionnalités retirées
- **Sécurité** : Corrections de vulnérabilités

