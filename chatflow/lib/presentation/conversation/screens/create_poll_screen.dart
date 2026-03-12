import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/custom_button.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({super.key});

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  List<TextEditingController> optionControllers = [];
  int optionCount = 2;

  bool allowMultipleAnswers = true;

  @override
  void initState() {
    super.initState();
    // Initialize controllers for default options
    for (int i = 0; i < optionCount; i++) {
      optionControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    for (var controller in optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, key: 'create_a_poll')),
      ),
      body: ListView(
        padding: const .symmetric(horizontal: 20, vertical: 20),
        children: [
          Text(trans(context, key: 'question'), style: StyleHelper.titleMedium(context)),
          TextFormField(
            decoration: fieldDeco(hintText: trans(context, key: 'enter_question')),
          ),
          spacing(height: 25),
          Text(trans(context, key: 'options'), style: StyleHelper.titleMedium(context)),
          spacing(height: 10),
          _buildOptionsWidget(),
          spacing(height: 10),
          buildAllowMultipleAns()
        ],
      ),
      bottomNavigationBar: _buildSendButton(),
    );
  }

  Widget _buildOptionsWidget() {
    return Column(
      children: [
        for (int i = 0; i < optionCount; i++) _buildOptionTextField(i),
        spacing(height: 5),
        Row(
          mainAxisAlignment: .end,
          children: [
            CustomButton(
                title: trans(context, key: 'add_option'),
                leftIcon: TablerIcons.plus,
                color: Colors.transparent,
                textColor: AppColors.primary,
                onTap: () {
                  setState(() {
                    optionCount++; // Increase option count
                    optionControllers.add(TextEditingController());
                  });
                }),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionTextField(int index) {
    return Padding(
      padding: const .only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: optionControllers[index],
              decoration: fieldDeco(hintText: '${trans(context, key: 'option')} ${index + 1}'),
            ),
          ),
          if (optionCount > 2 && index >= 2)
            IconButton(
              onPressed: () {
                setState(() {
                  optionCount--; // Decrease option count
                  optionControllers.removeLast(); // Remove controller
                });
              },
              icon: Icon(TablerIcons.trash, color: Colors.red.shade700),
            ),
        ],
      ),
    )
        .animate()
        .fade(
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut)
        .slideY(
            begin: 0.3,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
  }

  Widget buildAllowMultipleAns() {
    return CheckboxListTile(
      value: allowMultipleAnswers,
      title: Text(trans(context, key: 'allow_multiple_answers'),
          style: StyleHelper.titleMedium(context)),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: .zero,
      onChanged: (value) {
        setState(() {
          allowMultipleAnswers = !allowMultipleAnswers;
        });
      },
    );
  }

  /// Builds the send button.
  Widget _buildSendButton() {
    return Padding(
      padding: const .all(8.0),
      child: Column(
        mainAxisSize: .min,
        children: [
          CustomButton(
              title: trans(context, key: 'send'),
              width: double.infinity,
              yPadding: 12,
              fontSize: StyleHelper.titleMedium(context)?.fontSize,
              rightIcon: Icons.arrow_forward,
              onTap: () {
                navigateBack(context);
              })
        ],
      ),
    );
  }
}
