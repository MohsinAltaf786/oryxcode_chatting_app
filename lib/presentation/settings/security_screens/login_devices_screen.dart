import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/data/login_devices_data.dart';
import 'package:chat_flow/presentation/widgets/custom_button.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class LoginDevicesScreen extends StatefulWidget {
  const LoginDevicesScreen({super.key});

  @override
  State<LoginDevicesScreen> createState() => _LoginDevicesScreenState();
}

class _LoginDevicesScreenState extends State<LoginDevicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, key: 'login_devices')),
      ),
      body: ListView(
        padding: const .symmetric(horizontal: 20, vertical: 10),
        children: [
          spacing(height: 10),
          const Row(
            children: [
              Icon(
                TablerIcons.device_desktop,
                size: 35,
                color: AppColors.primary,
              ),
            ],
          ),
          spacing(height: 15),
          Text(trans(context, key: 'your_devices'),
              style: StyleHelper.titleLarge(context)),
          spacing(height: 5),
          Text(
              trans(context,
                  key: 'you_re_currently_logged_in_on_these_devices'),
              style: StyleHelper.titleMedium(context)?.copyWith(
                  color: ColorHelper.titleSmallColor(context),
                  fontWeight: FontWeight.w400)),
          spacing(height: 20),
          CustomButton(
              title: trans(context, key: 'log_out_from_all_devices'),
              color: AppColors.primary.withValues(alpha: 0.1),
              textColor: AppColors.primary,
              onTap: () {}),
          spacing(height: 15),
          const Divider(
            height: 1,
          ),
          spacing(height: 15),
          _buildDevicesList(LoginDevicesData.list),
        ],
      ),
    );
  }

  Widget _buildDevicesList(List<dynamic> list) {
    return ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var item = list[index];
          return ListTile(
            leading: Icon(item['icon'], color: AppColors.primary),
            title: Row(
              children: [
                Flexible(child: Text(item['device_name'])),
                if (item['this_device'] == true) ...[
                  spacing(width: 5),
                  _buildThisDeviceTag(),
                ]
              ],
            ),
            subtitle: Text(item['login_time']),
            contentPadding: .zero,
            trailing: IconButton(
                onPressed: () {}, icon: const Icon(TablerIcons.logout)),
          );
        });
  }

  Widget _buildThisDeviceTag() {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: .circular(20)),
        padding: const .symmetric(horizontal: 5),
        child: Text(trans(context, key: 'this_device'),
            style: StyleHelper.titleSmall(context)
                ?.copyWith(color: AppColors.primaryDark, fontSize: 11)));
  }
}
