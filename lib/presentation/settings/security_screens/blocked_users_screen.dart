import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/data/contact_data.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, key: 'blocked_users')),
      ),
      body: _buildListItem(ContactData.list.take(8).toList()),
    );
  }

  Widget _buildListItem(List<dynamic> list) {
    return ListView.builder(
        itemCount: list.length,
        padding: const .symmetric(vertical: 10),
        itemBuilder: (context, index) {
          final item = list[index];
          return _buildContactItem(item);
        });
  }

  Widget _buildContactItem(dynamic item) {
    return ListTile(
      title: Row(
        children: [
          CircleAvatar(
              radius: 20,
              child: ClipRRect(
                borderRadius: .circular(100),
                child: ImageWidget(
                  image: '${item['avatar']}',
                  type: ImageType.network,
                  fit: BoxFit.cover,
                  placeholder: AssetsConst.userPlaceholder,
                  errorWidget: Center(
                      child: Text(
                    '${item['name'][0]}',
                    style: StyleHelper.titleMedium(context),
                  )),
                ),
              )),
          spacing(width: 15),
          Expanded(
              child: Text('${item['name']}',
                  style: StyleHelper.titleMedium(context))),
        ],
      ),
      trailing: IconButton(onPressed: () {}, icon: const Icon(TablerIcons.x)),
    );
  }
}
