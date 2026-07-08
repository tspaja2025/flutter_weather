import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_weather/shared/daily_forecast_row.dart';
import 'package:flutter_weather/shared/hourly_forecast_item.dart';
import 'package:flutter_weather/shared/weather_card.dart';
import 'package:flutter_weather/widgets/gauge_painter.dart';
import 'package:flutter_weather/widgets/sun_moon_path_painter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  // Future<Map<String, dynamic>> getCurrentWeather(String cityName) async {
  //   try {
  //     final apiKey = dotenv.env['WEATHERAPI'] ?? '';

  //     final response = await http.get(
  //       Uri.parse(
  //         'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$cityName',
  //       ),
  //     );
  //     final data = jsonDecode(response.body);
  //     if (data['cod'] != '200') {
  //       throw ('An unhandled error occured!');
  //     }

  //     return data;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Icon(
                  Symbols.partly_cloudy_day,
                  size: 150,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text(
                  'San Francisco',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  '72°',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  'Mostly Sunny',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'H: 78°',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'L: 64°',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          WeatherCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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

                Row(
                  children: [
                    HourlyForecastItem(
                      time: 'Now',
                      icon: Symbols.sunny,
                      temperature: '72°',
                    ),
                    HourlyForecastItem(
                      time: '1PM',
                      icon: Symbols.partly_cloudy_day,
                      temperature: '74°',
                    ),
                    HourlyForecastItem(
                      time: '2PM',
                      icon: Symbols.partly_cloudy_day,
                      temperature: '75°',
                    ),
                    HourlyForecastItem(
                      time: '3PM',
                      icon: Symbols.cloud,
                      temperature: '73°',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.15,
            children: [
              WeatherCard(
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '12°',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '19°',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 8,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              WeatherCard(
                elevation: 0,
                child: Column(
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
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
                        '72°',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              WeatherCard(
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              WeatherCard(
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
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
                            painter: GaugePainter(0.87, Colors.blue),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '87%',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const Text('Very High'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              WeatherCard(
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
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
                          child: CustomPaint(painter: GaugePainter2(1)),
                        ),
                        Column(
                          children: [
                            Text(
                              '1',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const Text('Low'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              WeatherCard(
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
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
                            painter: GaugePainter(0.16, Colors.green),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '16',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const Text('Good'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              WeatherCard(
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Center(
                      child: Text(
                        '11°',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.yellow, Colors.deepOrange],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [const Text('-1'), const Text('27')],
                    ),
                  ],
                ),
              ),
              WeatherCard(
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
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
                            painter: GaugePainter(0.97, Colors.teal),
                          ),
                        ),
                        Text(
                          '997.3 mb',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              WeatherCard(
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '14.48 km',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 8,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              WeatherCard(
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: CustomPaint(
                        painter: SunMoonPathPainter(0.22, Colors.amber),
                      ),
                    ),
                  ],
                ),
              ),
              WeatherCard(
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: CustomPaint(
                        painter: SunMoonPathPainter(0.55, Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              WeatherCard(
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Symbols.bedtime,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Moon Phase',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Symbols.circle,
                            fill: 1,
                            size: 72,
                            color: Colors.black54,
                          ),
                          const Icon(Symbols.bedtime, fill: 1, size: 72),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          WeatherCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Symbols.calendar_month,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '10-DAY FORECAST',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                DailyForecastRow(
                  day: 'Today',
                  icon: Symbols.partly_cloudy_day,
                  low: 64,
                  high: 78,
                  progressStart: .30,
                  progressEnd: .72,
                ),
                const Divider(),
                DailyForecastRow(
                  day: 'Tue',
                  icon: Symbols.sunny,
                  low: 62,
                  high: 81,
                  progressStart: .28,
                  progressEnd: .75,
                ),
                const Divider(),
                DailyForecastRow(
                  day: 'Wed',
                  icon: Symbols.cloud,
                  low: 60,
                  high: 74,
                  progressStart: .26,
                  progressEnd: .68,
                ),
                const Divider(),
                DailyForecastRow(
                  day: 'Thu',
                  icon: Symbols.rainy,
                  low: 58,
                  high: 68,
                  progressStart: .24,
                  progressEnd: .60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // return FutureBuilder(
    //   future: getCurrentWeather('Tampere'),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasError) {
    //       return Center(child: Text('Error: ${snapshot.error}'));
    //     }

    //     final data = snapshot.data!;

    //     return SingleChildScrollView(
    //       physics: const BouncingScrollPhysics(),
    //       padding: const EdgeInsets.all(16),
    //       child: Column(
    //         children: [
    //           Center(
    //             child: Column(
    //               children: [
    //                 Icon(
    //                   Symbols.partly_cloudy_day,
    //                   size: 150,
    //                   color: Theme.of(context).colorScheme.primary,
    //                 ),
    //                 Text(
    //                   'San Francisco',
    //                   style: Theme.of(context).textTheme.headlineLarge,
    //                 ),
    //                 Text(
    //                   '72°',
    //                   style: Theme.of(context).textTheme.displayLarge?.copyWith(
    //                     color: Theme.of(context).colorScheme.primary,
    //                   ),
    //                 ),
    //                 Text(
    //                   'Mostly Sunny',
    //                   style: Theme.of(context).textTheme.bodyLarge,
    //                 ),
    //                 Row(
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: [
    //                     Text(
    //                       'H: 78°',
    //                       style: Theme.of(context).textTheme.bodyMedium,
    //                     ),
    //                     const SizedBox(width: 16),
    //                     Text(
    //                       'L: 64°',
    //                       style: Theme.of(context).textTheme.bodyMedium,
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),

    //           const SizedBox(height: 32),

    //           WeatherCard(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       'HOURLY FORECAST',
    //                       style: Theme.of(context).textTheme.labelMedium,
    //                     ),
    //                     Icon(
    //                       Symbols.access_time,
    //                       color: Theme.of(context).colorScheme.onSurface,
    //                     ),
    //                   ],
    //                 ),

    //                 const SizedBox(height: 8),

    //                 Row(
    //                   children: [
    //                     HourlyForecastItem(
    //                       time: 'Now',
    //                       icon: Symbols.sunny,
    //                       temperature: '72°',
    //                     ),
    //                     HourlyForecastItem(
    //                       time: '1PM',
    //                       icon: Symbols.partly_cloudy_day,
    //                       temperature: '74°',
    //                     ),
    //                     HourlyForecastItem(
    //                       time: '2PM',
    //                       icon: Symbols.partly_cloudy_day,
    //                       temperature: '75°',
    //                     ),
    //                     HourlyForecastItem(
    //                       time: '3PM',
    //                       icon: Symbols.cloud,
    //                       temperature: '73°',
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),

    //           const SizedBox(height: 16),

    //           Row(
    //             spacing: 16,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Expanded(
    //                 child: MetricCard(
    //                   icon: Symbols.sunny,
    //                   title: 'UV INDEX',
    //                   value: const Text('4'),
    //                   footer: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       const Text('Moderate'),
    //                       const SizedBox(height: 4),
    //                       LinearProgressIndicator(
    //                         value: 0.4,
    //                         minHeight: 8,
    //                         color: Theme.of(context).colorScheme.primary,
    //                         backgroundColor: Theme.of(
    //                           context,
    //                         ).colorScheme.onTertiary,
    //                         borderRadius: BorderRadius.circular(12),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               Expanded(
    //                 child: MetricCard(
    //                   icon: Symbols.air,
    //                   title: 'WIND',
    //                   value: const Text('12 mph'),
    //                   footer: const Text('WNW 8 mph'),
    //                 ),
    //               ),
    //             ],
    //           ),

    //           const SizedBox(height: 16),

    //           Row(
    //             spacing: 16,
    //             children: [
    //               Expanded(
    //                 child: MetricCard(
    //                   icon: Symbols.water_drop,
    //                   title: 'HUMIDITY',
    //                   value: const Text('64%'),
    //                   footer: const Text('Dew point 58°'),
    //                 ),
    //               ),
    //               Expanded(
    //                 child: MetricCard(
    //                   icon: Symbols.visibility,
    //                   title: 'VISIBILITY',
    //                   value: const Row(
    //                     children: [Text('10'), SizedBox(width: 4), Text('mi')],
    //                   ),
    //                   footer: const Text('Clear view'),
    //                 ),
    //               ),
    //             ],
    //           ),

    //           const SizedBox(height: 16),

    //           WeatherCard(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Row(
    //                   children: [
    //                     Icon(
    //                       Symbols.calendar_month,
    //                       color: Theme.of(context).colorScheme.onSurfaceVariant,
    //                     ),
    //                     const SizedBox(width: 8),
    //                     Text(
    //                       '10-DAY FORECAST',
    //                       style: Theme.of(context).textTheme.labelMedium,
    //                     ),
    //                   ],
    //                 ),

    //                 const SizedBox(height: 8),

    //                 DailyForecastRow(
    //                   day: 'Today',
    //                   icon: Symbols.partly_cloudy_day,
    //                   low: 64,
    //                   high: 78,
    //                   progressStart: .30,
    //                   progressEnd: .72,
    //                 ),
    //                 const Divider(),
    //                 DailyForecastRow(
    //                   day: 'Tue',
    //                   icon: Symbols.sunny,
    //                   low: 62,
    //                   high: 81,
    //                   progressStart: .28,
    //                   progressEnd: .75,
    //                 ),
    //                 const Divider(),
    //                 DailyForecastRow(
    //                   day: 'Wed',
    //                   icon: Symbols.cloud,
    //                   low: 60,
    //                   high: 74,
    //                   progressStart: .26,
    //                   progressEnd: .68,
    //                 ),
    //                 const Divider(),
    //                 DailyForecastRow(
    //                   day: 'Thu',
    //                   icon: Symbols.rainy,
    //                   low: 58,
    //                   high: 68,
    //                   progressStart: .24,
    //                   progressEnd: .60,
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }
}
