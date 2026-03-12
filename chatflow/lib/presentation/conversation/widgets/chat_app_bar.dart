import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/contacts/contact_info_screen.dart';
import 'package:chat_flow/presentation/contacts/group_info_screen.dart';
import 'package:chat_flow/presentation/conversation/screens/audio_calling_screen.dart';
import 'package:chat_flow/presentation/conversation/screens/video_calling_screen.dart';
import 'package:chat_flow/presentation/conversation/widgets/block_user.dart';
import 'package:chat_flow/presentation/conversation/widgets/clear_chat.dart';
import 'package:chat_flow/presentation/conversation/widgets/exit_group.dart';
import 'package:chat_flow/presentation/conversation/widgets/mute_notifications.dart';
import 'package:chat_flow/presentation/conversation/widgets/report_user.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key, this.data});

  final dynamic data;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => navigateBack(context),
          icon: Icon(
            TablerIcons.arrow_left,
            color: _isDark(context) ? AppColors.light80 : AppColors.darkText,
          ),
        ),
        title: _buildAppBar(context),
        actions: _buildActions(context),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      if (data?['type'] != 'group') ...[
        _buildActionButton(
          context,
          icon: TablerIcons.phone,
          onTap: () => navigateToScreen(context, const AudioCallingScreen()),
        ),
        _buildActionButton(
          context,
          icon: TablerIcons.video,
          onTap: () => navigateToScreen(context, const VideoCallingScreen()),
        ),
      ],
      _buildPopupMenuButton(context),
    ];
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          color: _isDark(context)
              ? AppColors.grey90
              : AppColors.primary.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: _isDark(context) ? AppColors.light80 : AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    if (data?['type'] == 'group') {
      return GestureDetector(
        onTap: () => navigateToScreen(context, const GroupInfoScreen()),
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            _buildGroupAvatars(context),
            spacing(width: 12),
            Expanded(child: _buildGroupInfo(context)),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => openInfoScreen(context),
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            _buildProfileImage(context),
            spacing(width: 12),
            Expanded(child: _buildUserInfo(context)),
          ],
        ),
      );
    }
  }

  Widget _buildProfileImage(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.tealGreen.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 19,
        backgroundColor: _isDark(context) ? AppColors.grey90 : AppColors.grey20,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: ImageWidget(
            image: data?['user']?['avatar'],
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            type: ImageType.asset,
            placeholder: AssetsConst.userPlaceholder,
            errorWidget: Center(
              child: Text(
                '${data['user']['name'][0]}',
                style: StyleHelper.titleMedium(context)?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupAvatars(BuildContext context) {
    final List users = data['users'] ?? [];
    final displayUsers = users.take(4).toList();
    
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        children: [
          for (int i = 0; i < displayUsers.length && i < 4; i++)
            Positioned(
              left: (i % 2) * 18.0,
              top: (i ~/ 2) * 18.0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 11,
                  backgroundColor: _isDark(context) ? AppColors.grey90 : AppColors.grey20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: ImageWidget(
                      image: displayUsers[i]['avatar'],
                      type: ImageType.asset,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      placeholder: AssetsConst.userPlaceholder,
                      errorWidget: Center(
                        child: Text(
                          '${displayUsers[i]['name'][0]}',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          data?['user']['name'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: StyleHelper.titleMedium(context)?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        spacing(height: 2),
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
            Text(
              trans(context, key: 'online'),
              style: const TextStyle(
                color: AppColors.tealGreen,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGroupInfo(BuildContext context) {
    var names =
        data?['users']?.map<String>((e) => e['name'] as String).toList() ?? [];
    var namesString = names.join(', ');
    final memberCount = names.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          data?['group_name'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: StyleHelper.titleMedium(context)?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        spacing(height: 2),
        Text(
          '$memberCount members',
          style: TextStyle(
            color: _isDark(context) ? AppColors.light60 : AppColors.greyText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (int item) {
        if (item == 1) {
          openMuteNotification(context);
        } else if (item == 2) {
          // TODO:: Implement search logic
        } else if (item == 3) {
          clearChat(context);
        } else if (item == 4) {
          exitGroup(context);
        } else if (item == 5) {
          openBlockUser(context);
        } else if (item == 6) {
          openReportUser(context);
        }
      },
      icon: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: _isDark(context) ? AppColors.grey90 : AppColors.grey20,
          shape: BoxShape.circle,
        ),
        child: Icon(
          TablerIcons.dots_vertical,
          size: 20,
          color: _isDark(context) ? AppColors.light80 : AppColors.darkText,
        ),
      ),
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: _isDark(context) ? AppColors.grey100 : Colors.white,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      itemBuilder: (BuildContext context) => [
        _buildMenuItem(context,
            value: 1,
            icon: TablerIcons.volume_off,
            title: trans(context, key: 'mute_notifications')),
        _buildMenuItem(
          context,
          value: 2,
          icon: TablerIcons.search,
          title: trans(context, key: 'search'),
        ),
        _buildMenuItem(
          context,
          value: 3,
          icon: TablerIcons.clear_all,
          title: trans(context, key: 'clear_chat'),
        ),
        if (data?['type'] == 'group')
          _buildMenuItem(
            context,
            value: 4,
            icon: TablerIcons.door_exit,
            title: trans(context, key: 'exit_group'),
          )
        else
          _buildMenuItem(
            context,
            value: 5,
            icon: TablerIcons.ban,
            title: trans(context, key: 'block'),
            isDestructive: true,
          ),
        _buildMenuItem(
          context,
          value: 6,
          icon: TablerIcons.thumb_down,
          title: trans(context, key: 'report'),
          isDestructive: true,
        ),
      ],
    );
  }

  PopupMenuItem<int> _buildMenuItem(
    BuildContext context, {
    required int value,
    required IconData icon,
    required String title,
    bool isDestructive = false,
  }) {
    final Color iconColor = isDestructive
        ? Colors.red
        : (_isDark(context) ? AppColors.light60 : AppColors.greyText);
    final Color textColor = isDestructive
        ? Colors.red
        : (_isDark(context) ? AppColors.light80 : AppColors.darkText);

    return PopupMenuItem<int>(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDestructive
                  ? Colors.red.withValues(alpha: 0.1)
                  : (_isDark(context) ? AppColors.grey90 : AppColors.grey20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          spacing(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openMuteNotification(BuildContext context) {
    showDialog(
        context: context, builder: (context) => const MuteNotifications());
  }

  void openBlockUser(BuildContext context) {
    showDialog(context: context, builder: (context) => const BlockUser());
  }

  void clearChat(BuildContext context) {
    showDialog(context: context, builder: (context) => const ClearChat());
  }

  void openReportUser(BuildContext context) {
    showDialog(context: context, builder: (context) => const ReportUser());
  }

  void exitGroup(BuildContext context) {
    showDialog(context: context, builder: (context) => const ExitGroup());
  }

  void openInfoScreen(BuildContext context) {
    navigateToScreen(context, const ContactInfoScreen());
  }
}
