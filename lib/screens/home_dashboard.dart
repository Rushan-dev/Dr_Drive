import 'package:flutter/material.dart';
import 'dart:async';
import '../constants/app_constants.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _carouselItems = [
    {
      'title': 'Safe Driving Starts Here',
      'subtitle': 'Always wear your seatbelt',
      'icon': Icons.security,
      'color': primaryColor,
      'gradient': [primaryColor, primaryColor.withValues(alpha: 0.8)],
    },
    {
      'title': 'Speed Awareness',
      'subtitle': 'Drive within speed limits',
      'icon': Icons.speed,
      'color': warningColor,
      'gradient': [warningColor, warningColor.withValues(alpha: 0.8)],
    },
    {
      'title': 'Weather Safety',
      'subtitle': 'Check conditions before driving',
      'icon': Icons.cloud,
      'color': successColor,
      'gradient': [successColor, successColor.withValues(alpha: 0.8)],
    },
    {
      'title': 'Emergency Ready',
      'subtitle': 'Know your emergency contacts',
      'icon': Icons.emergency,
      'color': errorColor,
      'gradient': [errorColor, errorColor.withValues(alpha: 0.8)],
    },
  ];

  final List<Map<String, dynamic>> _shortcuts = [
    {
      'title': 'Start Driving',
      'subtitle': 'Begin safe journey',
      'icon': Icons.drive_eta,
      'color': primaryColor,
      'route': '/driving_mode',
    },
    {
      'title': 'Weather & Hazards',
      'subtitle': 'Check road conditions',
      'icon': Icons.cloud,
      'color': successColor,
      'route': '/weather_alerts',
    },
    {
      'title': 'Accident Hotspots',
      'subtitle': 'View danger zones',
      'icon': Icons.warning,
      'color': warningColor,
      'route': '/accident_map',
    },
    {
      'title': 'Reminders',
      'subtitle': 'Manage compliance',
      'icon': Icons.notifications,
      'color': primaryColor,
      'route': '/compliance',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSwipe();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSwipe() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _carouselItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Traffic'),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotifications(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Hero Section - Auto-swiping Carousel
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _carouselItems.length,
                  itemBuilder: (context, index) {
                    final item = _carouselItems[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: item['gradient'],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: item['color'].withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -30,
                            bottom: -30,
                            child: Icon(
                              item['icon'],
                              size: 120,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item['title'],
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['subtitle'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Page Indicators
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _carouselItems.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2x2 Grid Shortcuts
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Access',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: _shortcuts.length,
                      itemBuilder: (context, index) {
                        final shortcut = _shortcuts[index];
                        return _buildShortcutCard(
                          context,
                          shortcut['title'],
                          shortcut['subtitle'],
                          shortcut['icon'],
                          shortcut['color'],
                          () => Navigator.pushNamed(context, shortcut['route']),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textPrimary,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: textSecondary,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Recent Alerts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textPrimary,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 16),
            _buildNotificationItem(
              'Speed Warning',
              'You exceeded 60 km/h in a 50 zone',
              '2 hours ago',
              warningColor,
            ),
            const Divider(),
            _buildNotificationItem(
              'Weather Alert',
              'Heavy rain expected in your area',
              '4 hours ago',
              warningColor,
            ),
            const Divider(),
            _buildNotificationItem(
              'Compliance Reminder',
              'Vehicle insurance expires in 7 days',
              '1 day ago',
              errorColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message, String time, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textPrimary,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: textSecondary,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}