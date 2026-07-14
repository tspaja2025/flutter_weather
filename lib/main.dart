import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_weather/shared/city_card.dart';
import 'package:flutter_weather/shared/daily_forecast_row.dart';
import 'package:flutter_weather/shared/hourly_forecast_item.dart';
import 'package:flutter_weather/shared/weather_card.dart';
import 'package:flutter_weather/theme/stormy.dart';
import 'package:flutter_weather/widgets/compass_painter.dart';
import 'package:flutter_weather/widgets/gauge_painter.dart';
import 'package:flutter_weather/widgets/sun_moon_path_painter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService();
});

final selectedCityProvider = StateProvider<String>((ref) => 'Tampere');

final savedCitiesProvider = StateProvider<List<String>>((ref) {
  return ['London', 'New York', 'Tokyo'];
});

final currentWeatherProvider = FutureProvider.family<WeatherData, String>((
  ref,
  city,
) async {
  final weatherService = ref.watch(weatherServiceProvider);
  return await weatherService.getWeatherData(city);
});

final multipleCitiesWeatherProvider = FutureProvider<List<WeatherData>>((
  ref,
) async {
  final cities = ref.watch(savedCitiesProvider);
  final weatherService = ref.watch(weatherServiceProvider);
  return await weatherService.getAllweather(cities);
});

final forecastProvider = FutureProvider.family<ForecastData, String>((
  ref,
  city,
) async {
  final weatherService = ref.watch(weatherServiceProvider);
  return await weatherService.getForecast(city);
});

final weatherDataProvider = FutureProvider<WeatherData>((ref) {
  final city = ref.watch(selectedCityProvider);
  return ref.watch(currentWeatherProvider(city).future);
});

class WeatherData {
  final Location location;
  final CurrentWeather current;
  final Forecast forecast;

  WeatherData({
    required this.location,
    required this.current,
    required this.forecast,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      location: Location.fromJson(json['location']),
      current: CurrentWeather.fromJson(json['current']),
      forecast: Forecast.fromJson(json['forecast']),
    );
  }
}

class Location {
  final String name;
  final String country;
  final String localtime;

  Location({
    required this.name,
    required this.country,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      country: json['country'],
      localtime: json['localtime'],
    );
  }
}

class CurrentWeather {
  final double tempC;
  final double feelslikeC;
  final int humidity;
  final double windKph;
  final String windDir;
  final double pressureMb;
  final double visKm;
  final double uv;
  final double cloud;
  final double dewpointC;
  final Condition condition;

  CurrentWeather({
    required this.tempC,
    required this.feelslikeC,
    required this.humidity,
    required this.windKph,
    required this.windDir,
    required this.pressureMb,
    required this.visKm,
    required this.uv,
    required this.cloud,
    required this.dewpointC,
    required this.condition,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      tempC: WeatherUtils.toDouble(json['temp_c']),
      feelslikeC: WeatherUtils.toDouble(json['feelslike_c']),
      humidity: WeatherUtils.toInt(json['humidity']),
      windKph: WeatherUtils.toDouble(json['wind_kph']),
      windDir: json['wind_dir'],
      pressureMb: WeatherUtils.toDouble(json['pressure_mb']),
      visKm: WeatherUtils.toDouble(json['vis_km']),
      uv: WeatherUtils.toDouble(json['uv']),
      cloud: WeatherUtils.toDouble(json['cloud']),
      dewpointC: WeatherUtils.toDouble(json['dewpoint_c']),
      condition: Condition.fromJson(json['condition']),
    );
  }
}

class Condition {
  final String text;
  final int code;

  Condition({required this.text, required this.code});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(text: json['text'], code: json['code']);
  }
}

class Forecast {
  final List<ForecastDay> forecastDays;

  Forecast({required this.forecastDays});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final forecastDays = (json['forecastday'] as List)
        .map((day) => ForecastDay.fromJson(day))
        .toList();
    return Forecast(forecastDays: forecastDays);
  }
}

class ForecastDay {
  final DateTime date;
  final DayWeather day;
  final Astro astro;
  final List<HourlyWeather> hours;

