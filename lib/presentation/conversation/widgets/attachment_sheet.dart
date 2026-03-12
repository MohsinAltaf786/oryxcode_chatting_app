import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/presentation/conversation/screens/create_poll_screen.dart';
import 'package:chat_flow/presentation/conversation/screens/send_contact_screen.dart';
import 'package:chat_flow/presentation/conversation/screens/send_location_screen.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:image_picker/image_picker.dart';

class AttachmentSheet extends StatelessWidget {
  const AttachmentSheet({super.key});

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _isDark(context) ? AppColors.grey100 : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            decoration: BoxDecoration(
              color: _isDark(context) ? AppColors.grey80 : AppColors.grey30,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildItem(context,
                    icon: TablerIcons.photo,
                    title: trans(context, key: 'images'),
                    gradient: [Colors.blue.shade400, Colors.blue.shade600],
                    onTap: () => pickImage(context)),
                _buildItem(context,
                    icon: TablerIcons.video,
                    title: trans(context, key: 'videos'),
                    gradient: [Colors.red.shade400, Colors.red.shade600],
                    onTap: () => pickVideo(context)),
                _buildItem(context,
                    icon: TablerIcons.music,
                    title: trans(context, key: 'audio'),
                    gradient: [Colors.teal.shade400, Colors.teal.shade600],
                    onTap: () => pickAudio(context)),
                _buildItem(context,
                    icon: TablerIcons.file,
                    title: trans(context, key: 'file'),
                    gradient: [Colors.orange.shade400, Colors.orange.shade600],
                    onTap: () => pickFile(context)),
              ],
            ),
          ),
          spacing(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildItem(context,
                    icon: TablerIcons.chart_bar,
                    title: trans(context, key: 'poll'),
                    gradient: [Colors.purple.shade400, Colors.purple.shade600],
                    onTap: () => createPoll(context)),
                spacing(width: 24),
                _buildItem(context,
                    icon: TablerIcons.user,
                    title: trans(context, key: 'contact'),
                    gradient: [Colors.indigo.shade400, Colors.indigo.shade600],
                    onTap: () => sendContact(context)),
                spacing(width: 24),
                _buildItem(context,
                    icon: TablerIcons.map_pin,
                    title: trans(context, key: 'location'),
                    gradient: [Colors.green.shade400, Colors.green.shade600],
                    onTap: () => sendLocation(context)),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context,
      {required IconData icon,
      required String title,
      required List<Color> gradient,
      required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            spacing(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _isDark(context) ? AppColors.light60 : AppColors.greyText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage(BuildContext context) async {
    Navigator.pop(context);
    final ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery);
  }

  Future<void> pickVideo(BuildContext context) async {
    Navigator.pop(context);
    final ImagePicker picker = ImagePicker();
    await picker.pickVideo(source: ImageSource.gallery);
  }

  Future<void> pickAudio(BuildContext context) async {
    Navigator.pop(context);
    await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
  }

  Future<void> pickFile(BuildContext context) async {
    Navigator.pop(context);
    await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );
  }

  void sendContact(BuildContext context) {
    navigateBack(context);
    navigateToScreen(context, const SendContactScreen());
  }

  void createPoll(BuildContext context) {
    navigateBack(context);
    navigateToScreen(context, const CreatePollScreen());
  }

  void sendLocation(BuildContext context) {
    navigateBack(context);
    navigateToScreen(context, const SendLocationScreen());
  }
}
