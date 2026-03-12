import 'package:chat_flow/core/theme/app_theme.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/data/archived_chats_data.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

/// Screen to display and manage archived chats
class ChatArchiveScreen extends StatefulWidget {
  const ChatArchiveScreen({super.key});

  @override
  State<ChatArchiveScreen> createState() => _ChatArchiveScreenState();
}

class _ChatArchiveScreenState extends State<ChatArchiveScreen> {
  String searchQuery = '';
  bool isSelectionMode = false;
  final Set<String> selectedChats = {};
  List<dynamic> archivedChats = ArchivedChatsData.list;

  List<dynamic> get filteredChats {
    if (searchQuery.isEmpty) return archivedChats;
    
    return archivedChats.where((chat) =>
        chat['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
        chat['lastMessage'].toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSelectionMode
            ? '${selectedChats.length} ${trans(context, key: 'selected')}'
            : trans(context, key: 'archived_chats')),
        leading: isSelectionMode
            ? IconButton(
                onPressed: _cancelSelection,
                icon: const Icon(Icons.close),
              )
            : null,
        actions: isSelectionMode
            ? [
                IconButton(
                  onPressed: _unarchiveSelected,
                  icon: const Icon(TablerIcons.archive_off),
                  tooltip: trans(context, key: 'unarchive'),
                ),
                IconButton(
                  onPressed: _deleteSelected,
                  icon: const Icon(TablerIcons.trash),
                  tooltip: trans(context, key: 'delete'),
                ),
              ]
            : [
                IconButton(
                  onPressed: _showOptions,
                  icon: const Icon(TablerIcons.dots_vertical),
                ),
              ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildInfoBanner(),
          Expanded(
            child: filteredChats.isEmpty
                ? _buildEmptyState()
                : _buildChatsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const .all(15),
      child: TextFormField(
        decoration: fieldDeco(
          hintText: trans(context, key: 'search_archived_chats'),
          prefixIcon: TablerIcons.search,
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      margin: const .symmetric(horizontal: 15, vertical: 8),
      padding: const .all(12),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: .circular(8),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            TablerIcons.info_circle,
            size: 20,
            color: AppColors.secondary,
          ),
          spacing(width: 12),
          Expanded(
            child: Text(
              trans(context, key: 'archived_chats_are_hidden_from_your_chats_list'),
              style: TextStyle(
                fontSize: 13,
                color: isDarkTheme(context) 
                    ? AppColors.light80 
                    : AppColors.darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatsList() {
    return ListView.builder(
      padding: const .symmetric(vertical: 8),
      itemCount: filteredChats.length,
      itemBuilder: (context, index) {
        final chat = filteredChats[index];
        final isSelected = selectedChats.contains(chat['id']);
        
        return _buildChatItem(chat, isSelected);
      },
    );
  }

  Widget _buildChatItem(dynamic chat, bool isSelected) {
    return InkWell(
      onTap: () => isSelectionMode
          ? _toggleSelection(chat['id'])
          : _openChat(chat),
      onLongPress: () => _startSelection(chat['id']),
      child: Container(
        padding: const .symmetric(horizontal: 15, vertical: 12),
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        child: Row(
          children: [
            // Selection checkbox
            if (isSelectionMode) ...[
              Checkbox(
                value: isSelected,
                onChanged: (_) => _toggleSelection(chat['id']),
                activeColor: AppColors.primary,
              ),
              spacing(width: 8),
            ],
            
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: chat['avatarUrl'] != null
                  ? ClipOval(child: Image.network(chat['avatarUrl']))
                  : Text(
                      chat['name'][0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
            ),
            spacing(width: 12),
            
            // Chat info
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat['name'],
                          style: StyleHelper.titleMedium(context)?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTimestamp(DateTime.parse(chat['timestamp'])),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkTheme(context)
                              ? AppColors.light60
                              : AppColors.greyText,
                        ),
                      ),
                    ],
                  ),
                  spacing(height: 4),
                  Row(
                    children: [
                      if (chat['isGroup'] == true)
                        Padding(
                          padding: const .only(right: 4),
                          child: Icon(
                            TablerIcons.users,
                            size: 14,
                            color: isDarkTheme(context)
                                ? AppColors.light60
                                : AppColors.greyText,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          chat['lastMessage'],
                          style: StyleHelper.titleSmall(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat['unreadCount'] > 0)
                        Container(
                          margin: const .only(left: 8),
                          padding: const .symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.tealGreen,
                            borderRadius: .circular(10),
                          ),
                          child: Text(
                            chat['unreadCount'].toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Archive indicator
            if (!isSelectionMode) ...[
              spacing(width: 8),
              Icon(
                TablerIcons.archive,
                size: 18,
                color: Colors.grey.withValues(alpha: 0.5),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Icon(
            TablerIcons.archive,
            size: 80,
            color: Colors.grey.withValues(alpha: 0.3),
          ),
          spacing(height: 16),
          Text(
            trans(context, key: 'no_archived_chats'),
            style: StyleHelper.titleLarge(context)?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          spacing(height: 8),
          Padding(
            padding: const .symmetric(horizontal: 40),
            child: Text(
              trans(context, key: 'archive_chats_to_hide_them_from_your_main_list'),
              style: StyleHelper.titleSmall(context),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays == 0) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return trans(context, key: 'yesterday');
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _openChat(dynamic chat) {
    // Navigate to chat conversation
    // TODO: Implement navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(trans(context, key: 'opening_chat_with').replaceFirst('{name}', chat['name']))),
    );
  }

  void _startSelection(String chatId) {
    setState(() {
      isSelectionMode = true;
      selectedChats.add(chatId);
    });
  }

  void _toggleSelection(String chatId) {
    setState(() {
      if (selectedChats.contains(chatId)) {
        selectedChats.remove(chatId);
        if (selectedChats.isEmpty) {
          isSelectionMode = false;
        }
      } else {
        selectedChats.add(chatId);
      }
    });
  }

  void _cancelSelection() {
    setState(() {
      isSelectionMode = false;
      selectedChats.clear();
    });
  }

  void _unarchiveSelected() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(trans(context, key: 'unarchive_chats').replaceFirst('{count}', selectedChats.length.toString())),
        content: Text(trans(context, key: 'these_chats_will_be_moved_back_to_your_chats_list')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(trans(context, key: 'cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement unarchive logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${selectedChats.length} chat(s) unarchived'),
                ),
              );
              _cancelSelection();
            },
            child: Text(trans(context, key: 'unarchive')),
          ),
        ],
      ),
    );
  }

  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(trans(context, key: 'delete_chats').replaceFirst('{count}', selectedChats.length.toString())),
        content: Text(trans(context, key: 'this_action_cannot_be_undone')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(trans(context, key: 'cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${selectedChats.length} chat(s) deleted'),
                ),
              );
              _cancelSelection();
            },
            child: Text(trans(context, key: 'delete'), style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const .all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const .vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(TablerIcons.archive_off),
              title: Text(trans(context, key: 'unarchive_all')),
              onTap: () {
                Navigator.pop(context);
                _unarchiveAll();
              },
            ),
            ListTile(
              leading: Icon(TablerIcons.trash, color: AppColors.accent),
              title: Text(trans(context, key: 'delete_all'), style: TextStyle(color: AppColors.accent)),
              onTap: () {
                Navigator.pop(context);
                _deleteAll();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _unarchiveAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(trans(context, key: 'unarchive_all_chats')),
        content: Text(trans(context, key: 'all_archived_chats_will_be_moved_back_to_your_chats_list')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(trans(context, key: 'cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement unarchive all logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(trans(context, key: 'all_chats_unarchived'))),
              );
            },
            child: Text(trans(context, key: 'unarchive_all')),
          ),
        ],
      ),
    );
  }

  void _deleteAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(trans(context, key: 'delete_all_archived_chats')),
        content: Text(trans(context, key: 'this_action_cannot_be_undone')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(trans(context, key: 'cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete all logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(trans(context, key: 'all_archived_chats_deleted'))),
              );
            },
            child: Text(trans(context, key: 'delete_all'), style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }
}


