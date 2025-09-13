import 'package:flutter/material.dart';
import 'package:mind_bloom/constants/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Politique de confidentialité',
          style: TextStyle(
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
                  const Text(
                    'Politique de confidentialité',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dernière mise à jour : ${_getCurrentDate()}',
                    style: TextStyle(
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
              title: 'Introduction',
              content:
                  'Cette politique de confidentialité décrit comment Mind Bloom collecte, utilise et protège vos informations personnelles lorsque vous utilisez notre application mobile. Nous nous engageons à protéger votre vie privée et à traiter vos données avec le plus grand respect.',
            ),

            // Section 1
            _buildSection(
              title: '1. Informations que nous collectons',
              content:
                  'Nous collectons les informations suivantes :\n\n• **Données de jeu** : Progression, scores, préférences de jeu\n• **Données techniques** : Version de l\'application, type d\'appareil, système d\'exploitation\n• **Données d\'utilisation** : Temps de jeu, fonctionnalités utilisées\n• **Données de publicité** : Identifiants publicitaires (si vous consentez aux publicités)',
            ),

            // Section 2
            _buildSection(
              title: '2. Comment nous utilisons vos informations',
              content:
                  'Nous utilisons vos informations pour :\n\n• Fournir et améliorer le service de jeu\n• Personnaliser votre expérience de jeu\n• Analyser l\'utilisation de l\'application\n• Afficher des publicités personnalisées (avec votre consentement)\n• Assurer la sécurité et prévenir la fraude\n• Communiquer avec vous concernant le service',
            ),

            // Section 3
            _buildSection(
              title: '3. Partage d\'informations',
              content:
                  'Nous ne vendons jamais vos informations personnelles. Nous pouvons partager vos informations uniquement dans les cas suivants :\n\n• **Partenaires de service** : Avec des tiers qui nous aident à fournir le service (hébergement, analytics)\n• **Obligations légales** : Lorsque requis par la loi\n• **Protection** : Pour protéger nos droits, votre sécurité ou celle d\'autrui\n• **Consentement** : Avec votre consentement explicite',
            ),

            // Section 4
            _buildSection(
              title: '4. Stockage et sécurité',
              content:
                  'Vos données sont stockées de manière sécurisée :\n\n• **Chiffrement** : Les données sensibles sont chiffrées\n• **Accès limité** : Seul le personnel autorisé peut accéder aux données\n• **Sauvegarde** : Des sauvegardes régulières sont effectuées\n• **Durée** : Les données sont conservées uniquement le temps nécessaire',
            ),

            // Section 5
            _buildSection(
              title: '5. Cookies et technologies similaires',
              content:
                  'L\'application peut utiliser :\n\n• **Cookies locaux** : Pour sauvegarder vos préférences de jeu\n• **Identifiants publicitaires** : Pour personnaliser les publicités\n• **Analytics** : Pour comprendre l\'utilisation de l\'application\n\nVous pouvez désactiver ces fonctionnalités dans les paramètres de votre appareil.',
            ),

            // Section 6
            _buildSection(
              title: '6. Vos droits (RGPD)',
              content:
                  'Conformément au RGPD, vous avez le droit de :\n\n• **Accès** : Demander une copie de vos données personnelles\n• **Rectification** : Corriger des données inexactes\n• **Effacement** : Demander la suppression de vos données\n• **Portabilité** : Recevoir vos données dans un format structuré\n• **Opposition** : Vous opposer au traitement de vos données\n• **Limitation** : Demander la limitation du traitement',
            ),

            // Section 7
            _buildSection(
              title: '7. Publicités et partenaires tiers',
              content:
                  'L\'application peut afficher des publicités via des partenaires tiers comme Google AdMob. Ces partenaires peuvent collecter des informations pour personnaliser les publicités. Vous pouvez :\n\n• Désactiver la personnalisation des publicités dans les paramètres\n• Utiliser les paramètres de confidentialité de votre appareil\n• Contacter directement les partenaires publicitaires',
            ),

            // Section 8
            _buildSection(
              title: '8. Données des mineurs',
              content:
                  'Mind Bloom ne collecte pas sciemment d\'informations personnelles d\'enfants de moins de 13 ans. Si nous découvrons qu\'un enfant de moins de 13 ans nous a fourni des informations personnelles, nous les supprimerons immédiatement.',
            ),

            // Section 9
            _buildSection(
              title: '9. Modifications de cette politique',
              content:
                  'Nous pouvons modifier cette politique de confidentialité à tout moment. Les modifications importantes seront communiquées via l\'application ou par email. Nous vous encourageons à consulter régulièrement cette politique.',
            ),

            // Section 10
            _buildSection(
              title: '10. Base légale du traitement',
              content:
                  'Nous traitons vos données personnelles sur la base de :\n\n• **Exécution du contrat** : Pour fournir le service de jeu\n• **Intérêt légitime** : Pour améliorer l\'application et prévenir la fraude\n• **Consentement** : Pour les publicités personnalisées et les communications marketing',
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
                  const Text(
                    'Contact et DPO',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pour toute question concernant cette politique de confidentialité ou pour exercer vos droits, contactez-nous :',
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
                    'Nous nous engageons à répondre à votre demande dans un délai de 30 jours.',
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
                    'Développé avec ❤️ par',
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
