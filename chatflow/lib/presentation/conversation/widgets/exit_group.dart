import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/custom_button.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';

class ExitGroup extends StatefulWidget {
  const ExitGroup({super.key});

  @override
  State<ExitGroup> createState() => _ExitGroupState();
}

class _ExitGroupState extends State<ExitGroup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      child: _buildCard(),
    );
  }

  Widget _buildCard() {
    return Column(
      mainAxisSize: .min,
      children: [_buildHeader(), spacing(height: 20), _buildActionButtons()],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const .symmetric(horizontal: 15),
      child: Column(
        children: [
          spacing(height: 20),
          Text(trans(context, key: 'exit_group'),
              style: StyleHelper.headlineSmall(context)
                  ?.copyWith(fontWeight: FontWeight.w500)),
          spacing(height: 5),
          Text(trans(context, key: 'are_you_sure_you_want_to_exit_from_this_group'),
              textAlign: TextAlign.center,
              style: StyleHelper.titleSmall(context)
                  ?.copyWith(fontWeight: FontWeight.w500)),
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
                  })),
          spacing(width: 10),
          Expanded(
              child: CustomButton(
                  title: trans(context, key: 'exit'),
                  color: Colors.red.shade600,
                  onTap: () {
                    navigateBack(context);
                  })),
        ],
      ),
    );
  }
}
