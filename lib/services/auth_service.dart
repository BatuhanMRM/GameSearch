import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // CurrentUser property'si
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Kullanıcı adını tutmak için map
  static final Map<String, String> _userDisplayNames = {};

  // Kayıt metodu - Local storage kullan
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      developer.log(
        '🔥 KAYIT BAŞLIYOR - Email: $email, DisplayName: $displayName',
        name: 'AuthService',
      );

      // Kullanıcı oluştur
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = result.user;
      developer.log(
        '✅ Kullanıcı oluşturuldu: ${user?.uid}',
        name: 'AuthService',
      );

      if (user != null) {
        // DisplayName'i local map'te sakla (Firebase hatası nedeniyle)
        _userDisplayNames[user.uid] = displayName;
        developer.log(
          '💾 DisplayName local olarak saklandı: $displayName',
          name: 'AuthService',
        );

        return user;
      }

      return null;
    } catch (e) {
      developer.log('❌ Kayıt hatası: $e', name: 'AuthService');
      return null;
    }
  }

  // DisplayName'i al (local storage'dan)
  String? getDisplayName() {
    final user = _auth.currentUser;
    if (user != null) {
      final displayName = _userDisplayNames[user.uid];
      developer.log('📖 DisplayName alındı: $displayName', name: 'AuthService');
      return displayName;
    }
    return null;
  }

  // Giriş metodu
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      developer.log('❌ Giriş hatası: $e', name: 'AuthService');
      return null;
    }
  }

  // DisplayName güncelleme metodu (local storage)
  Future<bool> updateDisplayName(String newDisplayName) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _userDisplayNames[user.uid] = newDisplayName;
        developer.log(
          '✅ DisplayName manuel güncellendi: $newDisplayName',
          name: 'AuthService',
        );
        return true;
      }
      return false;
    } catch (e) {
      developer.log('❌ DisplayName güncelleme hatası: $e', name: 'AuthService');
      return false;
    }
  }

  // Çıkış metodu
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      developer.log('❌ Çıkış hatası: $e', name: 'AuthService');
    }
  }
}
