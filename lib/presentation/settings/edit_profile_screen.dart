import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/theme/app_theme.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/custom_button.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String name = 'James Parker';
  String avatar =
      'https://images.pexels.com/photos/846741/pexels-photo-846741.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  String userId = '@jamesparker';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, key: 'edit_profile')),
        centerTitle: true,
        actions: [
          CustomButton(
              title: trans(context, key: 'save'),
              xPadding: 15,
              leftIcon: TablerIcons.check,
              onTap: () {}),
          spacing(width: 10)
        ],
      ),
      body: ListView(
        padding: const .symmetric(horizontal: 20, vertical: 25),
        children: [
          _changePhotoWidget(),
          spacing(height: 30),
          Text(trans(context, key: 'full_name'),
              style: StyleHelper.titleMedium(context)),
          spacing(height: 8),
          TextFormField(
            initialValue: name,
            decoration: fieldDeco(borderRadius: .circular(15)),
          ),
          spacing(height: 25),
          Text(trans(context, key: 'username'),
              style: StyleHelper.titleMedium(context)),
          spacing(height: 8),
          TextFormField(
            initialValue: userId,
            decoration: fieldDeco(borderRadius: .circular(15)),
          ),
          spacing(height: 25),
          Text(trans(context, key: 'email'),
              style: StyleHelper.titleMedium(context)),
          spacing(height: 8),
          TextFormField(
            initialValue: userId,
            decoration: fieldDeco(
                hintText: 'user@example.com',
                borderRadius: .circular(15)),
          ),
          spacing(height: 25),
          Text(trans(context, key: 'phone_number'),
              style: StyleHelper.titleMedium(context)),
          spacing(height: 8),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: fieldDeco(
              borderRadius: .circular(15),
              prefixWidget: CountryCodePicker(
                onChanged: print,
                showOnlyCountryWhenClosed: false,
                dialogBackgroundColor:
                    isDarkTheme(context) ? AppColors.darkBg : AppColors.white,
                alignLeft: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _changePhotoWidget() {
    return Center(
      child: Stack(
        children: [
          Hero(
            tag: 'avatar-hero',
            child: CircleAvatar(
                radius: 65,
                child: ClipRRect(
                  borderRadius: .circular(100),
                  child: ImageWidget(
                    image: avatar,
                    type: ImageType.network,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorWidget: Center(
                        child: Text(
                      name[0],
                      style: StyleHelper.titleLarge(context),
                    )),
                  ),
                )),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Hero(
              tag: 'avatar-hero-action',
              child: Container(
                decoration: const BoxDecoration(
                    color: AppColors.primary, shape: BoxShape.circle),
                padding: const .all(6),
                child: const Icon(TablerIcons.camera,
                    size: 25, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
