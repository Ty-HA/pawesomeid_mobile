// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _prefs = SharedPreferences.getInstance();
  bool _enableBiometrics = false;
  bool _darkMode = false;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await _prefs;
    setState(() {
      _enableBiometrics = prefs.getBool('enableBiometrics') ?? false;
      _darkMode = prefs.getBool('darkMode') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await _prefs;
    switch (value.runtimeType) {
      case bool:
        await prefs.setBool(key, value);
        break;
      case String:
        await prefs.setString(key, value);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            'Application Settings',
            [
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Enable dark theme'),
                value: _darkMode,
                onChanged: (bool value) {
                  setState(() => _darkMode = value);
                  _saveSetting('darkMode', value);
                },
              ),
              ListTile(
                title: const Text('Language'),
                subtitle: Text(_selectedLanguage), // Retirez const
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _showLanguageDialog,
              ),
            ],
          ),
          _buildSection(
            'Security',
            [
              SwitchListTile(
                title: const Text('Biometric Authentication'),
                subtitle: const Text('Use fingerprint or face ID'),
                value: _enableBiometrics,
                onChanged: (bool value) {
                  setState(() => _enableBiometrics = value);
                  _saveSetting('enableBiometrics', value);
                },
              ),
            ],
          ),
          _buildSection(
            'About',
            [
              const ListTile(
                title: Text('Version'),
                subtitle: Text('1.0.0'),
              ),
              const ListTile(
                title: Text('Developer'),
                subtitle: Text('Your Organization'),
              ),
              ListTile(
                title: const Text('Privacy Policy'),
                onTap: () {
                  // Navigate to privacy policy
                },
              ),
              ListTile(
                title: const Text('Terms of Service'),
                onTap: () {
                  // Navigate to terms of service
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Future<void> _showLanguageDialog() async {
    final languages = ['English', 'Français', 'Español', 'Deutsch'];
    final selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Language'),
          children: languages.map((String language) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, language);
              },
              child: Text(language),
            );
          }).toList(),
        );
      },
    );

    if (selected != null) {
      setState(() => _selectedLanguage = selected);
      _saveSetting('language', selected);
    }
  }
}
