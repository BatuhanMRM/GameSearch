class Comment {
  final String id;
  final String userName;
  final String comment;
  final String gameName;
  final int rating;
  final DateTime date;

  const Comment({
    required this.id,
    required this.userName,
    required this.comment,
    required this.gameName,
    required this.rating,
    required this.date,
  });
}
