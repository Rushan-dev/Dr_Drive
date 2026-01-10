import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider();

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // You can add more theme-related state and methods here if needed
}
