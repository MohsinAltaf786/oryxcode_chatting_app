import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class VideoCallingScreen extends StatefulWidget {
  const VideoCallingScreen({super.key});

  @override
  State<VideoCallingScreen> createState() => _VideoCallingScreenState();
}

class _VideoCallingScreenState extends State<VideoCallingScreen> {
  bool isMuted = false;
  bool isCameraOff = false;
  bool isSpeakerOn = true;
  bool showControls = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => setState(() => showControls = !showControls),
        child: Stack(
          children: [
            _buildRemoteVideo(),
            _buildLocalVideo(),
            if (showControls) ...[
              _buildTopBar(),
              _buildCallInfo(),
              _buildBottomActions(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRemoteVideo() {
    return Positioned.fill(
      child: ImageWidget(
        image:
            'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        type: ImageType.network,
        height: double.infinity,
        width: double.infinity,
        placeholder: AssetsConst.userPlaceholder,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildLocalVideo() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 60,
      right: 16,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: .circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: .circular(14),
                child: ImageWidget(
                  image:
                      'https://images.pexels.com/photos/3030332/pexels-photo-3030332.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                  type: ImageType.network,
                  height: 160,
                  width: 110,
                  placeholder: AssetsConst.userPlaceholder,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: _buildMiniButton(
                  icon: TablerIcons.camera_rotate,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          left: 8,
          right: 8,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.6),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            _buildMiniButton(
              icon: TablerIcons.chevron_left,
              onTap: () => navigateBack(context),
            ),
            const Spacer(),
            Container(
              padding: const .symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: .circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    TablerIcons.lock,
                    size: 14,
                    color: AppColors.tealGreen,
                  ),
                  spacing(width: 4),
                  const Text(
                    'End-to-end encrypted',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            _buildMiniButton(
              icon: TablerIcons.users_plus,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallInfo() {
    return Positioned(
      bottom: 140,
      left: 20,
      child: Container(
        padding: const .symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: .circular(12),
        ),
        child: Column(
          crossAxisAlignment: .start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Stephan Louis',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            spacing(height: 4),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.tealGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                spacing(width: 6),
                const Text(
                  '00:30',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: 20,
          bottom: MediaQuery.of(context).padding.bottom + 20,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withValues(alpha: 0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: .spaceEvenly,
          children: [
            _buildActionButton(
              icon: isCameraOff ? TablerIcons.camera_off : TablerIcons.camera,
              isActive: isCameraOff,
              onTap: () => setState(() => isCameraOff = !isCameraOff),
            ),
            _buildActionButton(
              icon: isMuted ? TablerIcons.microphone_off : TablerIcons.microphone,
              isActive: isMuted,
              onTap: () => setState(() => isMuted = !isMuted),
            ),
            _buildEndCallButton(),
            _buildActionButton(
              icon: isSpeakerOn ? TablerIcons.volume : TablerIcons.volume_off,
              isActive: !isSpeakerOn,
              onTap: () => setState(() => isSpeakerOn = !isSpeakerOn),
            ),
            _buildActionButton(
              icon: TablerIcons.message,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: isActive
              ? Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2)
              : null,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildEndCallButton() {
    return GestureDetector(
      onTap: () => navigateBack(context),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.red.shade500,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          TablerIcons.phone_off,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
