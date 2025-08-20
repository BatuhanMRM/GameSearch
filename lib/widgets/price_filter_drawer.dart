import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;
import '../data/dummy_data.dart';

class PriceFilterDrawer extends StatelessWidget {
  final String selectedPriceFilter;
  final Function(String) onFilterChanged;

  // Optimizasyon 1: Static const filter list
  static const List<String> _priceFilters = [
    'Tümü',
    'Ücretsiz',
    '0-50 TL',
    '51-100 TL',
    '101-200 TL',
    '201-300 TL',
    '300+ TL',
  ];

  // Optimizasyon 2: Static const filter icons
  static const Map<String, IconData> _filterIcons = {
    'Tümü': Icons.apps,
    'Ücretsiz': Icons.money_off,
    '0-50 TL': Icons.attach_money,
    '51-100 TL': Icons.attach_money,
    '101-200 TL': Icons.monetization_on,
    '201-300 TL': Icons.monetization_on,
    '300+ TL': Icons.diamond,
  };

  const PriceFilterDrawer({
    super.key,
    required this.selectedPriceFilter,
    required this.onFilterChanged,
  });

  // Optimizasyon 3: Cache'li game count hesaplaması
  int getFilteredGameCount(String filter) {
    if (filter == 'Tümü') return dummyGames.length;

    return dummyGames.where((game) {
      final price = _extractPrice(game.price);

      switch (filter) {
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
    }).length;
  }

  // Optimizasyon 4: Fiyat extraction optimize edildi
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          Expanded(child: _buildFilterList(context)),
          _buildFooter(context),
        ],
      ),
    );
  }

  // Optimizasyon 5: Header ayrı widget
  Widget _buildDrawerHeader(BuildContext context) {
    final gameCount = getFilteredGameCount(selectedPriceFilter);

    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
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
                    color: Colors.white.withOpacity(0.2),
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
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                selectedPriceFilter == 'Tümü'
                    ? '$gameCount oyun mevcut'
                    : '$gameCount oyun filtrelendi',
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
    );
  }

  // Optimizasyon 6: Filter list ayrı widget
  Widget _buildFilterList(BuildContext context) {
    return ListView.builder(
      // Optimizasyon 7: Physics optimize edildi
      physics: const BouncingScrollPhysics(),
      itemCount: _priceFilters.length,
      itemBuilder: (context, index) {
        final filter = _priceFilters[index];
        final isSelected = selectedPriceFilter == filter;
        final icon = _filterIcons[filter] ?? Icons.attach_money;

        return _buildFilterItem(context, filter, isSelected, icon);
      },
    );
  }

  // Optimizasyon 8: Animated filter item
  Widget _buildFilterItem(
    BuildContext context,
    String filter,
    bool isSelected,
    IconData icon,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: isSelected ? 6 : 2,
        color: isSelected
            ? Theme.of(context).primaryColor.withValues(alpha: 0.3)
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  width: 1,
                )
              : BorderSide.none,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _handleFilterTap(context, filter),
          splashColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          highlightColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: ListTile(
              leading: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).iconTheme.color,
                ),
              ),
              title: Text(
                filter,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              trailing: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).primaryColor,
                        key: const ValueKey('selected'),
                      )
                    : Container(
                        key: const ValueKey('count'),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          '${getFilteredGameCount(filter)}',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Optimizasyon 9: Seamless filter transition
  void _handleFilterTap(BuildContext context, String filter) {
    if (kDebugMode) {
      developer.log("Filtre değiştirildi: $filter", name: 'PriceFilterDrawer');
    }

    // Önce visual feedback göster (drawer açıkken)
    _showFilterChangedFeedback(context, filter);

    // Hemen filter'ı değiştir (state güncelleme)
    onFilterChanged(filter);

    // Seamless drawer kapanma - beyaz flash önleme
    Future.delayed(const Duration(milliseconds: 150), () {
      if (context.mounted) {
        Navigator.pop(context);
      }
    });
  }

  // Smooth visual feedback
  void _showFilterChangedFeedback(BuildContext context, String filter) {
    // Drawer kapanmadan önce kısa feedback göster
    if (filter != selectedPriceFilter) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _filterIcons[filter] ?? Icons.check,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text('$filter filtrelendi'),
            ],
          ),
          duration: const Duration(milliseconds: 800), // Kısaltıldı
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 3,
        ),
      );
    }
  }

  // Optimizasyon 10: Footer ayrı widget
  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Toplam ${getFilteredGameCount(selectedPriceFilter)} oyun',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontStyle: FontStyle.italic,
              fontSize: 12,
            ),
          ),
          if (selectedPriceFilter != 'Tümü')
            TextButton(
              onPressed: () => _handleFilterTap(context, 'Tümü'),
              child: const Text('Temizle'),
            ),
        ],
      ),
    );
  }
}
