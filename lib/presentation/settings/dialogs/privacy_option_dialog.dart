import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class PrivacyOptionDialog extends StatefulWidget {
  const PrivacyOptionDialog({super.key, required this.title});

  final String title;

  @override
  State<PrivacyOptionDialog> createState() => _PrivacyOptionDialogState();
}

class _PrivacyOptionDialogState extends State<PrivacyOptionDialog> {
  int groupValue = 2;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(trans(context, key: widget.title)),
      backgroundColor: Theme.of(context).cardColor,
      content: RadioGroup<int>(
        groupValue: groupValue,
        onChanged: (int? value) {
          setState(() {
            groupValue = value ?? groupValue;
          });
        },
        child: Column(
          mainAxisSize: .min,
          children: [
            RadioListTile(
              value: 1,
              title: Text(trans(context, key: 'only_me')),
              contentPadding: .zero,
            ),
            RadioListTile(
              value: 2,
              title: Text(trans(context, key: 'my_contacts')),
              contentPadding: .zero,
            ),
            RadioListTile(
              value: 3,
              title: Text(trans(context, key: 'everyone')),
              contentPadding: .zero,
            ),
          ],
        ),
      ),
      actions: [
        CustomButton(
            title: trans(context, key: 'close'),
            color: Colors.transparent,
            textColor: ColorHelper.titleSmallColor(context),
            onTap: () {
              navigateBack(context);
            }),
        CustomButton(
            title: trans(context, key: 'save'),
            onTap: () {
              navigateBack(context);
            })
      ],
    );
  }
}
