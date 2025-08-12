import 'package:flutter/material.dart';
import '../models/game.dart';
import '../screens/game_detail_screen.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const GameCard({
    super.key,
    required this.game,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(game.title),
        leading: Hero(
          tag: 'game-image-${game.id}',
          child: Image.network(
            game.imageUrl,
            width: 100,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: onFavoriteToggle,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => GameDetailScreen(game: game)),
          );
        },
      ),
    );
  }
}
