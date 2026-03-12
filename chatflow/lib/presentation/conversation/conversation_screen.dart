import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/data/conversation_data.dart';
import 'package:chat_flow/presentation/conversation/widgets/attachment_sheet.dart';
import 'package:chat_flow/presentation/conversation/widgets/chat_app_bar.dart';
import 'package:chat_flow/presentation/conversation/widgets/chat_bubble.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key, this.data});

  final dynamic data;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  bool _showEmojiPicker = false;
  dynamic _replyingTo;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _onReply(dynamic message) {
    setState(() {
      _replyingTo = message;
    });
    _inputFocusNode.requestFocus();
  }

  void _onReact(dynamic message, String emoji) {
    debugPrint('Reacted to message with $emoji');
  }

  void _cancelReply() {
    setState(() {
      _replyingTo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(data: widget.data),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isDark
                ? [AppColors.darkBg, AppColors.grey100]
                : [Colors.white, AppColors.grey20],
          ),
        ),
        child: Column(
          children: [
            Expanded(child: _buildConversationWidget(ConversationData.list)),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationWidget(List<dynamic> list) {
    return GestureDetector(
      onTap: () {
        if (_showEmojiPicker) {
          setState(() => _showEmojiPicker = false);
        }
        FocusScope.of(context).unfocus();
      },
      child: ListView.builder(
        itemCount: list.length,
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemBuilder: (context, index) {
          final showDate = index == 0 ||
              _shouldShowDateHeader(list[index], list[index - 1]);
          return Column(
            children: [
              if (showDate) _buildDateHeader(list[index]['time']),
              ChatBubble(
                data: list[index],
                onReply: _onReply,
                onReact: _onReact,
              ),
            ],
          );
        },
      ),
    );
  }

  bool _shouldShowDateHeader(dynamic current, dynamic previous) {
    return false; // Simplified - implement date comparison if needed
  }

  Widget _buildDateHeader(String time) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: _isDark ? AppColors.grey80 : AppColors.grey30)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _isDark ? AppColors.grey90 : AppColors.grey20,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Today',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _isDark ? AppColors.light60 : AppColors.greyText,
              ),
            ),
          ),
          Expanded(child: Divider(color: _isDark ? AppColors.grey80 : AppColors.grey30)),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      decoration: BoxDecoration(
        color: _isDark ? AppColors.grey100 : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_replyingTo != null) _buildReplyPreview(),
            _buildChatInputBar(),
            if (_showEmojiPicker) _buildEmojiPicker(),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyPreview() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          spacing(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _isDark
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.primaryLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    trans(context, key: 'replying_to_user')
                        .replaceFirst('{name}', _replyingTo['sender'] ?? ''),
                    style: StyleHelper.labelMedium(context)?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  spacing(height: 2),
                  Text(
                    _replyingTo['message'] ?? '',
                    style: StyleHelper.labelMedium(context)?.copyWith(
                      color: _isDark ? AppColors.light60 : AppColors.greyText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _isDark ? AppColors.grey80 : AppColors.grey20,
                shape: BoxShape.circle,
              ),
              child: Icon(
                TablerIcons.x,
                size: 16,
                color: _isDark ? AppColors.light60 : AppColors.greyText,
              ),
            ),
            onPressed: _cancelReply,
          ),
        ],
      ),
    );
  }

  Widget _buildChatInputBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildAttachmentButton(),
          spacing(width: 8),
          Expanded(child: _buildInputField()),
          spacing(width: 8),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildAttachmentButton() {
    return GestureDetector(
      onTap: () {
        if (_showEmojiPicker) {
          setState(() => _showEmojiPicker = false);
        }
        openAttachmentSheet();
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _isDark ? AppColors.grey90 : AppColors.grey20,
          shape: BoxShape.circle,
        ),
        child: Icon(
          TablerIcons.plus,
          color: _isDark ? AppColors.light80 : AppColors.darkText,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 120),
      decoration: BoxDecoration(
        color: _isDark ? AppColors.grey90 : AppColors.grey20,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _chatController,
              focusNode: _inputFocusNode,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              onTap: () {
                if (_showEmojiPicker) {
                  setState(() => _showEmojiPicker = false);
                }
              },
              onChanged: (value) => setState(() {}),
              style: TextStyle(
                color: _isDark ? AppColors.light80 : AppColors.darkText,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: trans(context, key: 'write_a_message'),
                hintStyle: TextStyle(
                  color: _isDark ? AppColors.light60 : AppColors.greyText,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() => _showEmojiPicker = !_showEmojiPicker);
              if (_showEmojiPicker) {
                _inputFocusNode.unfocus();
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              } else {
                _inputFocusNode.requestFocus();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                _showEmojiPicker ? TablerIcons.keyboard : TablerIcons.mood_smile,
                color: _isDark ? AppColors.light60 : AppColors.greyText,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    final bool hasText = _chatController.text.trim().isNotEmpty;
    return GestureDetector(
      onTap: hasText ? _sendMessage : _showVoiceRecordingSheet,
      onLongPress: hasText ? null : _showVoiceRecordingSheet,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          hasText ? TablerIcons.send : TablerIcons.microphone,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_chatController.text.trim().isNotEmpty) {
      if (_replyingTo != null) {
        debugPrint('Sending reply to: ${_replyingTo['message']}');
      }
      debugPrint('Sending message: ${_chatController.text}');
      setState(() {
        _chatController.clear();
        _replyingTo = null;
      });
    }
  }

  Widget _buildEmojiPicker() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: _isDark ? AppColors.grey100 : Colors.white,
        border: Border(
          top: BorderSide(
            color: _isDark ? AppColors.grey80 : AppColors.grey20,
          ),
        ),
      ),
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          _chatController.text += emoji.emoji;
          setState(() {});
        },
        onBackspacePressed: () {
          _chatController
            ..text = _chatController.text.characters.skipLast(1).toString()
            ..selection = TextSelection.fromPosition(
                TextPosition(offset: _chatController.text.length));
        },
        config: Config(
          height: 280,
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(
            emojiSizeMax: 28 *
                (foundation.defaultTargetPlatform == TargetPlatform.iOS
                    ? 1.2
                    : 1.0),
            backgroundColor: _isDark ? AppColors.grey100 : Colors.white,
          ),
          skinToneConfig: const SkinToneConfig(),
          categoryViewConfig: CategoryViewConfig(
            backgroundColor: _isDark ? AppColors.grey100 : Colors.white,
            iconColorSelected: AppColors.primary,
            indicatorColor: AppColors.primary,
            iconColor: _isDark ? AppColors.light60 : AppColors.greyText,
          ),
          bottomActionBarConfig: BottomActionBarConfig(
            backgroundColor: _isDark ? AppColors.grey100 : Colors.white,
            buttonColor: AppColors.primary,
          ),
        ),
      ),
    );
  }

  void _showVoiceRecordingSheet() {
    if (_showEmojiPicker) {
      setState(() => _showEmojiPicker = false);
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: _isDark ? AppColors.grey100 : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: _isDark ? AppColors.grey80 : AppColors.grey30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade400, Colors.red.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                TablerIcons.microphone,
                size: 36,
                color: Colors.white,
              ),
            ),
            spacing(height: 20),
            Text(
              trans(context, key: 'recording_status'),
              style: StyleHelper.titleLarge(context)?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            spacing(height: 8),
            Text(
              '0:00',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w300,
                color: _isDark ? AppColors.light60 : AppColors.greyText,
              ),
            ),
            spacing(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRecordingAction(
                  icon: TablerIcons.x,
                  label: trans(context, key: 'cancel'),
                  color: _isDark ? AppColors.grey80 : AppColors.grey30,
                  iconColor: _isDark ? AppColors.light80 : AppColors.darkText,
                  onTap: () => Navigator.pop(context),
                ),
                _buildRecordingAction(
                  icon: TablerIcons.send,
                  label: trans(context, key: 'send'),
                  color: AppColors.primary,
                  iconColor: Colors.white,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingAction({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          spacing(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _isDark ? AppColors.light60 : AppColors.greyText,
            ),
          ),
        ],
      ),
    );
  }

  void openAttachmentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AttachmentSheet(),
    );
  }
}
