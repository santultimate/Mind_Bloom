# 💰 Plan d'Implémentation - Monétisation Mind Bloom

## 🎯 **OBJECTIFS DE MONÉTISATION**

### **Revenus Cibles**
- **ARPU** : 6.57€/mois par joueur
- **Conversion** : 30% de joueurs payants
- **LTV** : 78.84€ sur 12 mois
- **ROI** : 15-40x

---

## 📱 **IMPLÉMENTATION TECHNIQUE**

### 1. **Système de Publicités Vidéo**

#### **Intégration Google AdMob**
```dart
// pubspec.yaml
dependencies:
  google_mobile_ads: ^3.0.0
  in_app_purchase: ^3.1.11

// lib/services/ad_service.dart
class AdService {
  static final _rewardedAd = RewardedAd();
  static final _interstitialAd = InterstitialAd();
  static final _bannerAd = BannerAd();
  
  // Pubs vidéo récompensées
  static Future<void> showRewardedAd({
    required String rewardType,
    required int rewardAmount,
    required VoidCallback onReward,
  }) async {
    if (await _rewardedAd.isLoaded()) {
      _rewardedAd.show(
        onUserEarnedReward: (ad, reward) {
          onReward();
          _giveReward(rewardType, rewardAmount);
        },
      );
    }
  }
  
  // Types de récompenses
  static void _giveReward(String type, int amount) {
    switch (type) {
      case 'life':
        GameProvider.addLife();
        break;
      case 'moves':
        GameProvider.addMoves(amount);
        break;
      case 'coins':
        UserProvider.addCoins(amount);
        break;
      case 'booster':
        UserProvider.addBooster(amount);
        break;
    }
  }
}
```

#### **Emplacements Publicitaires Identifiés**
```dart
// 1. Après chaque niveau (victoire/défaite)
class LevelCompleteScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Contenu du niveau
        _buildLevelContent(),
        
        // Bouton "Vie supplémentaire" (si vies = 0)
        if (gameProvider.lives == 0)
          _buildRewardedAdButton(
            title: "Vie supplémentaire",
            reward: "life",
            amount: 1,
            icon: Icons.favorite,
          ),
        
        // Bouton "Mouvements bonus" (si mouvements = 0)
        if (gameProvider.movesRemaining == 0)
          _buildRewardedAdButton(
            title: "3 mouvements bonus",
            reward: "moves",
            amount: 3,
            icon: Icons.refresh,
          ),
        
        // Bouton "Pièces bonus"
        _buildRewardedAdButton(
          title: "50 pièces gratuites",
          reward: "coins",
          amount: 50,
          icon: Icons.monetization_on,
        ),
      ],
    );
  }
}

// 2. Bouton "Indice gratuit" (après 3 indices payants)
class GameScreen extends StatefulWidget {
  void _showHint() {
    if (hintsUsedToday < 3) {
      // Indice gratuit
      gameProvider.findHint();
    } else {
      // Proposer pub vidéo pour indice gratuit
      _showRewardedAdForHint();
    }
  }
  
  void _showRewardedAdForHint() {
    AdService.showRewardedAd(
      rewardType: 'hint',
      rewardAmount: 1,
      onReward: () {
        gameProvider.findHint();
        hintsUsedToday++;
      },
    );
  }
}

// 3. Récompenses quotidiennes
class DailyRewardsScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDailyReward(),
        
        // Bouton "Double récompense"
        _buildRewardedAdButton(
          title: "Double récompense",
          reward: "double_reward",
          amount: 1,
          icon: Icons.star,
        ),
      ],
    );
  }
}
```

### 2. **Système de Bannières Publicitaires**

