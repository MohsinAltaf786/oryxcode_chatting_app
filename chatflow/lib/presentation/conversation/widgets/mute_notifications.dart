import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/custom_button.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';

class MuteNotifications extends StatefulWidget {
  const MuteNotifications({super.key});

  @override
  State<MuteNotifications> createState() => _MuteNotificationsState();
}

class _MuteNotificationsState extends State<MuteNotifications> {
  int selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      child: _buildCard(),
    );
  }

  Widget _buildCard() {
    return RadioGroup<int>(
      groupValue: selectedValue,
      onChanged: (int? value) {
        setState(() {
          selectedValue = value ?? 1;
        });
      },
      child: Column(
        mainAxisSize: .min,
        children: [
          _buildHeader(),
          spacing(height: 20),
          _buildRadioTile(title: trans(context, key: '8_hours'), value: 1),
          _buildRadioTile(title: trans(context, key: '1_week'), value: 2),
          _buildRadioTile(title: trans(context, key: 'always'), value: 3),
          spacing(height: 20),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildRadioTile({required String title, required int value}) {
    return RadioListTile(value: value, title: Text(title));
  }

  Widget _buildHeader() {
    return Padding(
      padding: const .symmetric(horizontal: 15),
      child: Column(
        children: [
          spacing(height: 10),
          Row(
            mainAxisAlignment: .end,
            children: [
              IconButton(
                onPressed: () {
                  navigateBack(context);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          Text(
            trans(context, key: 'mute_notifications'),
            style: StyleHelper.headlineSmall(
              context,
            )?.copyWith(fontWeight: FontWeight.w500),
          ),
          spacing(height: 5),
          Text(
            trans(context, key: 'silence_alerts_for_8_hours_or_1_week'),
            textAlign: TextAlign.center,
            style: StyleHelper.titleSmall(
              context,
            )?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const .all(10),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              title: trans(context, key: 'cancel'),
              lined: true,
              color: Colors.transparent,
              textColor: ColorHelper.titleMediumColor(context),
              onTap: () {
                navigateBack(context);
              },
            ),
          ),
          spacing(width: 10),
          Expanded(
            child: CustomButton(
              title: trans(context, key: 'save'),
              onTap: () {
                navigateBack(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
