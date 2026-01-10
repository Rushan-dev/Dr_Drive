import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AccidentHotspotMapScreen extends StatefulWidget {
  const AccidentHotspotMapScreen({super.key});

  @override
  State<AccidentHotspotMapScreen> createState() =>
      _AccidentHotspotMapScreenState();
}

class _AccidentHotspotMapScreenState extends State<AccidentHotspotMapScreen> {
  bool _showRoadblocks = true;
  bool _showAccidents = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotspots & Roadblocks'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Map Container
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Text(
                      'Interactive Map\n(Google Maps)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                  // Mock markers
                  if (_showRoadblocks) ..._buildRoadblockMarkers(),
                  if (_showAccidents) ..._buildAccidentMarkers(),
                  // Report button
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      onPressed: _showReportDialog,
                      backgroundColor: primaryColor,
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Legend
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('🚧 Roadblock', Colors.orange),
                _buildLegendItem('🚑 Accident', Colors.red),
                _buildLegendItem('⚠️ Hazard', Colors.yellow),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRoadblockMarkers() {
    return [
      Positioned(
        top: 100,
        left: 100,
        child: _buildMapMarker(
          Icons.block,
          Colors.orange,
          'Police Checkpoint',
          'Colombo Road',
        ),
      ),
      Positioned(
        bottom: 150,
        right: 80,
        child: _buildMapMarker(
          Icons.construction,
          Colors.orange,
          'Road Work',
          'Galle Road',
        ),
      ),
    ];
  }

  List<Widget> _buildAccidentMarkers() {
    return [
      Positioned(
        top: 200,
        right: 120,
        child: _buildMapMarker(
          Icons.car_crash,
          Colors.red,
          'Recent Accident',
          'Highway Junction',
        ),
      ),
      Positioned(
        bottom: 100,
        left: 150,
        child: _buildMapMarker(
          Icons.warning,
          Colors.red,
          'Accident Hotspot',
          'Busy Intersection',
        ),
      ),
    ];
  }

  Widget _buildMapMarker(
    IconData icon,
    Color color,
    String title,
    String subtitle,
  ) {
    return InkWell(
      onTap: () => _showMarkerDetails(title, subtitle),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textSecondary,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Filter Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: const Text('Show Roadblocks'),
                value: _showRoadblocks,
                onChanged: (value) {
                  setState(() => _showRoadblocks = value ?? true);
                  this.setState(() {});
                },
              ),
              CheckboxListTile(
                title: const Text('Show Accidents'),
                value: _showAccidents,
                onChanged: (value) {
                  setState(() => _showAccidents = value ?? true);
                  this.setState(() {});
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMarkerDetails(String title, String location) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textPrimary,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              location,
              style: TextStyle(
                fontSize: 16,
                color: textSecondary,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Reported 2 hours ago',
              style: TextStyle(
                fontSize: 14,
                color: textSecondary,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Get Directions'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Hazard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Hazard Type'),
              items: const [
                DropdownMenuItem(value: 'accident', child: Text('Accident')),
                DropdownMenuItem(value: 'roadblock', child: Text('Roadblock')),
                DropdownMenuItem(value: 'hazard', child: Text('Other Hazard')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe the hazard...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.photo_camera),
                const SizedBox(width: 8),
                Text(
                  'Add Photo (Optional)',
                  style: TextStyle(color: primaryColor, fontFamily: 'Roboto'),
                ),
              ],
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report submitted successfully!')),
              );
            },
            child: const Text('Submit Report'),
          ),
        ],
      ),
    );
  }
}
