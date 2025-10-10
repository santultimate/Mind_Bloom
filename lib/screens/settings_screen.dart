import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/language_provider.dart';
import 'package:mind_bloom/providers/theme_provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/screens/terms_of_service_screen.dart';
import 'package:mind_bloom/screens/privacy_policy_screen.dart';
import 'package:mind_bloom/screens/tutorial_screen.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.settings),
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
            title: l10n.audio,
            icon: Icons.volume_up,
            children: [
              Consumer<AudioProvider>(
                builder: (context, audioProvider, child) {
                  return Column(
                    children: [
                      _buildSwitchTile(
                        title: l10n.music,
                        subtitle: l10n.enableDisableMusic,
                        value: audioProvider.isMusicEnabled,
                        onChanged: (value) {
                          audioProvider.toggleMusicEnabled();
                        },
                      ),
                      if (audioProvider.isMusicEnabled)
                        _buildSliderTile(
                          title: l10n.musicVolume,
                          value: audioProvider.musicVolume,
                          onChanged: (value) {
                            audioProvider.setMusicVolume(value);
                          },
                        ),
                      const SizedBox(height: 16),
                      _buildSwitchTile(
                        title: l10n.soundEffects,
                        subtitle: l10n.enableDisableSfx,
                        value: audioProvider.isSfxEnabled,
                        onChanged: (value) {
                          audioProvider.toggleSfxEnabled();
                        },
                      ),
                      if (audioProvider.isSfxEnabled)
                        _buildSliderTile(
                          title: l10n.effectsVolume,
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
            title: l10n.game,
            icon: Icons.games,
            children: [
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return Column(
                    children: [
                      _buildSwitchTile(
                        title: l10n.animations,
                        subtitle: l10n.enableDisableAnimations,
                        value: userProvider.animationsEnabled,
                        onChanged: (value) {
                          userProvider.setAnimationsEnabled(value);
                        },
                      ),
                      _buildSwitchTile(
                        title: l10n.vibrations,
                        subtitle: l10n.enableDisableVibrations,
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
            title: l10n.account,
            icon: Icons.person,
            children: [
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return Column(
                    children: [
                      _buildInfoTile(
                        title: l10n.username,
                        subtitle: userProvider.username,
                        onTap: () =>
                            _showEditUsernameDialog(context, userProvider),
                      ),
                      _buildInfoTile(
                        title: l10n.level,
                        subtitle: '${l10n.level} ${userProvider.level}',
                      ),
                      _buildInfoTile(
                        title: l10n.experience,
                        subtitle:
                            '${userProvider.experience} / ${userProvider.level * 100} XP',
                      ),
                      _buildInfoTile(
                        title: l10n.currentStreak,
                        subtitle: '${userProvider.currentStreak} ${l10n.days}',
                      ),
                      _buildInfoTile(
                        title: l10n.bestStreak,
                        subtitle: '${userProvider.bestStreak} ${l10n.days}',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Section Thème
          _buildSection(
            title: l10n.theme,
            icon: Icons.palette,
            children: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return Column(
                    children: [
                      _buildInfoTile(
                        title: l10n.themeDescription,
                        subtitle: _getThemeName(themeProvider.themeMode, l10n),
                        onTap: () => _showThemeDialog(context, themeProvider),
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
            title: l10n.data,
            icon: Icons.storage,
            children: [
              _buildButtonTile(
                title: l10n.saveData,
                subtitle: l10n.saveProgress,
                icon: Icons.save,
                onTap: () => _saveUserData(context),
              ),
              _buildButtonTile(
                title: l10n.restoreData,
                subtitle: l10n.restoreProgress,
                icon: Icons.restore,
                onTap: () => _restoreUserData(context),
              ),
              _buildButtonTile(
                title: l10n.resetData,
                subtitle: l10n.deleteAllData,
                icon: Icons.delete_forever,
                onTap: () => _showResetDataDialog(context),
                isDestructive: true,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Section Langue
          _buildSection(
            title: l10n.language,
            icon: Icons.language,
            children: [
              Consumer<LanguageProvider>(
                builder: (context, languageProvider, child) {
                  return _buildLanguageSelector(languageProvider);
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Section À propos
          _buildSection(
            title: l10n.about,
            icon: Icons.info,
            children: [
              _buildInfoTile(
                title: l10n.version,
                subtitle: '1.0.0',
              ),
              _buildInfoTile(
                title: l10n.developer,
                subtitle: 'Mind Bloom Team',
              ),
              _buildButtonTile(
                title: l10n.termsOfService,
                subtitle: l10n.readTermsOfUse,
                icon: Icons.description,
                onTap: () => _navigateToTerms(context),
              ),
              _buildButtonTile(
                title: l10n.privacyPolicy,
                subtitle: l10n.readPrivacyPolicy,
                icon: Icons.privacy_tip,
                onTap: () => _navigateToPrivacy(context),
              ),
              _buildButtonTile(
                title: l10n.tutorial,
                subtitle: l10n.reviewTutorial,
                icon: Icons.school,
                onTap: () => _showTutorial(context),
              ),

              // 🚀 BOUTON DEBUG (supprimé pour la version de production)
              // if (kDebugMode)
              //   _buildButtonTile(
              //     title: l10n.debugUnlockAllLevels,
              //     subtitle: l10n.debugUnlockAllLevelsDescription,
              //     icon: Icons.developer_mode,
              //     onTap: () => _toggleDebugMode(context),
              //   ),
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
                        color: Theme.of(context).colorScheme.onSurface,
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
          color: isDestructive
              ? AppColors.error
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(subtitle),
      leading: Icon(
        icon,
        color: isDestructive
            ? AppColors.error
            : Theme.of(context).colorScheme.primary,
      ),
      onTap: onTap,
    );
  }

  void _showEditUsernameDialog(
      BuildContext context, UserProvider userProvider) {
    final controller = TextEditingController(text: userProvider.username);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editUsername),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.username,
            hintText: l10n.enterNewUsername,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final newUsername = controller.text.trim();
              if (newUsername.isNotEmpty) {
                userProvider.updateUsername(newUsername);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.usernameUpdated)),
                );
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showResetDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.reset_data),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer toutes vos données ? '
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
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
            child: Text(AppLocalizations.of(context)!.delete),
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

  void _navigateToTerms(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TermsOfServiceScreen(),
      ),
    );
  }

  void _navigateToPrivacy(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PrivacyPolicyScreen(),
      ),
    );
  }

  Widget _buildLanguageSelector(LanguageProvider languageProvider) {
    return Column(
      children: languageProvider.getSupportedLanguages().map((language) {
        final isSelected =
            languageProvider.currentLanguageCode == language['code'];

        return ListTile(
          title: Text(language['name']!),
          leading: Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          onTap: () {
            languageProvider.setLanguage(language['code']!);
          },
        );
      }).toList(),
    );
  }

  String _getThemeName(ThemeMode themeMode, AppLocalizations l10n) {
    switch (themeMode) {
      case ThemeMode.light:
        return l10n.lightTheme;
      case ThemeMode.dark:
        return l10n.darkTheme;
      case ThemeMode.system:
        return l10n.systemTheme;
    }
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.lightTheme),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.darkTheme),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.systemTheme),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  // Afficher le tutoriel
  void _showTutorial(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSfx('audio/sfx/button_click.wav');

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TutorialScreen(),
      ),
    );
  }

  // 🚀 MÉTHODE DEBUG (commentée pour la version de production)
  // void _toggleDebugMode(BuildContext context) {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);

  //   userProvider.toggleDebugMode();

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(userProvider.debugModeEnabled
  //           ? 'Mode debug activé - Tous les niveaux déverrouillés'
  //           : 'Mode debug désactivé'),
  //       backgroundColor:
  //           userProvider.debugModeEnabled ? Colors.green : Colors.orange,
  //     ),
  //   );
  // }
}
