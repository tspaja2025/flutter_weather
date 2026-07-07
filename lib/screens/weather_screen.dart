import 'package:flutter/material.dart';
import 'package:flutter_weather/shared/daily_forecast_row.dart';
import 'package:flutter_weather/shared/hourly_forecast_item.dart';
import 'package:flutter_weather/shared/metric_card.dart';
import 'package:flutter_weather/shared/weather_card.dart';
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
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                '72°',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
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
                    style: Theme.of(context).textTheme.labelMedium,
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
                  HourlyForecastItem(
                    time: 'Now',
                    icon: Symbols.sunny,
                    temperature: '72°',
                  ),
                  HourlyForecastItem(
                    time: '1PM',
                    icon: Symbols.partly_cloudy_day,
                    temperature: '74°',
                  ),
                  HourlyForecastItem(
                    time: '2PM',
                    icon: Symbols.partly_cloudy_day,
                    temperature: '75°',
                  ),
                  HourlyForecastItem(
                    time: '3PM',
                    icon: Symbols.cloud,
                    temperature: '73°',
                  ),
                ],
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

        const SizedBox(height: 16),

        WeatherCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Symbols.calendar_month,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '10-DAY FORECAST',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              DailyForecastRow(
                day: 'Today',
                icon: Symbols.partly_cloudy_day,
                low: 64,
                high: 78,
                progressStart: .30,
                progressEnd: .72,
              ),
              const Divider(),
              DailyForecastRow(
                day: 'Tue',
                icon: Symbols.sunny,
                low: 62,
                high: 81,
                progressStart: .28,
                progressEnd: .75,
              ),
              const Divider(),
              DailyForecastRow(
                day: 'Wed',
                icon: Symbols.cloud,
                low: 60,
                high: 74,
                progressStart: .26,
                progressEnd: .68,
              ),
              const Divider(),
              DailyForecastRow(
                day: 'Thu',
                icon: Symbols.rainy,
                low: 58,
                high: 68,
                progressStart: .24,
                progressEnd: .60,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
