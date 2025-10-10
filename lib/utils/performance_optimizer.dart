import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Classe utilitaire pour optimiser les performances
class PerformanceOptimizer {
  // Cache pour les widgets coûteux
  static final Map<String, Widget> _widgetCache = {};

  // Cache pour les calculs coûteux
  static final Map<String, dynamic> _calculationCache = {};

  /// Mémorise un widget pour éviter les reconstructions
  static Widget cachedWidget(String key, Widget Function() builder) {
    if (_widgetCache.containsKey(key)) {
      return _widgetCache[key]!;
    }

    final widget = builder();
    _widgetCache[key] = widget;
    return widget;
  }

  /// Mémorise un calcul coûteux
  static T cachedCalculation<T>(String key, T Function() calculator) {
    if (_calculationCache.containsKey(key)) {
      return _calculationCache[key] as T;
    }

    final result = calculator();
    _calculationCache[key] = result;
    return result;
  }

  /// Vide le cache
  static void clearCache() {
    _widgetCache.clear();
    _calculationCache.clear();
  }

  /// Optimise les animations pour les performances
  static bool shouldUseComplexAnimations() {
    // Désactiver les animations complexes sur les appareils moins puissants
    return !kDebugMode; // En mode debug, toujours activer pour les tests
  }

  /// Détermine si on doit utiliser des animations réduites
  static bool shouldUseReducedAnimations() {
    // Logique pour détecter les appareils moins puissants
    return false; // À implémenter selon les besoins
  }
}

/// Mixin pour optimiser les StatefulWidgets
mixin PerformanceOptimized<T extends StatefulWidget> on State<T> {
  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Nettoyer le cache si nécessaire
    if (shouldClearCache(oldWidget, widget)) {
      PerformanceOptimizer.clearCache();
    }
  }

  /// Détermine si le cache doit être vidé
  bool shouldClearCache(T oldWidget, T newWidget) {
    // Logique personnalisée pour déterminer quand vider le cache
    return false;
  }
}




