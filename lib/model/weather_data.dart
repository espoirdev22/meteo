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

  // Getters utiles
  String get displayName => '$cityName, $country';
  String get temperatureString => '${temperature.round()}°C';
  String get feelsLikeString => '${feelsLike.round()}°C';
  String get pressureString => '${pressure.round()} hPa';
  String get windSpeedString => '${windSpeed.round()} m/s';
  String get visibilityString => '${(visibility / 1000).round()} km';
  String get humidityString => '$humidity%';

  String get iconEmoji {
    switch (icon.substring(0, 2)) {
      case '01': return '☀️'; // clear sky
      case '02': return '⛅'; // few clouds
      case '03': return '☁️'; // scattered clouds
      case '04': return '☁️'; // broken clouds
      case '09': return '🌧️'; // shower rain
      case '10': return '🌦️'; // rain
      case '11': return '⛈️'; // thunderstorm
      case '13': return '❄️'; // snow
      case '50': return '🌫️'; // mist
      default: return '🌤️';
    }
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
}