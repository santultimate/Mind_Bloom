import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mind_bloom/utils/image_cache_manager.dart';

/// Widget optimisé pour afficher les images avec cache
class CachedImageWidget extends StatefulWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedImageWidget({
    Key? key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  @override
  State<CachedImageWidget> createState() => _CachedImageWidgetState();
}

class _CachedImageWidgetState extends State<CachedImageWidget> {
  Uint8List? _imageBytes;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(CachedImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final bytes = await ImageCacheManager.loadImage(widget.assetPath);

      if (mounted) {
        setState(() {
          _imageBytes = bytes;
          _isLoading = false;
          _hasError = bytes == null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.placeholder ??
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
    }

    if (_hasError || _imageBytes == null) {
      return widget.errorWidget ??
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.broken_image,
              color: Colors.grey,
            ),
          );
    }

    return Image.memory(
      _imageBytes!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit ?? BoxFit.contain,
      cacheWidth: widget.width?.toInt(),
      cacheHeight: widget.height?.toInt(),
    );
  }
}

/// Widget spécialisé pour les tuiles de jeu avec cache
class CachedTileWidget extends StatelessWidget {
  final String assetPath;
  final double size;
  final BoxFit fit;

  const CachedTileWidget({
    Key? key,
    required this.assetPath,
    this.size = 64.0,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedImageWidget(
      assetPath: assetPath,
      width: size,
      height: size,
      fit: fit,
      placeholder: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      errorWidget: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.broken_image,
          color: Colors.grey[600],
          size: size * 0.4,
        ),
      ),
    );
  }
}

/// Widget spécialisé pour les icônes d'interface avec cache
class CachedIconWidget extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color? color;

  const CachedIconWidget({
    Key? key,
    required this.assetPath,
    this.size = 24.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedImageWidget(
      assetPath: assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      placeholder: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
      errorWidget: SizedBox(
        width: size,
        height: size,
        child: Icon(
          Icons.broken_image,
          color: color ?? Colors.grey,
          size: size,
        ),
      ),
    );
  }
}
