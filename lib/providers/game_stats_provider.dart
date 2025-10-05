import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mind_bloom/utils/error_handler.dart';
import 'package:mind_bloom/utils/batch_saver.dart';

/// Provider pour les statistiques de jeu
class GameStatsProvider extends ChangeNotifier {
  List<int> _completedLevels = [];
  final Map<int, int> _levelStars = {}; // levelId -> stars (0-3)
  int _bestScore = 0;
  int _bestCombo = 0;
  int _totalScore = 0;
  int _perfectLevels = 0; // Niveaux avec 3 étoiles
  int _shareCount = 0;

  // Getters
  List<int> get completedLevels => _completedLevels;
  int get levelsCompleted => _completedLevels.length;
  Map<int, int> get levelStars => _levelStars;
  int get bestScore => _bestScore;
  int get bestCombo => _bestCombo;
  int get totalScore => _totalScore;
  int get perfectLevels => _perfectLevels;
  int get shareCount => _shareCount;

  /// Initialise les statistiques
  Future<void> initialize() async {
    try {
      // Charger depuis SharedPreferences via BatchSaver
      // Cette logique sera implémentée avec BatchSaver

      if (kDebugMode) {
        debugPrint(
            '📊 [GameStatsProvider] Initialisé avec ${_completedLevels.length} niveaux complétés');
      }
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace,
          context: 'GameStatsProvider.initialize');
    }
  }

  /// Complète un niveau
  Future<void> completeLevel(int levelId, int stars, int score) async {
    if (!_completedLevels.contains(levelId)) {
      _completedLevels.add(levelId);

      // Mettre à jour le score total
      _totalScore += score;

      // Mettre à jour le meilleur score
      if (score > _bestScore) {
        _bestScore = score;
      }

      // Mettre à jour les niveaux parfaits
      if (stars == 3) {
        _perfectLevels++;
      }

      if (kDebugMode) {
        debugPrint(
            '🎯 [GameStatsProvider] Niveau $levelId complété avec $stars étoiles');
      }
    } else {
      // Niveau déjà complété, mettre à jour seulement les étoiles si meilleur
      if (stars > (_levelStars[levelId] ?? 0)) {
        if (kDebugMode) {
          debugPrint(
              '⭐ [GameStatsProvider] Mise à jour des étoiles pour le niveau $levelId: $stars');
        }
      }
    }

    // Toujours mettre à jour les étoiles
    _levelStars[levelId] = stars;

    // Sauvegarder
    BatchSaver.queueChange('completedLevels', _completedLevels.join(','));
    BatchSaver.queueChange('bestScore', _bestScore);
    BatchSaver.queueChange('totalScore', _totalScore);
    BatchSaver.queueChange('perfectLevels', _perfectLevels);

    final levelStarsString =
        _levelStars.entries.map((e) => '${e.key}:${e.value}').join(',');
    BatchSaver.queueChange('levelStars', levelStarsString);

    notifyListeners();
  }

  /// Met à jour le meilleur combo
  Future<void> updateBestCombo(int combo) async {
    if (combo > _bestCombo) {
      _bestCombo = combo;
      BatchSaver.queueChange('bestCombo', _bestCombo);
      notifyListeners();
    }
  }

  /// Incrémente le compteur de partages
  Future<void> incrementShareCount() async {
    _shareCount++;
    BatchSaver.queueChange('shareCount', _shareCount);
    notifyListeners();
  }

  /// Vérifie si un niveau est complété
  bool isLevelCompleted(int levelId) {
    return _completedLevels.contains(levelId);
  }

  /// Obtient les étoiles d'un niveau
  int getLevelStars(int levelId) {
    return _levelStars[levelId] ?? 0;
  }

  /// Déverrouille un niveau manuellement (pour debug)
  Future<void> unlockLevel(int levelId) async {
    if (!_completedLevels.contains(levelId)) {
      _completedLevels.add(levelId);
      _levelStars[levelId] = 0;

      BatchSaver.queueChange('completedLevels', _completedLevels.join(','));
      final levelStarsString =
          _levelStars.entries.map((e) => '${e.key}:${e.value}').join(',');
      BatchSaver.queueChange('levelStars', levelStarsString);

      notifyListeners();

      if (kDebugMode) {
        debugPrint(
            '🔓 [GameStatsProvider] Niveau $levelId déverrouillé manuellement');
      }
    }
  }

  /// Réinitialise toutes les statistiques
  Future<void> resetAllStats() async {
    _completedLevels.clear();
    _levelStars.clear();
    _bestScore = 0;
    _bestCombo = 0;
    _totalScore = 0;
    _perfectLevels = 0;
    _shareCount = 0;

    // Sauvegarder
    BatchSaver.queueChange('completedLevels', '');
    BatchSaver.queueChange('levelStars', '');
    BatchSaver.queueChange('bestScore', 0);
    BatchSaver.queueChange('bestCombo', 0);
    BatchSaver.queueChange('totalScore', 0);
    BatchSaver.queueChange('perfectLevels', 0);
    BatchSaver.queueChange('shareCount', 0);

    notifyListeners();

    if (kDebugMode) {
      debugPrint(
          '🔄 [GameStatsProvider] Toutes les statistiques ont été réinitialisées');
    }
  }

  /// Obtient les statistiques de progression
  Map<String, dynamic> getProgressStats() {
    return {
      'levelsCompleted': _completedLevels.length,
      'perfectLevels': _perfectLevels,
      'bestScore': _bestScore,
      'bestCombo': _bestCombo,
      'totalScore': _totalScore,
      'shareCount': _shareCount,
      'averageStars': _levelStars.isNotEmpty
          ? _levelStars.values.reduce((a, b) => a + b) / _levelStars.length
          : 0.0,
    };
  }
}
