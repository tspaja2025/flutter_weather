import 'package:flutter/material.dart';
import 'package:flutter_weather/theme/stormy.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Weather',
      theme: ThemeData(
        colorScheme: StormyTheme.colorScheme,
        textTheme: StormyTheme.textTheme,
      ),
      themeMode: ThemeMode.dark,
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          ShellRoute(
            builder: (context, state, child) => AppScaffold(child: child),
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const WeatherPage(),
              ),
              GoRoute(
                path: '/forecast',
                builder: (context, state) => const ForecastPage(),
              ),
              GoRoute(
                path: '/cities',
                builder: (context, state) => const Cities(),
              ),
            ],
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
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        title: const Text('SkyGlass'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
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
          }
        },
        selectedIndex: _selectedIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.cloud),
            icon: Icon(Icons.cloud_outlined),
            label: 'Weather',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Forecast',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.location_on),
            icon: Icon(Icons.location_on_outlined),
            label: 'Cities',
          ),
        ],
      ),
      body: widget.child,
    );
  }
}

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [const Text('Weather Content')],
      ),
    );
  }
}

class ForecastPage extends StatelessWidget {
  const ForecastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [const Text('Forecast Content')],
      ),
    );
  }
}

class Cities extends StatelessWidget {
  const Cities({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [const Text('Cities Content')],
      ),
    );
  }
}
