class CommunityMessagesData {
  CommunityMessagesData._();

  static List<dynamic> getMessages(String communityName, String communityAvatar) {
    return [
      {
        'sender': 'Alice',
        'message': 'Welcome to $communityName!',
        'time': DateTime.now().subtract(const Duration(minutes: 25)).toIso8601String(),
      },
      {
        'sender': 'Bob',
        'message': 'Hi everyone 👋',
        'time': DateTime.now().subtract(const Duration(minutes: 20)).toIso8601String(),
      },
      {
        'sender': 'Me',
        'message': 'Excited to be here!',
        'time': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
      },
      {
        'sender': 'Carol',
        'message': '',
        'time': DateTime.now().subtract(const Duration(minutes: 2)).toIso8601String(),
        'screens': {
          'type': 'image',
          'src': communityAvatar,
        }
      }
    ];
  }
}
