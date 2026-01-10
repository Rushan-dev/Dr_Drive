import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app.dart';
import '../constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: kCardDecoration,
            child: Column(
              children: [
                ListTile(
                  title: const Text('Notifications'),
                  trailing: Switch(value: true, onChanged: (value) {}),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) => themeProvider.toggleTheme(),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Profile'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {}, // Profile is now a tab
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}