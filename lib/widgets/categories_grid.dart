import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:game_reviews_2/models/game.dart';
import '../data/dummy_data.dart';
import '../screens/category_games_screen.dart';

class CategoriesGrid extends StatelessWidget {
  final void Function(Game) onToggleFavorite;
  final List<Game> favorites;
  final String selectedPriceFilter;

  const CategoriesGrid({
    super.key,
    required this.onToggleFavorite,
    required this.favorites,
    required this.selectedPriceFilter,
  });

  // Optimizasyon 1: Navigation'ı ayrı metoda al
  void _navigateToCategory(BuildContext context, String categoryId) {
    if (kDebugMode) {
      print('Navigating to category: $categoryId');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => CategoryGamesScreen(
          categoryId: categoryId,
          onToggleFavorite: onToggleFavorite,
          favorites: favorites,
          priceFilter: selectedPriceFilter,
        ),
      ),
    );
  }

  // Optimizasyon 2: Category card'ı ayrı widget'a al
  Widget _buildCategoryCard(BuildContext context, category, int index) {
    return Hero(
      // Her kategori için unique hero tag
      tag: 'category_${category.id}',
      child: Material(
        borderRadius: BorderRadius.circular(16),
        elevation: 4,
        shadowColor: category.color.withOpacity(0.3),
        child: InkWell(
          onTap: () => _navigateToCategory(context, category.id),
          borderRadius: BorderRadius.circular(16),
          // Optimizasyon 3: Ripple effect'i optimize et
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [category.color, category.color.withOpacity(0.7)],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Optimizasyon 4: Sabit icon kullan
                Icon(Icons.games_outlined, size: 48, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  category.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        // Optimizasyon 5: Physics'i optimize et
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.3, // Biraz daha kare yapalım
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: dummyCategories.length,
        // Optimizasyon 6: Caching mechanism
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        itemBuilder: (context, index) {
          final category = dummyCategories[index];
          return _buildCategoryCard(context, category, index);
        },
      ),
    );
  }
}
