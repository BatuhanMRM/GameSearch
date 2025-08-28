import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../data/dummy_data.dart';
import '../widgets/categories_grid.dart';
import '../widgets/comment_section.dart';
import '../models/game.dart';
import '../models/comment.dart';
import 'friends_screen.dart';

class CategoriesScreen extends StatefulWidget {
  final void Function(Game) onToggleFavorite;
  final List<Game> favorites;
  final String selectedPriceFilter; // Ekle
  final Function(String) onFilterChanged; // Ekle
  final VoidCallback? onOpenFilterDrawer; // Filter drawer callback'i

  const CategoriesScreen({
    super.key,
    required this.onToggleFavorite,
    required this.favorites,
    required this.selectedPriceFilter, // Ekle
    required this.onFilterChanged, // Ekle
    this.onOpenFilterDrawer,
  });

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Comment> comments = List.from(dummyComments);

  void _onAddComment(Comment newComment) {
    setState(() {
      comments.insert(0, newComment);
    });
    developer.log(
      "Ana ekrana yorum eklendi: ${newComment.comment}",
      name: 'CategoriesScreen',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Oyun Kategorileri'),
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
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: const Text(
                      '3',
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
                MaterialPageRoute(builder: (context) => const FriendsScreen()),
              );
            },
            tooltip: 'Arkadaşlar',
          ),

          // Aktif filtreyi göster
          if (widget.selectedPriceFilter != 'Tümü')
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
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
                  const SizedBox(width: 4),
                  Text(
                    widget.selectedPriceFilter,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      widget.onFilterChanged('Tümü');
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
          // Kategoriler grid'i
          CategoriesGrid(
            onToggleFavorite: widget.onToggleFavorite,
            favorites: widget.favorites,
            selectedPriceFilter: widget.selectedPriceFilter, // Geçir
            onOpenFilterDrawer: widget.onOpenFilterDrawer, // Callback'i geçir
          ),

          // Comment section
          Expanded(
            child: CommentSection(
              comments: comments,
              onAddComment: _onAddComment,
            ),
          ),
        ],
      ),
    );
  }
}
