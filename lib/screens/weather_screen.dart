import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Column(
            children: [
              Icon(
                Symbols.partly_cloudy_day,
                size: 150,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(
                'San Francisco',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text('72°', style: Theme.of(context).textTheme.displayLarge),
              Text(
                'Mostly Sunny',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('H: 78°', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(width: 16),
                  Text('L: 64°', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        WeatherCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'HOURLY FORECAST',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Icon(
                    Symbols.access_time,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  HourForecast(
                    time: 'Now',
                    icon: Symbols.wb_sunny,
                    temp: '72°',
                  ),
                  HourForecast(
                    time: '1PM',
                    icon: Symbols.partly_cloudy_day,
                    temp: '74°',
                  ),
                  HourForecast(
                    time: '2PM',
                    icon: Symbols.partly_cloudy_day,
                    temp: '75°',
                  ),
                  HourForecast(time: '3PM', icon: Symbols.cloud, temp: '73°'),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MetricCard(
                icon: Symbols.sunny,
                title: 'UV INDEX',
                value: Text(
                  '4',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                footer: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Moderate',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: 0.4,
                      minHeight: 8,
                      color: Theme.of(context).colorScheme.primary,
                      backgroundColor: Theme.of(context).colorScheme.onTertiary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: MetricCard(
                icon: Symbols.air,
                title: 'WIND',
                value: Text(
                  '64%',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                footer: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WNW',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(Symbols.circle),
                  ],
                ),
              ),
            ),
          ],
        ),

        Row(
          children: [
            Expanded(
              child: MetricCard(
                icon: Symbols.water_drop,
                title: 'HUMIDITY',
                value: Text(
                  '64%',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                footer: Text(
                  'Dew point 58°',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            Expanded(
              child: MetricCard(
                icon: Symbols.water_drop,
                title: 'VISIBILITY',
                value: Row(
                  children: [
                    Text(
                      '10',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('mi'),
                  ],
                ),
                footer: Text(
                  'Clear view',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        WeatherCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Symbols.calendar_month,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '10-DAY FORECAST',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              DailyForecastRow(
                day: 'Today',
                icon: Symbols.partly_cloudy_day,
                low: 64,
                high: 78,
              ),
              const Divider(),
              DailyForecastRow(
                day: 'Tue',
                icon: Symbols.sunny,
                low: 62,
                high: 81,
              ),
              const Divider(),
              DailyForecastRow(
                day: 'Wed',
                icon: Symbols.cloud,
                low: 60,
                high: 74,
              ),
              const Divider(),
              DailyForecastRow(
                day: 'Thu',
                icon: Symbols.rainy,
                low: 58,
                high: 68,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WeatherCard extends StatelessWidget {
  final Widget child;

  const WeatherCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(18),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

class HourForecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;

  const HourForecast({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(time),
          const SizedBox(height: 8),
          Icon(icon),
          const SizedBox(height: 8),
          Text(temp, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget value;
  final Widget footer;

  const MetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return WeatherCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16),
              const SizedBox(width: 6),
              Text(title),
            ],
          ),
          const SizedBox(height: 12),
          value,
          const SizedBox(height: 8),
          footer,
        ],
      ),
    );
  }
}

class DailyForecastRow extends StatelessWidget {
  final String day;
  final IconData icon;
  final int low;
  final int high;

  const DailyForecastRow({
    super.key,
    required this.day,
    required this.icon,
    required this.low,
    required this.high,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(day)),
          Icon(icon),
          const Spacer(),
          Text('$low°'),
          const SizedBox(width: 20),
          Text('$high°', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
