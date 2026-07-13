import 'package:flutter/material.dart';
import 'package:flutter_weather/service/weather_service.dart';
import 'package:flutter_weather/shared/daily_forecast_row.dart';
import 'package:flutter_weather/shared/hourly_forecast_item.dart';
import 'package:flutter_weather/shared/weather_card.dart';
import 'package:flutter_weather/widgets/gauge_painter.dart';
import 'package:flutter_weather/widgets/sun_moon_path_painter.dart';
import 'package:material_symbols_icons/symbols.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
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

        // Current weather data
        final current = data['current'];
        final currentTemp = current['temp_c'].round();
        final currentCondition = current['condition']['text'];
        final feelsLike = current['feelslike_c'].round();
        final humidity = current['humidity'];
        final windKph = current['wind_kph'];
        final windDir = current['wind_dir'];
        final pressure = current['pressure_mb'];
        final visibility = current['vis_km'];
        final uv = current['uv'];
        final cloud = current['cloud'];
        final dewPoint = current['dewpoint_c'];

        // Forecast data
        final forecast = data['forecast'];
        final forecastDay = forecast['forecastday'];
        final todayForecast = forecastDay[0]['day'];
        final maxTemp = todayForecast['maxtemp_c'].round();
        final minTemp = todayForecast['mintemp_c'].round();

        // Get daily forecast for next days
        final dailyForecasts = forecastDay.map((day) {
          return {
            'date': DateTime.parse(day['date']),
            'day': day['day'],
            'condition': day['day']['condition']['text'],
          };
        }).toList();

        // Get hourly forecast for today
        final hourlyForecasts = forecastDay[0]['hour'];
        final now = DateTime.now();
        final currentHour = now.hour;

        // Get next 5 hours
        final nextHours = <Map<String, dynamic>>[];
        for (int i = 0; i < 5; i++) {
          final hourIndex = (currentHour + i) % 24;
          if (hourIndex < hourlyForecasts.length) {
            nextHours.add(hourlyForecasts[hourIndex]);
          }
        }

        // Get sunrise/sunset times
        final astro = forecastDay[0]['astro'];
        final sunrise = astro['sunrise'];
        final sunset = astro['sunset'];
        final moonrise = astro['moonrise'];
        final moonset = astro['moonset'];
        final moonPhase = astro['moon_phase'];

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Icon(
                      _getWeatherIcon(currentCondition),
                      size: 150,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      _city,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      '$currentTemp°',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      currentCondition,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'H: $maxTemp°',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'L: $minTemp°',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
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

                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: nextHours.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final hour = nextHours[index];
                          final time = hour['time'];
                          final temp = hour['temp_c'].round();
                          final condition = hour['condition']['text'];
                          final isNow = index == 0;

                          return HourlyForecastItem(
                            time: isNow ? 'Now' : time.split(' ')[1],
                            icon: _getWeatherIcon(condition),
                            temperature: '$temp°',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
                children: [
                  WeatherCard(
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Symbols.thermostat,
                              size: 16,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Temperature',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$minTemp°',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '$maxTemp°',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _buildTemperatureBars(),
                        ),
                      ],
                    ),
                  ),
                  WeatherCard(
                    elevation: 0,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Symbols.thermometer,
                              size: 16,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Feels like',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Container(
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: .2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$feelsLike°',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WeatherCard(
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Symbols.air,
                              size: 16,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Wind',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        Text(
                          '$windKph km/h',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          windDir,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  WeatherCard(
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Symbols.humidity_percentage,
                              size: 16,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Humidity',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 90,
                              child: CustomPaint(
                                painter: GaugePainter(
                                  humidity / 100,
                                  Colors.blue,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '$humidity%',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  _getHumidityLevel(humidity),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  WeatherCard(
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Symbols.sunny,
                              size: 16,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'UV Index',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 90,
                              child: CustomPaint(
                                painter: GaugePainter2(uv / 11),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  uv.toString(),
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  _getUVLevel(uv),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  WeatherCard(
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Symbols.air_purifier,
                              size: 16,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Air Quality',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 90,
                              child: CustomPaint(
                                painter: GaugePainter(
                                  cloud / 100,
                                  _getCloudColor(cloud),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '$cloud%',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  _getCloudLevel(cloud),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  WeatherCard(
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Symbols.dew_point,
                              size: 16,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Dew Point',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Center(
                          child: Text(
                            '$dewPoint°',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade100,
                                Colors.blue.shade400,
                                Colors.blue.shade700,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [const Text('-5'), const Text('25')],
                        ),
                      ],
                    ),
                  ),
                  WeatherCard(
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Symbols.compress,
                              size: 16,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Pressure',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 90,
                              child: CustomPaint(
                                painter: GaugePainter(
                                  (pressure - 980) / 100,
                                  Colors.teal,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '$pressure mb',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  _getPressureLevel(pressure),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  WeatherCard(
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Symbols.visibility,
                              size: 16,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Visibility',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          '${visibility.toStringAsFixed(1)} km',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _buildVisibilityBars(visibility),
                        ),
                      ],
                    ),
                  ),
                  WeatherCard(
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Symbols.wb_twilight,
                              size: 16,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Sunrise - Sunset',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$sunrise - $sunset',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: CustomPaint(
                            painter: SunMoonPathPainter(
                              _calculateSunPosition(sunrise, sunset),
                              Colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WeatherCard(
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Symbols.wb_twilight_2,
                              size: 16,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Moonrise - Moonset',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$moonrise - $moonset',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: CustomPaint(
                            painter: SunMoonPathPainter(
                              _calculateMoonPosition(moonrise, moonset),
                              Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WeatherCard(
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Symbols.bedtime,
                              size: 16,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Moon Phase',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Center(
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(Symbols.circle, fill: 1, size: 72),
                                  Icon(
                                    _getMoonPhaseIcon(moonPhase),
                                    fill: 1,
                                    size: 72,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                moonPhase,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
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
                          '${dailyForecasts.length}-DAY FORECAST',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

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

  String _getHumidityLevel(int humidity) {
    if (humidity < 30) return 'Low';
    if (humidity < 60) return 'Moderate';
    return 'High';
  }

  String _getUVLevel(double uv) {
    if (uv < 3) return 'Low';
    if (uv < 6) return 'Moderate';
    if (uv < 8) return 'High';
    if (uv < 11) return 'Very High';
    return 'Extreme';
  }

  Color _getCloudColor(double cloud) {
    if (cloud < 30) return Colors.green;
    if (cloud < 60) return Colors.orange;
    return Colors.red;
  }

  String _getCloudLevel(double cloud) {
    if (cloud < 30) return 'Clear';
    if (cloud < 60) return 'Partly Cloudy';
    return 'Cloudy';
  }

  String _getPressureLevel(double pressure) {
    if (pressure < 1010) return 'Low';
    if (pressure < 1020) return 'Normal';
    return 'High';
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  double _calculateSunPosition(String sunrise, String sunset) {
    final now = DateTime.now();
    final totalDaySeconds = 24 * 3600;
    final currentSeconds = now.hour * 3600 + now.minute * 60;
    return (currentSeconds / totalDaySeconds).clamp(0.0, 1.0);
  }

  double _calculateMoonPosition(String moonRise, String moonSet) {
    final now = DateTime.now();
    final totalDaySeconds = 24 * 3600;
    final currentSeconds = now.hour * 3600 + now.minute * 60;
    return (currentSeconds / totalDaySeconds).clamp(0.0, 1.0);
  }

  IconData _getMoonPhaseIcon(String phase) {
    final lower = phase.toLowerCase();
    if (lower.contains('new')) return Symbols.bedtime;
    if (lower.contains('waxing crescent')) return Symbols.brightness_3;
    if (lower.contains('first quarter')) return Symbols.brightness_4;
    if (lower.contains('waxing gibbous')) return Symbols.brightness_5;
    if (lower.contains('full')) return Symbols.brightness_6;
    if (lower.contains('waning gibbous')) return Symbols.brightness_7;
    if (lower.contains('last quarter')) return Symbols.brightness_4;
    if (lower.contains('waning crescent')) return Symbols.brightness_3;
    return Symbols.bedtime;
  }

  double _mapTemperatureToProgress(int temp, int maxTemp) {
    final minTemp = -20.0;
    final maxTempRange = 40.0;
    return (temp - minTemp) / (maxTempRange - minTemp);
  }

  List<Widget> _buildTemperatureBars() {
    final heights = [15, 20, 25, 30, 35, 35, 30, 25, 20, 15];
    return heights.map((height) {
      return Container(
        width: 8,
        height: height.toDouble(),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12),
            bottom: Radius.circular(12),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildVisibilityBars(double visibility) {
    final maxVisibility = 50.0;
    final bars = 9;
    final barHeight = (visibility / maxVisibility) * 60;

    return List.generate(bars, (index) {
      final height = (index + 1) / bars * 60;
      final isActive = height <= barHeight;
      return Container(
        width: 8,
        height: height,
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12),
            bottom: Radius.circular(12),
          ),
        ),
      );
    });
  }
}
