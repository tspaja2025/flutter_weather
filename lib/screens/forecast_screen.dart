import 'package:flutter/material.dart';
import 'package:flutter_weather/service/weather_service.dart';
import 'package:flutter_weather/shared/daily_forecast_row.dart';
import 'package:flutter_weather/shared/weather_card.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final WeatherService _weatherService = WeatherService();
  final String _city = 'Tampere';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _weatherService.getWeatherData(_city),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
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
                  'Error: ${snapshot.error}',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final data = snapshot.data!;

        // Forecast data
        final forecast = data['forecast'];
        final forecastDay = forecast['forecastday'];

        // Get daily forecast for next days
        final dailyForecasts = forecastDay.map((day) {
          return {
            'date': DateTime.parse(day['date']),
            'day': day['day'],
            'condition': day['day']['condition']['text'],
          };
        }).toList();

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _city,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  letterSpacing: 4,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${dailyForecasts.length}-Day Forecast',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 16),

              WeatherCard(
                child: Column(
                  children: [
                    ...dailyForecasts.asMap().entries.map((entry) {
                      final index = entry.key;
                      final dayData = entry.value;
                      final day = dayData['day'];
                      final date = dayData['date'];
                      final dayName = index == 0
                          ? 'Today'
                          : _getDayName(date.weekday);
                      final condition = dayData['condition'];
                      final low = day['mintemp_c'].round();
                      final high = day['maxtemp_c'].round();

                      return Column(
                        children: [
                          DailyForecastRow(
                            day: dayName,
                            icon: _getWeatherIcon(condition),
                            low: low,
                            high: high,
                            progressStart: _mapTemperatureToProgress(low, high),
                            progressEnd: _mapTemperatureToProgress(
                              high,
                              high + 5,
                            ),
                          ),
                          if (index < dailyForecasts.length - 1)
                            const Divider(),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helpers
  IconData _getWeatherIcon(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('sunny') || lower.contains('clear')) {
      return Symbols.sunny;
    } else if (lower.contains('partly cloudy')) {
      return Symbols.partly_cloudy_day;
    } else if (lower.contains('cloudy') || lower.contains('overcast')) {
      return Symbols.cloud;
    } else if (lower.contains('rain') || lower.contains('drizzle')) {
      return Symbols.rainy;
    } else if (lower.contains('snow')) {
      return Symbols.ac_unit;
    } else if (lower.contains('thunder') || lower.contains('storm')) {
      return Symbols.thunderstorm;
    } else if (lower.contains('fog') || lower.contains('mist')) {
      return Symbols.foggy;
    }
    return Symbols.partly_cloudy_day;
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  double _mapTemperatureToProgress(int temp, int maxTemp) {
    final minTemp = -20.0;
    final maxTempRange = 40.0;
    return (temp - minTemp) / (maxTempRange - minTemp);
  }
}
