import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/conversation/widgets/chat_attachment.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// Widget representing a chat bubble in the conversation screens.
class ChatBubble extends StatefulWidget {
  /// Constructs a [ChatBubble].
  const ChatBubble({
    super.key,
    this.data,
    this.onReply,
    this.onReact,
  });

  /// Data representing the chat message.
  final dynamic data;
  
  /// Callback when replying to a message.
  final Function(dynamic message)? onReply;
  
  /// Callback when reacting to a message.
  final Function(dynamic message, String emoji)? onReact;

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> with SingleTickerProviderStateMixin {
  String? _selectedReaction;
  bool _showActions = false;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final bool isIncoming = widget.data['sender'] != 'Me';
    _selectedReaction = widget.data['reaction'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Slidable(
        key: ValueKey(widget.data['id'] ?? widget.data['time']),
        startActionPane: !isIncoming ? null : _buildReplyAction(),
        endActionPane: isIncoming ? null : _buildReplyAction(),
        child: Align(
          alignment: isIncoming ? Alignment.centerLeft : Alignment.centerRight,
          child: GestureDetector(
            onLongPress: () => _showMessageActions(context, isIncoming),
            onDoubleTap: () => _quickReact('❤️'),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.78,
              ),
              child: Column(
                crossAxisAlignment: isIncoming ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  if (widget.data['replyTo'] != null)
                    _buildReplyPreview(widget.data['replyTo'], isIncoming),
                  _buildMessageContent(isIncoming),
                  _buildMessageFooter(isIncoming),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ActionPane _buildReplyAction() {
    return ActionPane(
      motion: const BehindMotion(),
      extentRatio: 0.15,
      children: [
        CustomSlidableAction(
          onPressed: (context) => widget.onReply?.call(widget.data),
          backgroundColor: Colors.transparent,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              TablerIcons.corner_up_left,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageContent(bool isIncoming) {
    final Color bubbleColor = isIncoming
        ? (_isDark ? AppColors.grey90 : AppColors.grey20)
        : AppColors.primary;

    return Column(
      crossAxisAlignment: isIncoming ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        if (widget.data?['screens'] != null)
          _buildAttachmentWrapper(isIncoming),
        if (widget.data?['message'] != null && widget.data?['message'] != '')
          _buildTextBubble(isIncoming, bubbleColor),
      ],
    );
  }

  Widget _buildAttachmentWrapper(bool isIncoming) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ChatAttachment(data: widget.data),
    );
  }

  Widget _buildTextBubble(bool isIncoming, Color bubbleColor) {
    final Color textColor = isIncoming
        ? (_isDark ? AppColors.light80 : AppColors.darkText)
        : Colors.white;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isIncoming ? 4 : 18),
              bottomRight: Radius.circular(isIncoming ? 18 : 4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(
              '${widget.data['message']}',
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ),
        if (_selectedReaction != null)
          Positioned(
            bottom: -10,
            right: isIncoming ? null : 12,
            left: isIncoming ? 12 : null,
            child: _buildReactionBadge(bubbleColor),
          ),
      ],
    );
  }

  Widget _buildReactionBadge(Color bubbleColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: _isDark ? AppColors.grey100 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        _selectedReaction!,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildMessageFooter(bool isIncoming) {
    return Padding(
      padding: EdgeInsets.only(
        top: _selectedReaction != null ? 12 : 4,
        left: 4,
        right: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: isIncoming ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Text(
            getTimeFormat(widget.data['time']),
            style: TextStyle(
              fontSize: 11,
              color: _isDark ? AppColors.light60 : AppColors.greyText,
            ),
          ),
          if (!isIncoming) ...[
            spacing(width: 4),
            _buildReadStatus(),
          ],
        ],
      ),
    );
  }

  Widget _buildReadStatus() {
    final bool isRead = widget.data['isRead'] ?? true;
    return Icon(
      isRead ? TablerIcons.checks : TablerIcons.check,
      size: 16,
      color: isRead ? AppColors.tealGreen : (_isDark ? AppColors.light60 : AppColors.greyText),
    );
  }

  Widget _buildReplyPreview(dynamic replyData, bool isIncoming) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _isDark
            ? AppColors.grey80.withValues(alpha: 0.5)
            : AppColors.grey20.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: isIncoming ? AppColors.primary : Colors.white.withValues(alpha: 0.5),
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            replyData['sender'] ?? 'Unknown',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: isIncoming ? AppColors.primary : AppColors.primary.withValues(alpha: 0.8),
            ),
          ),
          spacing(height: 2),
          Text(
            replyData['message'] ?? '',
            style: TextStyle(
              fontSize: 13,
              color: _isDark ? AppColors.light60 : AppColors.greyText,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _quickReact(String emoji) {
    setState(() {
      _selectedReaction = _selectedReaction == emoji ? null : emoji;
    });
    widget.onReact?.call(widget.data, emoji);
  }

  void _showMessageActions(BuildContext context, bool isIncoming) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: _isDark ? AppColors.grey100 : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: _isDark ? AppColors.grey80 : AppColors.grey30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _buildQuickReactions(),
            Divider(
              height: 1,
              color: _isDark ? AppColors.grey80 : AppColors.grey20,
            ),
            _buildActionsList(context),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReactions() {
    final List<String> reactions = ['❤️', '👍', '😂', '😮', '😢', '🙏', '🔥', '👎'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: reactions.map((emoji) {
          final bool isSelected = _selectedReaction == emoji;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedReaction = isSelected ? null : emoji;
              });
              widget.onReact?.call(widget.data, emoji);
              Navigator.pop(context);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2)
                    : null,
              ),
              child: Text(
                emoji,
                style: TextStyle(fontSize: isSelected ? 28 : 24),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionsList(BuildContext context) {
    return Column(
      children: [
        _buildActionTile(
          icon: TablerIcons.corner_up_left,
          title: trans(context, key: 'reply'),
          onTap: () {
            Navigator.pop(context);
            widget.onReply?.call(widget.data);
          },
        ),
        _buildActionTile(
          icon: TablerIcons.copy,
          title: trans(context, key: 'copy'),
          onTap: () => Navigator.pop(context),
        ),
        _buildActionTile(
          icon: TablerIcons.share,
          title: trans(context, key: 'forward'),
          onTap: () => Navigator.pop(context),
        ),
        _buildActionTile(
          icon: TablerIcons.star,
          title: trans(context, key: 'star'),
          onTap: () => Navigator.pop(context),
        ),
        _buildActionTile(
          icon: TablerIcons.trash,
          title: trans(context, key: 'delete'),
          isDestructive: true,
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final Color color = isDestructive
        ? Colors.red
        : (_isDark ? AppColors.light80 : AppColors.darkText);

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.withValues(alpha: 0.1)
              : (_isDark ? AppColors.grey90 : AppColors.grey20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    );
  }
}
