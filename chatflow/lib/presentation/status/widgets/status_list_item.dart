import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/status_border.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/status/status_view_screen.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';

class StatusListItem extends StatelessWidget {
  const StatusListItem({super.key, this.data});

  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          navigateToScreen(context, StatusViewScreen(data: data));
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 53,
                  height: 53,
                  child: CustomPaint(
                    painter: DottedBorder(
                        numberOfStories: data['status'].length,
                        watchedStories: data['watched']),
                  ),
                ),
                Container(
                  width: 45,
                  height: 45,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: .circular(100),
                    child: ImageWidget(
                      image: data['thumbnail'],
                      fit: BoxFit.cover,
                      type: ImageType.network,
                      placeholder: AssetsConst.userPlaceholder,
                      errorWidget: Center(
                          child: Text('${data['name'][0]}',
                              style: StyleHelper.titleLarge(context)
                                  ?.copyWith(fontWeight: FontWeight.w600))),
                    ),
                  ),
                )
              ],
            ),
            spacing(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text('${data['name']}',
                      style: StyleHelper.titleMedium(context)
                          ?.copyWith(fontSize: 17)),
                  spacing(height: 3),
                  Text('${data['created_at']}',
                      style: StyleHelper.titleSmall(context)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
