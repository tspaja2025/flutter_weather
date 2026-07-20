import 'package:flutter/material.dart';
import 'package:flutter_weather/service/weather_service.dart';
import 'package:flutter_weather/shared/app_scaffold.dart';
import 'package:flutter_weather/shared/city_card.dart';
import 'package:flutter_weather/utils/weather_utils.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class CitiesScreen extends StatefulWidget {
  const CitiesScreen({super.key});

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  final WeatherService _weatherService = WeatherService();
  final List<String> _cities = ['New York', 'London', 'Tokyo'];
  List<Map<String, dynamic>> _citiesData = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchAllCities();
  }

  Future<void> _fetchAllCities() async {
    try {
      final data = await _weatherService.getAllweather(_cities);
      setState(() {
        _citiesData = data;
        _isLoading = false;
        _error = '';
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return AppScaffold(
        currentIndex: 0,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error.isNotEmpty) {
      return AppScaffold(
        currentIndex: 0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchAllCities,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return AppScaffold(
      currentIndex: 2,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(children: [_buildCitiesContent(context, _citiesData)]),
      ),
    );
  }

  Widget _buildCitiesContent(
    BuildContext context,
    List<Map<String, dynamic>> cities,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manage Cities',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Symbols.search),
                hintText: 'Search for a city...',
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('MY CITIES', style: Theme.of(context).textTheme.labelMedium),
              TextButton(onPressed: () {}, child: const Text('Edit')),
            ],
          ),

          Column(
            children: cities.map((cityData) {
              final location = cityData['location'];
              final current = cityData['current'];
              final forecast = cityData['forecast']['forecastday'][0]['day'];

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CityCard(
                  city: location['name'],
                  time: location['localtime'],
                  weather: current['condition']['text'],
                  weatherIcon: WeatherUtils.getWeatherIcon(
                    current['condition']['text'],
                  ),
                  temperature: current['temp_c'],
                  high: forecast['maxtemp_c'].round(),
                  low: forecast['mintemp_c'].round(),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          Text(
            'RECOMMENDED CITIES',
            style: Theme.of(context).textTheme.labelMedium,
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(onPressed: () {}, child: const Text('Paris')),
              OutlinedButton(onPressed: () {}, child: const Text('Berlin')),
              OutlinedButton(onPressed: () {}, child: const Text('Sydney')),
              OutlinedButton(onPressed: () {}, child: const Text('Dubai')),
            ],
          ),
        ],
      ),
    );
  }
}
