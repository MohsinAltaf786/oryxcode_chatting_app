import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/settings/dialogs/privacy_option_dialog.dart';
import 'package:chat_flow/presentation/settings/security_screens/blocked_users_screen.dart';
import 'package:chat_flow/presentation/settings/security_screens/login_devices_screen.dart';
import 'package:chat_flow/presentation/settings/security_screens/set_passcode_screen.dart';
import 'package:chat_flow/presentation/settings/security_screens/two_step_auth_screen.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, key: 'privacy_security')),
      ),
      body: ListView(
        padding: const .symmetric(horizontal: 20, vertical: 10),
        children: [
          Text(trans(context, key: 'security'),
              style: StyleHelper.titleSmall(context)),
          spacing(height: 5),
          tileWidget(
              title: 'two_step_authentication',
              icon: TablerIcons.key,
              onTap: () {
                navigateToScreen(context, const TwoStepAuthScreen());
              }),
          tileWidget(
              title: 'passcode_lock',
              icon: TablerIcons.lock,
              onTap: () {
                navigateToScreen(context, const SetPasscodeScreen());
              }),
          tileWidget(
              title: 'blocked_users',
              icon: TablerIcons.ban,
              onTap: () {
                navigateToScreen(context, const BlockedUsersScreen());
              }),
          tileWidget(
              title: 'login_devices',
              icon: TablerIcons.devices,
              onTap: () {
                navigateToScreen(context, const LoginDevicesScreen());
              }),
          spacing(height: 5),
          const Divider(),
          spacing(height: 10),
          Text(trans(context, key: 'privacy'),
              style: StyleHelper.titleSmall(context)),
          spacing(height: 5),
          tileWidget(
              title: 'online_status',
              subText: 'everyone',
              onTap: () {
                privacyOptionDialog(title: 'online_status');
              }),
          tileWidget(
              title: 'phone_number',
              subText: 'my_contacts',
              onTap: () {
                privacyOptionDialog(title: 'phone_number');
              }),
          tileWidget(
              title: 'profile_photo',
              subText: 'my_contacts',
              onTap: () {
                privacyOptionDialog(title: 'profile_photo');
              }),
          tileWidget(
              title: 'messages',
              subText: 'everyone',
              onTap: () {
                privacyOptionDialog(title: 'messages');
              }),
          tileWidget(
              title: 'calls',
              subText: 'my_contacts',
              onTap: () {
                privacyOptionDialog(title: 'calls');
              }),
          tileWidget(
              title: 'voice_messages',
              subText: 'my_contacts',
              onTap: () {
                privacyOptionDialog(title: 'voice_messages');
              }),
        ],
      ),
    );
  }

  Widget tileWidget(
      {required String title,
      IconData? icon,
      String? subText,
      required Function() onTap}) {
    return ListTile(
      leading: icon != null
          ? Icon(
              icon,
              color: AppColors.primary,
            )
          : null,
      title: Text(
        trans(context, key: title),
        style: StyleHelper.titleMedium(context)
            ?.copyWith(fontSize: 17, fontWeight: FontWeight.w400),
      ),
      contentPadding: .zero,
      trailing: subText != null
          ? Text(trans(context, key: subText),
              style: StyleHelper.titleMedium(context)
                  ?.copyWith(color: AppColors.primary))
          : null,
      onTap: onTap,
    );
  }

  void privacyOptionDialog({required String title}) {
    showDialog(
      context: context,
      builder: (context) => PrivacyOptionDialog(title: title),
    );
  }
}
