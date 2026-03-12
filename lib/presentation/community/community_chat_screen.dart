import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/data/community_messages_data.dart';
import 'package:chat_flow/presentation/conversation/widgets/chat_bubble.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({super.key, required this.community});

  final dynamic community;

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<dynamic> _messages = [];

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _loadMockMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _loadMockMessages() {
    _messages.addAll(
      CommunityMessagesData.getMessages(
        widget.community['name'],
        widget.community['avatar'],
      ),
    );
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({
        'sender': 'Me',
        'message': text,
        'time': DateTime.now().toIso8601String(),
      });
      _controller.clear();
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatMemberCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ChatBubble(data: msg);
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isDark ? AppColors.grey80 : AppColors.grey30,
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.network(
                widget.community['avatar'],
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    TablerIcons.users_group,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          spacing(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.community['name'],
                  style: StyleHelper.titleMedium(context)?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                spacing(height: 2),
                Text(
                  trans(context, key: 'members_count').replaceFirst(
                    '{count}',
                    _formatMemberCount(widget.community['memberCount']),
                  ),
                  style: StyleHelper.bodySmall(context)?.copyWith(
                    color: _isDark ? AppColors.grey60 : AppColors.greyText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            TablerIcons.dots_vertical,
            color: _isDark ? AppColors.light80 : AppColors.darkText,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: _isDark ? AppColors.darkBg : Colors.white,
        border: Border(
          top: BorderSide(
            color: _isDark ? AppColors.grey90 : AppColors.grey30,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                TablerIcons.plus,
                color: _isDark ? AppColors.light60 : AppColors.greyText,
                size: 24,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            spacing(width: 10),
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(
                  color: _isDark ? AppColors.light80 : AppColors.darkText,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: trans(context, key: 'message_channel_hint')
                      .replaceFirst('{name}', widget.community['name']),
                  hintStyle: TextStyle(
                    color: _isDark ? AppColors.grey60 : AppColors.greyText,
                    fontSize: 15,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: _isDark ? AppColors.grey90 : AppColors.grey20,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            spacing(width: 10),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  TablerIcons.send,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: _sendMessage,
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
