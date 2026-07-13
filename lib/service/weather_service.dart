import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _apiKey = dotenv.env['WEATHERAPI'] ?? '';

  // Get current weather
  Future<Map<String, dynamic>> getWeather(String city) async {
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/current.json?key=$_apiKey&q=$city',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to load weather: ${response.statusCode}\n${response.body}',
      );
    }
  }

  // Get forecast weather
  Future<Map<String, dynamic>> getForecast(String city) async {
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=$_apiKey&q=$city&days=3',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to load forecast: ${response.statusCode}\n${response.body}',
      );
    }
  }

  // Get both current and forecast data
  Future<Map<String, dynamic>> getWeatherData(String city) async {
    final current = await getWeather(city);
    final forecast = await getForecast(city);
    return {...current, 'forecast': forecast['forecast']};
  }

  // Get weather data for multiple cities
  Future<List<Map<String, dynamic>>> getMultipleCitiesWeather(
    List<String> cities,
  ) async {
    final List<Future<Map<String, dynamic>>> futures = cities
        .map((city) => getWeatherData(city))
        .toList();

    return await Future.wait(futures);
  }

  Future<List<Map<String, dynamic>>> getAllweather(List<String> cities) async {
    return await Future.wait(cities.map((city) => getWeatherData(city)));
  }
}