#### **Intégration dans les Écrans**
```dart
// lib/widgets/ad_banner_widget.dart
class AdBannerWidget extends StatefulWidget {
  final AdSize adSize;
  final String adUnitId;
  
  const AdBannerWidget({
    Key? key,
    this.adSize = AdSize.banner,
    required this.adUnitId,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: adSize.height.toDouble(),
      child: AdWidget(ad: _bannerAd),
    );
  }
}

// Utilisation dans les écrans
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Contenu principal
          Expanded(child: _buildMainContent()),
          
          // Bannière publicitaire
          AdBannerWidget(
            adUnitId: 'ca-app-pub-xxx/home-banner',
            adSize: AdSize.banner,
          ),
        ],
      ),
    );
  }
}

// Écran de pause
class PauseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Contenu de pause
          _buildPauseContent(),
          
          // Bannière publicitaire
          AdBannerWidget(
            adUnitId: 'ca-app-pub-xxx/pause-banner',
            adSize: AdSize.mediumRectangle,
          ),
        ],
      ),
    );
  }
}
```

### 3. **Système d'Achats In-App**

#### **Configuration des Produits**
```dart
// lib/services/iap_service.dart
class IAPService {
  static const List<String> _productIds = [
    'coins_small',      // 100 pièces - 0.99€
    'coins_medium',     // 500 pièces - 3.99€
    'coins_large',      // 1200 pièces - 7.99€
    'coins_huge',       // 2500 pièces - 14.99€
    'lives_single',     // 1 vie - 0.49€
    'lives_pack',       // 5 vies - 1.99€
    'lives_unlimited',  // 24h - 2.99€
    'boosters_pack',    // 5 boosters - 1.99€
    'boosters_premium', // 10 boosters - 3.99€
    'premium_pass',     // 4.99€/mois
  ];
  
  static Future<void> purchaseProduct(String productId) async {
    final ProductDetails product = await _getProduct(productId);
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
  }
  
  static void _handlePurchase(PurchaseDetails purchase) {
    switch (purchase.productID) {
      case 'coins_small':
        UserProvider.addCoins(100);
        break;
      case 'coins_medium':
        UserProvider.addCoins(500);
        break;
      case 'lives_pack':
        GameProvider.addLives(5);
        break;
      case 'premium_pass':
        UserProvider.setPremium(true);
        break;
    }
  }
}
```

#### **Interface de Boutique**
```dart
// lib/screens/shop_screen.dart
class ShopScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Bannière publicitaire
          AdBannerWidget(
            adUnitId: 'ca-app-pub-xxx/shop-banner',
            adSize: AdSize.largeBanner,
          ),
          
          // Contenu de la boutique
          Expanded(
            child: ListView(
              children: [
                _buildCoinsSection(),
                _buildLivesSection(),
                _buildBoostersSection(),
                _buildPremiumSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCoinsSection() {
    return Column(
      children: [
        _buildShopItem(
          title: "Petit sac",
          description: "100 pièces",
          price: "0.99€",
          onTap: () => IAPService.purchaseProduct('coins_small'),
        ),
        _buildShopItem(
          title: "Sac moyen",
          description: "500 pièces",
          price: "3.99€",
          onTap: () => IAPService.purchaseProduct('coins_medium'),
        ),
        _buildShopItem(
          title: "Gros sac",
          description: "1200 pièces",
          price: "7.99€",
          onTap: () => IAPService.purchaseProduct('coins_large'),
        ),
      ],
    );
  }
}
```

---

## 📊 **SYSTÈME DE MÉTRIQUES**

### **Analytics et Tracking**
```dart
// lib/services/analytics_service.dart
class AnalyticsService {
  // Métriques de rétention
  static void trackSessionStart() {
    FirebaseAnalytics.instance.logEvent(
      name: 'session_start',
      parameters: {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
  
  static void trackLevelComplete(int level, bool won, int score) {
    FirebaseAnalytics.instance.logEvent(
      name: 'level_complete',
      parameters: {
        'level': level,
        'won': won,
        'score': score,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
  
  // Métriques de monétisation
  static void trackAdWatched(String adType, String rewardType) {
    FirebaseAnalytics.instance.logEvent(
      name: 'ad_watched',
      parameters: {
        'ad_type': adType,
        'reward_type': rewardType,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
  
  static void trackPurchase(String productId, double price) {
    FirebaseAnalytics.instance.logEvent(
      name: 'purchase',
      parameters: {
        'product_id': productId,
        'price': price,
        'currency': 'EUR',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}
```

---

## 🎮 **OPTIMISATION DE L'EXPÉRIENCE**

