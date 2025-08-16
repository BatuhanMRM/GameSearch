import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../models/comment.dart';
import '../models/game.dart';
import '../data/dummy_data.dart';
import '../screens/game_detail_screen.dart';

class CommentSection extends StatefulWidget {
  final List<Comment> comments;
  final Function(Comment) onAddComment;

  const CommentSection({
    super.key,
    required this.comments,
    required this.onAddComment,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
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
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => userName = value,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Yorumunuz',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) => commentText = value,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Puan: '),
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
                  child: const Text('Ekle'),
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
    try {
      final game = dummyGames.firstWhere((g) => g.id == gameId);
      final newComment = Comment(
        id: 'cm${widget.comments.length + 1}',
        userName: userName,
        comment: commentText,
        gameName: game.title,
        rating: rating,
        date: DateTime.now(),
      );

      developer.log(
        "Yeni yorum eklendi: ${newComment.comment}",
        name: 'CommentSection',
      );
      widget.onAddComment(newComment);
    } catch (e) {
      developer.log(
        "Yorum ekleme hatası: $e",
        name: 'CommentSection',
        level: 1000,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Başlık
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.comment, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Son Yorumlar',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.headlineSmall?.color,
                ),
              ),
              const Spacer(),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.comments.length,
            itemBuilder: (context, index) {
              final comment = widget.comments[index];
              final game = dummyGames.firstWhere(
                (g) => g.title == comment.gameName,
                orElse: () => dummyGames.first,
              );

              return Card(
                color: Theme.of(context).cardColor,
                elevation: Theme.of(context).brightness == Brightness.dark
                    ? 8
                    : 4,
                margin: const EdgeInsets.only(bottom: 12),
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
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.videogame_asset,
                            size: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
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
                          const Spacer(),
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
                                    : Colors.amber,
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
    );
  }
}
