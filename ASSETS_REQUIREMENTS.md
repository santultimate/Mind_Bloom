# 📁 Assets Requirements - Mind Bloom

## 🎵 Audio Assets

### 🎶 Musique de fond
**Format : MP3, 44.1kHz, 128-192kbps**

| Fichier | Description | Durée | Usage |
|---------|-------------|-------|-------|
| `assets/audio/music/main_menu.mp3` | Musique du menu principal | 2-3 min (loop) | Menu principal, écrans de navigation |
| `assets/audio/music/gameplay.mp3` | Musique de gameplay | 3-4 min (loop) | Pendant les parties |
| `assets/audio/music/victory.mp3` | Musique de victoire | 30-60 sec | Niveau terminé avec succès |

### 🔊 Effets sonores (SFX)
**Format : WAV, 44.1kHz, 16-bit**

| Fichier | Description | Durée | Fréquence | Usage |
|---------|-------------|-------|-----------|-------|
| `assets/audio/sfx/tile_swap.wav` | Son d'échange de tuiles | 0.1-0.2s | 800-1200Hz | Échange de tuiles |
| `assets/audio/sfx/tile_match.wav` | Son de correspondance | 0.2-0.3s | 1000-1500Hz | 3+ tuiles alignées |
| `assets/audio/sfx/special_match.wav` | Son de match spécial | 0.3-0.5s | 1200-1800Hz | Combos spéciaux |
| `assets/audio/sfx/level_complete.wav` | Son de niveau terminé | 0.5-1s | 600-800Hz | Objectif atteint |
| `assets/audio/sfx/level_fail.wav` | Son d'échec | 0.3-0.5s | 200-400Hz | Plus de coups |
| `assets/audio/sfx/button_click.wav` | Son de clic | 0.05-0.1s | 1000Hz | Boutons UI |
| `assets/audio/sfx/coin_collect.wav` | Son de collecte | 0.1-0.2s | 1500-2000Hz | Récompenses |

## 🖼️ Images

### 🎨 Icônes et UI
**Format : PNG, 32x32 à 512x512px**

| Fichier | Taille | Description | Usage |
|---------|--------|-------------|-------|
| `assets/images/app_icon.png` | 1024x1024 | Icône principale | Toutes les plateformes |
| `assets/images/icone_zoomed.png` | 1024x1024 | Icône zoomée | Icône d'application |
| `assets/images/ui/button_bg.png` | 200x80 | Fond de bouton | Interface utilisateur |
| `assets/images/ui/card_bg.png` | 300x200 | Fond de carte | Cartes de jeu |
| `assets/images/ui/panel_bg.png` | 400x300 | Fond de panneau | Panneaux d'interface |

### 🎮 Éléments de jeu
**Format : PNG, 64x64 à 256x256px**

| Fichier | Taille | Description | Usage |
|---------|--------|-------------|-------|
| `assets/images/tiles/flower_tile.png` | 64x64 | Tuile fleur | Type de tuile |
| `assets/images/tiles/leaf_tile.png` | 64x64 | Tuile feuille | Type de tuile |
| `assets/images/tiles/seed_tile.png` | 64x64 | Tuile graine | Type de tuile |
| `assets/images/tiles/water_tile.png` | 64x64 | Tuile eau | Type de tuile |
| `assets/images/tiles/sun_tile.png` | 64x64 | Tuile soleil | Type de tuile |
| `assets/images/tiles/special_tile.png` | 64x64 | Tuile spéciale | Bonus |

### 🏆 Récompenses et monnaie
**Format : PNG, 32x32 à 128x128px**

| Fichier | Taille | Description | Usage |
|---------|--------|-------------|-------|
| `assets/images/currency/coin.png` | 32x32 | Pièce | Monnaie du jeu |
| `assets/images/currency/gem.png` | 32x32 | Gemme | Monnaie premium |
| `assets/images/rewards/star.png` | 64x64 | Étoile | Récompense |
| `assets/images/rewards/trophy.png` | 64x64 | Trophée | Récompense spéciale |

## 🎬 Animations

### ✨ Effets visuels
**Format : Lottie JSON ou GIF**

| Fichier | Description | Durée | Usage |
|---------|-------------|-------|-------|
| `assets/animations/tile_match.json` | Animation de match | 0.5s | Correspondance de tuiles |
| `assets/animations/level_complete.json` | Animation de victoire | 2s | Niveau terminé |
| `assets/animations/particle_effect.json` | Effet de particules | 1s | Effets spéciaux |
| `assets/animations/loading.json` | Animation de chargement | Loop | Écrans de chargement |

## 📊 Données

### 🎯 Niveaux et progression
**Format : JSON**

| Fichier | Description | Contenu |
|---------|-------------|---------|
| `assets/data/levels.json` | Configuration des niveaux | Objectifs, grilles, récompenses |
| `assets/data/shop_items.json` | Articles de la boutique | Prix, effets, descriptions |
| `assets/data/achievements.json` | Défis et succès | Conditions, récompenses |

## 📱 Icônes d'application

### 🎨 Icônes multi-plateforme
**Formats requis pour chaque plateforme**

#### Android
- `android/app/src/main/res/mipmap-mdpi/launcher_icon.png` (48x48)
- `android/app/src/main/res/mipmap-hdpi/launcher_icon.png` (72x72)
- `android/app/src/main/res/mipmap-xhdpi/launcher_icon.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/launcher_icon.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/launcher_icon.png` (192x192)

#### iOS
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png` (20x20)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png` (40x40)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png` (60x60)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png` (29x29)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png` (58x58)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png` (87x87)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png` (40x40)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png` (80x80)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png` (120x120)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png` (120x120)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png` (180x180)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png` (76x76)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png` (152x152)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png` (167x167)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png` (1024x1024)

## 🎨 Spécifications techniques

### 🎵 Audio
- **Musique** : MP3, 44.1kHz, 128-192kbps, stéréo
- **SFX** : WAV, 44.1kHz, 16-bit, mono
- **Durée totale** : ~15-20 MB

### 🖼️ Images
- **Format** : PNG avec transparence
- **Compression** : Optimisée pour mobile
- **Taille totale** : ~5-10 MB

### 📱 Performance
- **Taille totale des assets** : < 50 MB
- **Temps de chargement** : < 3 secondes
- **Compatibilité** : iOS 12+, Android API 21+

## 🔧 Outils recommandés

### 🎵 Audio
- **DAW** : Audacity, GarageBand, FL Studio
- **Formatage** : FFmpeg pour conversion
- **Optimisation** : MP3Gain pour normalisation

### 🖼️ Images
- **Éditeur** : Photoshop, GIMP, Figma
- **Optimisation** : TinyPNG, ImageOptim
- **Icônes** : Flutter Launcher Icons

### 🎬 Animations
- **Création** : Adobe After Effects, LottieFiles
- **Export** : Bodymovin plugin
- **Intégration** : flutter_lottie package

