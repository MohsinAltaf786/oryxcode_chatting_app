class ArchivedChatsData {
  ArchivedChatsData._();

  static final List<dynamic> list = [
    {
      'id': '1',
      'name': 'Old Project Team',
      'lastMessage': 'Great working with you all!',
      'timestamp': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      'unreadCount': 0,
      'isGroup': true,
      'avatarUrl': null,
    },
    {
      'id': '2',
      'name': 'John Smith',
      'lastMessage': 'See you later!',
      'timestamp': DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
      'unreadCount': 2,
      'isGroup': false,
      'avatarUrl': null,
    },
    {
      'id': '3',
      'name': 'Marketing Team',
      'lastMessage': 'Campaign completed successfully',
      'timestamp': DateTime.now().subtract(const Duration(days: 45)).toIso8601String(),
      'unreadCount': 0,
      'isGroup': true,
      'avatarUrl': null,
    },
  ];
}
