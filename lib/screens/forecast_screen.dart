import 'package:flutter/material.dart';
import 'package:flutter_weather/service/weather_service.dart';
import 'package:flutter_weather/shared/daily_forecast_row.dart';
import 'package:flutter_weather/shared/weather_card.dart';
import 'package:flutter_weather/utils/weather_utils.dart';
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
          return _buildErrorWidget(context, snapshot.error.toString());
        }

        final data = snapshot.data!;
        return _buildForecastContent(context, data);
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

  Widget _buildForecastContent(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final forecast = data['forecast'];
    final forecastDay = forecast['forecastday'];

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
                      : WeatherUtils.getDayName(date.weekday);
                  final condition = dayData['condition'];
                  final low = day['mintemp_c'].round();
                  final high = day['maxtemp_c'].round();

                  return Column(
                    children: [
                      DailyForecastRow(
                        day: dayName,
                        icon: WeatherUtils.getWeatherIcon(condition),
                        low: low,
                        high: high,
                        progressStart: WeatherUtils.mapTemperatureToProgress(
                          low,
                          high,
                        ),
                        progressEnd: WeatherUtils.mapTemperatureToProgress(
                          high,
                          high + 5,
                        ),
                      ),
                      if (index < dailyForecasts.length - 1) const Divider(),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
