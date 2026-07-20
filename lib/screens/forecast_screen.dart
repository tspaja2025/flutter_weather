import 'package:flutter/material.dart';
import 'package:flutter_weather/service/weather_service.dart';
import 'package:flutter_weather/shared/app_scaffold.dart';
import 'package:flutter_weather/shared/daily_forecast_row.dart';
import 'package:flutter_weather/shared/weather_card.dart';
import 'package:flutter_weather/utils/weather_utils.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  final String _city = 'Tampere';
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final data = await _weatherService.getWeatherData('Tampere');
      setState(() {
        _weatherData = data;
        _isLoading = false;
        _error = '';
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return AppScaffold(
        currentIndex: 0,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error.isNotEmpty) {
      return AppScaffold(
        currentIndex: 0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchWeatherData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return AppScaffold(
      currentIndex: 1,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [_buildForecastContent(context, _weatherData!)],
        ),
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
        ],
      ),
    );
  }
}
