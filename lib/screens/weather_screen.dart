import 'package:flutter/material.dart';
import 'package:flutter_weather/service/weather_service.dart';
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
        return _buildWeatherContent(context, data);
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
        mainAxisSize: MainAxisSize.min, // Add this
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
        mainAxisSize: MainAxisSize.min, // Add this
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
    );
  }

  Widget _buildHourlyForecast(
    BuildContext context,
    List<Map<String, dynamic>> hours,
  ) {
    return WeatherCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Add this
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
                  temperature: '$temp°',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureCard(BuildContext context, int minTemp, int maxTemp) {
    return WeatherCard(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Add this
        children: [
          Row(
            children: [
              Icon(
                Symbols.thermostat,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Temperature',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                '$maxTemp°',
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
      ),
    );
  }

  Widget _buildFeelsLikeCard(BuildContext context, int feelsLike) {
    return WeatherCard(
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Add this
        children: [
          Row(
            children: [
              Icon(
                Symbols.thermometer,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Feels like',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindCard(BuildContext context, int windKph, String windDir) {
    return WeatherCard(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Add this
        children: [
          Row(
            children: [
              Icon(
                Symbols.air,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Wind',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
      ),
    );
  }

  Widget _buildHumidityCard(BuildContext context, int humidity) {
    return WeatherCard(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Add this
        children: [
          Row(
            children: [
              Icon(
                Symbols.humidity_percentage,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Humidity',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                  painter: GaugePainter(humidity / 100, Colors.blue),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min, // Add this
                children: [
                  Text(
                    '$humidity%',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
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
      ),
    );
  }

  Widget _buildUVCard(BuildContext context, double uv) {
    return WeatherCard(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Add this
        children: [
          Row(
            children: [
              Icon(
                Symbols.sunny,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'UV Index',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                child: CustomPaint(painter: GaugePainter2(uv / 11)),
              ),
              Column(
                mainAxisSize: MainAxisSize.min, // Add this
                children: [
                  Text(
                    uv.toString(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
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
      ),
    );
  }

  Widget _buildCloudCard(BuildContext context, double cloud) {
    return WeatherCard(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Add this
        children: [
          Row(
            children: [
              Icon(
                Symbols.air_purifier,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Air Quality',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                    WeatherUtils.getCloudColor(cloud),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min, // Add this
                children: [
                  Text(
                    '${cloud.round()}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
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
      ),
    );
  }

  Widget _buildDewPointCard(BuildContext context, int dewPoint) {
    return WeatherCard(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Add this
        children: [
          Row(
            children: [
              Icon(
                Symbols.dew_point,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Dew Point',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '$dewPoint°',
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
      ),
    );
  }

  Widget _buildPressureCard(BuildContext context, double pressure) {
    return WeatherCard(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Add this
        children: [
          Row(
            children: [
              Icon(
                Symbols.compress,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Pressure',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                  painter: GaugePainter((pressure - 980) / 100, Colors.teal),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min, // Add this
                children: [
                  Text(
                    '${pressure.round()} mb',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
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
      ),
    );
  }

  Widget _buildVisibilityCard(BuildContext context, double visibility) {
    return WeatherCard(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Add this
        children: [
          Row(
            children: [
              Icon(
                Symbols.visibility,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Visibility',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
      ),
    );
  }

  Widget _buildSunCard(BuildContext context, String sunrise, String sunset) {
    return WeatherCard(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Add this
        children: [
          Row(
            children: [
              Icon(
                Symbols.wb_twilight,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Sunrise - Sunset',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                WeatherUtils.calculateSunPosition(sunrise, sunset),
                Colors.amber,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoonCard(BuildContext context, String moonrise, String moonset) {
    return WeatherCard(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Symbols.wb_twilight_2,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Moonrise - Moonset',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                WeatherUtils.calculateMoonPosition(moonrise, moonset),
                Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoonPhaseCard(BuildContext context, String moonPhase) {
    return WeatherCard(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Symbols.circle,
                fill: 1,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Moon Phase',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Icon(WeatherUtils.getMoonPhaseIcon(moonPhase), size: 72),
          const SizedBox(width: 12),
          Center(
            child: Text(
              moonPhase,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
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
