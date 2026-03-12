import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/auth/login_screen.dart';
import 'package:chat_flow/presentation/settings/edit_profile_screen.dart';
import 'package:chat_flow/presentation/settings/general_screen.dart';
import 'package:chat_flow/presentation/settings/notification_screen.dart';
import 'package:chat_flow/presentation/settings/privacy_security_screen.dart';
import 'package:chat_flow/presentation/settings/storage_data_screen.dart';
import 'package:chat_flow/presentation/settings/widgets/settings_option.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:chat_flow/presentation/messaging/chat_archive/chat_archive_screen.dart';
import 'package:chat_flow/presentation/calls/calls_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String name = 'James Parker';
  String avatar =
      'https://images.pexels.com/photos/846741/pexels-photo-846741.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  String userId = '@jamesparker';

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildProfileCard()),
          SliverToBoxAdapter(child: spacing(height: 16)),
          SliverToBoxAdapter(child: _buildSettingsSections()),
          SliverToBoxAdapter(child: spacing(height: 24)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: _isDark ? AppColors.darkBg : Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          trans(context, key: 'settings'),
          style: StyleHelper.titleLarge(context)?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        titlePadding: const .only(left: 16, bottom: 16),
      ),
      actions: [
        IconButton(
          icon: Icon(
            TablerIcons.qrcode,
            color: AppColors.primary,
          ),
          onPressed: () {},
        ),
        spacing(width: 8),
      ],
    );
  }

  Widget _buildProfileCard() {
    return GestureDetector(
      onTap: () => navigateToScreen(context, const EditProfileScreen()),
      child: Container(
        margin: const .symmetric(horizontal: 16),
        padding: const .all(16),
        decoration: BoxDecoration(
          color: _isDark ? AppColors.grey100 : Colors.white,
          borderRadius: .circular(16),
          boxShadow: _isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Hero(
              tag: 'avatar-hero',
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 32,
                  child: ClipRRect(
                    borderRadius: .circular(100),
                    child: ImageWidget(
                      image: avatar,
                      type: ImageType.network,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: AssetsConst.userPlaceholder,
                      errorWidget: Center(
                        child: Text(name[0], style: StyleHelper.titleLarge(context)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            spacing(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    name,
                    style: StyleHelper.titleMedium(context)?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  spacing(height: 4),
                  Text(
                    userId,
                    style: StyleHelper.bodySmall(context)?.copyWith(
                      color: _isDark ? AppColors.light60 : AppColors.greyText,
                    ),
                  ),
                ],
              ),
            ),
            Hero(
              tag: 'avatar-hero-action',
              child: Container(
                padding: const .all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: .circular(10),
                ),
                child: Icon(
                  TablerIcons.edit,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSections() {
    return Padding(
      padding: const .symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _buildSectionCard(
            children: [
              SettingsOption(
                icon: TablerIcons.users,
                title: trans(context, key: 'invite_a_friend'),
                onTap: () {},
              ),
            ],
          ),
          spacing(height: 12),
          _buildSectionCard(
            children: [
              SettingsOption(
                icon: TablerIcons.bell,
                title: trans(context, key: 'notifications'),
                onTap: () => navigateToScreen(context, const NotificationScreen()),
              ),
              _optionsDivider(),
              SettingsOption(
                icon: TablerIcons.adjustments,
                title: trans(context, key: 'general_settings'),
                onTap: () => navigateToScreen(context, const GeneralSettings()),
              ),
              _optionsDivider(),
              SettingsOption(
                icon: TablerIcons.shield,
                title: trans(context, key: 'privacy_security'),
                onTap: () => navigateToScreen(context, const PrivacySecurityScreen()),
              ),
              _optionsDivider(),
              SettingsOption(
                icon: TablerIcons.database,
                title: trans(context, key: 'storage_and_data'),
                onTap: () => navigateToScreen(context, const StorageDataScreen()),
              ),
            ],
          ),
          spacing(height: 12),
          _buildSectionCard(
            children: [
              SettingsOption(
                icon: TablerIcons.phone,
                title: trans(context, key: 'calls'),
                onTap: () => navigateToScreen(context, const CallsScreen()),
              ),
              _optionsDivider(),
              SettingsOption(
                icon: TablerIcons.archive,
                title: trans(context, key: 'archived_chats'),
                onTap: () => navigateToScreen(context, const ChatArchiveScreen()),
              ),
            ],
          ),
          spacing(height: 12),
          _buildSectionCard(
            children: [
              SettingsOption(
                icon: TablerIcons.question_mark,
                title: trans(context, key: 'help_and_support'),
                onTap: () {},
              ),
            ],
          ),
          spacing(height: 12),
          _buildSectionCard(
            children: [
              SettingsOption(
                icon: TablerIcons.logout,
                title: trans(context, key: 'logout'),
                onTap: () => navigateToScreen(
                  context,
                  const LoginScreen(),
                  clearPreviousRoutes: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: _isDark ? AppColors.grey100 : Colors.white,
        borderRadius: .circular(16),
        boxShadow: _isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(children: children),
    );
  }

  Widget _optionsDivider() {
    return Divider(
      color: _isDark ? AppColors.grey90 : AppColors.grey30,
      height: 1,
      indent: 56,
    );
  }
}
