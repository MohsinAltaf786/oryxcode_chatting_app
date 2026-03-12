import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

/// Full-screen image viewer with zoom and swipe capabilities
/// Features:
/// - Pinch to zoom
/// - Swipe between images
/// - Share/download toolbar
/// - Caption overlay
/// - Close button
/// - Support for both network and local images
class ImageViewerWidget extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;
  final List<String>? captions;
  final VoidCallback? onClose;
  final Function(int index)? onShare;
  final Function(int index)? onDownload;
  final Function(int index)? onDelete;
  final bool isNetworkImage;

  const ImageViewerWidget({
    super.key,
    required this.imagePaths,
    this.initialIndex = 0,
    this.captions,
    this.onClose,
    this.onShare,
    this.onDownload,
    this.onDelete,
    this.isNetworkImage = true,
  });

  @override
  State<ImageViewerWidget> createState() => _ImageViewerWidgetState();
}

class _ImageViewerWidgetState extends State<ImageViewerWidget> {
  late PageController _pageController;
  late int _currentIndex;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image gallery
          GestureDetector(
            onTap: _toggleControls,
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                // Determine if the image path is a network URL or local file
                final imagePath = widget.imagePaths[index];
                final isNetwork = widget.isNetworkImage || 
                    imagePath.startsWith('http://') || 
                    imagePath.startsWith('https://');
                
                return PhotoViewGalleryPageOptions(
                  imageProvider: isNetwork
                      ? NetworkImage(imagePath) as ImageProvider
                      : FileImage(File(imagePath)),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                  heroAttributes: PhotoViewHeroAttributes(tag: imagePath),
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 64,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          spacing(height: 16),
                          Text(
                            trans(context, key: 'failed_to_load_image'),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              itemCount: widget.imagePaths.length,
              loadingBuilder: (context, event) => Center(
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
                  color: AppColors.primary,
                ),
              ),
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              pageController: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          
          // Top bar with controls
          if (_showControls)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                padding: .only(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    // Close button
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        widget.onClose?.call();
                        Navigator.of(context).pop();
                      },
                    ),
                    
                    // Image counter
                    if (widget.imagePaths.length > 1)
                      Container(
                        padding: const .symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: .circular(16),
                        ),
                        child: Text(
                          '${_currentIndex + 1} / ${widget.imagePaths.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    
                    // More options
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      color: AppColors.darkBg,
                      onSelected: (value) {
                        switch (value) {
                          case 'share':
                            widget.onShare?.call(_currentIndex);
                            break;
                          case 'download':
                            widget.onDownload?.call(_currentIndex);
                            break;
                          case 'delete':
                            widget.onDelete?.call(_currentIndex);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'share',
                          child: Row(
                            children: [
                              Icon(TablerIcons.share, size: 20, color: Colors.white),
                              spacing(width: 12),
                              Text(trans(context, key: 'share'), style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'download',
                          child: Row(
                            children: [
                              Icon(TablerIcons.download, size: 20, color: Colors.white),
                              spacing(width: 12),
                              Text(trans(context, key: 'download'), style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(TablerIcons.trash, size: 20, color: Colors.red),
                              spacing(width: 12),
                              Text(trans(context, key: 'delete'), style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          
          // Bottom caption overlay
          if (_showControls && 
              widget.captions != null && 
              _currentIndex < widget.captions!.length &&
              widget.captions![_currentIndex].isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                padding: .only(
                  left: 16,
                  right: 16,
                  top: 24,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                ),
                child: Text(
                  widget.captions![_currentIndex],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Helper function to show image viewer
void showImageViewer({
  required BuildContext context,
  required List<String> imagePaths,
  int initialIndex = 0,
  List<String>? captions,
  Function(int index)? onShare,
  Function(int index)? onDownload,
  Function(int index)? onDelete,
  bool isNetworkImage = true,
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ImageViewerWidget(
        imagePaths: imagePaths,
        initialIndex: initialIndex,
        captions: captions,
        onShare: onShare,
        onDownload: onDownload,
        onDelete: onDelete,
        isNetworkImage: isNetworkImage,
      ),
      fullscreenDialog: true,
    ),
  );
}
