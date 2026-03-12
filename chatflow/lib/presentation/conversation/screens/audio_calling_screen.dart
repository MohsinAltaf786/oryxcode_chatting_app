import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class AudioCallingScreen extends StatefulWidget {
  const AudioCallingScreen({super.key});

  @override
  State<AudioCallingScreen> createState() => _AudioCallingScreenState();
}

class _AudioCallingScreenState extends State<AudioCallingScreen>
    with SingleTickerProviderStateMixin {
  String avatar = "assets/img/avatars/avatar6.jpg";
  String userName = "Stephan Louis";
  String callDuration = "00:30";
  
  bool isMuted = false;
  bool isSpeakerOn = false;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isDark
                ? [AppColors.grey100, AppColors.darkBg]
                : [AppColors.primary.withValues(alpha: 0.05), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(child: _buildCallerInfo()),
              _buildActions(),
              spacing(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const .symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => navigateBack(context),
            icon: Icon(
              TablerIcons.chevron_down,
              color: _isDark ? AppColors.light80 : AppColors.darkText,
            ),
          ),
          const Spacer(),
          Container(
            padding: const .symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.tealGreen.withValues(alpha: 0.15),
              borderRadius: .circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
                Text(
                  'Encrypted',
                  style: TextStyle(
                    color: AppColors.tealGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              TablerIcons.users_plus,
              color: _isDark ? AppColors.light80 : AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallerInfo() {
    return Column(
      mainAxisAlignment: .center,
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                padding: const .all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
                child: Container(
                  padding: const .all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: _isDark ? AppColors.grey90 : AppColors.grey20,
                    child: ClipRRect(
                      borderRadius: .circular(100),
                      child: ImageWidget(
                        image: avatar,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        type: ImageType.asset,
                        errorWidget: Center(
                          child: Text(
                            userName[0],
                            style: StyleHelper.displaySmall(context)?.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        spacing(height: 24),
        Text(
          userName,
          style: StyleHelper.headlineSmall(context)?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        spacing(height: 8),
        Row(
          mainAxisAlignment: .center,
          children: [
            Icon(
              TablerIcons.phone,
              size: 16,
              color: AppColors.tealGreen,
            ),
            spacing(width: 6),
            Text(
              callDuration,
              style: StyleHelper.titleMedium(context)?.copyWith(
                color: _isDark ? AppColors.light60 : AppColors.greyText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Container(
      margin: const .symmetric(horizontal: 24),
      padding: const .symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: _isDark ? AppColors.grey100 : Colors.white,
        borderRadius: .circular(32),
        boxShadow: _isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: .spaceEvenly,
        children: [
          _buildActionButton(
            icon: isMuted ? TablerIcons.microphone_off : TablerIcons.microphone,
            label: isMuted ? 'Unmute' : 'Mute',
            isActive: isMuted,
            onTap: () => setState(() => isMuted = !isMuted),
          ),
          _buildActionButton(
            icon: isSpeakerOn ? TablerIcons.volume : TablerIcons.volume_off,
            label: 'Speaker',
            isActive: isSpeakerOn,
            onTap: () => setState(() => isSpeakerOn = !isSpeakerOn),
          ),
          _buildActionButton(
            icon: TablerIcons.video,
            label: 'Video',
            onTap: () {},
          ),
          _buildEndCallButton(),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : (_isDark ? AppColors.grey90 : AppColors.grey20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24,
              color: isActive
                  ? AppColors.primary
                  : (_isDark ? AppColors.light80 : AppColors.darkText),
            ),
          ),
          spacing(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: _isDark ? AppColors.light60 : AppColors.greyText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndCallButton() {
    return GestureDetector(
      onTap: () => navigateBack(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.red.shade500,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              TablerIcons.phone_off,
              size: 24,
              color: Colors.white,
            ),
          ),
          spacing(height: 8),
          Text(
            'End',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
