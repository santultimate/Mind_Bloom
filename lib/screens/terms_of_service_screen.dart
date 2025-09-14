import 'package:flutter/material.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.termsOfService,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.description,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.termsOfService,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!
                        .lastUpdated(_getCurrentDate()),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Section 1
            _buildSection(
              title: AppLocalizations.of(context)!.acceptanceOfTerms,
              content: AppLocalizations.of(context)!.acceptanceOfTermsContent,
            ),

            // Section 2
            _buildSection(
              title: AppLocalizations.of(context)!.serviceDescription,
              content: AppLocalizations.of(context)!.serviceDescriptionContent,
            ),

            // Section 3
            _buildSection(
              title: AppLocalizations.of(context)!.authorizedUse,
              content: AppLocalizations.of(context)!.authorizedUseContent,
            ),

            // Section 4
            _buildSection(
              title: AppLocalizations.of(context)!.intellectualProperty,
              content:
                  AppLocalizations.of(context)!.intellectualPropertyContent,
            ),

            // Section 5
            _buildSection(
              title: AppLocalizations.of(context)!.inAppPurchases,
              content: AppLocalizations.of(context)!.inAppPurchasesContent,
            ),

            // Section 6
            _buildSection(
              title: AppLocalizations.of(context)!.advertisements,
              content: AppLocalizations.of(context)!.advertisementsContent,
            ),

            // Section 7
            _buildSection(
              title: AppLocalizations.of(context)!.liabilityLimitation,
              content: AppLocalizations.of(context)!.liabilityLimitationContent,
            ),

            // Section 8
            _buildSection(
              title: AppLocalizations.of(context)!.termsModifications,
              content: AppLocalizations.of(context)!.termsModificationsContent,
            ),

            // Section 9
            _buildSection(
              title: AppLocalizations.of(context)!.termination,
              content: AppLocalizations.of(context)!.terminationContent,
            ),

            // Section 10
            _buildSection(
              title: AppLocalizations.of(context)!.applicableLaw,
              content: AppLocalizations.of(context)!.applicableLawContent,
            ),

            const SizedBox(height: 32),

            // Contact
            Container(
              padding: const EdgeInsets.all(20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.contact,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.contactContent,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'papysantara@gmail.com',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Signature
            Center(
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.developedWithLove,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'YACOUBA SANTARA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }
}
