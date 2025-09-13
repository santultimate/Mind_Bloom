# 🌸 Mind Bloom

Un jeu de puzzle magique avec des mécaniques de match-3 et une progression RPG dans un jardin enchanté.

## 👨‍💻 Développeur

**YACOUBA SANTARA**

- **Email** : papysantara@gmail.com
- **GitHub** : [@Santultimate](https://github.com/Santultimate)
- **Portfolio** : [Portfolio YACOUBA SANTARA](https://yacouba-santara.dev)

## 🎮 À propos du jeu

Mind Bloom est un jeu de puzzle captivant qui combine les mécaniques classiques du match-3 avec des éléments RPG. Les joueurs cultivent un jardin magique en alignant des tuiles colorées représentant différents éléments naturels.

### ✨ Fonctionnalités principales

- **Match-3 innovant** : Système de correspondance avec 6 types de tuiles différents
- **Progression RPG** : Système de niveaux, expérience et récompenses
- **Boutique intégrée** : Achat de vies, boosters et cosmétiques
- **Système de vies** : Rechargement automatique et gestion des tentatives
- **Audio immersif** : Effets sonores et musique de fond
- **Interface moderne** : Design Material Design 3 avec animations fluides

## 🛠️ Technologies utilisées

- **Framework** : Flutter 3.x
- **Langage** : Dart
- **Gestion d'état** : Provider
- **Audio** : audioplayers
- **Stockage** : SharedPreferences
- **Animations** : flutter_animate

## 📱 Plateformes supportées

- ✅ iOS (iPhone/iPad)
- ✅ Android
- ✅ Web (en développement)
- ✅ macOS (en développement)
- ✅ Windows (en développement)

## 🚀 Installation

### Prérequis

- Flutter SDK 3.0.0 ou supérieur
- Dart SDK 3.0.0 ou supérieur
- Android Studio / Xcode (pour le développement mobile)

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

3. **Lancer l'application**
   ```bash
   flutter run
   ```

## 🎯 Comment jouer

1. **Objectif** : Aligner 3 tuiles ou plus de la même couleur
2. **Contrôles** : Tap sur une tuile pour la sélectionner, puis tap sur une tuile adjacente pour échanger
3. **Objectifs** : Compléter les objectifs spécifiés pour chaque niveau
4. **Progression** : Gagner des étoiles et débloquer de nouveaux niveaux

## 📁 Structure du projet

```
mind_bloom/
├── lib/
│   ├── constants/          # Constantes de l'application
│   ├── models/            # Modèles de données
│   ├── providers/         # Gestionnaires d'état
│   ├── screens/           # Écrans de l'application
│   ├── widgets/           # Widgets réutilisables
│   └── main.dart          # Point d'entrée
├── assets/
│   ├── audio/             # Fichiers audio
│   ├── images/            # Images et icônes
│   └── data/              # Données de configuration
└── pubspec.yaml           # Configuration du projet
```

## 🎨 Assets

Le projet inclut une documentation complète des assets requis dans `ASSETS_REQUIREMENTS.md` :

- **Audio** : 7 SFX + 3 musiques de fond
- **Images** : 6 tuiles + 2 monnaies + 2 récompenses + 3 UI
- **Données** : Configuration des niveaux en JSON

## 🔧 Configuration

### Icône de l'application

L'icône est configurée via `flutter_launcher_icons` dans `pubspec.yaml` :

```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/images/icone_zoomed.png"
```

### Génération de l'icône

```bash
flutter pub run flutter_launcher_icons:main
```

## 📊 Métriques du projet

- **Lignes de code** : ~3000+
- **Fichiers Dart** : 25+
- **Widgets** : 15+
- **Écrans** : 8+
- **Assets** : 20+

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. Fork le projet
2. Créer une branche pour votre fonctionnalité
3. Commiter vos changements
4. Pousser vers la branche
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 🙏 Remerciements

- **Flutter Team** pour le framework exceptionnel
- **Provider** pour la gestion d'état
- **audioplayers** pour l'audio
- **flutter_animate** pour les animations

## 📞 Contact

Pour toute question ou suggestion concernant Mind Bloom :

- **Développeur** : YACOUBA SANTARA
- **Email** : papysantara@gmail.com
- **GitHub** : [@Santultimate](https://github.com/Santultimate)

---

**Développé avec ❤️ par YACOUBA SANTARA**

*"Cultivez votre jardin intérieur, un match à la fois"*
