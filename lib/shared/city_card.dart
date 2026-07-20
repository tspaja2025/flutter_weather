import 'package:flutter/material.dart';

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
                    '$temperature°C',
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
                      Text('H: $high°C'),
                      const SizedBox(width: 8),
                      Text('L: $low°C'),
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
