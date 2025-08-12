import 'package:flutter/material.dart';
import '../models/game.dart';
import '../widgets/game_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Game> favorites;

  const FavoritesScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: favorites.isEmpty
          ? Center(child: Text('Henüz favori oyun eklenmedi.'))
          : ListView(
              children: favorites
                  .map(
                    (game) => GameCard(
                      game: game,
                      isFavorite: true,
                      onFavoriteToggle: () {}, // sadece görüntüleme
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
