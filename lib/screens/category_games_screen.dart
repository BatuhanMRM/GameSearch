import 'package:flutter/material.dart';
import 'package:game_reviews_2/screens/game_detail_screen.dart';
import '../data/dummy_data.dart';
import '../models/game.dart';
import '../widgets/game_card.dart';

class CategoryGamesScreen extends StatelessWidget {
  final String categoryId;
  final void Function(Game) onToggleFavorite;
  final List<Game> favorites;
  final String? priceFilter; 

  const CategoryGamesScreen({
    super.key,
    required this.categoryId,
    required this.onToggleFavorite,
    required this.favorites,
    this.priceFilter, // Opsiyonel priceFilter parametresi
  });

  // Fiyat çıkarma fonksiyonu
  double _extractPrice(String priceText) {
    if (priceText.toLowerCase().contains('ücretsiz')) return 0.0;

    RegExp regExp = RegExp(r'[\d.,]+');
    String? match = regExp.stringMatch(priceText);
    if (match != null) {
      return double.tryParse(match.replaceAll(',', '.')) ?? 0.0;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    var categoryGames = dummyGames.where(
      (game) => game.categoryId == categoryId,
    );

    // Fiyat filtresini uygula
    if (priceFilter != null && priceFilter != 'Tümü') {
      categoryGames = categoryGames.where((game) {
        switch (priceFilter) {
          case 'Ücretsiz':
            return game.price.toLowerCase().contains('ücretsiz');
          case '0-50 TL':
            double price = _extractPrice(game.price);
            return price >= 0 && price <= 50;
          case '51-100 TL':
            double price = _extractPrice(game.price);
            return price >= 51 && price <= 100;
          case '101-200 TL':
            double price = _extractPrice(game.price);
            return price >= 101 && price <= 200;
          case '201-300 TL':
            double price = _extractPrice(game.price);
            return price >= 201 && price <= 300;
          case '300+ TL':
            double price = _extractPrice(game.price);
            return price > 300;
          default:
            return true;
        }
      });
    }

    // Kategori başlığını bul
    final category = dummyCategories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => dummyCategories.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${category.title} Oyunları'),
            if (priceFilter != null && priceFilter != 'Tümü')
              Text(
                'Filtre: $priceFilter',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).primaryColor,
                ),
              ),
          ],
        ),
      ),
      body: categoryGames.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.games_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Bu kategoride ${priceFilter != null && priceFilter != 'Tümü' ? '$priceFilter fiyat aralığında' : ''} oyun bulunamadı',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: categoryGames.length,
              itemBuilder: (context, index) {
                final game = categoryGames.elementAt(index);
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        game.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: Icon(Icons.games),
                        ),
                      ),
                    ),
                    title: Text(game.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${game.rating}⭐ • ${game.duration} dk'),
                        Text(
                          'Fiyat: ${game.price}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        favorites.contains(game)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: favorites.contains(game) ? Colors.red : null,
                      ),
                      onPressed: () => onToggleFavorite(game),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => GameDetailScreen(game: game),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
