import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

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
