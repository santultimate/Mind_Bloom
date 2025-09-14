# 🌸 Mind Bloom v1.1.0

Un jeu de puzzle magique avec des mécaniques match-3 avancées, une progression RPG et un système d'étoiles intelligent dans un jardin enchanté.

## 🎮 À propos

Mind Bloom est un jeu de puzzle captivant qui combine les mécaniques classiques du match-3 avec des éléments de progression RPG sophistiqués. Cultivez votre jardin intérieur en résolvant des puzzles colorés, en collectant des plantes magiques et en débloquant de nouveaux défis avec une difficulté progressive intelligente.

## ✨ Fonctionnalités principales

### 🎯 **Gameplay avancé**
- **Mécaniques Match-3** : Échangez des tuiles pour créer des alignements stratégiques
- **Système d'étoiles intelligent** : Évaluation basée sur les objectifs, l'efficacité et le score
- **Difficulté progressive** : 50 niveaux avec 4 niveaux de difficulté (Facile → Expert)
- **Disposition intelligente** : Évitement des patterns complexes et matches directs
- **Grilles adaptatives** : 6x6 → 7x7 → 8x8 selon la difficulté

### 🌟 **Progression et récompenses**
- **Système de vies** : Gestion stratégique avec régénération temporelle
- **Collection de plantes** : Découvrez et collectez différentes espèces magiques
- **Succès et défis** : Débloquez des récompenses et suivez vos progrès
- **Événements saisonniers** : Participez à des événements spéciaux

### 🎬 **Monétisation intelligente**
- **Pubs récompensées** : Regardez des vidéos pour obtenir des vies
- **Pubs interstitielles** : Publicités non-intrusives entre les niveaux
- **Bannières publicitaires** : Intégration harmonieuse dans l'interface

### 🌐 **Expérience utilisateur**
- **Support multilingue complet** : Français et Anglais
- **Thèmes adaptatifs** : Mode clair, sombre et système
- **Interface moderne** : Design épuré avec animations fluides
- **Audio immersif** : Musique de fond et effets sonores

## 🚀 Installation

### Prérequis

- Flutter SDK (version 3.0.0 ou supérieure)
- Dart SDK
- Android Studio / VS Code
- Émulateur ou appareil physique

### Étapes d'installation

