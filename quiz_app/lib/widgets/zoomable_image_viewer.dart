import 'package:flutter/material.dart';

/// Widget pour afficher une image avec zoom et pinch
/// Supporte les images locales (assets) et distantes (URLs HTTP/HTTPS)
class ZoomableImageViewer extends StatefulWidget {
  final String imageSource; // URL distante ou chemin local (assets/...)
  final String label;
  final String? description;
  final bool isRemote; // true = URL distante, false = asset local

  const ZoomableImageViewer({
    Key? key,
    required this.imageSource,
    required this.label,
    this.description,
    this.isRemote = false,
  }) : super(key: key);

  /// Créer à partir d'une source, en détectant automatiquement le type
  factory ZoomableImageViewer.auto({
    Key? key,
    required String source,
    required String label,
    String? description,
  }) {
    final isRemote = source.startsWith('http://') || source.startsWith('https://');
    return ZoomableImageViewer(
      key: key,
      imageSource: source,
      label: label,
      description: description,
      isRemote: isRemote,
    );
  }

  @override
  State<ZoomableImageViewer> createState() => _ZoomableImageViewerState();
}

class _ZoomableImageViewerState extends State<ZoomableImageViewer> {
  late TransformationController _transformationController;
  late TapDownDetails _tapDownDetails;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _tapDownDetails.localPosition;
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
    }
  }

  /// Construire le widget Image selon la source
  Widget _buildImage(BuildContext context) {
    if (widget.isRemote) {
      return Image.network(
        widget.imageSource,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[300],
            width: 300,
            height: 300,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            width: 300,
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.broken_image, size: 50),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Erreur chargement',
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        widget.imageSource,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            width: 300,
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.image_not_supported, size: 50),
                  const SizedBox(height: 12),
                  Text('Image non trouvée: ${widget.imageSource}'),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (details) {
        _tapDownDetails = details;
      },
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 0.5,
        maxScale: 4.0,
        constrained: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image (local ou remote)
                _buildImage(context),
                // Label
                if (widget.label.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      widget.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget pour afficher une galerie d'images cliquables
/// Supporte les images locales et distantes
class ImageGalleryWidget extends StatefulWidget {
  final List<Map<String, dynamic>> images; // {label, source, description?, isRemote?}
  final String title;

  const ImageGalleryWidget({
    Key? key,
    required this.images,
    this.title = 'Images',
  }) : super(key: key);

  @override
  State<ImageGalleryWidget> createState() => _ImageGalleryWidgetState();
}

class _ImageGalleryWidgetState extends State<ImageGalleryWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        // Galerie d'images
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final image = widget.images[index];
              final label = image['label'] ?? 'Image ${index + 1}';
              final source = image['source'] ?? image['asset_path'] ?? '';
              final description = image['description'];
              
              // Détecter le type de source
              final isRemote = source.startsWith('http://') || source.startsWith('https://');

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => _showImageDialog(
                    context,
                    source,
                    label,
                    description,
                    isRemote,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildThumbnail(source, isRemote),
                        ),
                        // Overlay avec label
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // Icône zoom
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.zoom_in,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Construire la miniature selon le type de source
  Widget _buildThumbnail(String source, bool isRemote) {
    if (isRemote) {
      return Image.network(
        source,
        fit: BoxFit.cover,
        width: 130,
        height: 150,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 130,
            height: 150,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.broken_image),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        source,
        fit: BoxFit.cover,
        width: 130,
        height: 150,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 130,
            height: 150,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.image_not_supported),
            ),
          );
        },
      );
    }
  }

  void _showImageDialog(
    BuildContext context,
    String source,
    String label,
    String? description,
    bool isRemote,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Titre
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Image zoomable
            Expanded(
              child: ZoomableImageViewer(
                imageSource: source,
                label: label,
                description: description,
                isRemote: isRemote,
              ),
            ),
            // Description si elle existe
            if (description != null && description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
