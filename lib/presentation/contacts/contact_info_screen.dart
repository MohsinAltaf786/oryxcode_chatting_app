import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/data/shared_media_data.dart';
import 'package:chat_flow/presentation/contacts/widgets/shared_media.dart';
import 'package:chat_flow/presentation/conversation/screens/audio_calling_screen.dart';
import 'package:chat_flow/presentation/conversation/screens/video_calling_screen.dart';
import 'package:chat_flow/presentation/conversation/widgets/block_user.dart';
import 'package:chat_flow/presentation/conversation/widgets/clear_chat.dart';
import 'package:chat_flow/presentation/conversation/widgets/mute_notifications.dart';
import 'package:chat_flow/presentation/conversation/widgets/report_user.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class ContactInfoScreen extends StatefulWidget {
  const ContactInfoScreen({super.key});

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  String avatar = "assets/img/avatars/avatar6.jpg";
  String userName = "Stephan Louis";
  String userEmail = "stephen@louis.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(TablerIcons.share)),
          spacing(width: 10),
        ],
      ),
      body: ListView(
        padding: const .all(15),
        children: [
          Center(
            child: ImageWidget(
              image: avatar,
              fit: BoxFit.cover,
              width: 150,
              height: 150,
              borderRadius: .circular(30),
              type: ImageType.asset,
              placeholder: AssetsConst.userPlaceholder,
              errorWidget: Center(
                  child: Text(
                userName[0],
                style: StyleHelper.titleMedium(context),
              )),
            ),
          ),
          spacing(height: 15),
          Text(
            userName,
            textAlign: TextAlign.center,
            style: StyleHelper.headlineMedium(context)
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          spacing(height: 5),
          Text(
            userEmail,
            textAlign: TextAlign.center,
            style: StyleHelper.titleMedium(context)
                ?.copyWith(color: ColorHelper.titleSmallColor(context)),
          ),
          spacing(height: 30),
          Row(
            mainAxisAlignment: .spaceEvenly,
            children: [
              _buildFilledButton(
                icon: TablerIcons.phone,
                onTap: () {
                  navigateToScreen(context, const AudioCallingScreen());
                },
              ),
              _buildTonalButton(
                icon: TablerIcons.video,
                onTap: () {
                  navigateToScreen(context, const VideoCallingScreen());
                },
              ),
              _buildOutlinedButton(
                icon: TablerIcons.message,
                onTap: () {
                  navigateBack(context);
                },
              ),
              _buildOutlinedButton(
                icon: TablerIcons.mail,
                onTap: () {},
              ),
            ],
          ),
          spacing(height: 20),
          const SharedMedia(list: SharedMediaData.list),
          spacing(height: 10),
          ListTile(
            leading: const Icon(TablerIcons.volume),
            title: Text(trans(context, key: 'mute_notifications'),
                style: StyleHelper.titleMedium(context)),
            onTap: () {
              openMuteNotification();
            },
          ),
          ListTile(
            leading: const Icon(TablerIcons.clear_all),
            title: Text(trans(context, key: 'clear_chat'),
                style: StyleHelper.titleMedium(context)),
            onTap: () {
              clearChat();
            },
          ),
          ListTile(
            leading: Icon(TablerIcons.thumb_down, color: Colors.red.shade600),
            title: Text(trans(context, key: 'report'),
                style: StyleHelper.titleMedium(context)
                    ?.copyWith(color: Colors.red.shade600)),
            onTap: () {
              openReportUser();
            },
          ),
          ListTile(
            leading: Icon(TablerIcons.ban, color: Colors.red.shade600),
            title: Text(trans(context, key: 'block'),
                style: StyleHelper.titleMedium(context)
                    ?.copyWith(color: Colors.red.shade600)),
            onTap: () {
              openBlockUser();
            },
          ),
          spacing(height: 30),
        ],
      ),
    );
  }

  Widget _buildFilledButton(
      {required IconData icon, required Function() onTap}) {
    return IconButton.filled(
        onPressed: onTap,
        constraints: BoxConstraints.tight(const Size(55, 55)),
        icon: Icon(icon, size: 26));
  }

  Widget _buildTonalButton(
      {required IconData icon, required Function() onTap}) {
    return IconButton.filledTonal(
        onPressed: onTap,
        constraints: BoxConstraints.tight(const Size(55, 55)),
        icon: Icon(icon, size: 26));
  }

  void openMuteNotification() {
    showDialog(
        context: context, builder: (context) => const MuteNotifications());
  }

  void clearChat() {
    showDialog(context: context, builder: (context) => const ClearChat());
  }

  void openBlockUser() {
    showDialog(context: context, builder: (context) => const BlockUser());
  }

  void openReportUser() {
    showDialog(context: context, builder: (context) => const ReportUser());
  }

  Widget _buildOutlinedButton(
      {required IconData icon, required Function() onTap}) {
    return IconButton.outlined(
        onPressed: onTap,
        constraints: BoxConstraints.tight(const Size(55, 55)),
        icon: Icon(
          icon,
          size: 26,
        ));
  }
}
