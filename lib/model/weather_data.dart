import 'package:flutter/material.dart';

class WeatherData {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final String description;
  final String icon;
  final int humidity;
  final double pressure;
  final double windSpeed;
  final int visibility;
  final DateTime dateTime;
  final DateTime? sunrise;
  final DateTime? sunset;

  WeatherData({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.visibility,
    required this.dateTime,
    this.sunrise,
    this.sunset,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['name'] ?? '',
      country: json['sys']?['country'] ?? '',
      temperature: (json['main']?['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']?['feels_like'] ?? 0).toDouble(),
      description: json['weather']?[0]?['description'] ?? '',
      icon: json['weather']?[0]?['icon'] ?? '01d',
      humidity: json['main']?['humidity'] ?? 0,
      pressure: (json['main']?['pressure'] ?? 0).toDouble(),
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      visibility: json['visibility'] ?? 0,
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] ?? 0) * 1000,
      ),
      sunrise: json['sys']?['sunrise'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000)
          : null,
      sunset: json['sys']?['sunset'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000)
          : null,
    );
  }

  // Display getters
  String get displayName => '$cityName, $country';
  String get temperatureString => '${temperature.round()}°C';
  String get feelsLikeString => '${feelsLike.round()}°C';
  String get pressureString => '${pressure.round()} hPa';
  String get windSpeedString => '${windSpeed.round()} m/s';
  String get visibilityString => '${(visibility / 1000).round()} km';
  String get humidityString => '$humidity%';

  // Method to get weather icon widget from OpenWeatherMap API
  Widget get weatherIconWidget {
    return Image.network(
      'https://openweathermap.org/img/wn/$icon@2x.png',
      width: 60,
      height: 60,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.error, size: 60);
      },
    );
  }

  // Asset path for local weather icons
  String get iconAssetPath {
    const knownIcons = [
      '01d', '01n', '02d', '02n', '03d', '03n', '04d', '04n',
      '09d', '09n', '10d', '10n', '11d', '11n', '13d', '13n',
      '50d', '50n'
    ];

    if (knownIcons.contains(icon)) {
      return 'assets/images/weather/$icon.png';
    } else {
      return 'assets/images/weather/default.png'; // fallback image
    }
  }

  // Alternative asset path with descriptive names based on day/night
  String get iconAssetDayNight {
    String timeIndicator = icon.length > 2 ? icon.substring(2) : 'd';
    String baseName;

    switch (icon.substring(0, 2)) {
      case '01':
        baseName = timeIndicator == 'd' ? 'clear_sky_day' : 'clear_sky_night';
        break;
      case '02':
        baseName = timeIndicator == 'd' ? 'few_clouds_day' : 'few_clouds_night';
        break;
      case '03':
        baseName = 'scattered_clouds';
        break;
      case '04':
        baseName = 'broken_clouds';
        break;
      case '09':
        baseName = 'shower_rain';
        break;
      case '10':
        baseName = timeIndicator == 'd' ? 'rain_day' : 'rain_night';
        break;
      case '11':
        baseName = 'thunderstorm';
        break;
      case '13':
        baseName = 'snow';
        break;
      case '50':
        baseName = 'mist';
        break;
      default:
        baseName = 'default';
    }

    return 'assets/images/weather/$baseName.png';
  }

  // Helper method to get local asset image widget
  Widget getAssetIconWidget({double size = 60}) {
    return Image.asset(
      iconAssetPath,
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.wb_sunny, size: size);
      },
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'country': country,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'description': description,
      'icon': icon,
      'humidity': humidity,
      'pressure': pressure,
      'windSpeed': windSpeed,
      'visibility': visibility,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'sunrise': sunrise?.millisecondsSinceEpoch,
      'sunset': sunset?.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'WeatherData(city: $displayName, temp: $temperatureString, desc: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeatherData &&
        other.cityName == cityName &&
        other.country == country &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode {
    return cityName.hashCode ^ country.hashCode ^ dateTime.hashCode;
  }
}