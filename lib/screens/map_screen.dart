import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import '../config/config.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(20.5937, 78.9629), // Default to India's center
    zoom: 5,
  );

  late final GoogleMapsPlaces places;

  @override
  void initState() {
    super.initState();
    places = GoogleMapsPlaces(
      apiKey: Config.googleMapsApiKey,
      apiHeaders: null, // Removed await as it's not needed here
    );
  }

  // Handle search functionality
  Future<void> _handleSearch() async {
    try {
      // Show search bar
      Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: Config.googleMapsApiKey,
        mode: Mode.overlay,
        language: 'en',
        components: [Component(Component.country, 'in')], // Restrict to India
      );

      if (p != null) {
        // Get place details
        final details = await places.getDetailsByPlaceId(
          p.placeId!,
          fields: ['geometry', 'name', 'formatted_address'],
        );

        // Move camera to selected location
        final lat = details.result.geometry!.location.lat;
        final lng = details.result.geometry!.location.lng;
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, lng), zoom: 15),
          ),
        );

        // Show a snackbar with the place name
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected: ${details.result.name}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'DR.DRIVE', showSOS: true),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onTap: _handleSearch,
              decoration: InputDecoration(
                hintText: 'Search for a location...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              readOnly: true,
            ),
          ),
          // Map Container
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
