import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/admob_config.dart';

class AdProvider extends ChangeNotifier {
  // IDs des publicités (utilise la configuration centralisée)
  static String get _bannerAdUnitId => AdMobConfig.bannerAdUnitId;
  static String get _interstitialAdUnitId => AdMobConfig.interstitialAdUnitId;
  static String get _rewardedAdUnitId => AdMobConfig.rewardedAdUnitId;

  // Variables d'état
  bool _isInitialized = false;
  bool _adsEnabled = true;
  int _adFreePurchased = 0; // 0 = pas acheté, 1 = acheté
  int _interstitialCounter = 0;
  int _lastAdShownLevel = 0;
  int _rewardedAdsWatched = 0;
  int _totalAdsWatched = 0;
  int _consecutiveRewardedAds = 0;
  DateTime? _lastRewardedAdTime;

  // Constructeur avec initialisation automatique
  AdProvider() {
    initialize();
  }

  // Getters
  bool get isInitialized => _isInitialized;
  bool get adsEnabled => _adsEnabled; // ✅ Réactiver les publicités
  int get interstitialCounter => _interstitialCounter;
  int get lastAdShownLevel => _lastAdShownLevel;
  int get rewardedAdsWatched => _rewardedAdsWatched;
  int get totalAdsWatched => _totalAdsWatched;
  int get consecutiveRewardedAds => _consecutiveRewardedAds;

  // Initialisation
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // ✅ Désactiver AdMob sur le web pour éviter les erreurs Platform
      if (kIsWeb) {
        _adsEnabled = false;
        _isInitialized = true;
        if (kDebugMode) {
          // debugPrint('🚀 AdProvider initialized successfully (ads disabled on web)');
        }
        return;
      }

      // ✅ Réactiver AdMob avec la configuration correcte pour mobile
      _adsEnabled = true;
      await _loadUserPreferences();
      _isInitialized = true;

