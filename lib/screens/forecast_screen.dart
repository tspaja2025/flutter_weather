import 'package:flutter/material.dart';
import 'package:flutter_weather/shared/daily_forecast_row.dart';
import 'package:flutter_weather/shared/metric_card.dart';
import 'package:flutter_weather/shared/weather_card.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
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
                  progressStart: .30,
                  progressEnd: .72,
                ),
                const Divider(),
                DailyForecastRow(
                  day: 'Tue',
                  icon: Symbols.cloud,
                  low: 52,
                  high: 65,
                  progressStart: .28,
                  progressEnd: .68,
                ),
                const Divider(),
                DailyForecastRow(
                  day: 'Wed',
                  icon: Symbols.rainy,
                  low: 55,
                  high: 62,
                  progressStart: .30,
                  progressEnd: .60,
                ),
                const Divider(),
                DailyForecastRow(
                  day: 'Thu',
                  icon: Symbols.partly_cloudy_day,
                  low: 53,
                  high: 64,
                  progressStart: .28,
                  progressEnd: .62,
                ),
                const Divider(),
                DailyForecastRow(
                  day: 'Fri',
                  icon: Symbols.thunderstorm,
                  low: 50,
                  high: 60,
                  progressStart: .26,
                  progressEnd: .56,
                ),
                const Divider(),
                DailyForecastRow(
                  day: 'Sat',
                  icon: Symbols.cloud,
                  low: 51,
                  high: 63,
                  progressStart: .28,
                  progressEnd: .58,
                ),
                const Divider(),
                DailyForecastRow(
                  day: 'Sun',
                  icon: Symbols.sunny,
                  low: 55,
                  high: 70,
                  progressStart: .32,
                  progressEnd: .68,
                ),
                const Divider(),
                DailyForecastRow(
                  day: 'Mon',
                  icon: Symbols.partly_cloudy_day,
                  low: 58,
                  high: 72,
                  progressStart: .30,
                  progressEnd: .72,
                ),
                const Divider(),
                DailyForecastRow(
                  day: 'Tue',
                  icon: Symbols.sunny,
                  low: 60,
                  high: 75,
                  progressStart: .28,
                  progressEnd: .68,
                ),
                const Divider(),
                DailyForecastRow(
                  day: 'Wed',
                  icon: Symbols.sunny,
                  low: 59,
                  high: 74,
                  progressStart: .30,
                  progressEnd: .60,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Row(
            spacing: 16,
            children: [
              Expanded(
                child: MetricCard(
                  icon: Symbols.sunny,
                  title: 'UV INDEX',
                  value: const Text('4'),
                  footer: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Moderate'),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: 0.4,
                        minHeight: 8,
                        color: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.onTertiary,
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
                  value: const Text('12 mph'),
                  footer: const Text('WNW 8 mph'),
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
                  value: const Text('64%'),
                  footer: const Text('Dew point 58°'),
                ),
              ),
              Expanded(
                child: MetricCard(
                  icon: Symbols.water_drop,
                  title: 'VISIBILITY',
                  value: const Row(
                    children: [Text('10'), SizedBox(width: 4), Text('mi')],
                  ),
                  footer: const Text('Clear view'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
