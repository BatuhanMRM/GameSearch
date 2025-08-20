import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:game_reviews_2/screens/profile_screen.dart';
import 'package:game_reviews_2/screens/settings_screen.dart';
import 'package:game_reviews_2/widgets/price_filter_drawer.dart';
import 'screens/categories_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/auth_screen.dart';
import 'services/auth_service.dart';
import 'models/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    if (kDebugMode) {
      developer.log("Firebase başarıyla başlatıldı", name: 'Firebase');
    }
  } catch (e) {
    if (kDebugMode) {
      developer.log(
        "Firebase başlatma hatası: $e",
        name: 'Firebase',
        level: 1000,
      );
    }
  }

  runApp(const GameApp());
}

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> with TickerProviderStateMixin {
  // Tek seferlik key'ler
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  final List<Game> _favoriteGames = [];
  final AuthService _authService = AuthService();

  ThemeMode _themeMode = ThemeMode.light;
  int _selectedIndex = 0;
  String _selectedPriceFilter = 'Tümü';

  // Cache edilmiş widget'lar - late kaldır, nullable yap
  List<Widget>? _pages;
  PriceFilterDrawer? _cachedDrawer;

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  void _initializePages() {
    _pages = [
      CategoriesScreen(
        onToggleFavorite: toggleFavorite,
        favorites: _favoriteGames,
        selectedPriceFilter: _selectedPriceFilter,
        onFilterChanged: _onFilterChanged,
      ),
      FavoritesScreen(favorites: _favoriteGames),
    ];
  }

  // Pages'i al - her seferinde kontrol et
  List<Widget> _getPages() {
    if (_pages == null) {
      _initializePages();
    }
    return _pages!;
  }

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

  void _onFilterChanged(String filter) {
    if (_selectedPriceFilter != filter) {
      setState(() {
        _selectedPriceFilter = filter;
        // Cache'leri koru, sadece güncelle
        if (_cachedDrawer != null) {
          _cachedDrawer = null; // Yeni filter ile güncellenecek
        }
        // Pages'i koruyalım, rebuild'i önleyelim
      });

      // Log'u sadece debug mode'da çalıştır
      if (kDebugMode) {
        developer.log("Price filter değişti: $filter", name: 'MainApp');
      }
    }
  }

  Future<void> _handleLogoutPress(BuildContext context) async {
    if (kDebugMode) {
      developer.log("Çıkış butonuna tıklandı!", name: 'MainApp');
    }

    try {
      if (!mounted) return;

      await _authService.signOut();

      if (!mounted) return;

      if (kDebugMode) {
        developer.log("Çıkış başarılı", name: 'MainApp');
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log("Çıkış hatası: $e", name: 'MainApp', level: 1000);
      }

      if (!mounted || !context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Çıkış hatası: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Drawer'ı cache'le
  PriceFilterDrawer _getDrawer() {
    _cachedDrawer ??= PriceFilterDrawer(
      selectedPriceFilter: _selectedPriceFilter,
      onFilterChanged: _onFilterChanged,
    );
    return _cachedDrawer!;
  }

  // AppBar actions'ları optimize et
  List<Widget> _buildActions(User user) {
    return [
      Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.person),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProfileScreen(email: user.email ?? ''),
            ),
          ),
        ),
      ),
      Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SettingsScreen(
                isDarkMode: _themeMode == ThemeMode.dark,
                onThemeChanged: changeTheme,
              ),
            ),
          ),
        ),
      ),
      Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _handleLogoutPress(context),
        ),
      ),
    ];
  }

  // Butik filter iconu
  Widget? _buildFilterIcon() {
    if (_selectedIndex != 0) return null;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.tune,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                if (_selectedPriceFilter != 'Tümü') ...[
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
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
          // Debug log'u optimize et
          if (kDebugMode && snapshot.hasData && snapshot.data?.email != null) {
            developer.log("User: ${snapshot.data!.email}", name: 'Auth');
          }

          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Error state
          if (snapshot.hasError) {
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
          return user != null ? _buildMainScreen(user) : const AuthScreen();
        },
      ),
    );
  }

  Widget _buildMainScreen(User user) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _selectedIndex == 0 ? _getDrawer() : null,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            if (_buildFilterIcon() != null) ...[
              _buildFilterIcon()!,
              const SizedBox(width: 4),
            ],
            Transform.translate(
              offset: const Offset(-8, 0),
              child: Text(
                _selectedIndex == 0 ? 'Game Search' : 'Favoriler',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        actions: _buildActions(user),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _getPages(), // _pages yerine _getPages() kullan
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (_selectedIndex != index) {
            setState(() => _selectedIndex = index);
          }
        },
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

  @override
  void dispose() {
    // Cleanup
    _cachedDrawer = null;
    _pages = null;
    super.dispose();
  }
}
