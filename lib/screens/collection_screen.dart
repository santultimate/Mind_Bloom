import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/providers/collection_provider.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  String _selectedRarity = 'all';

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionProvider>(
      builder: (context, collectionProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.collection,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.surface,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
          ),
          body: Column(
            children: [
              // Statistiques de collection
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatistic(
                      AppLocalizations.of(context)!.plants,
                      '${collectionProvider.unlockedPlants}/${collectionProvider.totalPlants}',
                      Icons.eco,
                      AppColors.primary,
                    ),
                    _buildStatistic(
                      AppLocalizations.of(context)!.rarity,
                      '${collectionProvider.totalRarity}',
                      Icons.star,
                      AppColors.gold,
                    ),
                    _buildStatistic(
                      AppLocalizations.of(context)!.level,
                      '${collectionProvider.totalLevels}',
                      Icons.trending_up,
                      AppColors.success,
                    ),
                  ],
                ),
              ),

              // Filtres de rareté
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      'all',
                      '1',
                      '2',
                      '3',
                      '4',
                      '5',
                    ].map((rarity) {
                      final isSelected = _selectedRarity == rarity;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedRarity = rarity;
                            });
                          },
                          label: Text(_getRarityLabel(rarity)),
                          backgroundColor: AppColors.surface,
                          selectedColor:
                              AppColors.primary.withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Liste des plantes
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _getFilteredPlants(collectionProvider).length,
                  itemBuilder: (context, index) {
                    return _buildPlantCard(
                        _getFilteredPlants(collectionProvider)[index],
                        collectionProvider);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getRarityLabel(String rarity) {
    if (rarity == 'all') {
      return AppLocalizations.of(context)!.all;
    }
    return '$rarity★';
  }

  String _getPlantName(String nameKey) {
    switch (nameKey) {
      case 'plant_tournesol_or_name':
        return AppLocalizations.of(context)!.plant_tournesol_or_name;
      case 'plant_rose_magique_name':
        return AppLocalizations.of(context)!.plant_rose_magique_name;
      case 'plant_lotus_cristal_name':
        return AppLocalizations.of(context)!.plant_lotus_cristal_name;
      case 'plant_tulipe_arc_name':
        return AppLocalizations.of(context)!.plant_tulipe_arc_name;
      case 'plant_orchidee_lune_name':
        return AppLocalizations.of(context)!.plant_orchidee_lune_name;
      case 'plant_marguerite_etoile_name':
        return AppLocalizations.of(context)!.plant_marguerite_etoile_name;
      case 'plant_violette_mystique_name':
        return AppLocalizations.of(context)!.plant_violette_mystique_name;
      case 'plant_jasmin_eternel_name':
        return AppLocalizations.of(context)!.plant_jasmin_eternel_name;
      case 'plant_petunia_cosmique_name':
        return AppLocalizations.of(context)!.plant_petunia_cosmique_name;
      case 'plant_lys_phoenix_name':
        return AppLocalizations.of(context)!.plant_lys_phoenix_name;
      case 'plant_cactus_temporel_name':
        return AppLocalizations.of(context)!.plant_cactus_temporel_name;
      case 'plant_rose_eternelle_name':
        return AppLocalizations.of(context)!.plant_rose_eternelle_name;
      case 'plant_lotus_paradis_name':
        return AppLocalizations.of(context)!.plant_lotus_paradis_name;
      case 'plant_orchidee_lunaire_name':
        return AppLocalizations.of(context)!.plant_orchidee_lunaire_name;
      case 'plant_tournesol_solaire_name':
        return AppLocalizations.of(context)!.plant_tournesol_solaire_name;
      case 'plant_cristal_vegetal_name':
        return AppLocalizations.of(context)!.plant_cristal_vegetal_name;
      case 'plant_nymphaea_mystique_name':
        return AppLocalizations.of(context)!.plant_nymphaea_mystique_name;
      case 'plant_flamme_vegetale_name':
        return AppLocalizations.of(context)!.plant_flamme_vegetale_name;
      case 'plant_glace_eternelle_name':
        return AppLocalizations.of(context)!.plant_glace_eternelle_name;
      case 'plant_arc_en_ciel_perdu_name':
        return AppLocalizations.of(context)!.plant_arc_en_ciel_perdu_name;
      case 'plant_jardin_celeste_name':
        return AppLocalizations.of(context)!.plant_jardin_celeste_name;
      default:
        return nameKey; // Fallback vers la clé si pas trouvée
    }
  }

  String _getPlantDescription(String descriptionKey) {
    switch (descriptionKey) {
      case 'plant_marguerite_etoile_description':
        return AppLocalizations.of(context)!
            .plant_marguerite_etoile_description;
      case 'plant_petunia_cosmique_description':
        return AppLocalizations.of(context)!.plant_petunia_cosmique_description;
      case 'plant_lotus_cristal_description':
        return AppLocalizations.of(context)!.plant_lotus_cristal_description;
      case 'plant_tournesol_or_description':
        return AppLocalizations.of(context)!.plant_tournesol_or_description;
      case 'plant_violette_mystique_description':
        return AppLocalizations.of(context)!
            .plant_violette_mystique_description;
      case 'plant_jasmin_eternel_description':
        return AppLocalizations.of(context)!.plant_jasmin_eternel_description;
      case 'plant_orchidee_lune_description':
        return AppLocalizations.of(context)!.plant_orchidee_lune_description;
      case 'plant_tulipe_arc_description':
        return AppLocalizations.of(context)!.plant_tulipe_arc_description;
      case 'plant_rose_magique_description':
        return AppLocalizations.of(context)!.plant_rose_magique_description;
      case 'plant_tournesol_solaire_description':
        return AppLocalizations.of(context)!
            .plant_tournesol_solaire_description;
      case 'plant_cristal_vegetal_description':
        return AppLocalizations.of(context)!.plant_cristal_vegetal_description;
      case 'plant_nymphaea_mystique_description':
        return AppLocalizations.of(context)!
            .plant_nymphaea_mystique_description;
      case 'plant_flamme_vegetale_description':
        return AppLocalizations.of(context)!.plant_flamme_vegetale_description;
      case 'plant_glace_eternelle_description':
        return AppLocalizations.of(context)!.plant_glace_eternelle_description;
      case 'plant_arc_en_ciel_perdu_description':
        return AppLocalizations.of(context)!
            .plant_arc_en_ciel_perdu_description;
      case 'plant_jardin_celeste_description':
        return AppLocalizations.of(context)!.plant_jardin_celeste_description;
      case 'plant_lys_phoenix_description':
        return AppLocalizations.of(context)!.plant_lys_phoenix_description;
      case 'plant_cactus_temporel_description':
        return AppLocalizations.of(context)!.plant_cactus_temporel_description;
      case 'plant_rose_eternelle_description':
        return AppLocalizations.of(context)!.plant_rose_eternelle_description;
      case 'plant_lotus_paradis_description':
        return AppLocalizations.of(context)!.plant_lotus_paradis_description;
      case 'plant_orchidee_lunaire_description':
        return AppLocalizations.of(context)!.plant_orchidee_lunaire_description;
      default:
        return descriptionKey; // Fallback vers la clé si pas trouvée
    }
  }

  List<Plant> _getFilteredPlants(CollectionProvider collectionProvider) {
    if (_selectedRarity == 'all') {
      return collectionProvider.plants;
    }

    final rarity = int.parse(_selectedRarity);

    return collectionProvider.plants
        .where((plant) => plant.rarity == rarity)
        .toList();
  }

  Widget _buildStatistic(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPlantCard(Plant plant, CollectionProvider collectionProvider) {
    final unlockProgress = collectionProvider.getUnlockProgress(plant.id);

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: plant.isUnlocked
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
        child: InkWell(
          onTap: () => _showPlantDetails(plant, collectionProvider),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image et rareté
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: plant.isUnlocked
                            ? AppColors.primary.withValues(alpha: 0.2)
                            : AppColors.textSecondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          // Image de la plante (toujours visible)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              plant.imagePath,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Debug: afficher l'erreur
                                if (kDebugMode) {
                                  debugPrint(
                                      'Erreur chargement image ${plant.imagePath}: $error');
                                }
                                // Fallback vers l'icône si l'image n'existe pas
                                return Icon(
                                  Icons.eco,
                                  color: plant.isUnlocked
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  size: 30,
                                );
                              },
                            ),
                          ),
                          // Overlay sombre si verrouillé
                          if (!plant.isUnlocked)
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          // Petit cadenas si verrouillé
                          if (!plant.isUnlocked)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                  size: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Étoiles de rareté (plus petites)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < plant.rarity ? Icons.star : Icons.star_border,
                          color: index < plant.rarity
                              ? AppColors.gold
                              : AppColors.textSecondary,
                          size: 12,
                        );
                      }),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Nom et niveau
                Text(
                  _getPlantName(plant.nameKey),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: plant.isUnlocked
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                if (plant.isUnlocked) ...[
                  Text(
                    AppLocalizations.of(context)!.plantLevel(plant.level),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ] else ...[
                  // Barre de progression pour les plantes verrouillées
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: unlockProgress,
                    backgroundColor:
                        AppColors.textSecondary.withValues(alpha: 0.2),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${(unlockProgress * 100).toInt()}%',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],

                const SizedBox(height: 4),

                // Description
                Expanded(
                  child: Text(
                    _getPlantDescription(plant.descriptionKey),
                    style: TextStyle(
                      color: plant.isUnlocked
                          ? AppColors.textSecondary
                          : AppColors.textSecondary.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Bonus
                if (plant.isUnlocked && plant.bonuses.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.bonus(plant.bonuses.length),
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPlantDetails(Plant plant, CollectionProvider collectionProvider) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSfx('audio/sfx/button_click.wav');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // En-tête
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: plant.isUnlocked
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : AppColors.textSecondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        // Image de la plante (toujours visible)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            plant.imagePath,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Debug: afficher l'erreur
                              if (kDebugMode) {
                                debugPrint(
                                    'Erreur chargement image modal ${plant.imagePath}: $error');
                              }
                              return Icon(
                                Icons.eco,
                                color: plant.isUnlocked
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                size: 40,
                              );
                            },
                          ),
                        ),
                        // Overlay sombre si verrouillé
                        if (!plant.isUnlocked)
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        // Petit cadenas si verrouillé
                        if (!plant.isUnlocked)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.lock,
                                color: Colors.black,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getPlantName(plant.nameKey),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < plant.rarity
                                  ? Icons.star
                                  : Icons.star_border,
                              color: index < plant.rarity
                                  ? AppColors.gold
                                  : AppColors.textSecondary,
                              size: 20,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Description
              Text(
                AppLocalizations.of(context)!.description,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                _getPlantDescription(plant.descriptionKey),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              // Condition de déblocage ou Bonus
              if (!plant.isUnlocked) ...[
                Text(
                  AppLocalizations.of(context)!.unlockCondition,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          plant.unlockCondition.description,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (plant.bonuses.isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context)!.bonuses,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 8),
                ...plant.bonuses.map((bonus) => _buildBonusItem(bonus)),
              ],

              const Spacer(),

              // Bouton d'action
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: plant.isUnlocked
                      ? () => _upgradePlant(plant, collectionProvider)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: plant.isUnlocked
                        ? AppColors.primary
                        : AppColors.textSecondary.withValues(alpha: 0.3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    plant.isUnlocked
                        ? AppLocalizations.of(context)!.upgrade
                        : AppLocalizations.of(context)!.locked,
                    style: const TextStyle(
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

  Widget _buildBonusItem(PlantBonus bonus) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            _getBonusIcon(bonus.type),
            color: AppColors.success,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getBonusDescription(bonus),
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getBonusIcon(BonusType type) {
    switch (type) {
      case BonusType.extraMoves:
        return Icons.add_circle;
      case BonusType.scoreMultiplier:
        return Icons.trending_up;
      case BonusType.coinMultiplier:
        return Icons.monetization_on;
      case BonusType.extraLives:
        return Icons.favorite;
    }
  }

  String _getBonusDescription(PlantBonus bonus) {
    switch (bonus.type) {
      case BonusType.extraMoves:
        return AppLocalizations.of(context)!.extraMoves(bonus.value.toInt());
      case BonusType.scoreMultiplier:
        return AppLocalizations.of(context)!.scoreMultiplier +
            ' x${bonus.value.toInt()}';
      case BonusType.coinMultiplier:
        return AppLocalizations.of(context)!
            .coinMultiplier(bonus.value.toInt());
      case BonusType.extraLives:
        return AppLocalizations.of(context)!.extraLives(bonus.value.toInt());
    }
  }

  void _upgradePlant(Plant plant, CollectionProvider collectionProvider) {
    collectionProvider.upgradePlant(plant.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!
            .plantUpgraded(_getPlantName(plant.nameKey), plant.level + 1)),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
