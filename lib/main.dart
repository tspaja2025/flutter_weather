import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_weather/theme/stormy.dart';
import 'package:flutter_weather/widgets/compass_painter.dart';
import 'package:flutter_weather/widgets/gauge_painter.dart';
import 'package:flutter_weather/widgets/sun_moon_path_painter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = dotenv.env['WEATHERAPI'] ?? '';
  final _cache = <String, _CacheEntry>{};
  static const _cacheDuration = Duration(minutes: 5);

  Future<Map<String, dynamic>> getWeatherData(String city) async {
    final key = city.toLowerCase();

    if (_cache.containsKey(key)) {
      final entry = _cache[key]!;
      if (DateTime.now().difference(entry.timestamp) < _cacheDuration) {
        return entry.data;
      }
    }

    try {
      final current = await getWeather(city);
      final forecast = await getForecast(city);
      final data = {...current, 'forecast': forecast['forecast']};

      _cache[key] = _CacheEntry(data, DateTime.now());
      return data;
    } catch (e) {
      throw Exception('Failed to fetch weather data: $e');
    }
  }

  Future<Map<String, dynamic>> getWeather(String city) async {
    if (apiKey.isEmpty) {
      throw Exception('Weather API key not configured');
    }

    final url = Uri.parse(
      'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Connection timeout. Please try again.');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> getForecast(String city) async {
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7',
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

class _CacheEntry {
  final Map<String, dynamic> data;
  final DateTime timestamp;

  _CacheEntry(this.data, this.timestamp);
}

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WeatherScreen()),
    GoRoute(
      path: '/forecast',
      builder: (context, state) => const ForecastScreen(),
    ),
    GoRoute(path: '/cities', builder: (context, state) => const CitiesScreen()),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Weather',
      theme: StormyTheme.dark(),
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}

class AppScaffold extends StatefulWidget {
  final int currentIndex;
  final Widget child;
  final String? title;

