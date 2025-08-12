import 'package:flutter/material.dart';
import 'package:game_reviews_2/screens/profile_screen.dart';
import 'package:game_reviews_2/screens/settings_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/favorites_screen.dart';
import 'models/game.dart';
import 'widgets/auth_form.dart';

void main() {
  runApp(GameApp());
}

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  final List<Game> _favoriteGames = [];
  ThemeMode _themeMode = ThemeMode.light;
  int _selectedIndex = 0;

  bool _showAuthScreen = true;
  String? _userEmail;

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

  // AuthForm'dan gelen callback
  void _handleAuth(
    String email,
    String password,
    bool isLogin,
    String? username,
  ) {
    setState(() {
      _showAuthScreen = false;
      _userEmail = email;
    });

    // İsteğe bağlı: Kayıt/giriş bilgilerini konsola yazdır
    if (isLogin) {
      print("Giriş yapıldı: $email");
    } else {
      print("Kayıt olundu: $email, Kullanıcı adı: $username");
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      CategoriesScreen(
        onToggleFavorite: toggleFavorite,
        favorites: _favoriteGames,
      ),
      FavoritesScreen(favorites: _favoriteGames),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kategoriler',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: _showAuthScreen
          ? Scaffold(
              backgroundColor: Colors.deepPurple[100],
              body: Center(child: AuthForm(onSubmit: _handleAuth)),
            )
          : Scaffold(
            
              appBar: AppBar(
                title: Text(_selectedIndex == 0 ? 'Kategoriler' : 'Favoriler'),
                actions: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) =>
                                ProfileScreen(email: _userEmail ?? ''),
                          ),
                        );
                      },
                    ),
                  ),
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => SettingsScreen(
                              isDarkMode: _themeMode == ThemeMode.dark,
                              onThemeChanged: changeTheme,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              body: pages[_selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) => setState(() => _selectedIndex = index),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: "Kategoriler",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: "Favoriler",
                  ),
                ],
              ),
            ),
    );
  }
}
