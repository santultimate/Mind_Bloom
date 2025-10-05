import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mind_bloom/utils/error_handler.dart';

/// Système de sauvegarde par lot pour optimiser les performances
class BatchSaver {
  static final Map<String, dynamic> _pendingChanges = {};
  static Timer? _saveTimer;
  static const Duration _saveDelay = Duration(seconds: 2);
  static bool _isSaving = false;

  /// Ajoute une modification à la file d'attente
  static void queueChange(String key, dynamic value) {
    _pendingChanges[key] = value;

    // Démarrer ou redémarrer le timer
    _saveTimer?.cancel();
    _saveTimer = Timer(_saveDelay, () {
      _flushChanges();
    });

    if (kDebugMode) {
      debugPrint('📝 [BatchSaver] Changement en attente: $key = $value');
    }
  }

  /// Sauvegarde immédiatement tous les changements en attente
  static Future<void> flushNow() async {
    await _flushChanges();
  }

  /// Sauvegarde tous les changements en attente
  static Future<void> _flushChanges() async {
    if (_isSaving || _pendingChanges.isEmpty) return;

    _isSaving = true;
    final changesToSave = Map<String, dynamic>.from(_pendingChanges);
    _pendingChanges.clear();

    try {
      final prefs = await SharedPreferences.getInstance();

      for (final entry in changesToSave.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is String) {
          await prefs.setString(key, value);
        } else if (value is int) {
          await prefs.setInt(key, value);
        } else if (value is bool) {
          await prefs.setBool(key, value);
        } else if (value is double) {
          await prefs.setDouble(key, value);
        } else if (value is List<String>) {
          await prefs.setStringList(key, value);
        } else {
          await prefs.setString(key, value.toString());
        }
      }

      if (kDebugMode) {
        debugPrint(
            '💾 [BatchSaver] Sauvegardé ${changesToSave.length} changements');
      }
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace,
          context: 'BatchSaver._flushChanges');

      // Remettre les changements dans la file en cas d'erreur
      _pendingChanges.addAll(changesToSave);
    } finally {
      _isSaving = false;
    }
  }

  /// Force la sauvegarde d'une clé spécifique
  static Future<void> forceSave(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is List<String>) {
        await prefs.setStringList(key, value);
      } else {
        await prefs.setString(key, value.toString());
      }

      // Retirer de la file d'attente si présent
      _pendingChanges.remove(key);

      if (kDebugMode) {
        debugPrint('⚡ [BatchSaver] Sauvegarde forcée: $key');
      }
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace,
          context: 'BatchSaver.forceSave');
    }
  }

  /// Annule tous les changements en attente
  static void cancelPendingChanges() {
    _pendingChanges.clear();
    _saveTimer?.cancel();

    if (kDebugMode) {
      debugPrint('❌ [BatchSaver] Changements annulés');
    }
  }

  /// Obtient le nombre de changements en attente
  static int get pendingChangesCount => _pendingChanges.length;

  /// Vérifie s'il y a des changements en attente
  static bool get hasPendingChanges => _pendingChanges.isNotEmpty;
}
