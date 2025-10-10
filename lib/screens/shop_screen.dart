import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/widgets/banner_ad_widget.dart';
import 'package:mind_bloom/widgets/rewarded_ad_button.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  ShopCategory _selectedCategory = ShopCategory.all;
  List<ShopItem> _items = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_items.isEmpty) {
      _generateItems();
    }
  }

  void _generateItems() {
    _items = [
      // Vies (corrigé - maximum 5 vies)
      ShopItem(
        id: 'lives_refill',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 25,
        currency: Currency.coins,
        icon: Icons.favorite,
        color: AppColors.error,
        category: ShopCategory.lives,
        isPopular: true,
      ),
      ShopItem(
        id: 'lives_3',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 15,
        currency: Currency.coins,
        icon: Icons.favorite,
        color: AppColors.error,
        category: ShopCategory.lives,
      ),

      // Monnaie (rééquilibré)
      ShopItem(
        id: 'coins_200',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 5,
        currency: Currency.gems,
        icon: Icons.monetization_on,
        color: AppColors.coins,
        category: ShopCategory.currency,
      ),
      ShopItem(
        id: 'coins_500',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 10,
        currency: Currency.gems,
        icon: Icons.monetization_on,
        color: AppColors.coins,
        category: ShopCategory.currency,
        isPopular: true,
      ),
      ShopItem(
        id: 'coins_1000',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 18,
        currency: Currency.gems,
        icon: Icons.monetization_on,
        color: AppColors.coins,
        category: ShopCategory.currency,
      ),
      ShopItem(
        id: 'gems_25',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 300,
        currency: Currency.coins,
        icon: Icons.diamond,
        color: AppColors.gold,
        category: ShopCategory.currency,
      ),

      // Boosters de jeu (améliorés)
      ShopItem(
        id: 'booster_shuffle',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 25,
        currency: Currency.coins,
        icon: Icons.shuffle,
        color: AppColors.secondary,
        category: ShopCategory.boosters,
      ),
      ShopItem(
        id: 'booster_hint',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 15,
        currency: Currency.coins,
        icon: Icons.lightbulb,
        color: AppColors.warning,
        category: ShopCategory.boosters,
      ),
      ShopItem(
        id: 'booster_extra_moves',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 40,
        currency: Currency.coins,
        icon: Icons.add_circle,
        color: AppColors.primary,
        category: ShopCategory.boosters,
        isPopular: true,
      ),
      ShopItem(
        id: 'booster_score_multiplier',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 60,
        currency: Currency.coins,
        icon: Icons.trending_up,
        color: AppColors.success,
        category: ShopCategory.boosters,
      ),

      // Progression et améliorations
      ShopItem(
        id: 'experience_boost',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 30,
        currency: Currency.coins,
        icon: Icons.star,
        color: AppColors.warning,
        category: ShopCategory.progression,
      ),
      ShopItem(
        id: 'level_skip',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 50,
        currency: Currency.gems,
        icon: Icons.skip_next,
        color: AppColors.primary,
        category: ShopCategory.progression,
      ),
      ShopItem(
        id: 'unlock_all_levels',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 200,
        currency: Currency.gems,
        icon: Icons.lock_open,
        color: AppColors.gold,
        category: ShopCategory.progression,
      ),

      // Cosmétiques et personnalisation
      ShopItem(
        id: 'theme_pack_nature',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 75,
        currency: Currency.gems,
        icon: Icons.palette,
        color: AppColors.success,
        category: ShopCategory.cosmetics,
      ),
      ShopItem(
        id: 'theme_pack_ocean',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 75,
        currency: Currency.gems,
        icon: Icons.waves,
        color: AppColors.primary,
        category: ShopCategory.cosmetics,
      ),
      ShopItem(
        id: 'avatar_frame_gold',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 100,
        currency: Currency.gems,
        icon: Icons.crop_square,
        color: AppColors.gold,
        category: ShopCategory.cosmetics,
      ),

      // Premium
      ShopItem(
        id: 'remove_ads',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 150,
        currency: Currency.gems,
        icon: Icons.block,
        color: AppColors.primary,
        category: ShopCategory.premium,
        isPopular: true,
      ),
      ShopItem(
        id: 'premium_pack',
        title: '', // Sera rempli dynamiquement
        description: '', // Sera rempli dynamiquement
        price: 300,
        currency: Currency.gems,
        icon: Icons.diamond,
        color: AppColors.gold,
        category: ShopCategory.premium,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.shop,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: AppColors.coins,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      userProvider.coins.toString(),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.diamond,
                      color: AppColors.gold,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      userProvider.gems.toString(),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres de catégorie
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ShopCategory.values.map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      label: Text(_getCategoryName(category)),
                      backgroundColor: AppColors.surface,
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Liste des articles
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section populaire
                  if (_selectedCategory == ShopCategory.all)
                    _buildPopularSection(),

                  // Grille des articles
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _getFilteredItems().length,
                    itemBuilder: (context, index) {
                      return _buildShopItem(_getFilteredItems()[index]);
                    },
                  ),
                ],
              ),
            ),
          ),

          // 🚀 BOUTONS DE PUBLICITÉS RÉCOMPENSÉES DANS LA BOUTIQUE
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.freeRewards,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                const CoinsRewardedAdButton(),
                const SizedBox(height: 8),
                const GemsRewardedAdButton(),
              ],
            ),
          ),

          // 🚀 BANNIÈRE PUBLICITAIRE DANS LA BOUTIQUE
          const ShopBannerAd(),
        ],
      ),
    );
  }

  List<ShopItem> _getFilteredItems() {
    if (_selectedCategory == ShopCategory.all) {
      return _items;
    }
    return _items.where((item) => item.category == _selectedCategory).toList();
  }

  Widget _buildPopularSection() {
    final popularItems = _items.where((item) => item.isPopular).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            AppLocalizations.of(context)!.popularItems,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: popularItems.length,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                child: _buildShopItem(popularItems[index], isPopular: true),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildShopItem(ShopItem item, {bool isPopular = false}) {
    return Card(
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isPopular
              ? LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.accent.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icône et badge populaire
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      item.icon,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const Spacer(),
                  if (isPopular)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.pop,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 6),

              // Titre et description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getItemTitle(item.id),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Expanded(
                      child: Text(
                        _getItemDescription(item.id),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // Prix et bouton d'achat
              Row(
                children: [
                  Icon(
                    _getCurrencyIcon(item.currency),
                    color: _getCurrencyColor(item.currency),
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.price.toString(),
                    style: TextStyle(
                      color: _getCurrencyColor(item.currency),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _purchaseItem(item),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.buy,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCurrencyIcon(Currency currency) {
    switch (currency) {
      case Currency.coins:
        return Icons.monetization_on;
      case Currency.gems:
        return Icons.diamond;
    }
  }

  Color _getCurrencyColor(Currency currency) {
    switch (currency) {
      case Currency.coins:
        return AppColors.coins;
      case Currency.gems:
        return AppColors.gold;
    }
  }

  String _getCategoryName(ShopCategory category) {
    switch (category) {
      case ShopCategory.all:
        return AppLocalizations.of(context)!.all;
      case ShopCategory.lives:
        return AppLocalizations.of(context)!.lives;
      case ShopCategory.currency:
        return AppLocalizations.of(context)!.currency;
      case ShopCategory.boosters:
        return AppLocalizations.of(context)!.boosters(0).replaceAll('0 ', '');
      case ShopCategory.progression:
        return AppLocalizations.of(context)!.progression;
      case ShopCategory.cosmetics:
        return AppLocalizations.of(context)!.cosmetics;
      case ShopCategory.premium:
        return AppLocalizations.of(context)!.premium;
    }
  }

  void _purchaseItem(ShopItem item) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    // Vérifier si l'utilisateur a assez de monnaie
    bool canAfford = false;
    if (item.currency == Currency.coins) {
      canAfford = userProvider.coins >= item.price;
    } else {
      canAfford = userProvider.gems >= item.price;
    }

    if (!canAfford) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.notEnoughCurrency(
              item.currency == Currency.coins
                  ? AppLocalizations.of(context)!.coins
                  : AppLocalizations.of(context)!
                      .gems)),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Jouer le son d'achat
    audioProvider.playSfx('audio/sfx/button_click.wav');

    // Effectuer l'achat
    if (item.currency == Currency.coins) {
      userProvider.spendCoins(item.price);
    } else {
      userProvider.spendGems(item.price);
    }

    // Appliquer l'effet de l'achat
    _applyPurchaseEffect(item, userProvider);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(AppLocalizations.of(context)!.purchaseSuccess(item.title)),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _applyPurchaseEffect(ShopItem item, UserProvider userProvider) {
    switch (item.id) {
      // Vies
      case 'lives_refill':
        userProvider.refillLives();
        break;
      case 'lives_3':
        final livesBefore = userProvider.lives;
        userProvider.addLives(3);
        final livesAfter = userProvider.lives;
        final actualLivesAdded = livesAfter - livesBefore;

        // Afficher un message informatif si l'achat a été limité
        if (actualLivesAdded < 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppLocalizations.of(context)!.purchaseSuccess(item.title)} - ${AppLocalizations.of(context)!.livesLimitedToMax(actualLivesAdded, userProvider.maxLives)}',
              ),
              backgroundColor: AppColors.warning,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        break;

      // Monnaie
      case 'coins_200':
        userProvider.addCoins(200);
        break;
      case 'coins_500':
        userProvider.addCoins(500);
        break;
      case 'coins_1000':
        userProvider.addCoins(1000);
        break;
      case 'gems_25':
        userProvider.addGems(25);
        break;

      // Boosters
      case 'booster_shuffle':
        // TODO: Ajouter le booster au stock
        break;
      case 'booster_hint':
        // TODO: Ajouter le booster au stock
        break;
      case 'booster_extra_moves':
        // TODO: Ajouter le booster au stock
        break;
      case 'booster_score_multiplier':
        // TODO: Ajouter le booster au stock
        break;

      // Progression
      case 'experience_boost':
        userProvider.addExperience(100);
        break;
      case 'level_skip':
        // TODO: Débloquer le niveau suivant
        break;
      case 'unlock_all_levels':
        // TODO: Débloquer tous les niveaux
        break;

      // Cosmétiques
      case 'theme_pack_nature':
        // TODO: Appliquer le thème nature
        break;
      case 'theme_pack_ocean':
        // TODO: Appliquer le thème océan
        break;
      case 'avatar_frame_gold':
        // TODO: Appliquer le cadre doré
        break;

      // Premium
      case 'remove_ads':
        // TODO: Supprimer les publicités
        break;
      case 'premium_pack':
        userProvider.addGems(100);
        // TODO: Appliquer tous les avantages premium
        break;
    }
  }

  /// Méthodes helper pour obtenir les traductions des articles
  String _getItemTitle(String itemId) {
    final l10n = AppLocalizations.of(context)!;
    switch (itemId) {
      case 'lives_refill':
        return l10n.fullLives;
      case 'lives_3':
        return l10n.threeLives;
      case 'coins_200':
        return l10n.twoHundredCoins;
      case 'coins_500':
        return l10n.fiveHundredCoins;
      case 'coins_1000':
        return l10n.thousandCoins;
      case 'gems_25':
        return l10n.twentyFiveGems;
      case 'booster_shuffle':
        return l10n.shuffler;
      case 'booster_hint':
        return l10n.hint;
      case 'booster_extra_moves':
        return l10n.bonusMoves;
      case 'booster_score_multiplier':
        return l10n.scoreMultiplier;
      case 'experience_boost':
        return l10n.experienceBoost;
      case 'level_skip':
        return l10n.skipLevel;
      case 'unlock_all_levels':
        return l10n.unlockAllLevels;
      case 'theme_pack_nature':
        return l10n.natureTheme;
      case 'theme_pack_ocean':
        return l10n.oceanTheme;
      case 'avatar_frame_gold':
        return l10n.goldFrame;
      case 'remove_ads':
        return l10n.removeAds;
      case 'premium_pack':
        return l10n.premiumPack;
      default:
        return 'Item';
    }
  }

  String _getItemDescription(String itemId) {
    final l10n = AppLocalizations.of(context)!;
    switch (itemId) {
      case 'lives_refill':
        return l10n.refillAllLives;
      case 'lives_3':
        return l10n.addThreeLives;
      case 'coins_200':
        return l10n.smallCoinBoost;
      case 'coins_500':
        return l10n.goodCoinStock;
      case 'coins_1000':
        return l10n.bigCoinStock;
      case 'gems_25':
        return l10n.preciousGems;
      case 'booster_shuffle':
        return l10n.shuffleGrid;
      case 'booster_hint':
        return l10n.revealWinningMove;
      case 'booster_extra_moves':
        return l10n.fiveExtraMoves;
      case 'booster_score_multiplier':
        return l10n.doubleScoreThreeLevels;
      case 'experience_boost':
        return l10n.hundredXpBoost;
      case 'level_skip':
        return l10n.unlockNextLevel;
      case 'unlock_all_levels':
        return l10n.accessAllLevels;
      case 'theme_pack_nature':
        return l10n.natureThemeDescription;
      case 'theme_pack_ocean':
        return l10n.oceanThemeDescription;
      case 'avatar_frame_gold':
        return l10n.goldFrameDescription;
      case 'remove_ads':
        return l10n.playWithoutAds;
      case 'premium_pack':
        return l10n.allPremiumBenefits;
      default:
        return 'Description';
    }
  }
}

enum Currency {
  coins,
  gems,
}

enum ShopCategory {
  all,
  lives,
  currency,
  boosters,
  progression,
  cosmetics,
  premium,
}

class ShopItem {
  final String id;
  final String title;
  final String description;
  final int price;
  final Currency currency;
  final IconData icon;
  final Color color;
  final ShopCategory category;
  final bool isPopular;

  ShopItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.icon,
    required this.color,
    required this.category,
    this.isPopular = false,
  });
}
