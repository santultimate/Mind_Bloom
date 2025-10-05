import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mind_bloom/utils/error_handler.dart';
import 'package:mind_bloom/utils/batch_saver.dart';

/// Provider pour les paramètres de l'application
class SettingsProvider extends ChangeNotifier {
  bool _animationsEnabled = true;
  bool _vibrationsEnabled = true;
  bool _autoHintsEnabled = false;
  bool _debugModeEnabled = false;
  bool _tutorialCompleted = false;
  int _selectedWorldId = 1;
  final Map<int, int> _worldProgress = {}; // mondeId -> dernier niveau complété

  // Getters
  bool get animationsEnabled => _animationsEnabled;
  bool get vibrationsEnabled => _vibrationsEnabled;
  bool get autoHintsEnabled => _autoHintsEnabled;
  bool get debugModeEnabled => _debugModeEnabled;
  bool get tutorialCompleted => _tutorialCompleted;
  int get selectedWorldId => _selectedWorldId;
  Map<int, int> get worldProgress => _worldProgress;

  /// Initialise les paramètres
  Future<void> initialize() async {
    try {
      // Charger depuis SharedPreferences via BatchSaver
      // Cette logique sera implémentée avec BatchSaver

      if (kDebugMode) {
        debugPrint('⚙️ [SettingsProvider] Initialisé');
      }
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace,
          context: 'SettingsProvider.initialize');
    }
  }

  /// Active/désactive les animations
  Future<void> setAnimationsEnabled(bool enabled) async {
    _animationsEnabled = enabled;
    BatchSaver.queueChange('animationsEnabled', enabled);
    notifyListeners();
  }

  /// Active/désactive les vibrations
  Future<void> setVibrationsEnabled(bool enabled) async {
    _vibrationsEnabled = enabled;
    BatchSaver.queueChange('vibrationsEnabled', enabled);
    notifyListeners();
  }

  /// Active/désactive les conseils automatiques
  Future<void> setAutoHintsEnabled(bool enabled) async {
    _autoHintsEnabled = enabled;
    BatchSaver.queueChange('autoHintsEnabled', enabled);
    notifyListeners();
  }

  /// Active/désactive le mode debug
  Future<void> setDebugModeEnabled(bool enabled) async {
    _debugModeEnabled = enabled;
    BatchSaver.queueChange('debugModeEnabled', enabled);
    notifyListeners();
  }

  /// Marque le tutoriel comme terminé
  Future<void> setTutorialCompleted(bool completed) async {
    _tutorialCompleted = completed;
    BatchSaver.queueChange('tutorialCompleted', completed);
    notifyListeners();
  }

  /// Met à jour le monde sélectionné
  Future<void> setSelectedWorld(int worldId) async {
    _selectedWorldId = worldId;
    BatchSaver.queueChange('selectedWorldId', worldId);
    notifyListeners();
  }

  /// Met à jour la progression d'un monde
  Future<void> updateWorldProgress(int worldId, int levelId) async {
    final currentProgress = _worldProgress[worldId] ?? 0;

    // Ne mettre à jour que si le nouveau niveau est supérieur
    if (levelId > currentProgress) {
      _worldProgress[worldId] = levelId;

      // Sauvegarder
      final worldProgressString =
          _worldProgress.entries.map((e) => '${e.key}:${e.value}').join(',');
      BatchSaver.queueChange('worldProgress', worldProgressString);

      notifyListeners();

      if (kDebugMode) {
        debugPrint(
            '🌍 [SettingsProvider] Monde $worldId: progression mise à jour vers le niveau $levelId');
      }
    }
  }

  /// Obtient la progression d'un monde
  int getWorldProgress(int worldId) {
    return _worldProgress[worldId] ?? 0;
  }

  /// Réinitialise tous les paramètres aux valeurs par défaut
  Future<void> resetToDefaults() async {
    _animationsEnabled = true;
    _vibrationsEnabled = true;
    _autoHintsEnabled = false;
    _debugModeEnabled = false;
    _tutorialCompleted = false;
    _selectedWorldId = 1;
    _worldProgress.clear();

    // Sauvegarder
    BatchSaver.queueChange('animationsEnabled', true);
    BatchSaver.queueChange('vibrationsEnabled', true);
    BatchSaver.queueChange('autoHintsEnabled', false);
    BatchSaver.queueChange('debugModeEnabled', false);
    BatchSaver.queueChange('tutorialCompleted', false);
    BatchSaver.queueChange('selectedWorldId', 1);
    BatchSaver.queueChange('worldProgress', '');

    notifyListeners();

    if (kDebugMode) {
      debugPrint(
          '🔄 [SettingsProvider] Paramètres réinitialisés aux valeurs par défaut');
    }
  }

  /// Exporte les paramètres pour sauvegarde/restauration
  Map<String, dynamic> exportSettings() {
    return {
      'animationsEnabled': _animationsEnabled,
      'vibrationsEnabled': _vibrationsEnabled,
      'autoHintsEnabled': _autoHintsEnabled,
      'debugModeEnabled': _debugModeEnabled,
      'tutorialCompleted': _tutorialCompleted,
      'selectedWorldId': _selectedWorldId,
      'worldProgress': Map.from(_worldProgress),
    };
  }

  /// Importe les paramètres depuis une sauvegarde
  Future<void> importSettings(Map<String, dynamic> settings) async {
    try {
      _animationsEnabled = settings['animationsEnabled'] ?? true;
      _vibrationsEnabled = settings['vibrationsEnabled'] ?? true;
      _autoHintsEnabled = settings['autoHintsEnabled'] ?? false;
      _debugModeEnabled = settings['debugModeEnabled'] ?? false;
      _tutorialCompleted = settings['tutorialCompleted'] ?? false;
      _selectedWorldId = settings['selectedWorldId'] ?? 1;

      final worldProgressData =
          settings['worldProgress'] as Map<String, dynamic>?;
      if (worldProgressData != null) {
        _worldProgress.clear();
        worldProgressData.forEach((key, value) {
          _worldProgress[int.parse(key)] = value as int;
        });
      }

      // Sauvegarder tous les paramètres
      BatchSaver.queueChange('animationsEnabled', _animationsEnabled);
      BatchSaver.queueChange('vibrationsEnabled', _vibrationsEnabled);
      BatchSaver.queueChange('autoHintsEnabled', _autoHintsEnabled);
      BatchSaver.queueChange('debugModeEnabled', _debugModeEnabled);
      BatchSaver.queueChange('tutorialCompleted', _tutorialCompleted);
      BatchSaver.queueChange('selectedWorldId', _selectedWorldId);

      final worldProgressString =
          _worldProgress.entries.map((e) => '${e.key}:${e.value}').join(',');
      BatchSaver.queueChange('worldProgress', worldProgressString);

      notifyListeners();

      if (kDebugMode) {
        debugPrint('📥 [SettingsProvider] Paramètres importés avec succès');
      }
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace,
          context: 'SettingsProvider.importSettings');
    }
  }
}
