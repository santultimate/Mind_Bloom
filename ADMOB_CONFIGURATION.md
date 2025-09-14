# Configuration AdMob - Mind Bloom

## 📱 IDs AdMob Configurés

### ✅ Configuration Actuelle (Production Mode)

L'application utilise maintenant les **IDs de production** pour Android et génère des revenus réels.

#### **Android (Production) :**
- **App ID :** `ca-app-pub-7487587531173203~3347511713`
- **Banner :** `ca-app-pub-7487587531173203/2035914351`
- **Interstitielle :** `ca-app-pub-7487587531173203/3213210752`
- **Récompensée :** `ca-app-pub-7487587531173203/9587047415`

#### **iOS :**
- **App ID :** `ca-app-pub-3940256099942544~1458002511`
- **Banner :** `ca-app-pub-3940256099942544/2934735716`
- **Interstitielle :** `ca-app-pub-3940256099942544/4411468910`
- **Récompensée :** `ca-app-pub-3940256099942544/1712485313`

## 🔧 Fichiers de Configuration

### 1. **lib/constants/admob_config.dart**
Configuration centralisée de tous les IDs AdMob et paramètres.

### 2. **android/app/src/main/AndroidManifest.xml**
```xml
<!-- AdMob App ID (Test ID for Android) -->
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-3940256099942544~3347511713"/>
```

### 3. **ios/Runner/Info.plist**
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string>
```

## 🚀 Passage en Production

### ⚠️ IMPORTANT : Avant la publication

1. **Créer un compte AdMob** sur [admob.google.com](https://admob.google.com)

2. **Créer une application** dans AdMob Console

3. **Récupérer vos vrais IDs** :
   - App ID
   - Banner Ad Unit ID
   - Interstitial Ad Unit ID
   - Rewarded Ad Unit ID

4. **Remplacer les IDs de test** dans `lib/constants/admob_config.dart` :
   ```dart
   // Remplacer par vos vrais IDs
   static String get appId => Platform.isAndroid
       ? 'ca-app-pub-VOTRE-ID-ANDROID~XXXXXXXXXX'
       : 'ca-app-pub-VOTRE-ID-IOS~XXXXXXXXXX';
   ```

5. **Mettre à jour les fichiers de configuration** :
   - `android/app/src/main/AndroidManifest.xml`
   - `ios/Runner/Info.plist`

6. **Changer le mode test** :
   ```dart
   static const bool isTestMode = false; // Passer à false
   ```

## 📊 Configuration des Publicités

### **Fréquence des Publicités Interstitielles**
```dart
static const int interstitialFrequency = 2; // Tous les 2 niveaux
```

### **Délai d'Affichage**
```dart
static const int interstitialDelay = 3; // 3 secondes après fin de niveau
```

### **Types de Publicités Activées**
```dart
static const bool showBanners = true;        // Bannières
static const bool showInterstitials = true;  // Interstitielles
static const bool showRewardedAds = true;    // Récompensées
```

## 🎯 Stratégie de Monétisation

### **Publicités Bannières**
- **Écran d'accueil** : Bannière en bas
- **Écrans de jeu** : Bannières contextuelles
- **Revenus** : Faibles mais constants

### **Publicités Interstitielles**
- **Fin de niveau** : Après chaque niveau gagné
- **Navigation** : Lors du passage au niveau suivant
- **Revenus** : Élevés, timing optimal

### **Publicités Récompensées**
- **Vies gratuites** : Regarder une pub pour une vie
- **Boosters** : Récompenses pour engagement
- **Revenus** : Très élevés, engagement utilisateur

## 🔍 Test et Débogage

### **Vérification des Publicités de Test**
1. Les publicités de test affichent "Test Ad" en haut
2. Pas de revenus réels générés
3. Comportement identique aux vraies publicités

### **Logs de Débogage**
```dart
if (kDebugMode) {
  print('AdProvider initialized successfully (ads enabled)');
  print('Banner ad loaded');
  print('Interstitial ad shown');
}
```

## 📈 Optimisation des Revenus

### **Meilleures Pratiques**
1. **Timing optimal** : Publicités après les moments de satisfaction
2. **Fréquence équilibrée** : Assez pour générer des revenus, pas trop pour frustrer
3. **Publicités récompensées** : Encourage l'engagement
4. **A/B Testing** : Tester différentes fréquences

### **Métriques à Surveiller**
- **eCPM** (Effective Cost Per Mille)
- **Fill Rate** (Taux de remplissage)
- **Click-Through Rate** (CTR)
- **User Retention** (Rétention utilisateur)

## 🛡️ Conformité et Légalité

### **RGPD/CCPA**
- Consentement utilisateur requis
- Option de désactivation des publicités
- Politique de confidentialité mise à jour

### **Politiques des Stores**
- Respect des guidelines Apple/Google
- Publicités appropriées pour tous âges
- Pas de publicités trompeuses

## 📞 Support

Pour toute question sur la configuration AdMob :
- [Documentation AdMob](https://developers.google.com/admob)
- [Support AdMob](https://support.google.com/admob)
- [Flutter AdMob Plugin](https://pub.dev/packages/google_mobile_ads)
