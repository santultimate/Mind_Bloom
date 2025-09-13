import 'package:flutter/material.dart';
import 'package:mind_bloom/constants/app_colors.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Conditions d\'utilisation',
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
                      Icons.description,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Conditions d\'utilisation',
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

            // Section 1
            _buildSection(
              title: '1. Acceptation des conditions',
              content:
                  'En utilisant l\'application Mind Bloom, vous acceptez d\'être lié par ces conditions d\'utilisation. Si vous n\'acceptez pas ces conditions, veuillez ne pas utiliser notre application.',
            ),

            // Section 2
            _buildSection(
              title: '2. Description du service',
              content:
                  'Mind Bloom est un jeu de puzzle mobile développé par YACOUBA SANTARA. L\'application propose des mécaniques de match-3 avec des éléments de progression RPG dans un univers de jardin magique.',
            ),

            // Section 3
            _buildSection(
              title: '3. Utilisation autorisée',
              content:
                  'Vous pouvez utiliser Mind Bloom à des fins personnelles et non commerciales uniquement. Il est interdit de :\n\n• Copier, modifier ou distribuer l\'application\n• Utiliser l\'application à des fins commerciales sans autorisation\n• Tenter de contourner les mesures de sécurité\n• Utiliser l\'application de manière à nuire à d\'autres utilisateurs',
            ),

            // Section 4
            _buildSection(
              title: '4. Contenu et propriété intellectuelle',
              content:
                  'Tous les éléments de Mind Bloom, incluant mais non limités aux graphismes, sons, code source, et design, sont la propriété exclusive de YACOUBA SANTARA et sont protégés par les lois sur le droit d\'auteur.',
            ),

            // Section 5
            _buildSection(
              title: '5. Achats intégrés',
              content:
                  'L\'application peut contenir des achats intégrés pour des vies supplémentaires, des boosters, ou d\'autres éléments de jeu. Tous les achats sont finaux et non remboursables, sauf disposition contraire de la loi applicable.',
            ),

            // Section 6
            _buildSection(
              title: '6. Publicités',
              content:
                  'Mind Bloom peut afficher des publicités tierces. Ces publicités sont gérées par des partenaires publicitaires et nous ne sommes pas responsables du contenu de ces publicités.',
            ),

            // Section 7
            _buildSection(
              title: '7. Limitation de responsabilité',
              content:
                  'L\'application est fournie "en l\'état" sans garantie d\'aucune sorte. Nous ne serons pas responsables des dommages directs, indirects, accessoires ou consécutifs résultant de l\'utilisation de l\'application.',
            ),

            // Section 8
            _buildSection(
              title: '8. Modifications des conditions',
              content:
                  'Nous nous réservons le droit de modifier ces conditions d\'utilisation à tout moment. Les modifications prendront effet dès leur publication dans l\'application. Votre utilisation continue de l\'application constitue votre acceptation des conditions modifiées.',
            ),

            // Section 9
            _buildSection(
              title: '9. Résiliation',
              content:
                  'Nous nous réservons le droit de suspendre ou de résilier votre accès à l\'application à tout moment, sans préavis, pour violation de ces conditions d\'utilisation.',
            ),

            // Section 10
            _buildSection(
              title: '10. Droit applicable',
              content:
                  'Ces conditions d\'utilisation sont régies par le droit français. Tout litige sera soumis à la juridiction exclusive des tribunaux français.',
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
                    'Contact',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pour toute question concernant ces conditions d\'utilisation, vous pouvez nous contacter à :',
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
