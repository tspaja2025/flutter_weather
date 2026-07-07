import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class CitiesScreen extends StatelessWidget {
  const CitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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

        const SizedBox(height: 8),

        CityCard(
          city: 'New York',
          time: '09:42 AM',
          weather: 'Cloudy',
          weatherIcon: Symbols.cloud,
          temperature: 18,
          high: 21,
          low: 14,
        ),

        const SizedBox(height: 8),

        CityCard(
          city: 'London',
          time: '02:42 PM',
          weather: 'Light Rain',
          weatherIcon: Symbols.rainy,
          temperature: 12,
          high: 15,
          low: 11,
        ),

        const SizedBox(height: 8),

        CityCard(
          city: 'Tokyo',
          time: '10:42 PM',
          weather: 'Clear',
          weatherIcon: Symbols.sunny,
          temperature: 24,
          high: 28,
          low: 19,
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
    );
  }
}

class CityCard extends StatelessWidget {
  final String city;
  final String time;
  final String weather;
  final IconData weatherIcon;
  final double temperature;
  final int high;
  final int low;

  const CityCard({
    super.key,
    required this.city,
    required this.time,
    required this.weather,
    required this.weatherIcon,
    required this.temperature,
    required this.high,
    required this.low,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(time, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  weather,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 180,
            height: 120,
            child: Stack(
              children: [
                Positioned(
                  top: -30,
                  right: -20,
                  child: Icon(
                    weatherIcon,
                    fill: 1,
                    size: 120,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: .10),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 18,
                  child: Text(
                    '$temperature°',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Row(
                    children: [
                      Text('H: $high°'),
                      const SizedBox(width: 8),
                      Text('L: $low°'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
