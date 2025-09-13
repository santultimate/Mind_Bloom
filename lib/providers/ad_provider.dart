import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdProvider extends ChangeNotifier {
  // IDs des publicités (à remplacer par vos vrais IDs AdMob)
  static String get _bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111' // Test ID Android
      : 'ca-app-pub-3940256099942544/2934735716'; // Test ID iOS

  static String get _interstitialAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712' // Test ID Android
      : 'ca-app-pub-3940256099942544/4411468910'; // Test ID iOS

  static String get _rewardedAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917' // Test ID Android
      : 'ca-app-pub-3940256099942544/1712485313'; // Test ID iOS

  // Variables d'état
  bool _isInitialized = false;
  bool _adsEnabled = true;
  int _adFreePurchased = 0; // 0 = pas acheté, 1 = acheté
  int _interstitialCounter = 0;
  int _lastAdShownLevel = 0;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get adsEnabled => _adsEnabled; // ✅ Réactiver les publicités
  int get interstitialCounter => _interstitialCounter;
  int get lastAdShownLevel => _lastAdShownLevel;

  // Initialisation
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // ✅ Réactiver AdMob avec la configuration correcte
      _adsEnabled = true;
      await _loadUserPreferences();
      _isInitialized = true;

      if (kDebugMode) {
        print('AdProvider initialized successfully (ads enabled)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing AdProvider: $e');
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
  }

  // Sauvegarder les préférences utilisateur
  Future<void> _saveUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ads_enabled', _adsEnabled);
    await prefs.setInt('ad_free_purchased', _adFreePurchased);
    await prefs.setInt('interstitial_counter', _interstitialCounter);
    await prefs.setInt('last_ad_shown_level', _lastAdShownLevel);
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
            print('Banner ad loaded');
          }
        },
        onAdFailedToLoad: (ad, error) {
          if (kDebugMode) {
            print('Banner ad failed to load: $error');
          }
          ad.dispose();
        },
        onAdOpened: (ad) {
          if (kDebugMode) {
            print('Banner ad opened');
          }
        },
        onAdClosed: (ad) {
          if (kDebugMode) {
            print('Banner ad closed');
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
              print('Interstitial ad loaded');
            }
          },
          onAdFailedToLoad: (error) {
            if (kDebugMode) {
              print('Interstitial ad failed to load: $error');
            }
          },
        ),
      );
      return interstitialAd;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading interstitial ad: $e');
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
          print('Interstitial ad showed full screen content');
        }
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialCounter = 0;
        _saveUserPreferences();
        if (kDebugMode) {
          print('Interstitial ad dismissed');
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        if (kDebugMode) {
          print('Interstitial ad failed to show: $error');
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
              print('Rewarded ad loaded');
            }
          },
          onAdFailedToLoad: (error) {
            if (kDebugMode) {
              print('Rewarded ad failed to load: $error');
            }
          },
        ),
      );
      return rewardedAd;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading rewarded ad: $e');
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
          print('Rewarded ad showed full screen content');
        }
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (kDebugMode) {
          print('Rewarded ad dismissed');
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        if (kDebugMode) {
          print('Rewarded ad failed to show: $error');
        }
      },
    );

    await ad.show(
      onUserEarnedReward: (ad, reward) {
        rewardEarned = true;
        onReward();
        if (kDebugMode) {
          print('User earned reward: ${reward.amount} ${reward.type}');
        }
      },
    );

    return rewardEarned;
  }

  // Vérifier si on doit afficher une pub interstitielle
  bool shouldShowInterstitialAd(int currentLevel) {
    if (!adsEnabled) return false;

    // Afficher une pub tous les 2 niveaux pour plus de revenus
    if (currentLevel > _lastAdShownLevel + 1) {
      _lastAdShownLevel = currentLevel;
      _saveUserPreferences();
      return true;
    }

    return false;
  }

  // Nouvelle méthode pour forcer l'affichage d'une pub interstitielle (pour les fins de niveau)
  bool shouldShowInterstitialAdOnLevelComplete(int currentLevel) {
    if (!adsEnabled) return false;

    // Afficher une pub à la fin de chaque niveau gagné (plus agressif pour les revenus)
    // Mais seulement si on n'a pas déjà affiché une pub récemment
    if (currentLevel > _lastAdShownLevel) {
      return true;
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
    };
  }
}