  ForecastDay({
    required this.date,
    required this.day,
    required this.astro,
    required this.hours,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: DateTime.parse(json['date']),
      day: DayWeather.fromJson(json['day']),
      astro: Astro.fromJson(json['astro']),
      hours: (json['hour'] as List)
          .map((hour) => HourlyWeather.fromJson(hour))
          .toList(),
    );
  }
}

class DayWeather {
  final double maxTempC;
  final double minTempC;
  final Condition condition;

  DayWeather({
    required this.maxTempC,
    required this.minTempC,
    required this.condition,
  });

  factory DayWeather.fromJson(Map<String, dynamic> json) {
    return DayWeather(
      maxTempC: WeatherUtils.toDouble(json['maxtemp_c']),
      minTempC: WeatherUtils.toDouble(json['mintemp_c']),
      condition: Condition.fromJson(json['condition']),
    );
  }
}

class Astro {
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonset;
  final String moonPhase;

  Astro({
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
  });

  factory Astro.fromJson(Map<String, dynamic> json) {
    return Astro(
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      moonrise: json['moonrise'],
      moonset: json['moonset'],
      moonPhase: json['moon_phase'],
    );
  }
}

class HourlyWeather {
  final String time;
  final double tempC;
  final Condition condition;

  HourlyWeather({
    required this.time,
    required this.tempC,
    required this.condition,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: json['time'],
      tempC: WeatherUtils.toDouble(json['temp_c']),
      condition: Condition.fromJson(json['condition']),
    );
  }
}

class ForecastData {
  final Forecast forecast;

  ForecastData({required this.forecast});

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(forecast: Forecast.fromJson(json['forecast']));
  }
}

class WeatherService {
  final String _apiKey = dotenv.env['WEATHERAPI'] ?? '';

  // Get current weather
  Future<Map<String, dynamic>> getWeather(String city) async {
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/current.json?key=$_apiKey&q=$city',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to load weather: ${response.statusCode}\n${response.body}',
      );
    }
  }

  // Get forecast weather
  Future<Map<String, dynamic>> getForecast(String city) async {
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=$_apiKey&q=$city&days=7',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to load forecast: ${response.statusCode}\n${response.body}',
      );
    }
  }

  // Get both current and forecast data
  Future<Map<String, dynamic>> getWeatherData(String city) async {
    final current = await getWeather(city);
    final forecast = await getForecast(city);
    return {...current, 'forecast': forecast['forecast']};
  }

  // Get weather data for multiple cities
  Future<List<Map<String, dynamic>>> getMultipleCitiesWeather(
    List<String> cities,
  ) async {
    final List<Future<Map<String, dynamic>>> futures = cities
        .map((city) => getWeatherData(city))
        .toList();

    return await Future.wait(futures);
  }

  Future<List<Map<String, dynamic>>> getAllweather(List<String> cities) async {
    return await Future.wait(cities.map((city) => getWeatherData(city)));
  }
}

class WeatherUtils {
  static IconData getWeatherIcon(String condition) {
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

  static String getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  static String getHumidityLevel(int humidity) {
    if (humidity < 30) return 'Low';
    if (humidity < 60) return 'Moderate';
    return 'High';
  }

  static String getUVLevel(double uv) {
    if (uv < 3) return 'Low';
    if (uv < 6) return 'Moderate';
    if (uv < 8) return 'High';
    if (uv < 11) return 'Very High';
    return 'Extreme';
  }

  static Color getCloudColor(double cloud) {
    if (cloud < 30) return Colors.green;
    if (cloud < 60) return Colors.orange;
    return Colors.red;
  }

  static String getCloudLevel(double cloud) {
    if (cloud < 30) return 'Clear';
    if (cloud < 60) return 'Partly Cloudy';
    return 'Cloudy';
  }

  static String getPressureLevel(double pressure) {
    if (pressure < 1010) return 'Low';
    if (pressure < 1020) return 'Normal';
    return 'High';
  }

  static IconData getMoonPhaseIcon(String phase) {
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

  static double mapTemperatureToProgress(double temp, double maxTemp) {
    final minTemp = -20.0;
    final maxTempRange = 40.0;
    return (temp - minTemp) / (maxTempRange - minTemp);
  }

  static double calculateSunPosition(String sunrise, String sunset) {
    final sunriseTime = _parseTime(sunrise);
    final sunsetTime = _parseTime(sunset);
    final now = DateTime.now();
    final totalDuration = sunsetTime.difference(sunriseTime).inSeconds;
    final elapsedDuration = now.difference(sunriseTime).inSeconds;
    return elapsedDuration / totalDuration;
  }

  static double calculateMoonPosition(String moonRise, String moonSet) {
    final moonRiseTime = _parseTime(moonRise);
    final moonSetTime = _parseTime(moonSet);
    final now = DateTime.now();
    final totalDuration = moonSetTime.difference(moonRiseTime).inSeconds;
    final elapsedDuration = now.difference(moonRiseTime).inSeconds;
    return elapsedDuration / totalDuration;
  }

  static DateTime _parseTime(String time) {
    final now = DateTime.now();
    final parsed = DateFormat('hh:mm a').parse(time);

    return DateTime(now.year, now.month, now.day, parsed.hour, parsed.minute);
  }

  static double toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return 0.0;
  }

  static int toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    return 0;
  }
}

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Weather',
      theme: StormyTheme.dark(),
      themeMode: ThemeMode.dark,
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          ShellRoute(
            builder: (context, state, child) => AppScaffold(child: child),
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const WeatherScreen(),
              ),
              GoRoute(
                path: '/forecast',
                builder: (context, state) => const ForecastScreen(),
              ),
              GoRoute(
                path: '/cities',
                builder: (context, state) => const CitiesScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    );
  }
}

