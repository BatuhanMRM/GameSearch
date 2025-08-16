import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:game_reviews_2/screens/profile_screen.dart';
import 'package:game_reviews_2/screens/settings_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/auth_screen.dart';
import 'services/auth_service.dart';
import 'models/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    developer.log("Firebase başarıyla başlatıldı", name: 'Firebase');
  } catch (e) {
    developer.log(
      "Firebase başlatma hatası: $e",
      name: 'Firebase',
      level: 1000,
    );
  }

  runApp(GameApp());
}

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final List<Game> _favoriteGames = [];
  final AuthService _authService = AuthService();
  ThemeMode _themeMode = ThemeMode.light;
  int _selectedIndex = 0;

  void toggleFavorite(Game game) {
    setState(() {
      if (_favoriteGames.contains(game)) {
        _favoriteGames.remove(game);
      } else {
        _favoriteGames.add(game);
      }
    });
  }

  void changeTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Logout işlemini ayrı metoda alın - Context güvenli
  Future<void> _handleLogoutPress(BuildContext context) async {
    developer.log("Çıkış butonuna tıklandı!", name: 'MainApp');

    try {
      // mounted kontrolü ekleyin
      if (!mounted) {
        developer.log("Widget dispose olmuş, çıkış iptal", name: 'MainApp');
        return;
      }

      await _authService.signOut();

      // Async işlem sonrası mounted kontrolü
      if (!mounted) {
        developer.log("Async sonrası widget dispose olmuş", name: 'MainApp');
        return;
      }

      developer.log("Çıkış başarılı", name: 'MainApp');
    } catch (e) {
      developer.log("Çıkış hatası: $e", name: 'MainApp', level: 1000);

      // Hata durumunda da mounted kontrolü
      if (!mounted || !context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Çıkış hatası: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Game Reviews',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(useMaterial3: true),
      themeMode: _themeMode,
      home: StreamBuilder<User?>(
        stream: _authService.authStateChanges,
        builder: (context, snapshot) {
          developer.log(
            "StreamBuilder tetiklendi - Data: ${snapshot.data?.email}",
            name: 'MainApp',
          );

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Yükleniyor...'),
                  ],
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            developer.log(
              "StreamBuilder hatası: ${snapshot.error}",
              name: 'MainApp',
              level: 1000,
            );
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Hata: ${snapshot.error}'),
                  ],
                ),
              ),
            );
          }

          final user = snapshot.data;

          if (user != null) {
            developer.log(
              "Kullanıcı var, ana ekran gösteriliyor: ${user.email}",
              name: 'MainApp',
            );
            return _buildMainScreen(user);
          } else {
            developer.log(
              "Kullanıcı yok, auth ekranı gösteriliyor",
              name: 'MainApp',
            );
            return const AuthScreen();
          }
        },
      ),
    );
  }

  Widget _buildMainScreen(User user) {
    final pages = [
      CategoriesScreen(
        onToggleFavorite: toggleFavorite,
        favorites: _favoriteGames,
      ),
      FavoritesScreen(favorites: _favoriteGames),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Game Search' : 'Favoriler'),
        actions: [
          // Profile button - Builder ile context'i koruyalım
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ProfileScreen(email: user.email ?? ''),
                    ),
                  );
                },
              );
            },
          ),
          // Settings button - Builder ile context'i koruyalım
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => SettingsScreen(
                        isDarkMode: _themeMode == ThemeMode.dark,
                        onThemeChanged: changeTheme,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          // Logout button - Güvenli context kontrolü ile
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _handleLogoutPress(context),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Game Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoriler",
          ),
        ],
      ),
    );
  }
}
