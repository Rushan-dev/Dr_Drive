import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherService {
  static const String _apiKey =
      '4ecf31103ea9b70cb8f665a100d151cd'; // OpenWeatherMap API key
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Get weather by city name
  static Future<Map<String, dynamic>> getWeatherByCity(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }

  // Get weather by current location
  static Future<Map<String, dynamic>> getWeatherByLocation() async {
    try {
      // Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final response = await http.get(
        Uri.parse(
          '$_baseUrl/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric',
        ),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error getting location or weather: $e');
    }
  }

  // Get weather icon URL
  static String getWeatherIcon(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  // Get weather description
  static String getWeatherDescription(int code) {
    if (code < 300) {
      return 'Thunderstorm';
    } else if (code < 500) {
      return 'Drizzle';
    } else if (code == 500) {
      return 'Light Rain';
    } else if (code < 600) {
      return 'Rain';
    } else if (code < 700) {
      return 'Snow';
    } else if (code < 800) {
      return 'Fog';
    } else if (code == 800) {
      return 'Clear';
    } else {
      return 'Cloudy';
    }
  }
}
