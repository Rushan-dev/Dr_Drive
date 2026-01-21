import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import '../widgets/custom_app_bar.dart';
import '../services/weather_service.dart';
import '../constants/colors.dart' as color_constants;
import '../config/config.dart';

// Initialize Google Places client
final places = GoogleMapsPlaces(apiKey: Config.googleMapsApiKey);

class WeatherHazardAlertsScreen extends StatefulWidget {
  const WeatherHazardAlertsScreen({super.key});

  @override
  State<WeatherHazardAlertsScreen> createState() =>
      _WeatherHazardAlertsScreenState();
}

class _WeatherHazardAlertsScreenState extends State<WeatherHazardAlertsScreen> {
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;
  String _error = '';
  String _location = 'Loading...';
  final String _defaultLocation = 'Colombo, LK';
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentLocations = [
    'Colombo, LK',
    'Kandy, LK',
    'Galle, LK',
  ];
  bool _isSearching = false;
  List<String> _searchResults = [];
  final Map<String, IconData> _weatherIcons = {
    'Thunderstorm': Icons.thunderstorm,
    'Drizzle': Icons.grain,
    'Rain': Icons.water_drop,
    'Snow': Icons.ac_unit,
    'Clear': Icons.wb_sunny,
    'Clouds': Icons.cloud,
    'Fog': Icons.cloud_queue,
    'Mist': Icons.cloud_queue,
  };

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeather({String? location}) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = '';
      _isSearching = false;
    });

    try {
      Map<String, dynamic> weatherData;
      if (location != null) {
        weatherData = await WeatherService.getWeatherByCity(location);
      } else {
        try {
          weatherData = await WeatherService.getWeatherByLocation();
        } catch (e) {
          weatherData = await WeatherService.getWeatherByCity(_defaultLocation);
        }
      }

      if (weatherData.isEmpty) {
        throw Exception('No weather data received');
      }

      _updateWeatherData(weatherData);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load weather data: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateWeatherData(Map<String, dynamic> weatherData) {
    setState(() {
      _weatherData = weatherData;
      final locationName =
          weatherData['name'] != null &&
              weatherData['sys'] != null &&
              weatherData['sys']['country'] != null
          ? '${weatherData['name']}, ${weatherData['sys']['country']}'
          : 'Unknown Location';
      _location = locationName;

      // Add to recent locations if not already present
      if (!_recentLocations.contains(locationName)) {
        _recentLocations.insert(0, locationName);
        // Keep only last 5 recent locations
        if (_recentLocations.length > 5) {
          _recentLocations.removeLast();
        }
      }
    });
  }

  Future<void> _handleSearch() async {
    try {
      // Show the Places Autocomplete dialog
      Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: Config.googleMapsApiKey,
        mode: Mode.overlay,
        language: 'en',
        components: [Component(Component.country, 'lk')],
        types: ['(cities)'],
      );

      if (p != null) {
        // Get the place details
        final details = await places.getDetailsByPlaceId(p.placeId!);
        final location = details.result.name ?? p.description ?? '';

        if (location.isNotEmpty) {
          _searchController.text = location;
          await _selectLocation(location);
        }
      }
    } catch (e) {
      // Fallback to local search
      final query = _searchController.text;
      if (query.isNotEmpty) {
        _selectLocation(query);
      }
    }
  }

  Future<void> _selectLocation(String location) async {
    // Clear the search
    _searchController.text = '';
    _searchLocations(''); // This will clear the search results

    try {
      // Get the place details to extract the city name
      final predictions = await places.autocomplete(location);

      if (predictions.predictions.isNotEmpty) {
        final placeId = predictions.predictions.first.placeId;
        if (placeId != null) {
          final details = await places.getDetailsByPlaceId(placeId);
          final city = details.result.name ?? location.split(',').first.trim();

          // Add to recent locations if not already present
          if (!_recentLocations.contains(location)) {
            setState(() {
              _recentLocations.insert(0, location);
              // Keep only last 5 recent locations
              if (_recentLocations.length > 5) {
                _recentLocations.removeLast();
              }
            });
          }

          // Fetch weather for the selected location
          await _fetchWeather(location: city);
          return;
        }
      }

      // Fallback to the original behavior if place details can't be fetched
      await _fetchWeather(location: location.split(',').first.trim());
    } catch (e) {
      // If any error occurs, fall back to the original behavior
      await _fetchWeather(location: location.split(',').first.trim());
    }
  }

  Future<void> _searchLocations(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    await Future.microtask(() {
      setState(() {
        _isSearching = true;
        _searchResults = _recentLocations
            .where(
              (location) =>
                  location.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      });
    });
  }

  Widget _buildWeatherIcon(String? main, {double size = 60}) {
    if (main == null)
      return const Icon(Icons.wb_sunny, color: Colors.white, size: 60);
    final icon = _weatherIcons[main] ?? Icons.wb_sunny;
    return Icon(icon, color: Colors.white, size: size);
  }

  String _formatTime(int? timestamp) {
    if (timestamp == null) return '--:--';
    try {
      return DateFormat('h a').format(
        DateTime.fromMillisecondsSinceEpoch(
          timestamp * 1000,
          isUtc: true,
        ).toLocal(),
      );
    } catch (e) {
      return '--:--';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'DR.DRIVE',
        showSOS: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: color_constants.primaryColor.withOpacity(0.1),
              child: const Text(
                'Weather & Hazards',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Location Search and Selection
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  onTap: _handleSearch,
                  decoration: InputDecoration(
                    hintText: 'Search location...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _searchLocations('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: color_constants.primaryColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: color_constants.primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                if (_isSearching)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _searchResults.isEmpty
                        ? const ListTile(
                            title: Text('No matching locations found'),
                          )
                        : Column(
                            children: _searchResults
                                .map(
                                  (location) => ListTile(
                                    leading: const Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                    ),
                                    title: Text(location),
                                    onTap: () => _selectLocation(location),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _location,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          _isLoading
                              ? 'Updating...'
                              : 'Updated ${DateFormat('h:mm a').format(DateTime.now())}',
                          style: textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.my_location),
                          onPressed: _isLoading ? null : () => _fetchWeather(),
                          color: color_constants.primaryColor,
                          tooltip: 'Use my location',
                        ),
                        _isLoading
                            ? const SizedBox(
                                width: 48,
                                height: 48,
                                child: Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        color_constants.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () =>
                                    _fetchWeather(location: _location),
                                color: color_constants.primaryColor,
                                tooltip: 'Refresh',
                              ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _error,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              )
            else if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              const SizedBox(height: 24),

            // Current Weather Card
            if (_weatherData != null)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color_constants.primaryColor,
                      color_constants.primaryColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: color_constants.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_weatherData!['main']['temp'].round()}°C',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          _weatherData!['weather'][0]['main'],
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.thermostat,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_weatherData!['main']['feels_like'].round()}°C',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                                fontFamily: 'Roboto',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.water_drop,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_weatherData!['main']['humidity']}%',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.air, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${(_weatherData!['wind']['speed'] * 3.6).toStringAsFixed(1)} km/h',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: _buildWeatherIcon(
                        _weatherData!['weather'][0]['main'],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Hourly Forecast
            Text(
              'Today\'s Forecast',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textTheme.bodyLarge?.color,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 16),
            // For demo purposes, we'll show the next 6 hours in 2-hour increments
            // In a real app, you would fetch this from a forecast API endpoint
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildHourlyForecast(
                    'Now',
                    '${_weatherData?['main']['temp']?.round() ?? '--'}°',
                    _weatherIcons[_weatherData?['weather'][0]['main']] ??
                        Icons.wb_sunny,
                    true,
                  ),
                  _buildHourlyForecast(
                    _formatTime(
                      DateTime.now().millisecondsSinceEpoch ~/ 1000 + 7200,
                    ),
                    '${(_weatherData?['main']['temp'] ?? 0) + 2}°',
                    _weatherIcons[_weatherData?['weather'][0]['main']] ??
                        Icons.wb_sunny,
                    false,
                  ),
                  _buildHourlyForecast(
                    _formatTime(
                      DateTime.now().millisecondsSinceEpoch ~/ 1000 + 14400,
                    ),
                    '${(_weatherData?['main']['temp'] ?? 0) + 1}°',
                    _weatherIcons[_weatherData?['weather'][0]['main']] ??
                        Icons.wb_cloudy,
                    false,
                  ),
                  _buildHourlyForecast(
                    _formatTime(
                      DateTime.now().millisecondsSinceEpoch ~/ 1000 + 21600,
                    ),
                    '${_weatherData?['main']['temp']?.round() ?? '--'}°',
                    _weatherIcons[_weatherData?['weather'][0]['main']] ??
                        Icons.cloud,
                    false,
                  ),
                  _buildHourlyForecast(
                    _formatTime(
                      DateTime.now().millisecondsSinceEpoch ~/ 1000 + 28800,
                    ),
                    '${(_weatherData?['main']['temp'] ?? 0) - 1}°',
                    _weatherIcons[_weatherData?['weather'][0]['main']] ??
                        Icons.cloud,
                    false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Weather Details Grid
            Text(
              'Weather Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textTheme.bodyLarge?.color,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildWeatherDetail(
                  'Feels like',
                  '${_weatherData?['main']?['feels_like']?.round() ?? '--'}°C',
                  Icons.thermostat,
                ),
                _buildWeatherDetail(
                  'Humidity',
                  '${_weatherData?['main']?['humidity']?.toString() ?? '--'}%',
                  Icons.water_drop,
                ),
                _buildWeatherDetail(
                  'Wind Speed',
                  '${_weatherData?['wind']?['speed'] != null ? (_weatherData!['wind']['speed'] * 3.6).toStringAsFixed(1) : '--'} km/h',
                  Icons.air,
                ),
                _buildWeatherDetail(
                  'Pressure',
                  '${_weatherData?['main']?['pressure']?.toString() ?? '--'} hPa',
                  Icons.compress,
                ),
                _buildWeatherDetail(
                  'Visibility',
                  '${_weatherData?['visibility'] != null ? (_weatherData!['visibility'] / 1000).toStringAsFixed(1) : '--'} km',
                  Icons.visibility,
                ),
                _buildWeatherDetail(
                  'Clouds',
                  '${_weatherData?['clouds']?['all']?.toString() ?? '--'}%',
                  Icons.cloud,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Active Alerts
            Text(
              'Active Alerts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textTheme.bodyLarge?.color,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 16),
            _buildAlertCard(
              'Heavy Rain Warning',
              'Heavy rainfall expected in your area',
              Icons.warning_amber_rounded,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyForecast(
    String time,
    String temp,
    IconData icon,
    bool isNow,
  ) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isNow
            ? color_constants.primaryColor.withOpacity(0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 14,
              color: isNow ? color_constants.primaryColor : Colors.grey[600],
              fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Icon(
            icon,
            color: isNow ? color_constants.primaryColor : Colors.grey[600],
            size: 24,
          ),
          Text(
            temp,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
              color: isNow ? color_constants.primaryColor : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Theme.of(context).primaryColor),
              const SizedBox(width: 4),
              Text(title, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(
    String title,
    String message,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: color),
        ],
      ),
    );
  }
}
