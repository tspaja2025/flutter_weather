import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

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
