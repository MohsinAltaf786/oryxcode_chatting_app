import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class CallCard extends StatelessWidget {
  const CallCard({super.key, this.data});

  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
              radius: 25,
              child: ClipRRect(
                borderRadius: .circular(100),
                child: ImageWidget(
                  image: '${data['profile_picture']}',
                  type: ImageType.asset,
                  fit: BoxFit.cover,
                  placeholder: AssetsConst.userPlaceholder,
                  errorWidget: Center(
                      child: Text(
                    '${data['caller_name'][0]}',
                    style: StyleHelper.titleLarge(context),
                  )),
                ),
              )),
          spacing(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text('${data['caller_name']}',
                    style: StyleHelper.titleMedium(context)),
                spacing(height: 5),
                Row(
                  children: [
                    Icon(
                      getStatusIcons(data['call_status']),
                      color: getStatusIconsColor(data['call_status']),
                      size: 20,
                    ),
                    spacing(width: 5),
                    Text('${data['timestamp']}',
                        style: StyleHelper.titleSmall(context)
                            ?.copyWith(color: Colors.grey.shade600)),
                  ],
                )
              ],
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                data['call_type'] == "video"
                    ? TablerIcons.video
                    : TablerIcons.phone,
                color: Colors.grey.shade600,
              )),
        ],
      ),
    );
  }

  IconData? getStatusIcons(String data) {
    if (data == 'outgoing') {
      return TablerIcons.phone_outgoing;
    } else if (data == 'incoming') {
      return TablerIcons.phone_incoming;
    } else {
      return TablerIcons.phone_x;
    }
  }

  Color getStatusIconsColor(String data) {
    if (data == 'outgoing') {
      return Colors.blueAccent;
    } else if (data == 'incoming') {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}