class AppScaffold extends StatefulWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/forecast');
              break;
            case 2:
              context.go('/cities');
              break;
            case 3:
              context.go('/settings');
              break;
          }
        },
        selectedIndex: _selectedIndex,
        indicatorColor: Theme.of(context).colorScheme.primary,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Symbols.cloud, fill: 1),
            icon: Icon(Symbols.cloud),
            label: 'Weather',
          ),
          NavigationDestination(
            selectedIcon: Icon(Symbols.calendar_month, fill: 1),
            icon: Icon(Symbols.calendar_month),
            label: 'Forecast',
          ),
          NavigationDestination(
            selectedIcon: Icon(Symbols.location_on, fill: 1),
            icon: Icon(Symbols.location_on),
            label: 'Cities',
          ),
          NavigationDestination(
            selectedIcon: Icon(Symbols.settings, fill: 1),
            icon: Icon(Symbols.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Search'),
                content: TextField(
                  decoration: InputDecoration(hintText: 'Search city'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        mini: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        child: const Icon(Symbols.search),
      ),
      body: widget.child,
    );
  }
}

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

class CitiesScreen extends StatefulWidget {
  const CitiesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  final WeatherService _weatherService = WeatherService();
  final List<String> _cities = ['London', 'New York', 'Tokyo'];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _weatherService.getAllweather(_cities),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildErrorWidget(context, snapshot.error.toString());
        }

        final cities = snapshot.data!;
        return _buildCitiesContent(context, cities);
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

  Widget _buildCitiesContent(
    BuildContext context,
    List<Map<String, dynamic>> cities,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manage Cities',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Symbols.search),
                hintText: 'Search for a city...',
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('MY CITIES', style: Theme.of(context).textTheme.labelMedium),
              TextButton(onPressed: () {}, child: const Text('Edit')),
            ],
          ),

          Column(
            children: cities.map((cityData) {
              final location = cityData['location'];
              final current = cityData['current'];
              final forecast = cityData['forecast']['forecastday'][0]['day'];

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CityCard(
                  city: location['name'],
                  time: location['localtime'],
                  weather: current['condition']['text'],
                  weatherIcon: WeatherUtils.getWeatherIcon(
                    current['condition']['text'],
                  ),
                  temperature: current['temp_c'],
                  high: forecast['maxtemp_c'].round(),
                  low: forecast['mintemp_c'].round(),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          Text(
            'RECOMMENDED CITIES',
            style: Theme.of(context).textTheme.labelMedium,
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(onPressed: () {}, child: const Text('Paris')),
              OutlinedButton(onPressed: () {}, child: const Text('Berlin')),
              OutlinedButton(onPressed: () {}, child: const Text('Sydney')),
              OutlinedButton(onPressed: () {}, child: const Text('Dubai')),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go('/');
          },
          icon: const Icon(Symbols.arrow_back),
        ),
      ),
      body: Center(child: const Text('Settings Screen')),
    );
  }
}