      if (kDebugMode) {
        // debugPrint('🚀 AdProvider initialized successfully (ads enabled)');
        // debugPrint('📱 Platform: ${Platform.isAndroid ? 'Android' : 'iOS'}');
        // debugPrint('🎯 Banner Ad Unit ID: $_bannerAdUnitId');
        // debugPrint('🎯 Interstitial Ad Unit ID: $_interstitialAdUnitId');
        // debugPrint('🎯 Rewarded Ad Unit ID: $_rewardedAdUnitId');
      }
    } catch (e) {
      if (kDebugMode) {
        // debugPrint('Error initializing AdProvider: $e');
      }
    }
  }

  // Charger les préférences utilisateur
  Future<void> _loadUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _adsEnabled = prefs.getBool('ads_enabled') ?? true;
    _adFreePurchased = prefs.getInt('ad_free_purchased') ?? 0;
    _interstitialCounter = prefs.getInt('interstitial_counter') ?? 0;
    _lastAdShownLevel = prefs.getInt('last_ad_shown_level') ?? 0;
    _rewardedAdsWatched = prefs.getInt('rewarded_ads_watched') ?? 0;
    _totalAdsWatched = prefs.getInt('total_ads_watched') ?? 0;
    _consecutiveRewardedAds = prefs.getInt('consecutive_rewarded_ads') ?? 0;

    final lastRewardedAdTimeString = prefs.getString('last_rewarded_ad_time');
    if (lastRewardedAdTimeString != null) {
      _lastRewardedAdTime = DateTime.parse(lastRewardedAdTimeString);
    }
  }

  // Sauvegarder les préférences utilisateur
  Future<void> _saveUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ads_enabled', _adsEnabled);
    await prefs.setInt('ad_free_purchased', _adFreePurchased);
    await prefs.setInt('interstitial_counter', _interstitialCounter);
    await prefs.setInt('last_ad_shown_level', _lastAdShownLevel);
    await prefs.setInt('rewarded_ads_watched', _rewardedAdsWatched);
    await prefs.setInt('total_ads_watched', _totalAdsWatched);
    await prefs.setInt('consecutive_rewarded_ads', _consecutiveRewardedAds);

    if (_lastRewardedAdTime != null) {
      await prefs.setString(
          'last_rewarded_ad_time', _lastRewardedAdTime!.toIso8601String());
    }
  }

  // Créer une bannière publicitaire
  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (kDebugMode) {
            debugPrint(
                '✅ Banner ad loaded successfully - Unit ID: $_bannerAdUnitId');
          }
        },
        onAdFailedToLoad: (ad, error) {
          if (kDebugMode) {
            // debugPrint('❌ Banner ad failed to load - Unit ID: $_bannerAdUnitId');
            // debugPrint('   Error code: ${error.code}');
            // debugPrint('   Error message: ${error.message}');
            // debugPrint('   Error domain: ${error.domain}');
          }
          ad.dispose();
        },
        onAdOpened: (ad) {
          if (kDebugMode) {
            // debugPrint('Banner ad opened');
          }
        },
        onAdClosed: (ad) {
          if (kDebugMode) {
            // debugPrint('Banner ad closed');
          }
        },
      ),
    );
  }

  // Charger une publicité interstitielle
  Future<InterstitialAd?> loadInterstitialAd() async {
    if (!adsEnabled) return null;

    try {
      InterstitialAd? interstitialAd;
      await InterstitialAd.load(
        adUnitId: _interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAd = ad;
            if (kDebugMode) {
              debugPrint(
                  '✅ Interstitial ad loaded successfully - Unit ID: $_interstitialAdUnitId');
            }
          },
          onAdFailedToLoad: (error) {
            if (kDebugMode) {
              debugPrint(
                  '❌ Interstitial ad failed to load - Unit ID: $_interstitialAdUnitId');
              // debugPrint('   Error code: ${error.code}');
              // debugPrint('   Error message: ${error.message}');
              // debugPrint('   Error domain: ${error.domain}');
            }
          },
        ),
      );
      return interstitialAd;
    } catch (e) {
      if (kDebugMode) {
        // debugPrint('Error loading interstitial ad: $e');
      }
      return null;
    }
  }

  // Afficher une publicité interstitielle
  Future<bool> showInterstitialAd() async {
    if (!adsEnabled) return false;

    // Vérifier si on doit afficher une pub (tous les 3 niveaux)
    if (_interstitialCounter < 3) {
      _interstitialCounter++;
      await _saveUserPreferences();
      return false;
    }

    final ad = await loadInterstitialAd();
    if (ad == null) return false;

    bool adShown = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        adShown = true;
        if (kDebugMode) {
          // debugPrint('Interstitial ad showed full screen content');
        }
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialCounter = 0;
        _saveUserPreferences();
        if (kDebugMode) {
          // debugPrint('Interstitial ad dismissed');
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        if (kDebugMode) {
          // debugPrint('Interstitial ad failed to show: $error');
        }
      },
    );

    await ad.show();
    return adShown;
  }

  // Charger une publicité récompensée
  Future<RewardedAd?> loadRewardedAd() async {
    if (!adsEnabled) return null;

    try {
      RewardedAd? rewardedAd;
      await RewardedAd.load(
        adUnitId: _rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            rewardedAd = ad;
            if (kDebugMode) {
              debugPrint(
                  '✅ Rewarded ad loaded successfully - Unit ID: $_rewardedAdUnitId');
            }
          },
          onAdFailedToLoad: (error) {
            if (kDebugMode) {
              debugPrint(
                  '❌ Rewarded ad failed to load - Unit ID: $_rewardedAdUnitId');
              // debugPrint('   Error code: ${error.code}');
              // debugPrint('   Error message: ${error.message}');
              // debugPrint('   Error domain: ${error.domain}');
            }
          },
        ),
      );
      return rewardedAd;
    } catch (e) {
      if (kDebugMode) {
        // debugPrint('Error loading rewarded ad: $e');
      }
      return null;
    }
  }

  // Afficher une publicité récompensée
  Future<bool> showRewardedAd({
    required Function() onReward,
    required String rewardType,
  }) async {
    if (!adsEnabled) return false;

    final ad = await loadRewardedAd();
    if (ad == null) return false;

    bool rewardEarned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        if (kDebugMode) {
          // debugPrint('Rewarded ad showed full screen content');
        }
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (kDebugMode) {
          // debugPrint('Rewarded ad dismissed');
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        if (kDebugMode) {
          // debugPrint('Rewarded ad failed to show: $error');
        }
      },
    );

    await ad.show(
      onUserEarnedReward: (ad, reward) {
        rewardEarned = true;
        onReward();
        if (kDebugMode) {
          // debugPrint('User earned reward: ${reward.amount} ${reward.type}');
        }
      },
    );

    return rewardEarned;
  }

  // Vérifier si on doit afficher une pub interstitielle
  bool shouldShowInterstitialAd(int currentLevel) {
    if (!adsEnabled) return false;

    // Afficher une pub selon la fréquence configurée
    if (currentLevel >
        _lastAdShownLevel + (AdMobConfig.interstitialFrequency - 1)) {
      _lastAdShownLevel = currentLevel;
      _saveUserPreferences();
      return true;
    }

    return false;
  }

  // Nouvelle méthode pour forcer l'affichage d'une pub interstitielle (pour les fins de niveau)
  bool shouldShowInterstitialAdOnLevelComplete(int currentLevel) {
    if (!adsEnabled) return false;

    // Afficher une pub tous les 2 niveaux pour éviter les interruptions trop fréquentes
    // Éviter aussi les pubs lors des dialogues de completion de monde
    if (currentLevel % 2 == 0 && currentLevel > _lastAdShownLevel) {
      // Éviter les pubs lors des fins de monde (niveaux 10, 20, 30, etc.)
      if (currentLevel % 10 != 0) {
        return true;
      }
    }

    return false;
  }

  // Activer/désactiver les publicités
  Future<void> setAdsEnabled(bool enabled) async {
    _adsEnabled = enabled;
    await _saveUserPreferences();
    notifyListeners();
  }

  // Marquer l'achat "Sans publicité"
  Future<void> purchaseAdFree() async {
    _adFreePurchased = 1;
    await _saveUserPreferences();
    notifyListeners();
  }

  // Réinitialiser le compteur de pubs interstitielles
  Future<void> resetInterstitialCounter() async {
    _interstitialCounter = 0;
    await _saveUserPreferences();
  }

  // Obtenir les statistiques des publicités
  Map<String, dynamic> getAdStats() {
    return {
      'adsEnabled': adsEnabled,
      'adFreePurchased': _adFreePurchased == 1,
      'interstitialCounter': _interstitialCounter,
      'lastAdShownLevel': _lastAdShownLevel,
      'rewardedAdsWatched': _rewardedAdsWatched,
      'totalAdsWatched': _totalAdsWatched,
      'consecutiveRewardedAds': _consecutiveRewardedAds,
    };
  }

  // Système de récompenses progressives pour les publicités
  Map<String, dynamic> getRewardedAdBonus() {
    // Bonus basé sur le nombre de publicités regardées consécutivement
    int bonusMultiplier = 1;
    String bonusType = 'standard';

    if (_consecutiveRewardedAds >= 10) {
      bonusMultiplier = 5;
      bonusType = 'legendary';
    } else if (_consecutiveRewardedAds >= 5) {
      bonusMultiplier = 3;
      bonusType = 'epic';
    } else if (_consecutiveRewardedAds >= 3) {
      bonusMultiplier = 2;
      bonusType = 'rare';
    }

    return {
      'multiplier': bonusMultiplier,
      'type': bonusType,
      'consecutiveCount': _consecutiveRewardedAds,
    };
  }

  // Marquer qu'une publicité récompensée a été regardée
  Future<void> markRewardedAdWatched() async {
    _rewardedAdsWatched++;
    _totalAdsWatched++;
    _consecutiveRewardedAds++;
    _lastRewardedAdTime = DateTime.now();

    await _saveUserPreferences();
    notifyListeners();
  }

  // Réinitialiser la série de publicités récompensées (si le joueur n'en regarde pas pendant 24h)
  void checkRewardedAdStreak() {
    if (_lastRewardedAdTime != null) {
      final timeSinceLastAd = DateTime.now().difference(_lastRewardedAdTime!);
      if (timeSinceLastAd.inHours >= 24) {
        _consecutiveRewardedAds = 0;
        _saveUserPreferences();
      }
    }
  }

  // Vérifier si le joueur mérite une récompense bonus
  bool shouldOfferBonusReward() {
    // Offrir des récompenses bonus après certains milestones
    return _rewardedAdsWatched > 0 && _rewardedAdsWatched % 5 == 0;
  }

  // Calculer la récompense optimale pour encourager l'engagement
  Map<String, int> calculateOptimalReward(String rewardType) {
    final bonus = getRewardedAdBonus();
    final multiplier = bonus['multiplier'] as int;

    switch (rewardType) {
      case 'life':
        return {
          'lives': 1 * multiplier,
          'bonus_coins': multiplier > 1 ? 20 * (multiplier - 1) : 0,
        };
      case 'coins':
        return {
          'coins': 50 * multiplier,
          'bonus_gems': multiplier >= 3 ? 1 : 0,
        };
      case 'gems':
        return {
          'gems': 2 * multiplier,
          'bonus_coins': 25 * multiplier,
        };
      default:
        return {'coins': 25};
    }
  }
}
