import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/data/chats_data.dart';
import 'package:chat_flow/presentation/chats/create_chat_screen.dart';
import 'package:chat_flow/presentation/conversation/conversation_screen.dart';
import 'package:chat_flow/presentation/chats/widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class PersonalList extends StatelessWidget {
  const PersonalList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildChatsList(context, ChatsData.list),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToScreen(context, const CreateChatScreen()),
        backgroundColor: AppColors.primary,
        elevation: 2,
        child: const Icon(TablerIcons.message, color: Colors.white),
      ),
    );
  }

  Widget _buildChatsList(BuildContext context, List<dynamic> list) {
    final personal = list.where((e) => e['type'] == 'personal').toList();

    return ListView.separated(
      itemCount: personal.length,
      padding: const .fromLTRB(12, 8, 12, 100),
      separatorBuilder: (context, index) => const SizedBox(height: 2),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => navigateToScreen(
            context,
            ConversationScreen(data: personal[index]),
          ),
          behavior: HitTestBehavior.opaque,
          child: ChatCard(data: personal[index]),
        );
      },
    );
  }
}
