import 'package:chat_flow/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class SettingsOption extends StatelessWidget {
  const SettingsOption(
      {super.key,
      required this.icon,
      required this.title,
      this.subtitle,
      required this.onTap});

  final IconData icon;
  final String title;
  final String? subtitle;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, size: 23),
        title: Text(
          title,
          style: StyleHelper.titleMedium(context)
              ?.copyWith(fontSize: 17, fontWeight: FontWeight.w400),
        ),
        trailing: const Icon(
          TablerIcons.chevron_right,
          size: 18,
        ),
      ),
    );
  }
}
