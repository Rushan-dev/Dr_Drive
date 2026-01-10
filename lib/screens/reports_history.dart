import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ReportsHistoryScreen extends StatelessWidget {
  const ReportsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reports & History'),
          backgroundColor: primaryColor,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Driving History'),
              Tab(text: 'SOS Events'),
              Tab(text: 'Contributions'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDrivingHistory(),
            _buildSOSEvents(),
            _buildContributions(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrivingHistory() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHistoryItem(
          'Speed Warning',
          'Exceeded 60 km/h in 50 zone',
          'Today, 2:30 PM',
          warningColor,
          Icons.speed,
        ),
        const SizedBox(height: 12),
        _buildHistoryItem(
          'Speed Warning',
          'Exceeded 70 km/h in 60 zone',
          'Yesterday, 8:15 AM',
          warningColor,
          Icons.speed,
        ),
        const SizedBox(height: 12),
        _buildHistoryItem(
          'Safe Driving',
          'Completed 50 km without violations',
          'Yesterday, 6:00 PM',
          successColor,
          Icons.check_circle,
        ),
        const SizedBox(height: 12),
        _buildHistoryItem(
          'Hazard Zone Alert',
          'Slowed down near school zone',
          '2 days ago, 3:45 PM',
          successColor,
          Icons.warning,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: kCardDecoration,
          child: Column(
            children: [
              Text(
                'Driving Statistics',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Total Distance', '1,250 km'),
                  _buildStatItem('Avg Speed', '45 km/h'),
                  _buildStatItem('Warnings', '3'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSOSEvents() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: errorColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: errorColor.withValues(alpha: 0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.emergency, color: Colors.red),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'No SOS events recorded',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Emergency Contacts',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 12),
        _buildContactItem('Emergency Contact 1', '+94 77 123 4567'),
        const SizedBox(height: 8),
        _buildContactItem('Emergency Contact 2', '+94 77 987 6543'),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit),
          label: const Text('Manage Emergency Contacts'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildContributions() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildContributionItem(
          'Road Hazard Report',
          'Reported fallen tree on Galle Road',
          '3 days ago',
          successColor,
          Icons.warning,
        ),
        const SizedBox(height: 12),
        _buildContributionItem(
          'Accident Report',
          'Reported minor accident at junction',
          '1 week ago',
          successColor,
          Icons.car_crash,
        ),
        const SizedBox(height: 12),
        _buildContributionItem(
          'Roadblock Report',
          'Reported police checkpoint',
          '2 weeks ago',
          successColor,
          Icons.block,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: kCardDecoration,
          child: Column(
            children: [
              Text(
                'Your Impact',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Reports Made', '12'),
                  _buildStatItem('Alerts Helped', '45'),
                  _buildStatItem('Community Rank', '#127'),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Thank you for making roads safer!',
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String description, String time, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: kCardDecoration,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 4),
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
      ),
    );
  }

  Widget _buildContributionItem(String title, String description, String time, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: kCardDecoration,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 4),
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
          Icon(Icons.verified, color: successColor, size: 20),
        ],
      ),
    );
  }

  Widget _buildContactItem(String name, String phone) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: kCardDecoration,
      child: Row(
        children: [
          const Icon(Icons.person, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                    fontFamily: 'Roboto',
                  ),
                ),
                Text(
                  phone,
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.green),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryColor,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textSecondary,
            fontFamily: 'Roboto',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}