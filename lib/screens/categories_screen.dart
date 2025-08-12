import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../widgets/category_card.dart';
import 'category_games_screen.dart';
import 'game_detail_screen.dart'; 
import '../models/game.dart';
import '../models/comment.dart';
import 'friends_screen.dart'; 

class CategoriesScreen extends StatefulWidget {
  final void Function(Game) onToggleFavorite;
  final List<Game> favorites;

  const CategoriesScreen({
    super.key,
    required this.onToggleFavorite,
    required this.favorites,
  });

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Comment> comments = List.from(dummyComments);
  String selectedPriceFilter = 'Tümü'; // Filtre durumu

  // Fiyat aralıkları
  final List<String> priceFilters = [
    'Tümü',
    'Ücretsiz',
    '0-50 TL',
    '51-100 TL',
    '101-200 TL',
    '201-300 TL',
    '300+ TL',
  ];

  // Filtrelenmiş oyunları getir
  List<Game> getFilteredGames() {
    if (selectedPriceFilter == 'Tümü') {
      return dummyGames;
    }

    return dummyGames.where((game) {
      switch (selectedPriceFilter) {
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
    }).toList();
  }

  // Fiyat metninden sayısal değeri çıkar
  double _extractPrice(String priceText) {
    if (priceText.toLowerCase().contains('ücretsiz')) return 0.0;

    RegExp regExp = RegExp(r'[\d.,]+');
    String? match = regExp.stringMatch(priceText);
    if (match != null) {
      return double.tryParse(match.replaceAll(',', '.')) ?? 0.0;
    }
    return 0.0;
  }

  void _showAddCommentDialog() {
    String selectedGameId = '';
    String commentText = '';
    String userName = '';
    int rating = 5;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
              title: Text(
                'Yorum Ekle',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        labelText: 'Adınız',
                        labelStyle: Theme.of(context).textTheme.bodyMedium,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => userName = value,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Oyun Seçin',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedGameId.isEmpty ? null : selectedGameId,
                      items: dummyGames.map((game) {
                        return DropdownMenuItem(
                          value: game.id,
                          child: Text(game.title),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGameId = value ?? '';
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Yorumunuz',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) => commentText = value,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Puan: '),
                        Expanded(
                          child: Slider(
                            value: rating.toDouble(),
                            min: 1,
                            max: 5,
                            divisions: 4,
                            label: rating.toString(),
                            onChanged: (value) {
                              setState(() {
                                rating = value.round();
                              });
                            },
                          ),
                        ),
                        Text('$rating/5'),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'İptal',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    if (userName.isNotEmpty &&
                        selectedGameId.isNotEmpty &&
                        commentText.isNotEmpty) {
                      _addComment(
                        userName,
                        selectedGameId,
                        commentText,
                        rating,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Ekle'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addComment(
    String userName,
    String gameId,
    String commentText,
    int rating,
  ) {
    final game = dummyGames.firstWhere((g) => g.id == gameId);
    final newComment = Comment(
      id: 'cm${comments.length + 1}',
      userName: userName,
      comment: commentText,
      gameName: game.title,
      rating: rating,
      date: DateTime.now(),
    );

    setState(() {
      comments.insert(0, newComment); // En üste ekle
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: Drawer(
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
                padding: EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.filter_list,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
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
                    SizedBox(height: 12),
                    // Alt kısımda filtrelenen oyun sayısını göster
                    Container(
                      padding: EdgeInsets.symmetric(
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
                            : '${getFilteredGames().length} oyun filtrelendi',
                        style: TextStyle(
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
                      filter == 'Ücretsiz'
                          ? Icons.money_off
                          : Icons.attach_money,
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
                      setState(() {
                        selectedPriceFilter = filter;
                      });
                      Navigator.pop(context); // Sadece drawer'ı kapat
                      // _showFilteredGames(); satırını sil
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Toplam ${getFilteredGames().length} oyun',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Oyun İncelemeleri'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          // Arkadaşlar butonu
          IconButton(
            icon: Stack(
              children: [
                Icon(
                  Icons.people,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                // Online arkadaş sayısını göster (eğer dummyFriends varsa)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(minWidth: 12, minHeight: 12),
                    child: Text(
                      '3', // Buraya online arkadaş sayısını yazabilirim
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendsScreen()),
              );
            },
            tooltip: 'Arkadaşlar',
          ),

          // Aktif filtreyi göster
          if (selectedPriceFilter != 'Tümü')
            Container(
              margin: EdgeInsets.only(right: 16),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).primaryColor,
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
                  SizedBox(width: 4),
                  Text(
                    selectedPriceFilter,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPriceFilter = 'Tümü';
                      });
                    },
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Kategoriler kısmı
          SizedBox(
            height: 200,
            child: GridView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                              onToggleFavorite: widget.onToggleFavorite,
                              favorites: widget.favorites,
                              priceFilter:
                                  selectedPriceFilter, // Aktif filtreyi gönder
                            ),
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ),

          // Tema uyumlu divider - düzeltildi
          Container(
            height: 5,
            margin: EdgeInsets.symmetric(horizontal: 20),
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

          // Yorumlar başlığı
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.comment,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8),
                Text(
                  'Son Yorumlar',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineSmall?.color,
                  ),
                ),
                Spacer(),
                TextButton.icon(
                  onPressed: _showAddCommentDialog,
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: Text(
                    'Yorum Ekle',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Yorumlar listesi
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                final game = dummyGames.firstWhere(
                  (g) => g.title == comment.gameName,
                  orElse: () => dummyGames.first,
                );

                return Card(
                  color: Theme.of(context).cardColor,
                  elevation: Theme.of(context).brightness == Brightness.dark
                      ? 8
                      : 4,
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        comment.userName[0].toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      comment.userName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.comment,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.videogame_asset,
                              size: 14,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                            SizedBox(width: 4),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        GameDetailScreen(game: game),
                                  ),
                                );
                              },
                              child: Text(
                                comment.gameName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: List.generate(5, (starIndex) {
                                return Icon(
                                  starIndex < comment.rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  size: 14,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.amber[300]
                                      : Colors
                                            .amber, // Karanlık modda daha açık sarı
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Filtrelenmiş oyunları gösteren dialog
  void _showFilteredGames() {
    final filteredGames = getFilteredGames();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$selectedPriceFilter - ${filteredGames.length} Oyun'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: filteredGames.length,
            itemBuilder: (context, index) {
              final game = filteredGames[index];
              return ListTile(
                leading: Image.network(
                  game.imageUrl,
                  width: 50,
                  height: 30,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.games),
                ),
                title: Text(game.title),
                subtitle: Text(game.price),
                trailing: Text('${game.rating}⭐'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => GameDetailScreen(game: game),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat'),
          ),
        ],
      ),
    );
  }
}
