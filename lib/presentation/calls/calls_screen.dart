import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/data/calls_data.dart';
import 'package:chat_flow/presentation/calls/widget/call_card.dart';
import 'package:flutter/material.dart';

class CallsScreen extends StatefulWidget {
  const CallsScreen({super.key});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : Colors.white,
      appBar: AppBar(title: Text(trans(context, key: 'calls'))),
      body: _buildList(CallsData.list),
    );
  }

  Widget _buildList(List<dynamic> list) {
    return ListView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      padding: const .only(top: 10, left: 15, right: 15, bottom: 100),
      itemBuilder: (context, index) {
        return CallCard(data: list[index]);
      },
    );
  }
}
