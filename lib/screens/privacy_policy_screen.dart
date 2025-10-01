import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.privacyPolicy,
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
                      Icons.privacy_tip,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.privacyPolicy,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.lastUpdated(_getCurrentDate()),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Introduction
            _buildSection(
              title: l10n.introduction,
              content: l10n.privacyPolicyIntroduction,
            ),

            // Section 1
            _buildSection(
              title: '1. ${l10n.informationWeCollect}',
              content: '''${l10n.weCollectFollowing}

• **${l10n.gameData}** : ${l10n.gameDataDescription}
• **${l10n.technicalData}** : ${l10n.technicalDataDescription}
• **${l10n.usageData}** : ${l10n.usageDataDescription}''',
            ),

            // Section 2
            _buildSection(
              title: '2. ${l10n.howWeUseInformation}',
              content: '''${l10n.weUseInformationFor}

• ${l10n.provideService}
• ${l10n.personalizeExperience}
• ${l10n.analyzeUsage}
• ${l10n.displayAds}
• ${l10n.ensureSecurity}
• ${l10n.communicateService}''',
            ),

            // Section 3
            _buildSection(
              title: '3. ${l10n.dataSharing}',
              content: l10n.dataSharingDescription,
            ),

            // Section 4
            _buildSection(
              title: l10n.dataStorage,
              content: l10n.dataStorageContent,
            ),

            // Section 5
            _buildSection(
              title: l10n.cookies,
              content: l10n.cookiesContent,
            ),

            // Section 6
            _buildSection(
              title: '6. ${l10n.yourRights}',
              content: '''${l10n.yourRightsDescription}

• ${l10n.accessData}
• ${l10n.correctData}
• ${l10n.deleteData}
• ${l10n.withdrawConsent}''',
            ),

            // Section 7
            _buildSection(
              title: l10n.thirdPartyAds,
              content: l10n.thirdPartyAdsContent,
            ),

            // Section 8
            _buildSection(
              title: l10n.minorsData,
              content: l10n.minorsDataContent,
            ),

            // Section 9
            _buildSection(
              title: l10n.policyChanges,
              content: l10n.policyChangesContent,
            ),

            // Section 10
            _buildSection(
              title: l10n.legalBasis,
              content: l10n.legalBasisContent,
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
                    l10n.contactDPO,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.contactDPOContent,
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
                  const SizedBox(height: 8),
                  Text(
                    l10n.responseTime,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
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
                    l10n.developedWithLove,
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
          MarkdownBody(
            data: content,
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              strong: TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              listBullet: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              listBulletPadding: const EdgeInsets.only(right: 8),
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
