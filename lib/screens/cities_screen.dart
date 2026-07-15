import 'package:flutter/material.dart';
import 'package:flutter_weather/service/weather_service.dart';
import 'package:flutter_weather/shared/city_card.dart';
import 'package:flutter_weather/utils/weather_utils.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class CitiesScreen extends StatefulWidget {
  const CitiesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  final WeatherService _weatherService = WeatherService();
  final List<String> _cities = ['London', 'New York', 'Tokyo'];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _weatherService.getAllweather(_cities),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildErrorWidget(context, snapshot.error.toString());
        }

        final cities = snapshot.data!;
        return _buildCitiesContent(context, cities);
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Symbols.error,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error: $error',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () {}, child: const Text('Retry')),
        ],
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
