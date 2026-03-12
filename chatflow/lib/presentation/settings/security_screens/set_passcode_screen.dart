import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/presentation/auth/passcode_screen.dart';
import 'package:flutter/material.dart';

class SetPasscodeScreen extends StatefulWidget {
  const SetPasscodeScreen({super.key});

  @override
  State<SetPasscodeScreen> createState() => _SetPasscodeScreenState();
}

class _SetPasscodeScreenState extends State<SetPasscodeScreen> {
  bool passcode = true;
  bool eraseData = false;
  bool fingerprintUnlock = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, key: 'passcode')),
      ),
      body: ListView(
        padding: const .symmetric(horizontal: 20, vertical: 10),
        children: [
          SwitchListTile(
            value: passcode,
            title: Text(trans(context, key: 'turn_passcode_off')),
            contentPadding: .zero,
            onChanged: (value) {
              setState(() {
                passcode = !passcode;
              });
            },
          ),
          ListTile(
            title: Text(trans(context, key: 'change_passcode')),
            contentPadding: .zero,
            onTap: () {
              navigateToScreen(context, const PasscodeScreen());
            },
          ),
          SwitchListTile(
            value: eraseData,
            title: Text(trans(context, key: 'erase_data')),
            subtitle: Text(trans(context,
                key: 'delete_all_chat_flow_data_from_this_device')),
            contentPadding: .zero,
            onChanged: (value) {
              setState(() {
                eraseData = !eraseData;
              });
            },
          ),
          SwitchListTile(
            value: fingerprintUnlock,
            title: Text(trans(context, key: 'fingerprint_unlock')),
            subtitle: Text(
                trans(context, key: 'use_your_fingerprint_to_unlock_the_app')),
            contentPadding: .zero,
            onChanged: (value) {
              setState(() {
                fingerprintUnlock = !fingerprintUnlock;
              });
            },
          ),
        ],
      ),
    );
  }
}
