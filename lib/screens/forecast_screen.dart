import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('SAN FRANCISCO'),
        const Text('10-Day Forecast'),
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