1. **Cloner le repository**
   ```bash
   git clone https://github.com/Santultimate/mind_bloom.git
   cd mind_bloom
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Générer les fichiers de localisation**
   ```bash
   flutter gen-l10n
   ```

4. **Lancer l'application**
   ```bash
   flutter run
   ```

## 🎯 Gameplay détaillé

### ⭐ **Système d'étoiles intelligent**
- **3 étoiles** : Performance parfaite (≥90%)
- **2 étoiles** : Très bonne performance (≥70%)
- **1 étoile** : Niveau terminé (≥50%)
- **0 étoile** : À améliorer (<50%)

### 🎮 **Contrôles et stratégie**
- **Tap** : Sélectionner une tuile
- **Swipe** : Échanger des tuiles adjacentes
- **Hint** : Obtenir un indice stratégique
- **Shuffle** : Mélanger la grille (coûte des gemmes)

### 📊 **Progression des niveaux**
- **Niveaux 1-10** : Facile (grille 6x6, 25+ mouvements)
- **Niveaux 11-25** : Moyen (grille 6x6→7x7, 20+ mouvements)
- **Niveaux 26-40** : Difficile (grille 7x7, 18+ mouvements)
- **Niveaux 41-50** : Expert (grille 7x7→8x8, 15+ mouvements)

## 🏗️ Architecture technique

### Structure du projet
```
lib/
├── constants/          # Constantes, couleurs et thèmes
├── models/            # Modèles de données (Level, Tile, etc.)
├── providers/         # Gestion d'état (Provider pattern)
│   ├── game_provider.dart      # Logique de jeu principale
│   ├── user_provider.dart      # Données utilisateur
│   ├── audio_provider.dart     # Gestion audio
│   ├── ad_provider.dart        # Monétisation AdMob
│   ├── collection_provider.dart # Collection de plantes
│   ├── language_provider.dart  # Internationalisation
│   └── theme_provider.dart     # Gestion des thèmes
├── screens/           # Écrans de l'application
├── widgets/           # Widgets réutilisables
├── services/          # Services externes
└── utils/             # Utilitaires et helpers
```

### Technologies utilisées
- **Flutter 3.32.8** : Framework de développement cross-platform
- **Provider** : Gestion d'état réactive
- **SharedPreferences** : Stockage local persistant
- **Audioplayers** : Gestion audio avancée
- **Google Mobile Ads** : Monétisation avec AdMob
- **Flutter Localizations** : Support multilingue
- **Share Plus** : Partage de contenu
- **URL Launcher** : Ouverture de liens externes

## 🎨 Personnalisation et configuration

### 🎨 **Thèmes et couleurs**
- Couleurs définies dans `lib/constants/app_colors.dart`
- Thèmes clair/sombre dans `lib/constants/app_theme.dart`
- Support du thème système automatique

### 🎵 **Audio et effets**
- Fichiers audio dans `assets/audio/`
- Gestion par `AudioProvider` avec contrôles utilisateur
- Musique de fond et effets sonores contextuels

### 🌐 **Internationalisation**
- Fichiers de traduction dans `lib/l10n/`
- Support complet FR/EN
- Génération automatique avec `flutter gen-l10n`

## 📱 Plateformes supportées

- ✅ **Android** (API 21+, testé sur émulateur)
- ✅ **iOS** (iOS 11.0+, prêt pour App Store)
- ✅ **Web** (Chrome, Safari, Firefox)
- ✅ **Desktop** (Windows, macOS, Linux)

## 🚀 Déploiement et publication

### 📱 **Google Play Store**
- Configuration AdMob avec IDs de production
- Signing configuré pour la release
- Métadonnées et screenshots prêts

### 🍎 **Apple App Store**
- Configuration iOS avec AdMob
- Certificats et provisioning profiles
- Guidelines App Store respectées

## 🤝 Contribution

Les contributions sont les bienvenues ! Voici comment contribuer :

1. **Fork** le projet
2. **Créer** une branche pour votre fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. **Commit** vos changements (`git commit -m 'Add some AmazingFeature'`)
4. **Push** vers la branche (`git push origin feature/AmazingFeature`)
5. **Ouvrir** une Pull Request

### 🐛 **Signaler un bug**
Utilisez les [Issues GitHub](https://github.com/Santultimate/mind_bloom/issues) pour signaler des bugs ou proposer des améliorations.

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 📞 Contact et support

**YACOUBA SANTARA**  
📧 **Email** : papysantara@gmail.com  
🌐 **GitHub** : [@Santultimate](https://github.com/Santultimate)  
💼 **Portfolio** : [Votre portfolio](https://votre-portfolio.com)

### 🆘 **Support technique**
- 📧 Email pour support technique
- 🐛 Issues GitHub pour bugs
- 💬 Discussions pour questions générales

## 🙏 Remerciements

- **Flutter team** pour le framework exceptionnel
- **Communauté Flutter** pour les packages et l'aide
- **Google AdMob** pour la monétisation
- **Tous les contributeurs** et testeurs bêta

## 📈 **Roadmap future**

### 🔮 **Version 1.2.0 (prévue)**
- [ ] Niveaux bonus et défis quotidiens
- [ ] Système de guildes et compétitions
- [ ] Nouvelles mécaniques de jeu
- [ ] Plus de langues (Espagnol, Allemand)

### 🌟 **Version 2.0.0 (vision)**
- [ ] Mode multijoueur
- [ ] Éditeur de niveaux
- [ ] Système de saisons
- [ ] Intégration sociale avancée

---

**Développé avec ❤️ en Flutter**  
*Version 1.1.0 - Janvier 2025*

> "Cultivez votre jardin intérieur, un match à la fois" 🌸