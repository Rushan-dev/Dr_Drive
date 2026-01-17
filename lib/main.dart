import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding_screen.dart';
import 'screens/weather_hazard_alerts.dart';
import 'screens/auth_screen.dart';
import 'screens/home_dashboard.dart';
import 'screens/driving_mode.dart';
import 'screens/accident_hotspot_map.dart';
import 'screens/weather_hazard_alerts.dart';
import 'screens/compliance_manager.dart';
import 'screens/profile_settings.dart';
import 'screens/admin_dashboard.dart';
import 'theme/theme_provider.dart';
import 'services/auth_service.dart';
import 'services/report_service.dart';
import 'models/user_model.dart' show UserModel, UserRole;
import 'package:firebase_auth/firebase_auth.dart' show User;

Future<void> main() async {
  print('Starting app...');
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize shared preferences
  final prefs = await SharedPreferences.getInstance();

  // Check if it's the first launch
  bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  if (isFirstLaunch) {
    await prefs.setBool('isFirstLaunch', false);
  }

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'YOUR_API_KEY', // Replace with your actual Firebase config
        appId: 'YOUR_APP_ID',
        messagingSenderId: 'YOUR_SENDER_ID',
        projectId: 'YOUR_PROJECT_ID',
      ),
    );
    print('Firebase initialized successfully');
  } on FirebaseException catch (e) {
    print('Firebase initialization error: ${e.message}');
    // Handle initialization error appropriately
    rethrow;
  } catch (e) {
    print('Unexpected error initializing Firebase: $e');
    rethrow;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<ReportService>(create: (_) => ReportService()),
      ],
      child: MyApp(isFirstLaunch: isFirstLaunch),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;

  const MyApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'DR.DRIVE',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      home: isFirstLaunch ? const OnboardingScreen() : const AuthWrapper(),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const MainNavigation(),
        '/admin': (context) => const AdminDashboard(),
        '/accident_map': (context) => const AccidentHotspotMapScreen(),
        '/compliance': (context) => const ComplianceManagerScreen(),
        '/weather_alerts': (context) => const WeatherHazardAlertsScreen(),
        '/driving_mode': (context) => const DrivingModeScreen(),
        '/profile': (context) => const ProfileSettingsScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('An error occurred!'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => authService.signOut(),
                    child: const Text('Back to Login'),
                  ),
                ],
              ),
            ),
          );
        }

        final user = snapshot.data;
        return user == null ? const AuthScreen() : const MainNavigation();
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
  late List<Widget> _screens;
  late List<BottomNavigationBarItem> _navBarItems;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  void _initializeScreens() {
    _screens = <Widget>[
      const HomeDashboard(),
      const DrivingModeScreen(),
      const AccidentHotspotMapScreen(),
      const WeatherHazardAlertsScreen(),
      const ComplianceManagerScreen(),
      const ProfileSettingsScreen(),
    ];

    _navBarItems = const [
      BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
      BottomNavigationBarItem(
        icon: Icon(Icons.directions_car),
        label: 'Drive Mode',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Hotspots'),
      BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Weather'),
      BottomNavigationBarItem(
        icon: Icon(Icons.assignment),
        label: 'Compliance',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<UserModel?>(
      stream: authService.getUserData(authService.currentUser?.uid ?? ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        // If user is admin, show admin dashboard
        if (user?.role == UserRole.admin) {
          return const AdminDashboard();
        }

        // For regular users, show the main app
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
      },
    );
  }
}
