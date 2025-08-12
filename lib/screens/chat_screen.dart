import 'package:flutter/material.dart';
import '../models/friend.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  final Friend friend;

  const ChatScreen({super.key, required this.friend});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    // Örnek mesajlar
    messages.addAll([
      Message(
        id: '1',
        senderId: widget.friend.id,
        receiverId: 'currentUser',
        content: 'Merhaba! Nasılsın?',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
      ),
      Message(
        id: '2',
        senderId: 'currentUser',
        receiverId: widget.friend.id,
        content: 'İyiyim, sen nasılsın? Hangi oyunu oynuyorsun?',
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: widget.friend.avatarUrl.isNotEmpty
                  ? NetworkImage(widget.friend.avatarUrl)
                  : null,
              backgroundColor: Theme.of(context).primaryColor,
              child: widget.friend.avatarUrl.isEmpty
                  ? Text(
                      widget.friend.name[0].toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    )
                  : null,
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.friend.name),
                Text(
                  widget.friend.isOnline ? 'Çevrimiçi' : widget.friend.lastSeen,
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.friend.isOnline ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videogame_asset),
            onPressed: _showGameInvite,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages.reversed.elementAt(index);
                final isMe = message.senderId == 'currentUser';

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      if (!isMe) ...[
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            widget.friend.name[0].toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.content,
                              style: TextStyle(
                                color: isMe ? Colors.white : null,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 10,
                                color: isMe ? Colors.white70 : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isMe) ...[
                        SizedBox(width: 8),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.blue,
                          child: Text(
                            'Sen',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Mesaj yaz...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: () => _sendMessage(_messageController.text),
                  child: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add(
        Message(
          id: '${messages.length + 1}',
          senderId: 'currentUser',
          receiverId: widget.friend.id,
          content: text.trim(),
          timestamp: DateTime.now(),
        ),
      );
    });

    _messageController.clear();
  }

  void _showGameInvite() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Oyun Davet Et'),
        content: Text(
          '${widget.friend.name} kişisini oyuna davet etmek istediğinden emin misin?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _sendMessage('🎮 Oyun davetim var! Katılmak ister misin?');
            },
            child: Text('Davet Et'),
          ),
        ],
      ),
    );
  }
}
