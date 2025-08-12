import 'package:game_reviews_2/models/comment.dart';

import '../models/category.dart';
import '../models/game.dart';
import '../models/friend.dart';
import 'package:flutter/material.dart';

final dummyComments = [
  Comment(
    id: 'cm1',
    userName: 'Ahmet K.',
    comment: 'Harika bir oyun! Kesinlikle tavsiye ederim.',
    gameName: 'The Witcher 3',
    rating: 5,
    date: DateTime.now().subtract(Duration(hours: 2)),
  ),
  Comment(
    id: 'cm2',
    userName: 'Ayşe M.',
    comment: 'Grafikleri muhteşem ama biraz zor.',
    gameName: 'Red Dead Redemption 2',
    rating: 4,
    date: DateTime.now().subtract(Duration(hours: 5)),
  ),
  Comment(
    id: 'cm3',
    userName: 'Mehmet S.',
    comment: 'Çok eğlenceli bir strateji oyunu.',
    gameName: 'Civilization VI',
    rating: 4,
    date: DateTime.now().subtract(Duration(days: 1)),
  ),
];

final dummyCategories = [
  Category(
    id: 'c1',
    title: 'Aksiyon',
    color: Colors.red,
    gradient: LinearGradient(
      colors: [Colors.red, Colors.redAccent, Colors.deepOrange],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  Category(
    id: 'c2',
    title: 'Strateji',
    color: Colors.blue,
    gradient: LinearGradient(
      colors: [Colors.blue, Colors.blueAccent, Colors.indigo],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  Category(
    id: 'c3',
    title: 'RPG',
    color: Colors.pink,
    gradient: LinearGradient(
      colors: [Colors.pink, Colors.pinkAccent, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  Category(
    id: 'c4',
    title: 'FPS',
    color: Colors.orange,
    gradient: LinearGradient(
      colors: [Colors.orange, Colors.orangeAccent, Colors.deepOrange],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  Category(
    id: 'c5',
    title: 'Yarış',
    color: Colors.green,
    gradient: LinearGradient(
      colors: [Colors.green, Colors.greenAccent, Colors.teal],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  Category(
    id: 'c6',
    title: 'Macera',
    color: Colors.teal,
    gradient: LinearGradient(
      colors: [Colors.teal, Colors.tealAccent, Colors.cyan],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  Category(
    id: 'c7',
    title: 'Spor',
    color: Colors.lightBlue,
    gradient: LinearGradient(
      colors: [Colors.lightBlue, Colors.lightBlueAccent, Colors.blue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  Category(
    id: 'c8',
    title: 'Simülasyon',
    color: Colors.brown,
    gradient: LinearGradient(
      colors: [Colors.brown, Colors.brown[600]!, Colors.brown[800]!],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
];

final dummyGames = [
  Game(
    id: 'g1',
    title: 'The Witcher 3',
    categoryId: 'c3',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/292030/header.jpg',
    description: 'Rivyalı Geralt ile epik bir RPG deneyimi.',
    rating: 4.9,
    duration: 200,
    steamUrl: 'https://store.steampowered.com/app/292030',
    price: "39.99 TL",
  ),
  Game(
    id: 'g2',
    title: 'Counter-Strike 2',
    categoryId: 'c4',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/730/header.jpg',
    description: 'Klasik FPS oyunu, takım bazlı çatışma.',
    rating: 4.7,
    duration: 100,
    steamUrl: 'https://store.steampowered.com/app/730',
    price: "Ücretsiz",
  ),
  Game(
    id: 'g3',
    title: 'Age of Empires IV',
    categoryId: 'c2',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/1466860/header.jpg',
    description: 'Tarihi savaşlara yön ver!',
    rating: 4.5,
    duration: 120,
    steamUrl: 'https://store.steampowered.com/app/1466860',
    price: "249.99 TL",
  ),
  Game(
    id: 'g4',
    title: 'Forza Horizon 5',
    categoryId: 'c5',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/1551360/header.jpg',
    description: 'Yarış tutkunları için Meksika yollarında hız.',
    rating: 4.6,
    duration: 80,
    steamUrl: 'https://store.steampowered.com/app/1551360',
    price: "299.99 TL",
  ),
  Game(
    id: 'g5',
    title: 'FIFA 23',
    categoryId: 'c7',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/1811260/header.jpg',
    description: 'Gerçekçi futbol simülasyonu.',
    rating: 4.2,
    duration: 90,
    steamUrl: 'https://store.steampowered.com/app/1811260',
    price: "199.99 TL",
  ),
  Game(
    id: 'g6',
    title: "Baldur's Gate 3",
    categoryId: 'c3',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/1086940/header.jpg',
    description: 'Klasik D&D evreninde derin RPG.',
    rating: 4.8,
    duration: 250,
    steamUrl: 'https://store.steampowered.com/app/1086940',
    price: "399.99 TL",
  ),
  Game(
    id: 'g7',
    title: 'DOOM Eternal',
    categoryId: 'c4',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/782330/header.jpg',
    description: 'Cehenneme karşı savaş!',
    rating: 4.6,
    duration: 60,
    steamUrl: 'https://store.steampowered.com/app/782330',
    price: "149.99 TL",
  ),
  Game(
    id: 'g8',
    title: 'Civilization VI',
    categoryId: 'c2',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/289070/header.jpg',
    description: 'Kendi medeniyetini kur ve geliştir.',
    rating: 4.4,
    duration: 150,
    steamUrl: 'https://store.steampowered.com/app/289070',
    price: "99.99 TL",
  ),
  Game(
    id: 'g9',
    title: 'NBA 2K24',
    categoryId: 'c7',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/2338770/header.jpg',
    description: 'Basketbolun en gerçekçi hali.',
    rating: 4.0,
    duration: 70,
    steamUrl: 'https://store.steampowered.com/app/2338770',
    price: "279.99 TL",
  ),
  Game(
    id: 'g10',
    title: 'Euro Truck Simulator 2',
    categoryId: 'c8',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/227300/header.jpg',
    description: 'Tır sürme simülasyonu.',
    rating: 4.5,
    duration: 300,
    steamUrl: 'https://store.steampowered.com/app/227300',
    price: "49.99 TL",
  ),
  Game(
    id: 'g11',
    title: 'Elden Ring',
    categoryId: 'c3',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/1245620/header.jpg',
    description: 'Karanlık fantastik dünyada zorlu RPG.',
    rating: 4.9,
    duration: 230,
    steamUrl: 'https://store.steampowered.com/app/1245620',
    price: "349.99 TL",
  ),
  Game(
    id: 'g12',
    title: 'Far Cry 6',
    categoryId: 'c1',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/2369390/header.jpg',
    description: 'Gerilla savaşına katıl!',
    rating: 4.1,
    duration: 110,
    steamUrl: 'https://store.steampowered.com/app/2369390',
    price: "179.99 TL",
  ),
  Game(
    id: 'g13',
    title: 'Portal 2',
    categoryId: 'c6',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/620/header.jpg',
    description: 'Zekice hazırlanmış bulmacalar.',
    rating: 4.9,
    duration: 50,
    steamUrl: 'https://store.steampowered.com/app/620',
    price: "29.99 TL",
  ),
  Game(
    id: 'g14',
    title: "Assassin's Creed Valhalla",
    categoryId: 'c1',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/2208920/header.jpg',
    description: 'Viking dünyasında aksiyon.',
    rating: 4.3,
    duration: 160,
    steamUrl: 'https://store.steampowered.com/app/2208920',
    price: "259.99 TL",
  ),
  Game(
    id: 'g15',
    title: 'Flight Simulator',
    categoryId: 'c8',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/1250410/header.jpg',
    description: 'Gerçekçi uçuş deneyimi.',
    rating: 4.7,
    duration: 400,
    steamUrl: 'https://store.steampowered.com/app/1250410',
    price: "329.99 TL",
  ),
  Game(
    id: 'g16',
    title: 'Need for Speed Heat',
    categoryId: 'c5',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/1222670/header.jpg',
    description: 'Gece yarışlarına katıl!',
    rating: 4.2,
    duration: 90,
    steamUrl: 'https://store.steampowered.com/app/1222670',
    price: "199.99 TL",
  ),
  Game(
    id: 'g17',
    title: 'GTA V',
    categoryId: 'c1',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/271590/header.jpg',
    description: 'Özgür bir suç dünyasında yaşa.',
    rating: 4.9,
    duration: 180,
    steamUrl: 'https://store.steampowered.com/app/271590',
    price: "89.99 TL",
  ),
  Game(
    id: 'g18',
    title: 'Terraria',
    categoryId: 'c6',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/105600/header.jpg',
    description: '2D sandbox macera.',
    rating: 4.8,
    duration: 100,
    steamUrl: 'https://store.steampowered.com/app/105600',
    price: "39.99 TL",
  ),
  Game(
    id: 'g19',
    title: 'F1 23',
    categoryId: 'c5',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/2108330/header.jpg',
    description: 'Formula 1 yarış heyecanı.',
    rating: 4.3,
    duration: 85,
    steamUrl: 'https://store.steampowered.com/app/2108330',
    price: "399.99 TL",
  ),
  Game(
    id: 'g20',
    title: 'Skyrim',
    categoryId: 'c3',
    imageUrl:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/489830/header.jpg',
    description: 'Ejderhalarla dolu açık dünya.',
    rating: 4.8,
    duration: 220,
    steamUrl: 'https://store.steampowered.com/app/489830',
    price: "79.99 TL",
  ),
];

final dummyFriends = [
  Friend(
    id: 'f1',
    name: 'Ahmet Yılmaz',
    isOnline: true,
    lastSeen: 'Çevrimiçi',
    avatarUrl: '',
    currentGame: 'Counter-Strike 2',
    hasUnreadMessages: true,
  ),
  Friend(
    id: 'f2',
    name: 'Zeynep Kaya',
    isOnline: true,
    lastSeen: 'Çevrimiçi',
    avatarUrl: '',
    currentGame: 'The Witcher 3',
    hasUnreadMessages: false,
  ),
  Friend(
    id: 'f3',
    name: 'Mehmet Can',
    isOnline: false,
    lastSeen: '2 saat önce',
    avatarUrl: '',
    currentGame: '',
    hasUnreadMessages: false,
  ),
  Friend(
    id: 'f4',
    name: 'Ayşe Demir',
    isOnline: false,
    lastSeen: '1 gün önce',
    avatarUrl: '',
    currentGame: '',
    hasUnreadMessages: true,
  ),
  Friend(
    id: 'f5',
    name: 'Emre Özkan',
    isOnline: true,
    lastSeen: 'Çevrimiçi',
    avatarUrl: '',
    currentGame: 'FIFA 23',
    hasUnreadMessages: false,
  ),
];
