import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../models/vehicle_model.dart';
import 'compliance_manager.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  // Editable user data
  late Map<String, dynamic> _userData;
  List<Vehicle> _vehicles = [];
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseController = TextEditingController();

  // Vehicle form controllers
  final _vehicleTypeController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _fuelTypeController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehicleYearController = TextEditingController();
  final _vehicleColorController = TextEditingController();

  // Available options
  final List<String> _vehicleTypes = [
    'Sedan',
    'SUV',
    'Truck',
    'Motorcycle',
    'Van',
  ];
  final List<String> _fuelTypes = [
    'Petrol',
    'Diesel',
    'Electric',
    'Hybrid',
    'CNG',
    'LPG',
  ];

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
    _vehicleTypeController.dispose();
    _vehicleNumberController.dispose();
    _fuelTypeController.dispose();
    _vehicleModelController.dispose();
    _vehicleYearController.dispose();
    _vehicleColorController.dispose();
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

  void _showAddEditVehicleDialog({Vehicle? vehicle, int? index}) {
    final isEdit = vehicle != null;

    if (isEdit) {
      _vehicleTypeController.text = vehicle.type;
      _vehicleNumberController.text = vehicle.number;
      _fuelTypeController.text = vehicle.fuelType;
      _vehicleModelController.text = vehicle.model ?? '';
      _vehicleYearController.text = vehicle.year?.toString() ?? '';
      _vehicleColorController.text = vehicle.color ?? '';
    } else {
      _vehicleTypeController.clear();
      _vehicleNumberController.clear();
      _fuelTypeController.clear();
      _vehicleModelController.clear();
      _vehicleYearController.clear();
      _vehicleColorController.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Vehicle' : 'Add New Vehicle'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Vehicle Type Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _vehicleTypeController.text.isNotEmpty
                        ? _vehicleTypeController.text
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Type',
                      border: OutlineInputBorder(),
                    ),
                    items: _vehicleTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _vehicleTypeController.text = value;
                      }
                    },
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Vehicle Number
                  TextFormField(
                    controller: _vehicleNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Fuel Type Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _fuelTypeController.text.isNotEmpty
                        ? _fuelTypeController.text
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'Fuel Type',
                      border: OutlineInputBorder(),
                    ),
                    items: _fuelTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _fuelTypeController.text = value;
                      }
                    },
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Vehicle Model
                  TextFormField(
                    controller: _vehicleModelController,
                    decoration: const InputDecoration(
                      labelText: 'Model (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Vehicle Year and Color in a row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _vehicleYearController,
                          decoration: const InputDecoration(
                            labelText: 'Year (Optional)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _vehicleColorController,
                          decoration: const InputDecoration(
                            labelText: 'Color (Optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (isEdit) ...[
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      title: const Text('Set as default vehicle'),
                      value: vehicle.isDefault,
                      onChanged: (bool? value) {
                        if (value == true) {
                          setState(() {
                            for (var v in _vehicles) {
                              v.isDefault = false;
                            }
                            _vehicles[index!] = vehicle.copyWith(
                              isDefault: true,
                            );
                          });
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newVehicle = Vehicle(
                    id: isEdit ? vehicle.id : _uuid.v4(),
                    type: _vehicleTypeController.text,
                    number: _vehicleNumberController.text,
                    fuelType: _fuelTypeController.text,
                    model: _vehicleModelController.text.isEmpty
                        ? null
                        : _vehicleModelController.text,
                    year: _vehicleYearController.text.isEmpty
                        ? null
                        : int.tryParse(_vehicleYearController.text),
                    color: _vehicleColorController.text.isEmpty
                        ? null
                        : _vehicleColorController.text,
                    isDefault: isEdit
                        ? _vehicles[index!].isDefault
                        : _vehicles.isEmpty, // First vehicle is default
                  );

                  setState(() {
                    if (isEdit) {
                      _vehicles[index!] = newVehicle;
                    } else {
                      _vehicles.add(newVehicle);
                    }

                    // Update user data with the first vehicle as default
                    if (_vehicles.isNotEmpty) {
                      final defaultVehicle = _vehicles.firstWhere(
                        (v) => v.isDefault,
                        orElse: () => _vehicles.first,
                      );
                      _userData['vehicleType'] = defaultVehicle.type;
                      _userData['vehicleNumber'] = defaultVehicle.number;
                      _userData['fuelType'] = defaultVehicle.fuelType;
                    }
                  });

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isEdit
                            ? 'Vehicle updated successfully'
                            : 'Vehicle added successfully',
                      ),
                    ),
                  );
                }
              },
              child: Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  void _deleteVehicle(int index) {
    final vehicle = _vehicles[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Vehicle'),
          content: Text('Are you sure you want to delete ${vehicle.number}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _vehicles.removeAt(index);

                  // If we deleted the default vehicle, make the first one default
                  if (_vehicles.isNotEmpty) {
                    _vehicles[0] = _vehicles[0].copyWith(isDefault: true);

                    // Update user data with the new default vehicle
                    _userData['vehicleType'] = _vehicles[0].type;
                    _userData['vehicleNumber'] = _vehicles[0].number;
                    _userData['fuelType'] = _vehicles[0].fuelType;
                  } else {
                    // No vehicles left
                    _userData['vehicleType'] = '';
                    _userData['vehicleNumber'] = '';
                    _userData['fuelType'] = '';
                  }
                });

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vehicle deleted')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVehicleDetailsCard() {
    // Initialize vehicles from user data if empty
    if (_vehicles.isEmpty &&
        _userData['vehicleNumber'] != null &&
        _userData['vehicleNumber'].isNotEmpty) {
      _vehicles.add(
        Vehicle(
          id: _uuid.v4(),
          type: _userData['vehicleType'] ?? 'Sedan',
          number: _userData['vehicleNumber'],
          fuelType: _userData['fuelType'] ?? 'Petrol',
          isDefault: true,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: kCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Vehicles',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton.icon(
                onPressed: () => _showAddEditVehicleDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Vehicle'),
                style: TextButton.styleFrom(foregroundColor: primaryColor),
              ),
            ],
          ),

          if (_vehicles.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'No vehicles added yet. Click "Add Vehicle" to get started.',
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _vehicles.length,
              separatorBuilder: (context, index) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final vehicle = _vehicles[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${vehicle.type} • ${vehicle.number}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          children: [
                            if (vehicle.isDefault)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'DEFAULT',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    if (vehicle.model != null ||
                        vehicle.year != null ||
                        vehicle.color != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        [
                          if (vehicle.model != null) vehicle.model,
                          if (vehicle.year != null) vehicle.year.toString(),
                          if (vehicle.color != null) vehicle.color,
                        ].join(' • '),
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label: Text(vehicle.fuelType),
                          backgroundColor: primaryColor.withOpacity(0.1),
                          labelStyle: TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => _showAddEditVehicleDialog(
                            vehicle: vehicle,
                            index: index,
                          ),
                          color: primaryColor,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.red,
                          ),
                          onPressed: () => _deleteVehicle(index),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
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
                  builder: (context) => const ComplianceManagerScreen(),
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
                thumbColor: WidgetStateProperty.all(primaryColor),
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
