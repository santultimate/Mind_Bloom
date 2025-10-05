import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mind_bloom/utils/error_handler.dart';

/// Gestionnaire de cache d'images optimisé pour Mind Bloom
class ImageCacheManager {
  static final Map<String, Uint8List> _memoryCache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const int _maxMemoryCacheSize = 50; // Nombre max d'images en mémoire
  static const Duration _cacheExpiry = Duration(hours: 24);

  /// Charge une image depuis le cache ou les assets
  static Future<Uint8List?> loadImage(String assetPath) async {
    try {
      // Vérifier le cache mémoire d'abord
      if (_memoryCache.containsKey(assetPath)) {
        if (kDebugMode) {
          debugPrint('🖼️ [ImageCache] Image trouvée en mémoire: $assetPath');
        }
        return _memoryCache[assetPath];
      }

      // Charger depuis les assets
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      // Mettre en cache
      _cacheImage(assetPath, bytes);

      if (kDebugMode) {
        debugPrint('📁 [ImageCache] Image chargée depuis assets: $assetPath');
      }

      return bytes;
    } catch (error, stackTrace) {
      ErrorHandler.handleError(error, stackTrace,
          context: 'ImageCacheManager.loadImage($assetPath)');
      return null;
    }
  }

  /// Met une image en cache
  static void _cacheImage(String assetPath, Uint8List bytes) {
    // Nettoyer le cache si nécessaire
    _cleanupCache();

    _memoryCache[assetPath] = bytes;
    _cacheTimestamps[assetPath] = DateTime.now();

    if (kDebugMode) {
      debugPrint(
          '💾 [ImageCache] Image mise en cache: $assetPath (${bytes.length} bytes)');
    }
  }

  /// Nettoie le cache (supprime les images expirées ou les plus anciennes)
  static void _cleanupCache() {
    if (_memoryCache.length < _maxMemoryCacheSize) return;

    final now = DateTime.now();
    final expiredKeys = <String>[];
    final sortedKeys = _cacheTimestamps.keys.toList()
      ..sort((a, b) => _cacheTimestamps[a]!.compareTo(_cacheTimestamps[b]!));

    // Supprimer les images expirées
    for (final key in _cacheTimestamps.keys) {
      if (now.difference(_cacheTimestamps[key]!) > _cacheExpiry) {
        expiredKeys.add(key);
      }
    }

    // Supprimer les plus anciennes si nécessaire
    final keysToRemove = <String>[];
    keysToRemove.addAll(expiredKeys);

    while (_memoryCache.length - keysToRemove.length >= _maxMemoryCacheSize) {
      keysToRemove.add(sortedKeys.removeAt(0));
    }

    // Effectuer les suppressions
    for (final key in keysToRemove) {
      _memoryCache.remove(key);
      _cacheTimestamps.remove(key);
    }

    if (kDebugMode && keysToRemove.isNotEmpty) {
      debugPrint(
          '🗑️ [ImageCache] ${keysToRemove.length} images supprimées du cache');
    }
  }

  /// Vide complètement le cache
  static void clearCache() {
    _memoryCache.clear();
    _cacheTimestamps.clear();

    if (kDebugMode) {
      debugPrint('🧹 [ImageCache] Cache vidé complètement');
    }
  }

  /// Obtient les statistiques du cache
  static Map<String, dynamic> getCacheStats() {
    int totalSize = 0;
    for (final bytes in _memoryCache.values) {
      totalSize += bytes.length;
    }

    return {
      'cachedImages': _memoryCache.length,
      'totalSize': totalSize,
      'totalSizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
      'maxCacheSize': _maxMemoryCacheSize,
    };
  }

  /// Préchauffe le cache avec les images les plus utilisées
  static Future<void> preloadCommonImages() async {
    const commonImages = [
      'assets/images/tiles/flower.png',
      'assets/images/tiles/leaf.png',
      'assets/images/tiles/crystal.png',
      'assets/images/tiles/seed.png',
      'assets/images/tiles/dew.png',
      'assets/images/tiles/sun.png',
      'assets/images/tiles/moon.png',
      'assets/images/tiles/gem.png',
      'assets/images/icone.png',
    ];

    if (kDebugMode) {
      debugPrint(
          '🚀 [ImageCache] Préchargement de ${commonImages.length} images communes');
    }

    final futures = commonImages.map((path) => loadImage(path));
    await Future.wait(futures);

    if (kDebugMode) {
      debugPrint('✅ [ImageCache] Préchargement terminé');
    }
  }

  /// Vérifie si une image est en cache
  static bool isCached(String assetPath) {
    return _memoryCache.containsKey(assetPath);
  }

  /// Obtient la taille du cache en mémoire
  static int getCacheSize() {
    return _memoryCache.length;
  }

  /// Force le nettoyage du cache
  static void forceCleanup() {
    _cleanupCache();
  }
}
