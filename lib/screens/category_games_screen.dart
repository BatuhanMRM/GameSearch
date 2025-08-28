import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:game_reviews_2/screens/game_detail_screen.dart';
import '../data/dummy_data.dart';
import '../models/game.dart';
import '../main.dart'; // Global filter notifier için

class CategoryGamesScreen extends StatefulWidget {
  final String categoryId;
  final void Function(Game) onToggleFavorite;
  final List<Game> favorites;
  final String? priceFilter;
  final VoidCallback? onOpenFilterDrawer; // Filter drawer açma callback'i

  const CategoryGamesScreen({
    super.key,
    required this.categoryId,
    required this.onToggleFavorite,
    required this.favorites,
    this.priceFilter,
    this.onOpenFilterDrawer,
  });

  @override
  State<CategoryGamesScreen> createState() => _CategoryGamesScreenState();
}

class _CategoryGamesScreenState extends State<CategoryGamesScreen> {
  @override
  void didUpdateWidget(CategoryGamesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Filter değiştiğinde widget'ı yeniden build et
    if (oldWidget.priceFilter != widget.priceFilter) {
      if (kDebugMode) {
        print(
          'Filter changed from ${oldWidget.priceFilter} to ${widget.priceFilter}',
        );
      }
      // setState çağırmaya gerek yok, build otomatik çağrılacak
    }
  }

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
  List<Game> _getFilteredGamesWithFilter(String priceFilter) {
    final categoryGames = dummyGames
        .where((game) => game.categoryId == widget.categoryId)
        .toList();

    if (kDebugMode) {
      print('=== CATEGORY GAMES FILTERING DEBUG ===');
      print('Category ID: ${widget.categoryId}');
      print('Price Filter: $priceFilter');
      print('Category Games Count: ${categoryGames.length}');
      print('Filter is Tümü? ${priceFilter == "Tümü"}');
      for (var game in categoryGames) {
        print(
          'Game: ${game.title}, Price: ${game.price}, Extracted: ${_extractPrice(game.price)}',
        );
      }
    }

    if (priceFilter == 'Tümü') {
      if (kDebugMode) {
        print(
          'No price filter applied, returning ${categoryGames.length} games',
        );
      }
      return categoryGames;
    }

    final filtered = categoryGames.where((game) {
      final price = _extractPrice(game.price);

      if (kDebugMode) {
        print('Checking game ${game.title}: price=$price, filter=$priceFilter');
      }

      bool result;
      switch (priceFilter) {
        case 'Ücretsiz':
          result = price == 0.0;
          break;
        case '0-50 TL':
          result = price > 0 && price <= 50;
          break;
        case '51-100 TL':
          result = price > 50 && price <= 100;
          break;
        case '101-200 TL':
          result = price > 100 && price <= 200;
          break;
        case '201-300 TL':
          result = price > 200 && price <= 300;
          break;
        case '300+ TL':
          result = price > 300;
          break;
        default:
          result = true;
      }

      if (kDebugMode) {
        print('Game ${game.title}: price=$price -> result=$result');
      }

      return result;
    }).toList();

    if (kDebugMode) {
      print('After filtering with $priceFilter: ${filtered.length} games');
      for (var game in filtered) {
        print('Filtered Game: ${game.title}, Price: ${game.price}');
      }
      print('=== END DEBUG ===');
    }

    return filtered;
  }

  // Optimizasyon 3: Kategori başlığı fonksiyonu
  String _getCategoryTitle() {
    final category = dummyCategories.firstWhere(
      (cat) => cat.id == widget.categoryId,
      orElse: () => dummyCategories.first,
    );
    return category.title;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: globalPriceFilter,
      builder: (context, currentFilter, child) {
        if (kDebugMode) {
          print('=== CategoryGamesScreen BUILD ===');
          print('Widget filter: ${widget.priceFilter}');
          print('Global filter: $currentFilter');
        }

        // Global filter'ı kullan, widget priceFilter'ı değil
        final effectiveFilter = currentFilter;

        // Filtrelenmiş oyunları hesapla
        final filteredGames = _getFilteredGamesWithFilter(effectiveFilter);
        final categoryTitle = _getCategoryTitle();

        return _buildScaffold(
          context,
          filteredGames,
          categoryTitle,
          effectiveFilter,
        );
      },
    );
  }

  // Scaffold'u ayrı metoda al
  Widget _buildScaffold(
    BuildContext context,
    List<Game> filteredGames,
    String categoryTitle,
    String effectiveFilter,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$categoryTitle Oyunları'),
            if (effectiveFilter != 'Tümü')
              Text(
                'Filtre: $effectiveFilter',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).primaryColor,
                ),
              ),
          ],
        ),
        // Optimizasyon 5: Sağ tarafta filter kontrolü ve oyun sayısı
        actions: [
          // Filter durumu göstergesi
          if (effectiveFilter != 'Tümü')
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.filter_alt,
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    effectiveFilter,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),

          // Filter butonu
          IconButton(
            icon: Icon(
              Icons.tune,
              color: (effectiveFilter != 'Tümü')
                  ? Theme.of(context).primaryColor
                  : null,
            ),
            onPressed: () {
              if (widget.onOpenFilterDrawer != null) {
                // Ana ekrandan filter drawer'ı aç
                Navigator.pop(context);
                // Callback ile ana ekranda drawer'ı aç
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.onOpenFilterDrawer!();
                });
              }
            },
            tooltip: 'Filtreleri Aç',
          ),

          // Oyun sayısı
          if (filteredGames.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    key: ValueKey(filteredGames.length),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      '${filteredGames.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
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
            ? _buildEmptyState(effectiveFilter)
            : _buildGamesList(filteredGames),
      ),
    );
  }

  // Optimizasyon 6: Empty state ayrı widget
  Widget _buildEmptyState(String currentFilter) {
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
          if (currentFilter != 'Tümü') ...[
            const SizedBox(height: 8),
            Text(
              'Filtre: $currentFilter',
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
        final isFavorite = widget.favorites.contains(game);

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
      onPressed: () => widget.onToggleFavorite(game),
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
