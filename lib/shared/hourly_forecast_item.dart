import 'package:flutter/material.dart';

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
