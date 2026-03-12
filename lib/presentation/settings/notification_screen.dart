import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool enableNotifications = true;

  bool vibrate1 = true;
  bool vibrate2 = true;
  bool vibrate3 = true;

  bool uploadFilesNotification = true;
  bool newStatusNotification = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(trans(context, key: 'notifications'))),
      body: ListView(
        padding: const .symmetric(horizontal: 20, vertical: 10),
        children: [
          SwitchListTile(
            value: enableNotifications,
            title: Text(trans(context, key: 'enable_notifications')),
            contentPadding: .zero,
            onChanged: (e) {
              setState(() {
                enableNotifications = e;
                vibrate1 = e;
                vibrate2 = e;
                vibrate3 = e;
                uploadFilesNotification = e;
                newStatusNotification = e;
              });
            },
          ),
          spacing(height: 10),
          Text(
            trans(context, key: 'messages'),
            style: StyleHelper.titleSmall(context),
          ),
          ListTile(
            title: Text(trans(context, key: 'notification_tone')),
            subtitle: const Text('Default (Hello)'),
            contentPadding: .zero,
          ),
          SwitchListTile(
            value: vibrate1,
            title: Text(trans(context, key: 'vibrate')),
            contentPadding: .zero,
            onChanged: (e) {
              setState(() {
                vibrate1 = e;
              });
            },
          ),
          spacing(height: 5),
          const Divider(),
          spacing(height: 5),
          Text(
            trans(context, key: 'groups'),
            style: StyleHelper.titleSmall(context),
          ),
          ListTile(
            title: Text(trans(context, key: 'notification_tone')),
            subtitle: const Text('Default (Hello)'),
            contentPadding: .zero,
          ),

          SwitchListTile(
            value: vibrate2,
            title: Text(trans(context, key: 'vibrate')),
            contentPadding: .zero,
            onChanged: (e) {
              setState(() {
                vibrate2 = e;
              });
            },
          ),
          spacing(height: 5),
          const Divider(),
          spacing(height: 5),
          Text(
            trans(context, key: 'calls'),
            style: StyleHelper.titleSmall(context),
          ),
          ListTile(
            title: Text(trans(context, key: 'ringtone')),
            subtitle: const Text('Default (Hello)'),
            contentPadding: .zero,
          ),
          SwitchListTile(
            value: vibrate3,
            title: Text(trans(context, key: 'vibrate')),
            contentPadding: .zero,
            onChanged: (e) {
              setState(() {
                vibrate3 = e;
              });
            },
          ),
          spacing(height: 5),
          const Divider(),
          spacing(height: 5),
          Text(
            trans(context, key: 'others'),
            style: StyleHelper.titleSmall(context),
          ),
          SwitchListTile(
            value: uploadFilesNotification,
            title: Text(trans(context, key: 'upload_files_notification')),
            contentPadding: .zero,
            onChanged: (e) {
              setState(() {
                uploadFilesNotification = e;
              });
            },
          ),
          SwitchListTile(
            value: newStatusNotification,
            title: Text(trans(context, key: 'new_status_notification')),
            contentPadding: .zero,
            onChanged: (e) {
              setState(() {
                newStatusNotification = e;
              });
            },
          ),
        ],
      ),
    );
  }
}
