import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SAN FRANCISCO',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            letterSpacing: 4,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '10-Day Forecast',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),

        const SizedBox(height: 16),

        WeatherCard(
          child: Column(
            children: [
              DailyForecastRow(
                day: 'Today',
                icon: Symbols.sunny,
                low: 54,
                high: 68,
              ),
              const Divider(),
              DailyForecastRow(
                day: 'Tue',
                icon: Symbols.cloud,
                low: 52,
                high: 65,
              ),
              const Divider(),
              DailyForecastRow(
                day: 'Wed',
                icon: Symbols.rainy,
                low: 55,
                high: 62,
              ),
              const Divider(),
              DailyForecastRow(
                day: 'Thu',
                icon: Symbols.partly_cloudy_day,
                low: 53,
                high: 64,
              ),
              const Divider(),
              DailyForecastRow(
                day: 'Fri',
                icon: Symbols.thunderstorm,
                low: 50,
                high: 60,
              ),
              const Divider(),
              DailyForecastRow(
                day: 'Sat',
                icon: Symbols.cloud,
                low: 51,
                high: 63,
              ),
              const Divider(),
              DailyForecastRow(
                day: 'Sun',
                icon: Symbols.sunny,
                low: 55,
                high: 70,
              ),
              const Divider(),
              DailyForecastRow(
                day: 'Mon',
                icon: Symbols.partly_cloudy_day,
                low: 58,
                high: 72,
              ),
              const Divider(),
              DailyForecastRow(
                day: 'Tue',
                icon: Symbols.sunny,
                low: 60,
                high: 75,
              ),
              const Divider(),
              DailyForecastRow(
                day: 'Wed',
                icon: Symbols.sunny,
                low: 59,
                high: 74,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Row(
          spacing: 16,
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

        const SizedBox(height: 16),

        Row(
          spacing: 16,
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
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(18),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
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
          TemperatureRange(start: .30, end: .72),
          const SizedBox(width: 20),
          Text('$high°', style: const TextStyle(fontWeight: FontWeight.bold)),
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

class TemperatureRange extends StatelessWidget {
  final double start;
  final double end;

  const TemperatureRange({super.key, required this.start, required this.end});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999),
            ),
          ),

          FractionallySizedBox(
            widthFactor: end - start,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
