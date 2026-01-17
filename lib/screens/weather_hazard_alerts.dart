import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';

class WeatherHazardAlertsScreen extends StatefulWidget {
  const WeatherHazardAlertsScreen({super.key});

  @override
  State<WeatherHazardAlertsScreen> createState() =>
      _WeatherHazardAlertsScreenState();
}

class _WeatherHazardAlertsScreenState extends State<WeatherHazardAlertsScreen> {
  @override
  Widget build(BuildContext context) {
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
              color: primaryColor.withOpacity(0.1),
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

            // Current Location & Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Colombo, Sri Lanka',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Text(
                      'Updated 5 min ago',
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.location_on),
                  onPressed: () {},
                  color: primaryColor,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Current Weather Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
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
                        '28°C',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        'Partly Cloudy',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9),
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.air, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '12 km/h',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                              fontFamily: 'Roboto',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.water_drop, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '65%',
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
                    child: Icon(Icons.wb_cloudy, color: Colors.white, size: 60),
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
                color: textPrimary,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildHourlyForecast('Now', '28°', Icons.wb_cloudy, true),
                  _buildHourlyForecast('2 PM', '30°', Icons.wb_sunny, false),
                  _buildHourlyForecast('4 PM', '32°', Icons.wb_sunny, false),
                  _buildHourlyForecast('6 PM', '29°', Icons.wb_cloudy, false),
                  _buildHourlyForecast('8 PM', '27°', Icons.cloud, false),
                  _buildHourlyForecast('10 PM', '26°', Icons.cloud, false),
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
                color: textPrimary,
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
                _buildWeatherDetail('Feels like', '30°C', Icons.thermostat),
                _buildWeatherDetail('Humidity', '65%', Icons.water_drop),
                _buildWeatherDetail('Wind Speed', '12 km/h', Icons.air),
                _buildWeatherDetail('UV Index', '6', Icons.wb_sunny),
                _buildWeatherDetail('Visibility', '10 km', Icons.visibility),
                _buildWeatherDetail('Pressure', '1013 hPa', Icons.compress),
              ],
            ),

            const SizedBox(height: 24),

            // Active Alerts
            Text(
              'Active Alerts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textPrimary,
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
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isNow ? primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isNow ? primaryColor : Colors.grey.shade300,
          width: isNow ? 1.5 : 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 14,
              color: isNow ? primaryColor : textSecondary,
              fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Icon(icon, color: isNow ? primaryColor : Colors.orange, size: 24),
          Text(
            temp,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isNow ? primaryColor : textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
