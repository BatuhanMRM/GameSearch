import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dart:developer' as developer;

class ProfileScreen extends StatefulWidget {
  final String email;
  const ProfileScreen({super.key, required this.email});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  String _displayName = 'Kullanıcı';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    developer.log('🔍 PROFIL YÜKLEME BAŞLIYOR', name: 'ProfileScreen');

    final user = _authService.currentUser;
    if (user == null) {
      developer.log('❌ Kullanıcı null!', name: 'ProfileScreen');
      return;
    }

    developer.log('👤 User UID: ${user.uid}', name: 'ProfileScreen');
    developer.log('📧 User Email: ${user.email}', name: 'ProfileScreen');

    // AuthService'den displayName'i al (local storage'dan)
    final displayName = _authService.getDisplayName();
    developer.log('🏷️ Local DisplayName: $displayName', name: 'ProfileScreen');

    if (displayName != null && displayName.isNotEmpty) {
      setState(() {
        _displayName = displayName;
      });
      developer.log(
        '✅ BAŞARILI! DisplayName bulundu: $_displayName',
        name: 'ProfileScreen',
      );
      return;
    }

    developer.log(
      '❌ DisplayName bulunamadı, varsayılan kalıyor',
      name: 'ProfileScreen',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Yenile butonu ekle
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _loadUserData();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Üst kısım - Profil resmi ve temel bilgiler
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.deepPurple, Colors.deepPurple.shade300],
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  // Profil resmi
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey.shade200,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.deepPurple,
                              width: 2,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Profil resmi değiştirme özelliği eklenecek',
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.deepPurple,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  // Kullanıcı adı
                  Text(
                    _displayName,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.email,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),

            // Alt kısım - Profil bilgileri
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // İstatistikler
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard('Değerlendirme', '15', Icons.star),
                      _buildStatCard('Favori', '8', Icons.favorite),
                      _buildStatCard('Oynanan', '23', Icons.games),
                    ],
                  ),
                  SizedBox(height: 30),

                  // Profil seçenekleri
                  _buildProfileOption(
                    icon: Icons.edit,
                    title: 'Profili Düzenle',
                    subtitle: 'Adınızı ve profil resminizi değiştirin',
                    onTap: () {
                      _showEditNameDialog();
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.history,
                    title: 'Değerlendirme Geçmişi',
                    subtitle: 'Yaptığınız tüm değerlendirmeleri görün',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Değerlendirme geçmişi açılacak'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Profil düzenleme dialog'u
  void _showEditNameDialog() {
    TextEditingController nameController = TextEditingController(
      text: _displayName,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adınızı Düzenleyin'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Yeni adınız',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              String newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                await _updateDisplayName(newName);
                Navigator.pop(context);
              }
            },
            child: Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  // DisplayName güncelleme
  Future<void> _updateDisplayName(String newName) async {
    try {
      final success = await _authService.updateDisplayName(newName);
      if (success) {
        setState(() {
          _displayName = newName;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Adınız başarıyla güncellendi!')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Güncelleme başarısız!')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hata: ${e.toString()}')));
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 30),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (textColor ?? Colors.deepPurple).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: textColor ?? Colors.deepPurple),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
