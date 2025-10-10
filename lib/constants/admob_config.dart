import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

/// Configuration centralisée des IDs AdMob
///
/// ⚠️ IMPORTANT : Ces sont des IDs de TEST fournis par Google
/// Pour la production, remplacez par vos vrais IDs AdMob
class AdMobConfig {
  // IDs d'application AdMob (Production IDs)
  static String get appId {
    if (kIsWeb) return 'ca-app-pub-3940256099942544~1458002511'; // Web test ID
    return Platform.isAndroid
        ? 'ca-app-pub-7487587531173203~3347511713' // Production ID Android
        : 'ca-app-pub-3940256099942544~1458002511'; // Test ID iOS (à remplacer)
  }

  // IDs des bannières publicitaires (Production IDs)
  static String get bannerAdUnitId {
    if (kIsWeb) return 'ca-app-pub-3940256099942544/2934735716'; // Web test ID
    return Platform.isAndroid
        ? 'ca-app-pub-7487587531173203/2035914351' // Production ID Android
        : 'ca-app-pub-3940256099942544/2934735716'; // Test ID iOS (à remplacer)
  }

  // IDs des publicités interstitielles (Production IDs)
  static String get interstitialAdUnitId {
    if (kIsWeb) return 'ca-app-pub-3940256099942544/4411468910'; // Web test ID
    return Platform.isAndroid
        ? 'ca-app-pub-7487587531173203/3213210752' // Production ID Android
        : 'ca-app-pub-3940256099942544/4411468910'; // Test ID iOS (à remplacer)
  }

  // IDs des publicités récompensées (Production IDs)
  static String get rewardedAdUnitId {
    if (kIsWeb) return 'ca-app-pub-3940256099942544/1712485313'; // Web test ID
    return Platform.isAndroid
        ? 'ca-app-pub-7487587531173203/9587047415' // Production ID Android
        : 'ca-app-pub-3940256099942544/1712485313'; // Test ID iOS (à remplacer)
  }

  // Configuration des publicités
  static const bool isTestMode = false; // Production mode activé

  // 🔧 OPTIMISÉ: Fréquence réduite pour moins d'intrusion
  static const int interstitialFrequency =
      5; // TOUS LES 5 NIVEAUX pour une meilleure expérience utilisateur

  // 🔧 OPTIMISÉ: Délai augmenté pour laisser le joueur savourer sa victoire
  static const int interstitialDelay =
      3; // 3 secondes - Assez court pour ne pas perdre l'utilisateur

  // Configuration des bannières
  static const bool showBanners = true;
  static const bool showInterstitials = true;
  static const bool showRewardedAds = true;
}

/// IDs de production (à utiliser en production)
///
/// ⚠️ REMPLACEZ CES IDs PAR VOS VRAIS IDs ADMOB EN PRODUCTION
class AdMobProductionConfig {
  // IDs d'application AdMob (Production)
  static String get appId {
    if (kIsWeb) return 'ca-app-pub-XXXXXXXXXXXXXXX~XXXXXXXXXX'; // Web ID
    return Platform.isAndroid
        ? 'ca-app-pub-XXXXXXXXXXXXXXX~XXXXXXXXXX' // Votre ID Android
        : 'ca-app-pub-XXXXXXXXXXXXXXX~XXXXXXXXXX'; // Votre ID iOS
  }

  // IDs des bannières publicitaires (Production)
  static String get bannerAdUnitId {
    if (kIsWeb) return 'ca-app-pub-XXXXXXXXXXXXXXX/XXXXXXXXXX'; // Web ID
    return Platform.isAndroid
        ? 'ca-app-pub-XXXXXXXXXXXXXXX/XXXXXXXXXX' // Votre ID Android
        : 'ca-app-pub-XXXXXXXXXXXXXXX/XXXXXXXXXX'; // Votre ID iOS
  }

  // IDs des publicités interstitielles (Production)
  static String get interstitialAdUnitId {
    if (kIsWeb) return 'ca-app-pub-XXXXXXXXXXXXXXX/XXXXXXXXXX'; // Web ID
    return Platform.isAndroid
        ? 'ca-app-pub-XXXXXXXXXXXXXXX/XXXXXXXXXX' // Votre ID Android
        : 'ca-app-pub-XXXXXXXXXXXXXXX/XXXXXXXXXX'; // Votre ID iOS
  }

  // IDs des publicités récompensées (Production)
  static String get rewardedAdUnitId {
    if (kIsWeb) return 'ca-app-pub-XXXXXXXXXXXXXXX/XXXXXXXXXX'; // Web ID
    return Platform.isAndroid
        ? 'ca-app-pub-XXXXXXXXXXXXXXX/XXXXXXXXXX' // Votre ID Android
        : 'ca-app-pub-XXXXXXXXXXXXXXX/XXXXXXXXXX'; // Votre ID iOS
  }
}