### **Système de Fréquence Publicitaire**
```dart
// lib/services/ad_frequency_manager.dart
class AdFrequencyManager {
  static int _adCount = 0;
  static DateTime _lastAdTime = DateTime.now();
  
  static bool shouldShowAd(String adType) {
    switch (adType) {
      case 'rewarded_video':
        // 1 pub toutes les 2-3 victoires
        return _adCount % 3 == 0;
      
      case 'interstitial':
        // 1 pub toutes les 4 sessions
        return _adCount % 4 == 0;
      
      case 'banner':
        // Toujours (sauf pendant le jeu)
        return true;
    }
  }
  
  static void incrementAdCount() {
    _adCount++;
    _lastAdTime = DateTime.now();
  }
}
```

### **Système de Récompenses**
```dart
// lib/services/reward_service.dart
class RewardService {
  static void giveReward(String type, int amount) {
    switch (type) {
      case 'life':
        GameProvider.addLife();
        _showRewardNotification("Vie supplémentaire obtenue!");
        break;
      
      case 'moves':
        GameProvider.addMoves(amount);
        _showRewardNotification("$amount mouvements bonus!");
        break;
      
      case 'coins':
        UserProvider.addCoins(amount);
        _showRewardNotification("$amount pièces obtenues!");
        break;
      
      case 'booster':
        UserProvider.addBooster(amount);
        _showRewardNotification("$amount boosters obtenus!");
        break;
    }
  }
  
  static void _showRewardNotification(String message) {
    // Afficher une notification de récompense
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
```

---

## 📈 **CALENDRIER D'IMPLÉMENTATION**

### **Phase 1 : Base (Semaine 1-2)**
- ✅ **Intégration AdMob** : Pubs vidéo récompensées
- ✅ **Système de vies** : Régénération + achat
- ✅ **Boutique de base** : Pièces et vies
- ✅ **Analytics** : Tracking des événements

### **Phase 2 : Optimisation (Semaine 3-4)**
- 🔄 **Bannières publicitaires** : Écrans statiques
- 🔄 **Système de boosters** : Achat et utilisation
- 🔄 **Récompenses quotidiennes** : Engagement
- 🔄 **A/B testing** : Optimisation des placements

### **Phase 3 : Avancé (Semaine 5-6)**
- ⏳ **Abonnement premium** : Pas de pubs
- ⏳ **Événements spéciaux** : Monétisation saisonnière
- ⏳ **Personnalisation** : Offres adaptées
- ⏳ **Machine learning** : Prédiction de churn

---

## 💡 **RECOMMANDATIONS STRATÉGIQUES**

### **1. Priorités Immédiates**
1. **Pubs vidéo** après chaque niveau (revenus immédiats)
2. **Système de vies** avec régénération (rétention)
3. **Boutique de base** (conversion)
4. **Analytics** (optimisation)

### **2. Optimisations Moyen Terme**
1. **Bannières** sur écrans statiques (revenus constants)
2. **Boosters** payants (monétisation gameplay)
3. **Récompenses quotidiennes** (engagement)
4. **A/B testing** (optimisation)

### **3. Développements Long Terme**
1. **Abonnement premium** (revenus récurrents)
2. **Événements spéciaux** (monétisation saisonnière)
3. **Personnalisation** (conversion optimisée)
4. **Machine learning** (prédiction et optimisation)

---

## 🏆 **CONCLUSION**

### **Potentiel de Revenus**
- **ARPU** : 6.57€/mois (excellent pour un match-3)
- **Conversion** : 30% (standard de l'industrie)
- **LTV** : 78.84€ (très rentable)
- **ROI** : 15-40x (excellent)

### **Stratégie de Monétisation**
- **Pubs vidéo** : 60% des revenus (revenus constants)
- **Achats In-App** : 35% des revenus (revenus élevés)
- **Abonnements** : 5% des revenus (revenus récurrents)

### **Rentabilité Élevée**
- **Coût d'acquisition** : 2-5€
- **Break-even** : 2-3 mois
- **Profit margin** : 70-80%
- **Scalabilité** : Excellente

**Mind Bloom a un excellent potentiel de rentabilité avec une stratégie de monétisation équilibrée et des opportunités de revenus multiples !** 💰🚀
