import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isDarkMode;
  late bool _isNotificationMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _isNotificationMode = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ayarlar')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Tema Modu'),
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (val) {
                setState(() {
                  _isDarkMode = val;
                });
                widget.onThemeChanged(val);
              },
            ),
            onTap: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
              widget.onThemeChanged(_isDarkMode);
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Bildirimler'),
            trailing: Switch(
              value: _isNotificationMode,
              onChanged: (val) {
                setState(() {
                  _isNotificationMode = val;
                });
              },
            ),
            onTap: () {
              setState(() {
                _isNotificationMode = !_isNotificationMode;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Dil Seçimi'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
