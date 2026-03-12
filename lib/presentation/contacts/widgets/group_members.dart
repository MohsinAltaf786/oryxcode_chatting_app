import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';

class GroupMembers extends StatelessWidget {
  const GroupMembers({super.key, required this.list});

  final List<dynamic> list;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: cardShape,
      elevation: 2,
      child: Padding(
        padding: const .all(15),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(trans(context, key: 'members'), style: StyleHelper.titleMedium(context)),
            spacing(height: 10),
            _buildListItem(context),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context) {
    return ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (listContext, index) {
          return _buildMemberItem(list[index], context);
        });
  }

  Widget _buildMemberItem(dynamic item, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          radius: 20,
          child: ClipRRect(
            borderRadius: .circular(100),
            child: ImageWidget(
              image: '${item['avatar']}',
              type: ImageType.network,
              fit: BoxFit.cover,
              errorWidget: Center(
                  child: Text(
                '${item['name'][0]}',
                style: StyleHelper.titleMedium(context),
              )),
            ),
          )),
      title: Text('${item['name']}', style: StyleHelper.titleMedium(context)),
      contentPadding: .zero,
      trailing: _buildRoleType(context, item),
    );
  }

  Widget _buildRoleType(BuildContext context, dynamic item) {
    if(item['role'] == 'Admin') {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.tealGreen.withValues(alpha: 0.5),
          borderRadius: .circular(50)
        ),
        padding: const .symmetric(horizontal: 8, vertical: 2),
        child: Text(trans(context, key: 'admin'), style: StyleHelper.titleSmall(context)?.copyWith(
          color: ColorHelper.titleMediumColor(context)
        )),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
