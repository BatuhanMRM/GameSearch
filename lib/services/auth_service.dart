import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current user getter
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      developer.log("Kayıt işlemi başladı: $email", name: 'AuthService');

      // Create user
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      developer.log(
        "Firebase Auth'da kullanıcı oluşturuldu: ${result.user?.uid}",
        name: 'AuthService',
      );

      // Update display name
      if (result.user != null) {
        await result.user!.updateDisplayName(displayName);
        developer.log(
          "Display name güncellendi: $displayName",
          name: 'AuthService',
        );
      }

      // Firestore işlemini arka planda yap
      _createUserDocument(result.user!, email, displayName);

      developer.log("Kayıt işlemi başarılı!", name: 'AuthService');
      return result;
    } on FirebaseAuthException catch (e) {
      developer.log(
        "FirebaseAuth Error: ${e.code} - ${e.message}",
        name: 'AuthService',
        level: 1000,
      );
      return null;
    } catch (e) {
      developer.log("Genel hata: $e", name: 'AuthService', level: 1000);
      return null;
    }
  }

  // Firestore işlemi
  Future<void> _createUserDocument(
    User user,
    String email,
    String displayName,
  ) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'displayName': displayName,
        'createdAt': FieldValue.serverTimestamp(),
        'favoriteGames': [],
        'reviews': [],
        'profileImageUrl': '',
      });
      developer.log(
        "Firestore'da kullanıcı dökümanı oluşturuldu",
        name: 'AuthService',
      );
    } catch (e) {
      developer.log(
        "Firestore'a yazma hatası: $e",
        name: 'AuthService',
        level: 900,
      );
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      developer.log("Giriş işlemi başladı: $email", name: 'AuthService');

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      developer.log(
        "Giriş başarılı: ${result.user?.email}",
        name: 'AuthService',
      );
      return result;
    } on FirebaseAuthException catch (e) {
      developer.log(
        "Giriş hatası: ${e.code} - ${e.message}",
        name: 'AuthService',
        level: 1000,
      );
      return null;
    } catch (e) {
      developer.log("Genel giriş hatası: $e", name: 'AuthService', level: 1000);
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      developer.log("SignOut metodu çağrıldı", name: 'AuthService');
      await _auth.signOut();
      developer.log("Firebase signOut tamamlandı", name: 'AuthService');
    } catch (e) {
      developer.log("SignOut hatası: $e", name: 'AuthService', level: 1000);
      rethrow;
    }
  }

  // Get user data from Firestore
  Future<DocumentSnapshot?> getUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      return await _firestore.collection('users').doc(user.uid).get();
    } catch (e) {
      developer.log(
        "Get user data error: $e",
        name: 'AuthService',
        level: 1000,
      );
      return null;
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      developer.log(
        "Reset password error: ${e.code} - ${e.message}",
        name: 'AuthService',
        level: 1000,
      );
      return false;
    } catch (e) {
      developer.log(
        "Reset password error: $e",
        name: 'AuthService',
        level: 1000,
      );
      return false;
    }
  }
}
