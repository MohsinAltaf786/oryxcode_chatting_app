import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

/// Document preview widget for viewing various file types
/// Supports: PDF, Images, and placeholder for other documents
class DocumentPreviewWidget extends StatefulWidget {
  final String filePath;
  final String? fileName;
  final VoidCallback? onShare;
  final VoidCallback? onDownload;
  final VoidCallback? onDelete;

  const DocumentPreviewWidget({
    super.key,
    required this.filePath,
    this.fileName,
    this.onShare,
    this.onDownload,
    this.onDelete,
  });

  @override
  State<DocumentPreviewWidget> createState() => _DocumentPreviewWidgetState();
}

class _DocumentPreviewWidgetState extends State<DocumentPreviewWidget> {
  final PdfViewerController _pdfController = PdfViewerController();
  int _currentPage = 1;
  int _totalPages = 0;
  bool _showControls = true;

  String get _fileExtension {
    return widget.filePath.split('.').last.toUpperCase();
  }

  bool get _isPdf => _fileExtension == 'PDF';

  @override
  void dispose() {
    _pdfController.dispose();
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
      backgroundColor: _isPdf ? Colors.grey[300] : Colors.white,
      body: Stack(
        children: [
          // Document viewer
          GestureDetector(
            onTap: _toggleControls,
            child: _isPdf ? _buildPdfViewer() : _buildGenericDocument(),
          ),
          
          // Top app bar
          if (_showControls)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopBar(context),
            ),
          
          // PDF controls
          if (_isPdf && _showControls)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildPdfControls(),
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
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
        left: 8,
        right: 8,
        bottom: 16,
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          
          // File name
          Expanded(
            child: Text(
              widget.fileName ?? widget.filePath.split('/').last,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Actions
          if (widget.onShare != null)
            IconButton(
              icon: const Icon(TablerIcons.share, color: Colors.white),
              onPressed: widget.onShare,
            ),
          if (widget.onDownload != null)
            IconButton(
              icon: const Icon(TablerIcons.download, color: Colors.white),
              onPressed: widget.onDownload,
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: AppColors.darkBg,
            onSelected: (value) {
              if (value == 'delete' && widget.onDelete != null) {
                widget.onDelete!();
              }
            },
            itemBuilder: (context) => [
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
    );
  }

  Widget _buildPdfViewer() {
    return SfPdfViewer.file(
      File(widget.filePath),
      controller: _pdfController,
      onDocumentLoaded: (details) {
        setState(() {
          _totalPages = details.document.pages.count;
        });
      },
      onPageChanged: (details) {
        setState(() {
          _currentPage = details.newPageNumber;
        });
      },
      onDocumentLoadFailed: (details) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(trans(context, key: 'failed_to_load_pdf').replaceFirst('{error}', details.error)),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  Widget _buildPdfControls() {
    return Container(
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
      padding: .only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          // Previous page
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
            onPressed: _currentPage > 1
                ? () {
                    _pdfController.previousPage();
                  }
                : null,
          ),
          
          // Page indicator
          Container(
            padding: const .symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: .circular(20),
            ),
            child: Text(
              trans(context, key: 'page_indicator')
                  .replaceFirst('{current}', _currentPage.toString())
                  .replaceFirst('{total}', _totalPages.toString()),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Next page
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white, size: 32),
            onPressed: _currentPage < _totalPages
                ? () {
                    _pdfController.nextPage();
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildGenericDocument() {
    final fileName = widget.fileName ?? widget.filePath.split('/').last;
    
    return Center(
      child: Container(
        margin: const .all(32),
        padding: const .all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: .circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // File icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _getFileColor(_fileExtension),
                borderRadius: .circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(
                      _getFileIcon(_fileExtension),
                      size: 48,
                      color: Colors.white,
                    ),
                    spacing(height: 8),
                    Text(
                      _fileExtension,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            spacing(height: 24),
            
            // File name
            Text(
              fileName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            
            spacing(height: 12),
            
            // File size
            Text(
              _getFileSize(),
              style: TextStyle(
                fontSize: 14,
                color: AppColors.greyText,
              ),
            ),
            
            spacing(height: 32),
            
            // Actions
            Row(
              mainAxisAlignment: .center,
              children: [
                if (widget.onDownload != null)
                  ElevatedButton.icon(
                    onPressed: widget.onDownload,
                    icon: const Icon(TablerIcons.download),
                    label: Text(trans(context, key: 'download')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const .symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                if (widget.onShare != null) ...[
                  spacing(width: 16),
                  OutlinedButton.icon(
                    onPressed: widget.onShare,
                    icon: const Icon(TablerIcons.share),
                    label: Text(trans(context, key: 'share')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      padding: const .symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
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
      case 'TXT':
        return Colors.grey;
      default:
        return AppColors.greyText;
    }
  }

  IconData _getFileIcon(String extension) {
    switch (extension) {
      case 'PDF':
        return TablerIcons.file_type_pdf;
      case 'DOC':
      case 'DOCX':
        return TablerIcons.file_type_doc;
      case 'XLS':
      case 'XLSX':
        return TablerIcons.file_type_xls;
      case 'PPT':
      case 'PPTX':
        return TablerIcons.file_type_ppt;
      case 'ZIP':
      case 'RAR':
        return TablerIcons.file_zip;
      case 'TXT':
        return TablerIcons.file_text;
      default:
        return TablerIcons.file;
    }
  }

  String _getFileSize() {
    try {
      final file = File(widget.filePath);
      final bytes = file.lengthSync();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } catch (e) {
      return trans(context, key: 'unknown_size');
    }
  }
}

/// Helper function to show document preview
void showDocumentPreview({
  required BuildContext context,
  required String filePath,
  String? fileName,
  VoidCallback? onShare,
  VoidCallback? onDownload,
  VoidCallback? onDelete,
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => DocumentPreviewWidget(
        filePath: filePath,
        fileName: fileName,
        onShare: onShare,
        onDownload: onDownload,
        onDelete: onDelete,
      ),
      fullscreenDialog: true,
    ),
  );
}
