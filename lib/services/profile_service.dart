import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class ProfileData {
  final String displayName;
  final String? profileImageUrl;
  final String joinDate;

  ProfileData({
    required this.displayName,
    this.profileImageUrl,
    required this.joinDate,
  });
}

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ProfileData> loadUserData(String fallbackEmail) async {
    try {
      developer.log("Kullanıcı verileri yükleniyor...", name: 'ProfileService');

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Kullanıcı bulunamadı');
      }

      // Firebase Auth'dan güvenli veri alma
      String? authDisplayName;
      String? authPhotoURL;

      try {
        authDisplayName = user.displayName;
        authPhotoURL = user.photoURL;
        developer.log(
          "Auth displayName: '$authDisplayName'",
          name: 'ProfileService',
        );
      } catch (e) {
        developer.log(
          "Auth veri alma hatası: $e",
          name: 'ProfileService',
          level: 900,
        );
      }

      // Firestore'dan veri alma
      String? firestoreDisplayName;
      String? firestoreProfileImage;

      try {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          final userData = userDoc.data();
          if (userData != null) {
            firestoreDisplayName = userData['displayName'] as String?;
            firestoreProfileImage = userData['profileImageUrl'] as String?;
          }
        }
      } catch (e) {
        developer.log(
          "Firestore hatası: $e",
          name: 'ProfileService',
          level: 900,
        );
      }

      // Final veriyi belirle
      final finalDisplayName =
          firestoreDisplayName ??
          authDisplayName ??
          _extractNameFromEmail(fallbackEmail);
      final finalProfileImage = firestoreProfileImage ?? authPhotoURL;
      final joinDate = _getJoinDate(user);

      return ProfileData(
        displayName: finalDisplayName,
        profileImageUrl: finalProfileImage,
        joinDate: joinDate,
      );
    } catch (e) {
      developer.log("Genel hata: $e", name: 'ProfileService', level: 1000);
      return ProfileData(
        displayName: _extractNameFromEmail(fallbackEmail),
        joinDate: 'Bilinmiyor',
      );
    }
  }

  String _extractNameFromEmail(String email) {
    final emailParts = email.split('@');
    if (emailParts.isNotEmpty) {
      final username = emailParts[0];
      return username.isEmpty
          ? 'Kullanıcı'
          : '${username[0].toUpperCase()}${username.substring(1)}';
    }
    return 'Kullanıcı';
  }

  String _getJoinDate(User user) {
    try {
      if (user.metadata.creationTime != null) {
        final date = user.metadata.creationTime!;
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      developer.log(
        "Tarih alma hatası: $e",
        name: 'ProfileService',
        level: 900,
      );
    }
    return 'Bilinmiyor';
  }
}
