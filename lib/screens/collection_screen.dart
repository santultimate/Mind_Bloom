import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/providers/collection_provider.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  String _selectedRarity = 'Toutes';

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionProvider>(
      builder: (context, collectionProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text(
              'Collection',
              style: TextStyle(
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
                      'Plantes',
                      '${collectionProvider.unlockedPlants}/${collectionProvider.totalPlants}',
                      Icons.eco,
                      AppColors.primary,
                    ),
                    _buildStatistic(
                      'Rareté',
                      '${collectionProvider.totalRarity}',
                      Icons.star,
                      AppColors.gold,
                    ),
                    _buildStatistic(
                      'Niveau',
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
                      'Toutes',
                      '1★',
                      '2★',
                      '3★',
                      '4★',
                      '5★',
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
                          label: Text(rarity),
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

  List<Plant> _getFilteredPlants(CollectionProvider collectionProvider) {
    if (_selectedRarity == 'Toutes') {
      return collectionProvider.plants;
    }

    final rarity = _selectedRarity == '1★'
        ? 1
        : _selectedRarity == '2★'
            ? 2
            : _selectedRarity == '3★'
                ? 3
                : _selectedRarity == '4★'
                    ? 4
                    : 5;

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
                      child: plant.isUnlocked
                          ? Icon(
                              Icons.eco,
                              color: AppColors.primary,
                              size: 30,
                            )
                          : Icon(
                              Icons.lock,
                              color: AppColors.textSecondary,
                              size: 30,
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
                  plant.name,
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
                    'Niveau ${plant.level}',
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
                    plant.description,
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
                      '+${plant.bonuses.length} bonus',
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
                    child: plant.isUnlocked
                        ? Icon(
                            Icons.eco,
                            color: AppColors.primary,
                            size: 40,
                          )
                        : Icon(
                            Icons.lock,
                            color: AppColors.textSecondary,
                            size: 40,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plant.name,
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
                'Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                plant.description,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              // Condition de déblocage ou Bonus
              if (!plant.isUnlocked) ...[
                Text(
                  'Condition de déblocage',
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
                  'Bonus',
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
                    plant.isUnlocked ? 'Améliorer' : 'Verrouillé',
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
        return '+${bonus.value} coups supplémentaires';
      case BonusType.scoreMultiplier:
        return 'Score x${bonus.value}';
      case BonusType.coinMultiplier:
        return 'Pièces x${bonus.value}';
      case BonusType.extraLives:
        return '+${bonus.value} vie(s)';
    }
  }

  void _upgradePlant(Plant plant, CollectionProvider collectionProvider) {
    collectionProvider.upgradePlant(plant.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${plant.name} améliorée au niveau ${plant.level + 1} !'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
