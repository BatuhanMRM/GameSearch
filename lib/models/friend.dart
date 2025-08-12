class Friend {
  final String id;
  final String name;
  final bool isOnline;
  final String lastSeen;
  final String avatarUrl;
  final String currentGame;
  final bool hasUnreadMessages;

  const Friend({
    required this.id,
    required this.name,
    required this.isOnline,
    required this.lastSeen,
    required this.avatarUrl,
    required this.currentGame,
    required this.hasUnreadMessages,
  });
}
