import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/media/image_viewer_widget.dart';
import 'package:chat_flow/presentation/conversation/widgets/audio_player_widget.dart';
import 'package:chat_flow/presentation/conversation/screens/video_player_screen.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatAttachment extends StatelessWidget {
  const ChatAttachment({super.key, this.data});

  final dynamic data;

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final bool isIncoming = data['sender'] != 'Me';
    final String type = data?['screens']['type'] ?? '';

    switch (type) {
      case 'image':
        return _buildImageAttachment(context, isIncoming);
      case 'video':
        return _buildVideoAttachment(context, isIncoming);
      case 'audio':
        return _buildAudioAttachment(context, isIncoming);
      case 'link':
        return _buildLinkAttachment(context, isIncoming);
      default:
        return const SizedBox();
    }
  }

  Widget _buildImageAttachment(BuildContext context, bool isIncoming) {
    return GestureDetector(
      onTap: () {
        showImageViewer(
          context: context,
          imagePaths: [data['screens']['src']],
          initialIndex: 0,
          isNetworkImage: true,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isIncoming ? 4 : 18),
            bottomRight: Radius.circular(isIncoming ? 18 : 4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            ImageWidget(
              image: data['screens']['src'],
              height: 220,
              width: 260,
              fit: BoxFit.cover,
              placeholder: AssetsConst.imagePlaceholder,
              type: ImageType.network,
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.2),
                    ],
                    stops: const [0.7, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  TablerIcons.arrows_maximize,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoAttachment(BuildContext context, bool isIncoming) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatVideoPlayerScreen(
              videoUrl: data['screens']['src'],
              thumbnailUrl: data['screens']['thumbnail'],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isIncoming ? 4 : 18),
            bottomRight: Radius.circular(isIncoming ? 18 : 4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Container(
              height: 220,
              width: 260,
              decoration: BoxDecoration(
                color: Colors.black,
                image: data['screens']['thumbnail'] != null
                    ? DecorationImage(
                        image: NetworkImage(data['screens']['thumbnail']),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.black.withValues(alpha: 0.2),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    TablerIcons.player_play_filled,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(TablerIcons.video, color: Colors.white, size: 14),
                    spacing(width: 4),
                    const Text(
                      'Video',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioAttachment(BuildContext context, bool isIncoming) {
    return AudioPlayerWidget(
      audioUrl: data['screens']['src'],
      isIncoming: isIncoming,
      duration: data['screens']['duration'],
    );
  }

  Widget _buildLinkAttachment(BuildContext context, bool isIncoming) {
    final Color bubbleColor = isIncoming
        ? (_isDark(context) ? AppColors.grey90 : AppColors.grey20)
        : AppColors.primary;
    final Color textColor = isIncoming
        ? (_isDark(context) ? AppColors.light80 : AppColors.darkText)
        : Colors.white;

    return GestureDetector(
      onTap: () async {
        final url = data['screens']['url'];
        if (url != null) {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      },
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isIncoming ? 4 : 18),
            bottomRight: Radius.circular(isIncoming ? 18 : 4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data['screens']['image'] != null)
              Stack(
                children: [
                  Image.network(
                    data['screens']['image'],
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        color: _isDark(context)
                            ? AppColors.grey80.withValues(alpha: 0.5)
                            : AppColors.grey30,
                        child: Center(
                          child: Icon(
                            TablerIcons.link,
                            size: 40,
                            color: _isDark(context)
                                ? AppColors.light60
                                : AppColors.greyText,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        TablerIcons.external_link,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['screens']['title'] ?? 'Link',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (data['screens']['description'] != null) ...[
                    spacing(height: 6),
                    Text(
                      data['screens']['description'],
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.7),
                        fontSize: 13,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  spacing(height: 8),
                  Row(
                    children: [
                      Icon(
                        TablerIcons.link,
                        size: 14,
                        color: textColor.withValues(alpha: 0.5),
                      ),
                      spacing(width: 6),
                      Expanded(
                        child: Text(
                          _extractDomain(data['screens']['url'] ?? ''),
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (_) {
      return url;
    }
  }
}
