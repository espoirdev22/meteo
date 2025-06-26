import 'package:flutter/material.dart';
import '../core/constants/weather_emojis.dart'; // Import de votre bibliothèque

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

  // ⭐ NOUVELLES PROPRIÉTÉS POUR LA GÉOLOCALISATION
  final double? latitude;
  final double? longitude;

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
    // ⭐ PARAMÈTRES OPTIONNELS POUR LA GÉOLOCALISATION
    this.latitude,
    this.longitude,
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
      // ⭐ EXTRACTION DES COORDONNÉES DEPUIS L'API
      latitude: json['coord']?['lat']?.toDouble(),
      longitude: json['coord']?['lon']?.toDouble(),
    );
  }

  // ⭐ FACTORY CONSTRUCTOR AVEC COORDONNÉES EXPLICITES
  factory WeatherData.withCoordinates({
    required String cityName,
    required String country,
    required double temperature,
    required double feelsLike,
    required String description,
    required String icon,
    required int humidity,
    required double pressure,
    required double windSpeed,
    required int visibility,
    required DateTime dateTime,
    required double latitude,
    required double longitude,
    DateTime? sunrise,
    DateTime? sunset,
  }) {
    return WeatherData(
      cityName: cityName,
      country: country,
      temperature: temperature,
      feelsLike: feelsLike,
      description: description,
      icon: icon,
      humidity: humidity,
      pressure: pressure,
      windSpeed: windSpeed,
      visibility: visibility,
      dateTime: dateTime,
      sunrise: sunrise,
      sunset: sunset,
      latitude: latitude,
      longitude: longitude,
    );
  }

  // ============================================
  // 🎯 GETTERS POUR AFFICHAGE
  // ============================================

  String get displayName => '$cityName, $country';
  String get temperatureString => '${temperature.round()}°C';
  String get feelsLikeString => '${feelsLike.round()}°C';
  String get pressureString => '${pressure.round()} hPa';
  String get windSpeedString => '${windSpeed.round()} m/s';
  String get visibilityString => '${(visibility / 1000).round()} km';
  String get humidityString => '$humidity%';

  // ⭐ NOUVEAUX GETTERS POUR LES COORDONNÉES
  String get coordinatesString {
    if (latitude != null && longitude != null) {
      return '${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)}';
    }
    return 'Coordonnées non disponibles';
  }

  bool get hasCoordinates => latitude != null && longitude != null;

  // ============================================
  // 🎨 EMOJIS MÉTÉO (GETTERS EXISTANTS)
  // ============================================

  /// Emoji météo principal basé sur le code OpenWeatherMap
  String get iconEmoji => WeatherEmojis.getWeatherEmoji(icon);

  /// Emoji météo intelligent (prend en compte température, vent, etc.)
  String get smartEmoji => WeatherEmojis.getSmartEmoji(
    iconCode: icon,
    temperature: temperature,
    windSpeed: windSpeed,
    humidity: humidity,
  );

  /// Emoji basé sur la température uniquement
  String get temperatureEmoji => WeatherEmojis.getTemperatureEmoji(temperature);

  /// Emoji basé sur le vent uniquement
  String get windEmoji => WeatherEmojis.getWindEmoji(windSpeed);

  /// Emoji basé sur l'humidité uniquement
  String get humidityEmoji => WeatherEmojis.getHumidityEmoji(humidity);

  /// Emoji alternatif aléatoire de la même catégorie
  String get randomCategoryEmoji => WeatherEmojis.getRandomEmoji(weatherCategory);

  /// Catégorie météo (sunny, rainy, etc.)
  String get weatherCategory => WeatherEmojis.getWeatherCategory(icon);

  /// Description de l'emoji météo
  String get emojiDescription => WeatherEmojis.getEmojiDescription(icon);

  /// Vérifie si c'est la nuit
  bool get isNightTime => WeatherEmojis.isNightTime(icon);

  // ============================================
  // 🖼️ WIDGETS D'ICÔNES (MÉTHODES EXISTANTES)
  // ============================================

  /// Widget d'icône depuis l'API OpenWeatherMap
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

  /// Chemin d'asset pour les icônes locales
  String get iconAssetPath {
    const knownIcons = [
      '01d', '01n', '02d', '02n', '03d', '03n', '04d', '04n',
      '09d', '09n', '10d', '10n', '11d', '11n', '13d', '13n',
      '50d', '50n'
    ];

    if (knownIcons.contains(icon)) {
      return 'assets/images/weather/$icon.png';
    } else {
      return 'assets/images/weather/default.png';
    }
  }

  /// Widget d'icône depuis les assets locaux
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

  // ============================================
  // 🎨 WIDGETS EMOJI (MÉTHODES EXISTANTES)
  // ============================================

  /// Widget emoji simple
  Widget getEmojiWidget({double fontSize = 60}) {
    return Text(
      iconEmoji,
      style: TextStyle(fontSize: fontSize),
    );
  }

  /// Widget emoji intelligent
  Widget getSmartEmojiWidget({double fontSize = 60}) {
    return Text(
      smartEmoji,
      style: TextStyle(fontSize: fontSize),
    );
  }

  /// Widget emoji avec description
  Widget getEmojiWithDescription({
    double fontSize = 48,
    double descriptionFontSize = 16,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          iconEmoji,
          style: TextStyle(fontSize: fontSize),
        ),
        const SizedBox(height: 4),
        Text(
          emojiDescription,
          style: TextStyle(
            fontSize: descriptionFontSize,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Widget combinant emoji et température
  Widget getEmojiWithTemperature({
    double emojiSize = 48,
    double tempSize = 24,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          iconEmoji,
          style: TextStyle(fontSize: emojiSize),
        ),
        const SizedBox(width: 8),
        Text(
          temperatureString,
          style: TextStyle(
            fontSize: tempSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ============================================
  // 🔧 MÉTHODES UTILITAIRES
  // ============================================

  /// Obtient un ensemble d'emojis liés à cette météo
  List<String> getRelatedEmojis() {
    return [
      iconEmoji,
      temperatureEmoji,
      windEmoji,
      humidityEmoji,
    ];
  }

  /// Obtient un résumé emoji complet
  String get emojiSummary {
    return '$iconEmoji $temperatureEmoji $windEmoji $humidityEmoji';
  }

  // ⭐ MÉTHODE POUR CRÉER UNE COPIE AVEC DE NOUVELLES COORDONNÉES
  WeatherData copyWithCoordinates(double latitude, double longitude) {
    return WeatherData(
      cityName: cityName,
      country: country,
      temperature: temperature,
      feelsLike: feelsLike,
      description: description,
      icon: icon,
      humidity: humidity,
      pressure: pressure,
      windSpeed: windSpeed,
      visibility: visibility,
      dateTime: dateTime,
      sunrise: sunrise,
      sunset: sunset,
      latitude: latitude,
      longitude: longitude,
    );
  }

  // ============================================
  // 📊 MÉTHODES DE SÉRIALISATION
  // ============================================

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
      // ⭐ AJOUT DES COORDONNÉES AU JSON
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    String coordsInfo = hasCoordinates
        ? ' (${coordinatesString})'
        : '';
    return 'WeatherData(city: $displayName$coordsInfo, temp: $temperatureString, emoji: $iconEmoji)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeatherData &&
        other.cityName == cityName &&
        other.country == country &&
        other.dateTime == dateTime &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return cityName.hashCode ^
    country.hashCode ^
    dateTime.hashCode ^
    latitude.hashCode ^
    longitude.hashCode;
  }
}