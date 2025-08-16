import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../data/dummy_data.dart';

class PriceFilterDrawer extends StatelessWidget {
  final String selectedPriceFilter;
  final Function(String) onFilterChanged;
  final List<String> priceFilters = const [
    'Tümü',
    'Ücretsiz',
    '0-50 TL',
    '51-100 TL',
    '101-200 TL',
    '201-300 TL',
    '300+ TL',
  ];

  const PriceFilterDrawer({
    super.key,
    required this.selectedPriceFilter,
    required this.onFilterChanged,
  });

  int getFilteredGameCount(String filter) {
    if (filter == 'Tümü') return dummyGames.length;

    return dummyGames.where((game) {
      switch (filter) {
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
    }).length;
  }

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
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fiyat Filtreleri',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Oyunları fiyata göre filtrele',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      selectedPriceFilter == 'Tümü'
                          ? '${dummyGames.length} oyun mevcut'
                          : '${getFilteredGameCount(selectedPriceFilter)} oyun filtrelendi',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: priceFilters.length,
              itemBuilder: (context, index) {
                final filter = priceFilters[index];
                final isSelected = selectedPriceFilter == filter;

                return ListTile(
                  leading: Icon(
                    filter == 'Ücretsiz' ? Icons.money_off : Icons.attach_money,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    filter,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.onSurface,
                        )
                      : null,
                  onTap: () {
                    developer.log(
                      "Filtre değiştirildi: $filter",
                      name: 'PriceFilterDrawer',
                    );
                    onFilterChanged(filter);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Toplam ${getFilteredGameCount(selectedPriceFilter)} oyun',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
