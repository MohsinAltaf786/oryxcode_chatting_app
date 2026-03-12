import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key, this.data});

  final dynamic data;

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final hasUnread = data['unread_messages'] != 0;

    return Container(
      padding: const .symmetric(vertical: 12, horizontal: 4),
      child: Row(
        children: [
          _buildAvatar(context),
          spacing(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    Expanded(child: _buildName(context, hasUnread)),
                    spacing(width: 8),
                    _buildTime(context, hasUnread),
                  ],
                ),
                spacing(height: 6),
                Row(
                  children: [
                    Expanded(child: _buildLastMessage(context)),
                    spacing(width: 8),
                    _buildTrailing(context, hasUnread),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    if (data['type'] == 'group') {
      return Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: _isDark(context) ? AppColors.grey90 : AppColors.grey20,
          borderRadius: .circular(16),
        ),
        child: ClipRRect(
          borderRadius: .circular(16),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            spacing: 1,
            runSpacing: 1,
            children: [
              for (var i = 0; i < (data['users'] as List).take(4).length; i++)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: ClipRRect(
                    borderRadius: .circular(6),
                    child: ImageWidget(
                      image: data['users'][i]['avatar'],
                      type: ImageType.asset,
                      fit: BoxFit.cover,
                      placeholder: AssetsConst.userPlaceholder,
                      errorWidget: Container(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        child: Center(
                          child: Text(
                            '${data['users'][i]['name'][0]}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _isDark(context) ? AppColors.grey80 : AppColors.grey30,
          width: 1,
        ),
      ),
      child: CircleAvatar(
        radius: 26,
        backgroundColor: _isDark(context) ? AppColors.grey90 : AppColors.grey20,
        child: ClipRRect(
          borderRadius: .circular(100),
          child: ImageWidget(
            image: '${data['user']['avatar']}',
            type: ImageType.asset,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: AssetsConst.userPlaceholder,
            errorWidget: Center(
              child: Text(
                '${data['user']['name'][0]}',
                style: StyleHelper.titleLarge(context)?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildName(BuildContext context, bool hasUnread) {
    final name = data['user'] != null
        ? '${data['user']['name']}'
        : '${data['group_name']}';

    return Text(
      name,
      style: StyleHelper.titleMedium(context)?.copyWith(
        fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w500,
        fontSize: 16,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTime(BuildContext context, bool hasUnread) {
    return Text(
      '${data['time']}',
      style: StyleHelper.bodySmall(context)?.copyWith(
        color: hasUnread
            ? AppColors.primary
            : (_isDark(context) ? AppColors.light60 : AppColors.greyText),
        fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
        fontSize: 12,
      ),
    );
  }

  Widget _buildLastMessage(BuildContext context) {
    return Text(
      '${data['last_message']}',
      style: StyleHelper.bodySmall(context)?.copyWith(
        color: _isDark(context) ? AppColors.light60 : AppColors.greyText,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTrailing(BuildContext context, bool hasUnread) {
    if (hasUnread) {
      return Container(
        padding: const .symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: .circular(12),
        ),
        child: Text(
          data['unread_messages'].toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    
    return Icon(
      TablerIcons.checks,
      color: AppColors.primary,
      size: 18,
    );
  }
}
