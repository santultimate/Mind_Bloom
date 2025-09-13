import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/providers/ad_provider.dart';

class BannerAdWidget extends StatefulWidget {
  final String placement; // 'home', 'level_select', 'level_complete', 'shop'
  final double? height;
  final EdgeInsets? margin;

  const BannerAdWidget({
    super.key,
    required this.placement,
    this.height,
    this.margin,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isAdFailed = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    final adProvider = Provider.of<AdProvider>(context, listen: false);

    // Vérifier si les pubs sont activées
    if (!adProvider.adsEnabled) {
      setState(() {
        _isAdFailed = true;
      });
      return;
    }

    _bannerAd = adProvider.createBannerAd();
    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdProvider>(
      builder: (context, adProvider, child) {
        // Si les pubs sont désactivées, ne pas afficher le widget
        if (!adProvider.adsEnabled) {
          return const SizedBox.shrink();
        }

        // Si la pub a échoué, afficher un placeholder discret
        if (_isAdFailed) {
          return _buildPlaceholder();
        }

        // Si la pub n'est pas encore chargée, afficher un placeholder
        if (!_isAdLoaded || _bannerAd == null) {
          return _buildLoadingPlaceholder();
        }

        // Afficher la bannière publicitaire
        return Container(
          width: double.infinity,
          height: widget.height ?? 50,
          margin: widget.margin ?? const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AdWidget(ad: _bannerAd!),
          ),
        );
      },
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: double.infinity,
      height: widget.height ?? 50,
      margin: widget.margin ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: widget.height ?? 50,
      margin: widget.margin ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Center(
        child: Text(
          'Publicité',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Widget spécialisé pour l'écran d'accueil
class HomeBannerAd extends StatelessWidget {
  const HomeBannerAd({super.key});

  @override
  Widget build(BuildContext context) {
    return const BannerAdWidget(
      placement: 'home',
      height: 60,
      margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
    );
  }
}

// Widget spécialisé pour la sélection de niveau
class LevelSelectBannerAd extends StatelessWidget {
  const LevelSelectBannerAd({super.key});

  @override
  Widget build(BuildContext context) {
    return const BannerAdWidget(
      placement: 'level_select',
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}

// Widget spécialisé pour la fin de niveau
class LevelCompleteBannerAd extends StatelessWidget {
  const LevelCompleteBannerAd({super.key});

  @override
  Widget build(BuildContext context) {
    return const BannerAdWidget(
      placement: 'level_complete',
      height: 50,
      margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
    );
  }
}

// Widget spécialisé pour la boutique
class ShopBannerAd extends StatelessWidget {
  const ShopBannerAd({super.key});

  @override
  Widget build(BuildContext context) {
    return const BannerAdWidget(
      placement: 'shop',
      height: 50,
      margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
    );
  }
}
