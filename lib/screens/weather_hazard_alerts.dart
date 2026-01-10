import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class WeatherHazardAlertsScreen extends StatefulWidget {
  const WeatherHazardAlertsScreen({super.key});

  @override
  State<WeatherHazardAlertsScreen> createState() => _WeatherHazardAlertsScreenState();
}

class _WeatherHazardAlertsScreenState extends State<WeatherHazardAlertsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather & Hazards'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withValues(alpha: 0.1),
              backgroundColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
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
                            color: Colors.white.withValues(alpha: 0.9),
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.air,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '12 km/h',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.9),
                                fontFamily: 'Roboto',
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.water_drop,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '65%',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.9),
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
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.wb_cloudy,
                        color: Colors.white,
                        size: 60,
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
                'Heavy rainfall expected in Colombo area from 2:00 PM to 6:00 PM',
                warningColor,
                Icons.cloud,
                'Alternate Route: A1 Highway → Baseline Road',
              ),
              const SizedBox(height: 16),
              _buildAlertCard(
                'Fog Alert',
                'Dense fog reported on Southern Expressway',
                warningColor,
                Icons.cloud_queue,
                'Reduce speed, use fog lights',
              ),

              const SizedBox(height: 24),

              // Road Conditions
              Text(
                'Road Conditions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 16),
              _buildRoadConditionCard(
                'Colombo - Kandy Road',
                'Wet surface, slippery',
                warningColor,
                Icons.warning,
              ),
              const SizedBox(height: 12),
              _buildRoadConditionCard(
                'Galle Road',
                'Flooded sections',
                errorColor,
                Icons.water_damage,
              ),
              const SizedBox(height: 12),
              _buildRoadConditionCard(
                'Southern Expressway',
                'Clear, good visibility',
                successColor,
                Icons.check_circle,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHourlyForecast(String time, String temp, IconData icon, bool isSelected) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isSelected ? [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.white : textSecondary,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Icon(
            icon,
            color: isSelected ? Colors.white : primaryColor,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            temp,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : textPrimary,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: kCardDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: primaryColor,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimary,
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
      ),
    );
  }

  Widget _buildAlertCard(String title, String description, Color color, IconData icon, String advice) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: textPrimary,
              fontFamily: 'Roboto',
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.directions, color: color, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    advice,
                    style: TextStyle(
                      fontSize: 14,
                      color: color,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadConditionCard(String road, String condition, Color color, IconData icon) {
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
                  road,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                    fontFamily: 'Roboto',
                  ),
                ),
                Text(
                  condition,
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}