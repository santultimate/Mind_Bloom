import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Paramètres'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Section Audio
          _buildSection(
            title: 'Audio',
            icon: Icons.volume_up,
            children: [
              Consumer<AudioProvider>(
                builder: (context, audioProvider, child) {
                  return Column(
                    children: [
                      _buildSwitchTile(
                        title: 'Musique',
                        subtitle: 'Activer/désactiver la musique de fond',
                        value: audioProvider.isMusicEnabled,
                        onChanged: (value) {
                          audioProvider.toggleMusicEnabled();
                        },
                      ),
                      if (audioProvider.isMusicEnabled)
                        _buildSliderTile(
                          title: 'Volume de la musique',
                          value: audioProvider.musicVolume,
                          onChanged: (value) {
                            audioProvider.setMusicVolume(value);
                          },
                        ),
                      const SizedBox(height: 16),
                      _buildSwitchTile(
                        title: 'Effets sonores',
                        subtitle: 'Activer/désactiver les effets sonores',
                        value: audioProvider.isSfxEnabled,
                        onChanged: (value) {
                          audioProvider.toggleSfxEnabled();
                        },
                      ),
                      if (audioProvider.isSfxEnabled)
                        _buildSliderTile(
                          title: 'Volume des effets',
                          value: audioProvider.sfxVolume,
                          onChanged: (value) {
                            audioProvider.setSfxVolume(value);
                          },
                        ),
                    ],
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Section Jeu
          _buildSection(
            title: 'Jeu',
            icon: Icons.games,
            children: [
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return Column(
                    children: [
                      _buildSwitchTile(
                        title: 'Animations',
                        subtitle: 'Activer/désactiver les animations',
                        value: userProvider.animationsEnabled,
                        onChanged: (value) {
                          userProvider.setAnimationsEnabled(value);
                        },
                      ),
                      _buildSwitchTile(
                        title: 'Vibrations',
                        subtitle: 'Activer/désactiver les vibrations',
                        value: userProvider.vibrationsEnabled,
                        onChanged: (value) {
                          userProvider.setVibrationsEnabled(value);
                        },
                      ),
                      _buildSwitchTile(
                        title: 'Indices automatiques',
                        subtitle: 'Afficher des indices après un délai',
                        value: userProvider.autoHintsEnabled,
                        onChanged: (value) {
                          userProvider.setAutoHintsEnabled(value);
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Section Compte
          _buildSection(
            title: 'Compte',
            icon: Icons.person,
            children: [
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return Column(
                    children: [
                      _buildInfoTile(
                        title: 'Nom d\'utilisateur',
                        subtitle: userProvider.username,
                        onTap: () =>
                            _showEditUsernameDialog(context, userProvider),
                      ),
                      _buildInfoTile(
                        title: 'Niveau',
                        subtitle: 'Niveau ${userProvider.level}',
                      ),
                      _buildInfoTile(
                        title: 'Expérience',
                        subtitle:
                            '${userProvider.experience} / ${userProvider.level * 100} XP',
                      ),
                      _buildInfoTile(
                        title: 'Série actuelle',
                        subtitle: '${userProvider.currentStreak} jours',
                      ),
                      _buildInfoTile(
                        title: 'Meilleure série',
                        subtitle: '${userProvider.bestStreak} jours',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Section Données
          _buildSection(
            title: 'Données',
            icon: Icons.storage,
            children: [
              _buildButtonTile(
                title: 'Sauvegarder les données',
                subtitle: 'Sauvegarder vos progrès',
                icon: Icons.save,
                onTap: () => _saveUserData(context),
              ),
              _buildButtonTile(
                title: 'Restaurer les données',
                subtitle: 'Restaurer vos progrès',
                icon: Icons.restore,
                onTap: () => _restoreUserData(context),
              ),
              _buildButtonTile(
                title: 'Réinitialiser les données',
                subtitle: 'Supprimer toutes les données (irréversible)',
                icon: Icons.delete_forever,
                onTap: () => _showResetDataDialog(context),
                isDestructive: true,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Section À propos
          _buildSection(
            title: 'À propos',
            icon: Icons.info,
            children: [
              _buildInfoTile(
                title: 'Version',
                subtitle: '1.0.0',
              ),
              _buildInfoTile(
                title: 'Développeur',
                subtitle: 'Mind Bloom Team',
              ),
              _buildButtonTile(
                title: 'Conditions d\'utilisation',
                subtitle: 'Lire les conditions d\'utilisation',
                icon: Icons.description,
                onTap: () {
                  // TODO: Ouvrir les conditions d'utilisation
                },
              ),
              _buildButtonTile(
                title: 'Politique de confidentialité',
                subtitle: 'Lire la politique de confidentialité',
                icon: Icons.privacy_tip,
                onTap: () {
                  // TODO: Ouvrir la politique de confidentialité
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }

  Widget _buildSliderTile({
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Slider(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.border,
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: onTap != null ? const Icon(Icons.edit) : null,
      onTap: onTap,
    );
  }

  Widget _buildButtonTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(subtitle),
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.primary,
      ),
      onTap: onTap,
    );
  }

  void _showEditUsernameDialog(
      BuildContext context, UserProvider userProvider) {
    final controller = TextEditingController(text: userProvider.username);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le nom d\'utilisateur'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nom d\'utilisateur',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final newUsername = controller.text.trim();
              if (newUsername.isNotEmpty) {
                userProvider.updateUsername(newUsername);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Nom d\'utilisateur mis à jour')),
                );
              }
            },
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }

  void _showResetDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réinitialiser les données'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer toutes vos données ? '
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              userProvider.resetUserData();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Données réinitialisées')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _saveUserData(BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.saveUserData();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Données sauvegardées avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sauvegarde: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _restoreUserData(BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUserData();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Données restaurées avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la restauration: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
