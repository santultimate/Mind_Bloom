import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/widgets/rewarded_ad_button.dart';
import 'package:mind_bloom/widgets/banner_ad_widget.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

class FreeLivesScreen extends StatelessWidget {
  const FreeLivesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.free_lives),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Bannière publicitaire en haut
            const ShopBannerAd(),

            // Contenu principal
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // En-tête
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.8)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.favorite,
                            size: 48,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Obtenez des Vies Gratuites',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Regardez des publicités pour obtenir des vies gratuites et continuer à jouer !',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Statut actuel des vies
                    Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vies Actuelles',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: AppColors.error,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${userProvider.lives} / ${userProvider.maxLives}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.error,
                                        ),
                                  ),
                                  const Spacer(),
                                  if (userProvider.lives <
                                      userProvider.maxLives)
                                    Text(
                                      'Prochaine vie dans ${_getTimeUntilNextLife(userProvider)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Options de vies gratuites
                    Text(
                      'Options Gratuites',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // Vie gratuite
                    const FreeLivesButton(
                      onRewardEarned: null,
                    ),

                    const SizedBox(height: 16),

                    // Pièces gratuites
                    const FreeCoinsButton(
                      onRewardEarned: null,
                    ),

                    const SizedBox(height: 16),

                    // Gemmes gratuites
                    const FreeGemsButton(
                      onRewardEarned: null,
                    ),

                    const SizedBox(height: 24),

                    // Informations
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.info.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.info,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Comment ça marche ?',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.info,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '• Regardez une publicité de 30 secondes\n'
                            '• Obtenez immédiatement votre récompense\n'
                            '• Pas de limite sur le nombre de publicités\n'
                            '• Les récompenses sont cumulables',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bannière publicitaire en bas
            const HomeBannerAd(),
          ],
        ),
      ),
    );
  }

  String _getTimeUntilNextLife(UserProvider userProvider) {
    // TODO: Implémenter le calcul du temps restant
    return '30 min';
  }
}
