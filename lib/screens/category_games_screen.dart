import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:game_reviews_2/screens/game_detail_screen.dart';
import '../data/dummy_data.dart';
import '../models/game.dart';

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
    this.priceFilter,
  });

  // Optimizasyon 1: Fiyat çıkarma fonksiyonu optimize edildi
  double _extractPrice(String priceText) {
    if (priceText.toLowerCase().contains('ücretsiz')) return 0.0;

    final regExp = RegExp(r'[\d.,]+');
    final match = regExp.stringMatch(priceText);

    if (match != null) {
      final cleanedMatch = match.replaceAll(',', '.');
      return double.tryParse(cleanedMatch) ?? 0.0;
    }

    return 0.0;
  }

  // Optimizasyon 2: Filtreleme fonksiyonu ayrı metoda alındı
  List<Game> _getFilteredGames() {
    final categoryGames = dummyGames
        .where((game) => game.categoryId == categoryId)
        .toList();

    if (priceFilter == null || priceFilter == 'Tümü') {
      return categoryGames;
    }

    return categoryGames.where((game) {
      final price = _extractPrice(game.price);

      switch (priceFilter) {
        case 'Ücretsiz':
          return price == 0.0;
        case '0-50 TL':
          return price > 0 && price <= 50;
        case '51-100 TL':
          return price > 50 && price <= 100;
        case '101-200 TL':
          return price > 100 && price <= 200;
        case '201-300 TL':
          return price > 200 && price <= 300;
        case '300+ TL':
          return price > 300;
        default:
          return true;
      }
    }).toList();
  }

  // Optimizasyon 3: Kategori başlığı fonksiyonu
  String _getCategoryTitle() {
    final category = dummyCategories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => dummyCategories.first,
    );
    return category.title;
  }

  @override
  Widget build(BuildContext context) {
    // Optimizasyon 4: Filtrelenmiş oyunları bir kez hesapla
    final filteredGames = _getFilteredGames();
    final categoryTitle = _getCategoryTitle();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$categoryTitle Oyunları'),
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
        // Optimizasyon 5: Oyun sayısını göster
        actions: [
          if (filteredGames.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    '${filteredGames.length}',
                    key: ValueKey(filteredGames.length),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: filteredGames.isEmpty
            ? _buildEmptyState()
            : _buildGamesList(filteredGames),
      ),
    );
  }

  // Optimizasyon 6: Empty state ayrı widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.games_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Bu kategoride oyun bulunamadı',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          if (priceFilter != null && priceFilter != 'Tümü') ...[
            const SizedBox(height: 8),
            Text(
              'Filtre: $priceFilter',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }

  // Optimizasyon 7: Oyun listesi ayrı widget
  Widget _buildGamesList(List<Game> games) {
    return ListView.builder(
      // Performans optimizasyonu
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        final isFavorite = favorites.contains(game);

        return _buildGameCard(game, isFavorite, index, context);
      },
    );
  }

  // Optimizasyon 8: Game card optimize edildi
  Widget _buildGameCard(
    Game game,
    bool isFavorite,
    int index,
    BuildContext context,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: _buildGameImage(game),
        title: Text(
          game.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: _buildGameSubtitle(game),
        trailing: _buildFavoriteButton(game, isFavorite),
        onTap: () => _navigateToGameDetail(game, context),
      ),
    );
  }

  // Optimizasyon 9: Game image optimize edildi
  Widget _buildGameImage(Game game) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        game.imageUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        // Loading placeholder
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 60,
            height: 60,
            color: Colors.grey[300],
            child: const Icon(Icons.games),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          width: 60,
          height: 60,
          color: Colors.grey[300],
          child: const Icon(Icons.games),
        ),
      ),
    );
  }

  // Optimizasyon 10: Game subtitle optimize edildi
  Widget _buildGameSubtitle(Game game) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${game.rating}⭐ • ${game.duration} dk'),
        const SizedBox(height: 4),
        Text(
          'Fiyat: ${game.price}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Optimizasyon 11: Favorite button optimize edildi
  Widget _buildFavoriteButton(Game game, bool isFavorite) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : null,
      ),
      onPressed: () => onToggleFavorite(game),
      tooltip: isFavorite ? 'Favorilerden çıkar' : 'Favorilere ekle',
    );
  }

  // Optimizasyon 12: Navigation optimize edildi
  void _navigateToGameDetail(Game game, BuildContext context) {
    if (kDebugMode) {
      print('Navigating to: ${game.title}');
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameDetailScreen(game: game)),
    );
  }
}
