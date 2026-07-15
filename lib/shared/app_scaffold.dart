import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

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
