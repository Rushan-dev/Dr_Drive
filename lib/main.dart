import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_dashboard.dart';
import 'screens/driving_mode.dart';
import 'screens/accident_hotspot_map.dart';
import 'screens/weather_hazard_alerts.dart';
import 'screens/compliance_manager.dart';
import 'screens/profile_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;

  const MyApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Traffic App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: isFirstLaunch ? const OnboardingScreen() : const AuthWrapper(),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const MainNavigation(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      // Replace with your auth state stream if using Firebase Auth or similar
      stream: Stream.value(
        false,
      ), // This is a placeholder - replace with actual auth stream
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isLoggedIn = snapshot.data ?? false;
        return isLoggedIn ? const MainNavigation() : const AuthScreen();
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    const HomeDashboard(),
    const DrivingModeScreen(),
    const AccidentHotspotMapScreen(),
    const WeatherHazardAlertsScreen(),
    const ComplianceManagerScreen(),
    const ProfileScreen(),
  ];

  static const List<BottomNavigationBarItem> _navBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
    BottomNavigationBarItem(
      icon: Icon(Icons.directions_car),
      label: 'Drive Mode',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Hotspots'),
    BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Weather'),
    BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Compliance'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _navBarItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
