import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_weather/screens/cities_screen.dart';
import 'package:flutter_weather/screens/forecast_screen.dart';
import 'package:flutter_weather/screens/settings_screen.dart';
import 'package:flutter_weather/screens/weather_screen.dart';
import 'package:flutter_weather/theme/stormy.dart';
import 'package:go_router/go_router.dart';

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