  const AppScaffold({
    super.key,
    required this.currentIndex,
    required this.child,
    this.title,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  void _onDestinationSelected(int index) {
    if (index == widget.currentIndex) return;

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
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title != null ? AppBar(title: Text(widget.title!)) : null,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onDestinationSelected,
        selectedIndex: widget.currentIndex,
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
        onPressed: _showSearchDialog,
        mini: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        child: const Icon(Symbols.search),
      ),
      body: widget.child,
    );
  }
}

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCurrentWeather(context),
            const SizedBox(height: 32),
            _buildHourlyForecast(context),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [
                _buildTemperatureCard(context),
                _buildFeelsLikeCard(context),
                _buildWindCard(context),
                _buildHumidityCard(context),
                _buildUVCard(context),
                _buildCloudCard(context),
                _buildDewPointCard(context),
                _buildPressureCard(context),
                _buildVisibilityCard(context),
                _buildSunCard(context),
                _buildMoonCard(context),
                _buildMoonPhaseCard(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWeather(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.sunny,
            size: 150,
            color: Theme.of(context).colorScheme.primary,
          ),
          Text('Tampere', style: Theme.of(context).textTheme.headlineLarge),
          Text('20 °C', style: Theme.of(context).textTheme.headlineLarge),
          Text('Sunny', style: Theme.of(context).textTheme.bodyLarge),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('H: 27 °C', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(width: 16),
              Text('L: 13 °C', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast(BuildContext context) {
    return WeatherCard(
      icon: Symbols.access_time,
      title: 'Hourly Forecast',
      children: [
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return HourlyForecastItem(
                time: '1 PM',
                icon: Symbols.sunny,
                temperature: '17 °C',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureCard(BuildContext context) {
    return WeatherCard(
      icon: Symbols.thermostat,
      title: 'Temperature',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '13 °C',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              '27 °C',
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

  Widget _buildFeelsLikeCard(BuildContext context) {
    return WeatherCard(
      icon: Symbols.thermometer,
      title: 'Feels like',
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: Alignment.center,
          child: Text(
            '17 °C',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildWindCard(BuildContext context) {
    return WeatherCard(
      icon: Symbols.air,
      title: 'Wind',
      children: [
        Text(
          '9 km/h',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Center(
          child: Column(
            children: [
              CustomPaint(size: Size.square(60), painter: CompassPainter('N')),
              Text('N', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHumidityCard(BuildContext context) {
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
              child: CustomPaint(painter: GaugePainter(66 / 100, Colors.blue)),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '66%',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text('High', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUVCard(BuildContext context) {
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
              child: CustomPaint(painter: GaugePainter2(20 / 11)),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '20',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text('Low', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCloudCard(BuildContext context) {
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
              child: CustomPaint(painter: GaugePainter(10 / 100, Colors.grey)),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '51',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text('Moderate', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDewPointCard(BuildContext context) {
    return WeatherCard(
      icon: Symbols.dew_point,
      title: 'Dew Point',
      children: [
        Center(
          child: Text(
            '12 °C',
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

  Widget _buildPressureCard(BuildContext context) {
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
              child: CustomPaint(painter: GaugePainter(10 / 100, Colors.teal)),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('30.11 in', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVisibilityCard(BuildContext context) {
    return WeatherCard(
      icon: Symbols.visibility,
      title: 'Visibility',
      children: [
        Text(
          '10 km',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildVisibilityBars(10),
        ),
      ],
    );
  }

  Widget _buildSunCard(BuildContext context) {
    return WeatherCard(
      icon: Symbols.wb_twilight,
      title: 'Sunrise - Sunset',
      children: [
        Text('05:00 - 09:00', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: CustomPaint(painter: SunMoonPathPainter(20.0, Colors.amber)),
        ),
      ],
    );
  }

  Widget _buildMoonCard(BuildContext context) {
    return WeatherCard(
      icon: Symbols.wb_twilight_2,
      title: 'Moonrise - Moonset',
      children: [
        Text('02:00 - 04:00', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: CustomPaint(painter: SunMoonPathPainter(20.0, Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildMoonPhaseCard(BuildContext context) {
    return WeatherCard(
      title: 'Moon Phase',
      icon: Symbols.circle,
      children: [
        Icon(Symbols.brightness_2, size: 72),
        const SizedBox(width: 12),
        Center(
          child: Text('New Moon', style: Theme.of(context).textTheme.bodySmall),
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

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 1,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(children: [_buildForecastContent(context)]),
      ),
    );
  }

  Widget _buildForecastContent(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tampere',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              letterSpacing: 4,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '7-Day Forecast',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(height: 16),

          WeatherCard(
            children: [
              DailyForecastRow(
                day: 'Today',
                icon: Symbols.sunny,
                low: 12,
                high: 27,
                progressStart: 3,
                progressEnd: 20,
              ),
              const Divider(),
              DailyForecastRow(
                day: 'Tue',
                icon: Symbols.cloud,
                low: 12,
                high: 27,
                progressStart: 3,
                progressEnd: 20,
              ),
              const Divider(),
              DailyForecastRow(
                day: 'Wed',
                icon: Symbols.rainy,
                low: 12,
                high: 27,
                progressStart: 3,
                progressEnd: 20,
              ),
              const Divider(),
            ],
          ),
        ],
      ),
    );
  }
}

class CitiesScreen extends StatelessWidget {
  const CitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 2,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(children: [_buildCitiesContent(context)]),
      ),
    );
  }

  Widget _buildCitiesContent(BuildContext context) {
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
            children: [
              CityCard(
                city: 'New York',
                time: '09:42 AM',
                weather: 'Cloudy',
                weatherIcon: Symbols.cloud,
                temperature: 18,
                high: 27,
                low: 13,
              ),
              CityCard(
                city: 'London',
                time: '02:42 PM',
                weather: 'Rainy',
                weatherIcon: Symbols.rainy,
                temperature: 18,
                high: 27,
                low: 13,
              ),
              CityCard(
                city: 'Tokyo',
                time: '10:42 PM',
                weather: 'Sunny',
                weatherIcon: Symbols.sunny,
                temperature: 18,
                high: 27,
                low: 13,
              ),
            ],
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
    return AppScaffold(
      currentIndex: 3,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(children: [const Text('Settings Screen')]),
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final IconData? icon;
  final String title;

  const WeatherCard({
    super.key,
    required this.children,
    this.icon,
    this.title = '',
    this.padding,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? 0,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class CityCard extends StatelessWidget {
  final String city;
  final String time;
  final String weather;
  final IconData weatherIcon;
  final double temperature;
  final int high;
  final int low;

  const CityCard({
    super.key,
    required this.city,
    required this.time,
    required this.weather,
    required this.weatherIcon,
    required this.temperature,
    required this.high,
    required this.low,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(time, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  weather,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 180,
            height: 120,
            child: Stack(
              children: [
                Positioned(
                  top: -30,
                  right: -20,
                  child: Icon(
                    weatherIcon,
                    fill: 1,
                    size: 120,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: .10),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 18,
                  child: Text(
                    '$temperature°C',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Row(
                    children: [
                      Text('H: $high°C'),
                      const SizedBox(width: 8),
                      Text('L: $low°C'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;

  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.icon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Text(time, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Icon(icon, fill: 1, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            temperature,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class DailyForecastRow extends StatelessWidget {
  final String day;
  final IconData icon;
  final int low;
  final int high;
  final double? progressStart;
  final double? progressEnd;

  const DailyForecastRow({
    super.key,
    required this.day,
    required this.icon,
    required this.low,
    required this.high,
    this.progressStart,
    this.progressEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(day, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Icon(icon, fill: 1, color: Theme.of(context).colorScheme.primary),
          const Spacer(),
          Text('$low°', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: 20),
          if (progressStart != null && progressEnd != null)
            SizedBox(
              width: 110,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progressEnd! - progressStart!,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 20),
          Text(
            '$high°',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
