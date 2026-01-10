import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Traffic'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Traffic Overview', style: kHeadline1),
            const SizedBox(height: 20),
            Container(
              height: 200,
              decoration: kCardDecoration,
              child: const Center(child: Text('Traffic Map Placeholder')),
            ),
            const SizedBox(height: 20),
            Text('Quick Actions', style: kHeadline2),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickAction(
                  context,
                  'View Map',
                  Icons.map,
                  () {}, // Already on map tab
                ),
                _buildQuickAction(
                  context,
                  'Traffic Info',
                  Icons.traffic,
                  () {}, // Already on traffic tab
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: kCardDecoration,
        child: Column(
          children: [
            Icon(icon, size: 32, color: primaryColor),
            const SizedBox(height: 8),
            Text(label, style: kBodyText2),
          ],
        ),
      ),
    );
  }
}
