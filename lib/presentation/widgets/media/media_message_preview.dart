import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';

/// Media type enum
enum MediaType { image, video, document, audio }

/// Media message preview widget for displaying media in chat bubbles
/// Supports: Images, Videos, Documents, Audio
class MediaMessagePreview extends StatefulWidget {
  final String mediaPath;
  final MediaType mediaType;
  final String? caption;
  final bool isSender;
  final VoidCallback? onTap;
  final VoidCallback? onDownload;
  final double? width;
  final double? height;
  final bool showPlayButton;

  const MediaMessagePreview({
    super.key,
    required this.mediaPath,
    required this.mediaType,
    this.caption,
    this.isSender = false,
    this.onTap,
    this.onDownload,
    this.width,
    this.height,
    this.showPlayButton = true,
  });

  @override
  State<MediaMessagePreview> createState() => _MediaMessagePreviewState();
}

class _MediaMessagePreviewState extends State<MediaMessagePreview> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == MediaType.video) {
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.file(File(widget.mediaPath));
    await _videoController!.initialize();
    setState(() {
      _isVideoInitialized = true;
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.mediaType) {
      case MediaType.image:
        return _buildImagePreview();
      case MediaType.video:
        return _buildVideoPreview();
      case MediaType.document:
        return _buildDocumentPreview();
      case MediaType.audio:
        return _buildAudioPreview();
    }
  }

  Widget _buildImagePreview() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width ?? 250,
        height: widget.height ?? 250,
        decoration: BoxDecoration(
          borderRadius: .circular(12),
          color: AppColors.light60,
        ),
        child: ClipRRect(
          borderRadius: .circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              Image.file(
                File(widget.mediaPath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 48,
                      color: AppColors.greyText.withValues(alpha: 0.5),
                    ),
                  );
                },
              ),
              
              // Caption overlay
              if (widget.caption != null && widget.caption!.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const .all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    child: Text(
                      widget.caption!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPreview() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width ?? 250,
        height: widget.height ?? 250,
        decoration: BoxDecoration(
          borderRadius: .circular(12),
          color: Colors.black,
        ),
        child: ClipRRect(
          borderRadius: .circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Video thumbnail
              if (_isVideoInitialized && _videoController != null)
                VideoPlayer(_videoController!)
              else
                Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              
              // Play button overlay
              if (widget.showPlayButton)
                Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              
              // Duration badge
              if (_videoController != null && _isVideoInitialized)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const .symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: .circular(4),
                    ),
                    child: Text(
                      _formatDuration(_videoController!.value.duration),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              
              // Caption overlay
              if (widget.caption != null && widget.caption!.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const .all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    child: Text(
                      widget.caption!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentPreview() {
    final fileName = widget.mediaPath.split('/').last;
    final fileExtension = fileName.split('.').last.toUpperCase();
    
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const .all(12),
        decoration: BoxDecoration(
          color: widget.isSender 
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.light60,
          borderRadius: .circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // File icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getFileColor(fileExtension),
                borderRadius: .circular(8),
              ),
              child: Center(
                child: Text(
                  fileExtension,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            spacing(width: 12),
            
            // File info
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    fileName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  spacing(height: 4),
                  Text(
                    _getFileSize(),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.greyText,
                    ),
                  ),
                ],
              ),
            ),
            
            spacing(width: 8),
            
            // Download button
            if (widget.onDownload != null)
              IconButton(
                icon: Icon(
                  Icons.download,
                  color: widget.isSender ? AppColors.primary : AppColors.greyText,
                ),
                onPressed: widget.onDownload,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPreview() {
    return Container(
      padding: const .all(12),
      decoration: BoxDecoration(
        color: widget.isSender 
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.light60,
        borderRadius: .circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Audio icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.isSender ? AppColors.primary : AppColors.greyText,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.audiotrack,
              color: Colors.white,
              size: 20,
            ),
          ),
          
          spacing(width: 12),
          
          // Audio info
          Column(
            crossAxisAlignment: .start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                trans(context, key: 'audio_message'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkText,
                ),
              ),
              spacing(height: 4),
              Text(
                '0:00',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.greyText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getFileColor(String extension) {
    switch (extension) {
      case 'PDF':
        return Colors.red;
      case 'DOC':
      case 'DOCX':
        return Colors.blue;
      case 'XLS':
      case 'XLSX':
        return Colors.green;
      case 'PPT':
      case 'PPTX':
        return Colors.orange;
      case 'ZIP':
      case 'RAR':
        return Colors.purple;
      default:
        return AppColors.greyText;
    }
  }

  String _getFileSize() {
    try {
      final file = File(widget.mediaPath);
      final bytes = file.lengthSync();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } catch (e) {
      return trans(context, key: 'unknown');
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
