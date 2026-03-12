import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/data/contact_data.dart';
import 'package:chat_flow/presentation/widgets/custom_button.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  List<dynamic> selectedContacts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, key: 'create_new_group')),
        leading: IconButton(
            onPressed: () {
              navigateBack(context);
            },
            icon: const Icon(TablerIcons.chevron_left)),
      ),
      bottomNavigationBar: _buildCreateButton(),
      body: ListView(
        padding: const .symmetric(horizontal: 15),
        children: [
          spacing(height: 10),
          TextFormField(decoration: fieldDeco(label: trans(context, key: 'group_name'))),
          spacing(height: 20),
          Text(trans(context, key: 'add_members'), style: StyleHelper.titleMedium(context)),
          _buildListItem(ContactData.list)
        ],
      ),
    );
  }

  Widget _buildListItem(List<dynamic> list) {
    return ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const .symmetric(vertical: 10),
        itemBuilder: (context, index) {
          final item = list[index];
          final bool isSelected = selectedContacts.contains(item);
          return _buildContactItem(item, isSelected);
        });
  }

  Widget _buildContactItem(dynamic item, bool isSelected) {
    return CheckboxListTile(
      value: isSelected,
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
      onChanged: (value) {
        setState(() {
          if (value == true) {
            selectedContacts.add(item);
          } else {
            selectedContacts.remove(item);
          }
        });
      },
    );
  }

  Widget _buildCreateButton() {
    return Padding(
      padding: const .all(8.0),
      child: Column(
        mainAxisSize: .min,
        children: [
          CustomButton(
              title: trans(context, key: 'create'),
              width: double.infinity,
              yPadding: 12,
              fontSize: StyleHelper.titleMedium(context)?.fontSize,
              leftIcon: Icons.add,
              enable: selectedContacts.isNotEmpty,
              onTap: () {
                navigateBack(context);
              })
        ],
      ),
    );
  }
}
