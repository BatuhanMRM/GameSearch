import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../widgets/category_card.dart';
import '../screens/category_games_screen.dart';
import '../models/game.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Kategoriler grid'i
        SizedBox(
          height: 200,
          child: GridView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 20,
              mainAxisSpacing: 5,
              childAspectRatio: 1,
            ),
            children: dummyCategories
                .take(8)
                .map(
                  (cat) => CategoryCard(
                    category: cat,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => CategoryGamesScreen(
                            categoryId: cat.id,
                            onToggleFavorite: onToggleFavorite,
                            favorites: favorites,
                            priceFilter: selectedPriceFilter,
                          ),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),
        ),

        // Divider
        Container(
          height: 5,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.7),
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.surfaceTint,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
      ],
    );
  }
}
