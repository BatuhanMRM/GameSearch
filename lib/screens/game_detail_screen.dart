import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer;
import '../models/game.dart';

class GameDetailScreen extends StatefulWidget {
  final Game game;

  const GameDetailScreen({super.key, required this.game});

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  bool _isFavorite = false; // Favoriye eklenme durumu

  void _launchSteamLink(BuildContext context) async {
    try {
      final Uri url = Uri.parse(widget.game.steamUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        developer.log(
          "Steam linki açıldı: ${widget.game.steamUrl}",
          name: 'GameDetail',
        );
      } else {
        throw 'Steam linki açılamadı';
      }
    } catch (e) {
      developer.log("Steam link hatası: $e", name: 'GameDetail', level: 1000);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Steam linki açılamadı: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    // Favori durumuna göre mesaj göster
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? '${widget.game.title} favorilere eklendi! ❤️'
              : '${widget.game.title} favorilerden çıkarıldı! 💔',
        ),
        backgroundColor: _isFavorite ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );

    developer.log(
      "Oyun favori durumu değişti: ${widget.game.title} - $_isFavorite",
      name: 'GameDetail',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Biraz daha büyük app bar
          SliverAppBar(
            expandedHeight: 220, // 180 -> 220
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.game.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18, // 16 -> 18
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'game-image-${widget.game.id}',
                    child: Image.network(
                      widget.game.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.games, size: 60), // 48 -> 60
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16), // 12 -> 16
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Compact info row
                  _buildCompactInfoRow(context),
                  const SizedBox(height: 16), // 12 -> 16
                  // Quick stats
                  _buildQuickStats(context),
                  const SizedBox(height: 16), // 12 -> 16
                  // Description section
                  _buildDescriptionSection(context),
                  const SizedBox(height: 16), // 12 -> 16
                  // Additional info
                  _buildAdditionalInfo(context),
                  const SizedBox(height: 20), // 16 -> 20
                  // Action buttons
                  _buildActionButtons(context),
                  const SizedBox(height: 16), // 12 -> 16
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfoRow(BuildContext context) {
    final isUcretsiz = widget.game.price.toLowerCase().contains('ücretsiz');

    return Row(
      children: [
        // Rating
        _buildCompactInfoItem(
          context,
          Icons.star,
          '${widget.game.rating}/5',
          Colors.amber,
        ),
        const SizedBox(width: 12), // 8 -> 12
        // Duration
        _buildCompactInfoItem(
          context,
          Icons.timer_outlined,
          '${widget.game.duration}dk',
          Colors.blue,
        ),
        const SizedBox(width: 12), // 8 -> 12
        // Price
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ), // 10,6 -> 14,8
            decoration: BoxDecoration(
              color: isUcretsiz ? Colors.green : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10), // 8 -> 10
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isUcretsiz ? Icons.money_off : Icons.attach_money,
                  color: Colors.white,
                  size: 18, // 16 -> 18
                ),
                const SizedBox(width: 6), // 4 -> 6
                Flexible(
                  child: Text(
                    widget.game.price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15, // 13 -> 15
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            Icons.category,
            'Kategori',
            'Aksiyon',
            Colors.purple,
          ),
        ),
        const SizedBox(width: 12), // 8 -> 12
        Expanded(
          child: _buildStatCard(
            context,
            Icons.people,
            'Oyuncular',
            'Çok Oyunculu',
            Colors.green,
          ),
        ),
        const SizedBox(width: 12), // 8 -> 12
        Expanded(
          child: _buildStatCard(
            context,
            Icons.calendar_today,
            'Çıkış',
            '2023',
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12), // 8 -> 12
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10), // 8 -> 10
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20), // 16 -> 20
          const SizedBox(height: 4), // 2 -> 4
          Text(
            label,
            style: TextStyle(
              fontSize: 12, // 10 -> 12
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13, // 11 -> 13
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfoItem(
    BuildContext context,
    IconData icon,
    String value,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ), // 8,6 -> 12,8
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10), // 8 -> 10
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16), // 14 -> 16
          const SizedBox(width: 6), // 4 -> 6
          Text(
            value,
            style: TextStyle(
              fontSize: 14, // 12 -> 14
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Açıklama',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            // titleSmall -> titleMedium
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8), // 6 -> 8
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14), // 10 -> 14
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10), // 8 -> 10
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          ),
          child: Text(
            widget.game.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5, // 1.4 -> 1.5
              fontSize: 15, // 13 -> 15
            ),
            maxLines: 5, // 4 -> 5
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Özellikler',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            // titleSmall -> titleMedium
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8), // 6 -> 8
        Wrap(
          spacing: 8, // 6 -> 8
          runSpacing: 6, // 4 -> 6
          children: [
            _buildFeatureChip(context, 'Tek Oyunculu'),
            _buildFeatureChip(context, 'Çok Oyunculu'),
            _buildFeatureChip(context, 'Maceracı'),
            _buildFeatureChip(context, 'Strateji'),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ), // 8,4 -> 12,6
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14), // 12 -> 14
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13, // 11 -> 13
          fontWeight: FontWeight.w500,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () => _launchSteamLink(context),
            icon: const Icon(Icons.store, size: 20), // 18 -> 20
            label: const Text(
              'Steam\'de Görüntüle',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ), // 14 -> 16
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B2838),
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(vertical: 14), // 10 -> 14
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // 8 -> 10
              ),
            ),
          ),
        ),
        const SizedBox(width: 12), // 8 -> 12
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _toggleFavorite, // Yeni fonksiyon
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: _isFavorite ? Colors.red : null,
                key: ValueKey(_isFavorite), // Animation için key
              ),
            ),
            label: Text(
              _isFavorite ? 'Favoride' : 'Favori',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ), // 14 -> 16
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: _isFavorite ? Colors.red : null,
              side: BorderSide(
                color: _isFavorite
                    ? Colors.red
                    : Theme.of(context).primaryColor,
                width: _isFavorite ? 2 : 1,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14), // 10 -> 14
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // 8 -> 10
              ),
            ),
          ),
        ),
      ],
    );
  }
}
