import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../services/auth_service.dart';
import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2), // Daha güzel gradient
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo ve başlık
                  const Icon(
                    Icons.games_rounded,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Game Reviews',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Auth Form
                  AuthForm(onSubmit: _handleAuthSubmit, isLoading: _isLoading),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleAuthSubmit(
    String email,
    String password,
    bool isLogin,
    String? username,
  ) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (isLogin) {
        developer.log("Giriş denemesi başlıyor...", name: 'AuthScreen');

        final result = await _authService.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (result != null) {
          developer.log("Giriş başarılı", name: 'AuthScreen');
          if (mounted) {
            _showSuccessMessage('Giriş başarılı! Hoş geldiniz.');
          }
        } else {
          developer.log("Giriş başarısız", name: 'AuthScreen', level: 900);
          if (mounted) {
            _showErrorMessage('Giriş başarısız. E-mail veya şifre yanlış.');
          }
        }
      } else {
        developer.log("Kayıt denemesi başlıyor...", name: 'AuthScreen');

        if (username == null || username.isEmpty) {
          developer.log("Kullanıcı adı eksik", name: 'AuthScreen', level: 900);
          if (mounted) {
            _showErrorMessage('Kullanıcı adı gerekli.');
            setState(() => _isLoading = false);
          }
          return;
        }

        final result = await _authService.signUpWithEmailAndPassword(
          email: email,
          password: password,
          displayName: username,
        );

        if (result != null) {
          developer.log("Kayıt başarılı", name: 'AuthScreen');
          if (mounted) {
            _showSuccessMessage('Kayıt başarılı! Hoş geldiniz.');
          }
        } else {
          developer.log(
            "Kayıt başarısız olarak algılandı",
            name: 'AuthScreen',
            level: 900,
          );
          if (mounted) {
            _showErrorMessage('Kayıt başarısız. Lütfen tekrar deneyin.');
          }
        }
      }
    } catch (e) {
      developer.log("Exception yakalandı: $e", name: 'AuthScreen', level: 1000);
      if (mounted) {
        _showErrorMessage('Bir hata oluştu: ${e.toString()}');
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      developer.log("Başarı mesajı gösteriliyor: $message", name: 'AuthScreen');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      developer.log(
        "Hata mesajı gösteriliyor: $message",
        name: 'AuthScreen',
        level: 900,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
