import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class CitiesScreen extends StatelessWidget {
  const CitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Manage Cities'),
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

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('MY CITIES'),
            TextButton(onPressed: () {}, child: const Text('Edit')),
          ],
        ),

        Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(18),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('New York'),
                    const Text('09:42 AM'),
                    const Text('Cloudy'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('18°'),
                    Row(children: [const Text('H: 21°'), const Text('L: 14°')]),
                  ],
                ),
              ],
            ),
          ),
        ),

        Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(18),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('London'),
                    const Text('02:42 PM'),
                    const Text('Light Rain'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('12°'),
                    Row(children: [const Text('H: 28°'), const Text('L: 8°')]),
                  ],
                ),
              ],
            ),
          ),
        ),

        Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(18),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tokyo'),
                    const Text('10:42 AM'),
                    const Text('Clear'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('24°'),
                    Row(children: [const Text('H: 28°'), const Text('L: 19°')]),
                  ],
                ),
              ],
            ),
          ),
        ),

        const Text('RECOMMENDED CITIES'),

        Row(
          children: [
            OutlinedButton(onPressed: () {}, child: const Text('Paris')),
            OutlinedButton(onPressed: () {}, child: const Text('Berlin')),
            OutlinedButton(onPressed: () {}, child: const Text('Sydney')),
            OutlinedButton(onPressed: () {}, child: const Text('Dubai')),
          ],
        ),
      ],
    );
  }
}
