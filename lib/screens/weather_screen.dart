import 'package:flutter/material.dart';
import 'package:flutter_weather/service/weather_service.dart';
import 'package:flutter_weather/shared/app_scaffold.dart';
import 'package:flutter_weather/shared/hourly_forecast_item.dart';
import 'package:flutter_weather/shared/weather_card.dart';
import 'package:flutter_weather/utils/weather_utils.dart';
import 'package:flutter_weather/widgets/compass_painter.dart';
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
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final data = await _weatherService.getWeatherData(_city);
      setState(() {
        _weatherData = data;
        _isLoading = false;
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
      currentIndex: 0,
      child: _buildWeatherContent(context, _weatherData!),
    );
  }

  Widget _buildWeatherContent(BuildContext context, Map<String, dynamic> data) {
    final current = data['current'];
    final forecast = data['forecast'];
    final forecastDay = forecast['forecastday'];
    final todayForecast = forecastDay[0]['day'];

    final currentTemp = WeatherUtils.toInt(current['temp_c']);
    final currentCondition = current['condition']['text'] as String;
    final feelsLike = WeatherUtils.toInt(current['feelslike_c']);
    final humidity = WeatherUtils.toInt(current['humidity']);
    final windKph = WeatherUtils.toInt(current['wind_kph']);
    final windDir = current['wind_dir'] as String;
    final pressure = WeatherUtils.toDouble(current['pressure_mb']);
    final visibility = WeatherUtils.toDouble(current['vis_km']);
    final uv = WeatherUtils.toDouble(current['uv']);
    final cloud = WeatherUtils.toDouble(current['cloud']);
    final dewPoint = WeatherUtils.toInt(current['dewpoint_c']);
    final maxTemp = WeatherUtils.toInt(todayForecast['maxtemp_c']);
    final minTemp = WeatherUtils.toInt(todayForecast['mintemp_c']);

    final astro = forecastDay[0]['astro'];
    final sunrise = astro['sunrise'] as String;
    final sunset = astro['sunset'] as String;
    final moonrise = astro['moonrise'] as String;
    final moonset = astro['moonset'] as String;
    final moonPhase = astro['moon_phase'] as String;

    // Get hourly forecast for today
    final hourlyForecasts = (forecastDay[0]['hour'] as List)
        .cast<Map<String, dynamic>>();
    final now = DateTime.now();
    final currentHour = now.hour;
    final nextHours = <Map<String, dynamic>>[];
    for (int i = 0; i < 5; i++) {
      final hourIndex = (currentHour + i) % 24;
      if (hourIndex < hourlyForecasts.length) {
        nextHours.add(hourlyForecasts[hourIndex]);
      }
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCurrentWeather(
            context,
            city: _city,
            temperature: currentTemp,
            condition: currentCondition,
            maxTemp: maxTemp,
            minTemp: minTemp,
          ),
          const SizedBox(height: 32),
          _buildHourlyForecast(context, nextHours),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.15,
            children: [
              _buildTemperatureCard(context, minTemp, maxTemp),
              _buildFeelsLikeCard(context, feelsLike),
              _buildWindCard(context, windKph, windDir),
              _buildHumidityCard(context, humidity),
              _buildUVCard(context, uv),
              _buildCloudCard(context, cloud),
              _buildDewPointCard(context, dewPoint),
              _buildPressureCard(context, pressure),
              _buildVisibilityCard(context, visibility),
              _buildSunCard(context, sunrise, sunset),
              _buildMoonCard(context, moonrise, moonset),
              _buildMoonPhaseCard(context, moonPhase),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeather(
    BuildContext context, {
    required String city,
    required int temperature,
    required String condition,
    required int maxTemp,
    required int minTemp,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            WeatherUtils.getWeatherIcon(condition),
            size: 150,
            color: Theme.of(context).colorScheme.primary,
          ),
          Text(_city, style: Theme.of(context).textTheme.headlineLarge),
          Text(
            '$temperature°',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(condition, style: Theme.of(context).textTheme.bodyLarge),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'H: $maxTemp °C',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 16),
              Text(
                'L: $minTemp °C',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast(
    BuildContext context,
    List<Map<String, dynamic>> hours,
  ) {
    return WeatherCard(
      icon: Symbols.access_time,
      title: 'Hourly Forecast',
      children: [
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: hours.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final hour = hours[index];
              final time = hour['time'] as String;
              final temp = WeatherUtils.toInt(hour['temp_c']);
              final condition = hour['condition']['text'] as String;
              final isNow = index == 0;

              return HourlyForecastItem(
                time: isNow ? 'Now' : time.split(' ')[1],
                icon: WeatherUtils.getWeatherIcon(condition),
                temperature: '$temp °C',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureCard(BuildContext context, int minTemp, int maxTemp) {
    return WeatherCard(
      icon: Symbols.thermostat,
      title: 'Temperature',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$minTemp °C',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              '$maxTemp °C',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
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
    );
  }

  Widget _buildFeelsLikeCard(BuildContext context, int feelsLike) {
    return WeatherCard(
      icon: Symbols.thermometer,
      title: 'Feels like',
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: Alignment.center,
          child: Text(
            '$feelsLike °C',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildWindCard(BuildContext context, int windKph, String windDir) {
    return WeatherCard(
      icon: Symbols.air,
      title: 'Wind',
      children: [
        Text(
          '$windKph km/h',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Center(
          child: Column(
            children: [
              CustomPaint(
                size: Size.square(60),
                painter: CompassPainter(windDir),
              ),
              Text(windDir, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHumidityCard(BuildContext context, int humidity) {
    return WeatherCard(
      icon: Symbols.humidity_percentage,
      title: 'Humidity',
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              width: double.infinity,
              height: 90,
              child: CustomPaint(
                painter: GaugePainter(humidity / 100, Colors.blue),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$humidity%',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  WeatherUtils.getHumidityLevel(humidity),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUVCard(BuildContext context, double uv) {
    return WeatherCard(
      icon: Symbols.sunny,
      title: 'UV Index',
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              width: double.infinity,
              height: 90,
              child: CustomPaint(painter: GaugePainter2(uv / 11)),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  uv.toString(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  WeatherUtils.getUVLevel(uv),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCloudCard(BuildContext context, double cloud) {
    return WeatherCard(
      icon: Symbols.air_purifier,
      title: 'Air Quality',
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              width: double.infinity,
              height: 90,
              child: CustomPaint(
                painter: GaugePainter(
                  cloud / 100,
                  WeatherUtils.getCloudColor(cloud),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${cloud.round()}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  WeatherUtils.getCloudLevel(cloud),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDewPointCard(BuildContext context, int dewPoint) {
    return WeatherCard(
      icon: Symbols.dew_point,
      title: 'Dew Point',
      children: [
        Center(
          child: Text(
            '$dewPoint °C',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
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
    );
  }

  Widget _buildPressureCard(BuildContext context, double pressure) {
    return WeatherCard(
      icon: Symbols.compress,
      title: 'Pressure',
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              width: double.infinity,
              height: 90,
              child: CustomPaint(
                painter: GaugePainter((pressure - 980) / 100, Colors.teal),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${pressure.round()} mb',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  WeatherUtils.getPressureLevel(pressure),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVisibilityCard(BuildContext context, double visibility) {
    return WeatherCard(
      icon: Symbols.visibility,
      title: 'Visibility',
      children: [
        Text(
          '${visibility.toStringAsFixed(1)} km',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildVisibilityBars(visibility),
        ),
      ],
    );
  }

  Widget _buildSunCard(BuildContext context, String sunrise, String sunset) {
    return WeatherCard(
      icon: Symbols.wb_twilight,
      title: 'Sunrise - Sunset',
      children: [
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
              WeatherUtils.calculateSunPosition(sunrise, sunset),
              Colors.amber,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoonCard(BuildContext context, String moonrise, String moonset) {
    return WeatherCard(
      icon: Symbols.wb_twilight_2,
      title: 'Moonrise - Moonset',
      children: [
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
              WeatherUtils.calculateMoonPosition(moonrise, moonset),
              Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoonPhaseCard(BuildContext context, String moonPhase) {
    return WeatherCard(
      title: 'Moon Phase',
      icon: Symbols.circle,
      children: [
        Icon(WeatherUtils.getMoonPhaseIcon(moonPhase), size: 72),
        const SizedBox(width: 12),
        Center(
          child: Text(moonPhase, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }

  // Helpers
  List<Widget> _buildTemperatureBars() {
    final heights = [15, 20, 25, 30, 35, 35, 30, 25, 20, 15];

    return List.generate(heights.length, (index) {
      return SizedBox(
        width: 8,
        child: Container(
          height: heights[index].toDouble(),
          decoration: BoxDecoration(
            color: getBarColor(index, heights.length),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    });
  }

  Color getBarColor(int index, int total) {
    final t = index <= total / 2
        ? index / (total / 2)
        : (total - 1 - index) / (total / 2);

    return Color.lerp(
      Colors.green.shade300,
      Colors.yellow.shade600,
      t.clamp(0.0, 1.0),
    )!;
  }

  List<Widget> _buildVisibilityBars(double visibility) {
    final maxVisibility = 50.0;
    final bars = 9;
    final barHeight = (visibility / maxVisibility) * 60;

    return List.generate(bars, (index) {
      final height = (index + 1) / bars * 60;
      final isActive = height <= barHeight;
      return SizedBox(
        width: 8,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.grey.shade300,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12),
              bottom: Radius.circular(12),
            ),
          ),
        ),
      );
    });
  }
}
