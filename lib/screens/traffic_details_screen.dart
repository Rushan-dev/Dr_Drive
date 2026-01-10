import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class TrafficDetailsScreen extends StatelessWidget {
  const TrafficDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Details'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Traffic Conditions',
              style: kHeadline2,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: kCardDecoration,
              child: Column(
                children: [
                  _buildTrafficItem('Highway 101', 'Heavy Traffic', Colors.red),
                  const Divider(),
                  _buildTrafficItem('Main Street', 'Moderate Traffic', Colors.orange),
                  const Divider(),
                  _buildTrafficItem('Broadway', 'Light Traffic', Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficItem(String route, String condition, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(route, style: kBodyText1),
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(condition, style: kBodyText2),
          ],
        ),
      ],
    );
  }
}