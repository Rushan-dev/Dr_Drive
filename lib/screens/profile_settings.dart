import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  // Editable user data
  late Map<String, dynamic> _userData;

  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with mock data
    _userData = {
      'name': 'John Driver',
      'email': 'john.driver@example.com',
      'phone': '+1 (555) 123-4567',
      'licenseNumber': 'DL-XXXX-XXXX-XXXX',
      'vehicleType': 'Sedan',
      'vehicleNumber': 'ABC 1234',
      'fuelType': 'Petrol',
      'safetyScore': 87,
      'averageSpeed': '42 km/h',
      'overspeedAlerts': 3,
      'emergencyContacts': [
        {'name': 'Sarah Wilson', 'number': '+1 (555) 987-6543'},
        {'name': 'Mike Johnson', 'number': '+1 (555) 456-7890'},
      ],
      'alertMode': 'Sound',
    };

    // Initialize controllers with initial values
    _nameController.text = _userData['name'];
    _emailController.text = _userData['email'];
    _phoneController.text = _userData['phone'];
    _licenseController.text = _userData['licenseNumber'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _licenseController,
                  decoration: const InputDecoration(
                    labelText: 'License Number',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _userData['name'] = _nameController.text;
                  _userData['email'] = _emailController.text;
                  _userData['phone'] = _phoneController.text;
                  _userData['licenseNumber'] = _licenseController.text;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout() {
    // TODO: Implement actual logout logic
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        showSOS: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 24),
                  _buildSafetyOverview(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Personal Details'),
                  _buildPersonalDetailsCard(),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Vehicle Details'),
                  _buildVehicleDetailsCard(),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Compliance Status'),
                  _buildComplianceCard(),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Emergency Settings'),
                  _buildEmergencySettingsCard(),
                  const SizedBox(height: 16),
                  _buildSectionTitle('App Preferences'),
                  _buildAppPreferencesCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: primaryColor.withOpacity(0.1),
            child: const Icon(Icons.person, size: 50, color: primaryColor),
          ),
          const SizedBox(height: 12),
          Text(_userData['name'] ?? 'User', style: kHeadline2),
          const SizedBox(height: 4),
          Text(_userData['email'] ?? '', style: kBodyText2),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _showEditProfileDialog,
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit Profile'),
            style: TextButton.styleFrom(foregroundColor: primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyOverview() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Safety Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(Icons.speed, 'Avg. Speed', '65 km/h'),
                _buildStatItem(Icons.timelapse, 'Drive Time', '2.5 hrs'),
                _buildStatItem(Icons.warning_amber, 'Alerts', '3'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: primaryColor, size: 28),
        const SizedBox(height: 4),
        Text(label, style: kBodyText2),
        const SizedBox(height: 2),
        Text(value, style: kBodyText1.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: kBodyText1.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimary.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildPersonalDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: kCardDecoration,
      child: Column(
        children: [
          _buildDetailRow('Full Name', _userData['name']),
          const Divider(height: 24),
          _buildDetailRow('Email', _userData['email']),
          const Divider(height: 24),
          _buildDetailRow('Mobile', _userData['phone']),
          const Divider(height: 24),
          _buildDetailRow(
            'License',
            '•••• •••• •••• ${_userData['licenseNumber'].toString().substring(_userData['licenseNumber'].length - 4)}',
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: kCardDecoration,
      child: Column(
        children: [
          _buildDetailRow('Vehicle Type', _userData['vehicleType']),
          const Divider(height: 24),
          _buildDetailRow('Vehicle Number', _userData['vehicleNumber']),
          const Divider(height: 24),
          _buildDetailRow('Fuel Type', _userData['fuelType']),
        ],
      ),
    );
  }

  Widget _buildComplianceCard() {
    // Mock compliance status - replace with actual data
    final complianceStatus = {
      'license': 'Valid',
      'insurance': 'Expiring',
      'inspection': 'Valid',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: kCardDecoration,
      child: Column(
        children: [
          _buildComplianceRow('Driving License', complianceStatus['license']!),
          const SizedBox(height: 12),
          _buildComplianceRow(
            'Vehicle Insurance',
            complianceStatus['insurance']!,
          ),
          const SizedBox(height: 12),
          _buildComplianceRow(
            'Vehicle Inspection',
            complianceStatus['inspection']!,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Scaffold(
                    body: Center(child: Text('Compliance Details')),
                  ),
                ),
              );
            },
            child: const Text('View All Compliance Details'),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceRow(String label, String status) {
    Color statusColor = status == 'Valid'
        ? successColor
        : status == 'Expiring'
        ? warningColor
        : errorColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: kBodyText1),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencySettingsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: kCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency Contacts',
            style: kBodyText1.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._userData['emergencyContacts'].asMap().entries.map<Widget>((
            entry,
          ) {
            final contact = entry.value;
            final index = entry.key;
            return Column(
              children: [
                ListTile(
                  title: Text(contact['name'], style: kBodyText1),
                  subtitle: Text(contact['number'], style: kBodyText2),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _userData['emergencyContacts'].removeAt(index);
                      });
                    },
                  ),
                ),
                if (index < _userData['emergencyContacts'].length - 1)
                  const Divider(height: 1),
              ],
            );
          }).toList(),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _showAddEmergencyContactDialog,
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Add Emergency Contact'),
            style: TextButton.styleFrom(foregroundColor: primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildAppPreferencesCard() {
    // Initialize speedWarningEnabled if not exists
    _userData['speedWarningEnabled'] = _userData['speedWarningEnabled'] ?? true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: kCardDecoration,
      child: Column(
        children: [
          _buildPreferenceItem(
            Icons.notifications,
            'Alert Mode',
            _userData['alertMode'],
            onTap: () => _showAlertModeDialog(),
          ),
          const Divider(height: 24),
          _buildPreferenceItem(
            Icons.speed,
            'Speed Warning',
            _userData['speedWarningEnabled'] == true ? 'On' : 'Off',
            showSwitch: true,
            switchValue: _userData['speedWarningEnabled'],
            onChanged: (value) {
              setState(() {
                _userData['speedWarningEnabled'] = value;
              });
              // TODO: Update speed warning setting
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem(
    IconData icon,
    String title,
    String value, {
    bool showSwitch = false,
    bool switchValue = false,
    ValueChanged<bool>? onChanged,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: primaryColor, size: 24),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: kBodyText1)),
            if (!showSwitch) ...[
              Text(value, style: kBodyText2),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ] else
              Switch(
                value: switchValue,
                onChanged: onChanged,
                activeTrackColor: primaryColor,
                thumbColor: MaterialStateProperty.all(primaryColor),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: kBodyText2.copyWith(color: textSecondary)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(value, style: kBodyText1, textAlign: TextAlign.right),
        ),
      ],
    );
  }

  Color _getSafetyScoreColor(int score) {
    if (score >= 80) return successColor;
    if (score >= 50) return warningColor;
    return errorColor;
  }

  void _showAlertModeDialog() {
    final modes = ['Sound', 'Vibration', 'Voice'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Alert Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: modes
              .map(
                (mode) => RadioListTile<String>(
                  title: Text(mode),
                  value: mode,
                  groupValue: _userData['alertMode'],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _userData['alertMode'] = value;
                      });
                      Navigator.pop(context);
                      // TODO: Update alert mode setting
                    }
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _showAddEmergencyContactDialog() {
    final nameController = TextEditingController();
    final numberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Emergency Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Contact Name',
                hintText: 'Enter name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter phone number with country code',
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  numberController.text.isNotEmpty) {
                setState(() {
                  _userData['emergencyContacts'].add({
                    'name': nameController.text,
                    'number': numberController.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
