import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../widgets/custom_app_bar.dart';
import '../theme/app_theme.dart';

class AccidentHotspotMapScreen extends StatefulWidget {
  const AccidentHotspotMapScreen({super.key});

  @override
  State<AccidentHotspotMapScreen> createState() =>
      _AccidentHotspotMapScreenState();
}

class _AccidentHotspotMapScreenState extends State<AccidentHotspotMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  bool _showRoadblocks = true;
  bool _showAccidents = true;
  String? _selectedHazardType;
  final TextEditingController _descriptionController = TextEditingController();

  // Default location (Colombo, Sri Lanka)
  static const CameraPosition _defaultLocation = CameraPosition(
    target: LatLng(6.9271, 79.8612),
    zoom: 12,
  );

  // Sample markers data
  final Set<Marker> _markers = {};
  final Set<Polygon> _polygons = {};

  @override
  void initState() {
    super.initState();
    _loadMapMarkers();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition();

    // Update camera position
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14,
        ),
      ),
    );

    // Add current location marker
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    });
  }

  void _loadMapMarkers() {
    // Sample accident markers
    if (_showAccidents) {
      _markers.addAll({
        Marker(
          markerId: const MarkerId('accident1'),
          position: const LatLng(6.9218, 79.8564), // Galle Face
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(
            title: 'Recent Accident',
            snippet: '3-vehicle collision',
          ),
        ),
        Marker(
          markerId: const MarkerId('accident2'),
          position: const LatLng(6.9344, 79.8529), // Bambalapitiya
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(
            title: 'Accident Hotspot',
            snippet: 'High risk intersection',
          ),
        ),
      });
    }

    // Sample roadblock markers
    if (_showRoadblocks) {
      _markers.addAll({
        Marker(
          markerId: const MarkerId('roadblock1'),
          position: const LatLng(6.9097, 79.8524), // Kollupitiya
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
          infoWindow: const InfoWindow(
            title: 'Police Checkpoint',
            snippet: 'Routine check',
          ),
        ),
        Marker(
          markerId: const MarkerId('roadblock2'),
          position: const LatLng(6.9475, 79.8660), // Borella
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
          infoWindow: const InfoWindow(
            title: 'Road Work',
            snippet: 'Construction zone',
          ),
        ),
      });

      // Add a polygon for road work area
      _polygons.add(
        Polygon(
          polygonId: const PolygonId('constructionArea'),
          points: const [
            LatLng(6.9455, 79.8640),
            LatLng(6.9455, 79.8680),
            LatLng(6.9495, 79.8680),
            LatLng(6.9495, 79.8640),
          ],
          strokeWidth: 2,
          strokeColor: Colors.orange,
          fillColor: Colors.orange.withOpacity(0.2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'DR.DRIVE',
        showSOS: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Page Title
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: const Text(
              'Hotspots & Roadblocks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          // Google Map Container
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: _defaultLocation,
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      markers: _markers,
                      polygons: _polygons,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                    // Report button
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: FloatingActionButton(
                        onPressed: _showReportDialog,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(
                          Icons.add_location_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Current location button
                    Positioned(
                      bottom: 90,
                      right: 20,
                      child: FloatingActionButton(
                        onPressed: _getCurrentLocation,
                        backgroundColor: Colors.white,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
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
            color: AppTheme.secondaryTextColor,
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
          title: const Text('Map Filters'),
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
                color: Colors.black87,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              location,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.secondaryTextColor,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Reported 2 hours ago',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.secondaryTextColor,
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
    final TextEditingController dialogController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Report Hazard'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Hazard Type',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _selectedHazardType,
                    items: const [
                      DropdownMenuItem(
                        value: 'accident',
                        child: Text('🚑 Accident'),
                      ),
                      DropdownMenuItem(
                        value: 'roadblock',
                        child: Text('🚧 Roadblock'),
                      ),
                      DropdownMenuItem(
                        value: 'hazard',
                        child: Text('⚠️ Other Hazard'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedHazardType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: dialogController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Describe the hazard...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _selectedHazardType == null
                    ? null
                    : () {
                        _addNewMarker(description: dialogController.text);
                        dialogController.dispose();
                        Navigator.pop(context);
                      },
                child: const Text('Submit Report'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _addNewMarker({String description = ''}) {
    if (_selectedHazardType == null) return;

    setState(() {
      final markerId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      final position =
          _defaultLocation.target; // Default position or get current location

      BitmapDescriptor icon;
      String title;

      switch (_selectedHazardType) {
        case 'accident':
          icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
          title = 'Reported Accident';
        case 'roadblock':
          icon = BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          );
          title = 'Reported Roadblock';
        case 'hazard':
          icon = BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow,
          );
          title = 'Reported Hazard';
        default:
          icon = BitmapDescriptor.defaultMarker;
          title = 'Reported Issue';
      }

      _markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: position,
          icon: icon,
          infoWindow: InfoWindow(
            title: title,
            snippet: description.isNotEmpty
                ? description
                : 'No description provided',
          ),
          onTap: () {
            _showMarkerDetails(
              title,
              description.isNotEmpty ? description : 'No description provided',
            );
          },
        ),
      );
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hazard reported successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
