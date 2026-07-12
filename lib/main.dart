import 'package:flutter/material.dart';
import 'package:flutter_weather/screens/cities_screen.dart';
import 'package:flutter_weather/screens/forecast_screen.dart';
import 'package:flutter_weather/screens/weather_screen.dart';
import 'package:flutter_weather/shared/app_scaffold.dart';
import 'package:flutter_weather/theme/stormy.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
        ],
      ),
    );
  }
}
