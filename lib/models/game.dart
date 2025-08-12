class Game {
  final String id;
  final String title;
  final String categoryId;
  final String imageUrl;
  final String description;
  final double rating;
  final int duration; 
  final String steamUrl;
  final String price;
  Game({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.duration,
    required this.steamUrl,
    required this.price,
  });
}
