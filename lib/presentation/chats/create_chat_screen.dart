import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/data/contact_data.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class CreateChatScreen extends StatefulWidget {
  const CreateChatScreen({super.key});

  @override
  State<CreateChatScreen> createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, key: 'create_new_chat')),
        leading: IconButton(
            onPressed: () {
              navigateBack(context);
            },
            icon: const Icon(TablerIcons.chevron_left)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const .symmetric(horizontal: 15),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: .circular(50),
                  border: Border.all(color: AppColors.grey30)),
              child: TextFormField(
                  decoration: fieldDeco(
                      hintText: trans(context, key: 'search_contact'),
                      isFilled: true,
                      prefixIcon: TablerIcons.search)),
            ),
          ),
          Expanded(child: _buildListItem(ContactData.list))
        ],
      ),
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
      onTap: () {
        navigateBack(context);
      },
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
    );
  }
}
