import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Gestionnaire d'erreurs centralisé pour Mind Bloom
class ErrorHandler {
  static void handleError(dynamic error, StackTrace? stackTrace,
      {String? context, bool showToUser = false, BuildContext? userContext}) {
    if (kDebugMode) {
      debugPrint('🚨 === ERREUR ===');
      if (context != null) {
        debugPrint('📍 Contexte: $context');
      }
      debugPrint('❌ Erreur: $error');
      if (stackTrace != null) {
        debugPrint('📚 Stack trace: $stackTrace');
      }
      debugPrint('=================');
    } else {
      // En production, envoyer à un service de crash reporting
      // FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }

    // Afficher à l'utilisateur si demandé
    if (showToUser && userContext != null) {
      showUserError(userContext, _getUserFriendlyMessage(error));
    }
  }

  /// Convertit une erreur technique en message user-friendly
  static String _getUserFriendlyMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Problème de connexion. Vérifiez votre réseau.';
    } else if (errorString.contains('timeout')) {
      return 'Délai d\'attente dépassé. Réessayez.';
    } else if (errorString.contains('permission')) {
      return 'Permission refusée. Vérifiez les paramètres.';
    } else if (errorString.contains('not found')) {
      return 'Ressource introuvable.';
    } else {
      return 'Une erreur inattendue s\'est produite.';
    }
  }

  static void handleAsyncError(dynamic error, StackTrace stackTrace) {
    handleError(error, stackTrace, context: 'Async operation');
  }

  /// Affiche une erreur à l'utilisateur de manière user-friendly
  static void showUserError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Wrapper pour les opérations async qui peuvent échouer
  static Future<T?> safeAsync<T>(Future<T> Function() operation,
      {String? context}) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      handleError(error, stackTrace, context: context);
      return null;
    }
  }

  /// Wrapper pour les opérations sync qui peuvent échouer
  static T? safeSync<T>(T Function() operation, {String? context}) {
    try {
      return operation();
    } catch (error, stackTrace) {
      handleError(error, stackTrace, context: context);
      return null;
    }
  }
}
