import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = dotenv.env['WEATHERAPI'] ?? '';
  final _cache = <String, _CacheEntry>{};
  static const _cacheDuration = Duration(minutes: 5);

  Future<Map<String, dynamic>> getWeatherData(String city) async {
    final key = city.toLowerCase();

    if (_cache.containsKey(key)) {
      final entry = _cache[key]!;
      if (DateTime.now().difference(entry.timestamp) < _cacheDuration) {
        return entry.data;
      }
    }

    try {
      final current = await getWeather(city);
      final forecast = await getForecast(city);
      final data = {...current, 'forecast': forecast['forecast']};

      _cache[key] = _CacheEntry(data, DateTime.now());
      return data;
    } catch (e) {
      throw Exception('Failed to fetch weather data: $e');
    }
  }

  Future<Map<String, dynamic>> getWeather(String city) async {
    if (apiKey.isEmpty) {
      throw Exception('Weather API key not configured');
    }

    final url = Uri.parse(
      'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Connection timeout. Please try again.');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> getForecast(String city) async {
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7',
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

class _CacheEntry {
  final Map<String, dynamic> data;
  final DateTime timestamp;

  _CacheEntry(this.data, this.timestamp);
}
