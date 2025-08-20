import 'package:flutter/material.dart';
import 'package:game_reviews_2/screens/settings_screen.dart';

class ProfileHeader extends StatelessWidget {
  final String displayName;
  final String email;
  final String? profileImageUrl;

  const ProfileHeader({
    super.key,
    required this.displayName,
    required this.email,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 46,
              backgroundColor: Colors.white,
              backgroundImage:
                  profileImageUrl != null && profileImageUrl!.isNotEmpty
                  ? NetworkImage(profileImageUrl!)
                  : null,
              child: profileImageUrl == null || profileImageUrl!.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 50,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 15),

          // User name
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),

          // Email
          Text(
            email,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final String displayName;
  final String email;
  final String joinDate;

  const ProfileInfoCard({
    super.key,
    required this.displayName,
    required this.email,
    required this.joinDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hesap Bilgileri',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 15),

          _ProfileInfoRow(
            icon: Icons.person,
            label: 'Kullanıcı Adı',
            value: displayName,
          ),
          const SizedBox(height: 12),
          _ProfileInfoRow(icon: Icons.email, label: 'E-posta', value: email),
          const SizedBox(height: 12),
          _ProfileInfoRow(
            icon: Icons.calendar_today,
            label: 'Üyelik Tarihi',
            value: joinDate,
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileStatsSection extends StatelessWidget {
  const ProfileStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.favorite,
            label: 'Favoriler',
            value: '12',
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _StatCard(icon: Icons.comment, label: 'Yorumlar', value: '8'),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _StatCard(icon: Icons.star, label: 'Puanlar', value: '4.2'),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).primaryColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil düzenleme özelliği yakında!'),
                ),
              );
            },
            icon: const Icon(Icons.edit, size: 20),
            label: const Text(
              'Profili Düzenle',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;
  final Widget? trailing; // ✅ Yeni parametre - switch için

  const _SettingsOption({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
    this.trailing, // ✅ Trailing widget ekledik
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive
              ? Colors.red
              : Theme.of(context).textTheme.bodyLarge?.color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing:
          trailing ??
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ), // ✅ Conditional trailing
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

// ✅ Yeni helper widget - Dark Mode Switch için
class DarkModeSettingsOption extends StatefulWidget {
  const DarkModeSettingsOption({super.key});

  @override
  State<DarkModeSettingsOption> createState() => _DarkModeSettingsOptionState();
}

class _DarkModeSettingsOptionState extends State<DarkModeSettingsOption> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  void _loadThemePreference() {
    // Theme durumunu kontrol et
    final brightness = Theme.of(context).brightness;
    setState(() {
      _isDarkMode = brightness == Brightness.dark;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });

    // Theme değişikliğini uygula (Provider kullanıyorsanız)
    // Provider.of<ThemeProvider>(context, listen: false).toggleTheme();

    // Geçici olarak SnackBar göster
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isDarkMode
              ? 'Karanlık mod aktifleştirildi'
              : 'Açık mod aktifleştirildi',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsOption(
      icon: _isDarkMode ? Icons.dark_mode : Icons.light_mode,
      title: 'Karanlık Mod',
      trailing: Switch(
        value: _isDarkMode,
        onChanged: (value) => _toggleTheme(),
        activeColor: Theme.of(context).primaryColor,
      ),
      onTap: _toggleTheme,
    );
  }
}
