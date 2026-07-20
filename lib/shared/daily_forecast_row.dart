import 'package:flutter/material.dart';

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
          Text('$low °C', style: Theme.of(context).textTheme.bodyMedium),
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
            '$high °C',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
