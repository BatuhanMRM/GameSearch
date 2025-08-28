import 'package:flutter/material.dart';
import '../models/friend.dart';
import '../data/dummy_data.dart';
import 'chat_screen.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  List<Friend> friends = List.from(dummyFriends);
  String searchQuery = '';

  List<Friend> get filteredFriends {
    if (searchQuery.isEmpty) {
      return friends;
    }
    return friends
        .where(
          (friend) =>
              friend.name.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Arkadaşlar (${friends.length})'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: _showAddFriendDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Arama çubuğu
          Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Arkadaş ara...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // Online arkadaşlar
          if (filteredFriends.where((f) => f.isOnline).isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 12),
                  SizedBox(width: 8),
                  Text(
                    'Çevrimiçi (${filteredFriends.where((f) => f.isOnline).length})',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            ...filteredFriends
                .where((friend) => friend.isOnline)
                .map((friend) => _buildFriendTile(friend)),
          ],

          // Offline arkadaşlar
          if (filteredFriends.where((f) => !f.isOnline).isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.circle, color: Colors.grey, size: 12),
                  SizedBox(width: 8),
                  Text(
                    'Çevrimdışı (${filteredFriends.where((f) => !f.isOnline).length})',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: filteredFriends
                    .where((friend) => !friend.isOnline)
                    .map((friend) => _buildFriendTile(friend))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFriendTile(Friend friend) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: friend.avatarUrl.isNotEmpty
                  ? NetworkImage(friend.avatarUrl)
                  : null,
              backgroundColor: Theme.of(context).primaryColor,
              child: friend.avatarUrl.isEmpty
                  ? Text(
                      friend.name[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: friend.isOnline ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        title: Text(friend.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              friend.isOnline ? 'Çevrimiçi' : friend.lastSeen,
              style: TextStyle(
                color: friend.isOnline ? Colors.green : Colors.grey,
                fontSize: 12,
              ),
            ),
            if (friend.currentGame.isNotEmpty)
              Text(
                '🎮 ${friend.currentGame}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (friend.hasUnreadMessages)
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            SizedBox(width: 8),
            Icon(Icons.message, color: Theme.of(context).primaryColor),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen(friend: friend)),
          );
        },
      ),
    );
  }

  void _showAddFriendDialog() {
    String friendName = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Arkadaş Ekle'),
        content: TextField(
          decoration: InputDecoration(
            labelText: 'Arkadaş Adı',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => friendName = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (friendName.isNotEmpty) {
                setState(() {
                  friends.add(
                    Friend(
                      id: 'f${friends.length + 1}',
                      name: friendName,
                      isOnline: false,
                      lastSeen: 'Yeni eklendi',
                      avatarUrl: '',
                      currentGame: '',
                      hasUnreadMessages: false,
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: Text('Ekle'),
          ),
        ],
      ),
    );
  }
}
