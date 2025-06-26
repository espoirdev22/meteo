// ============================================
// 🎯 BIBLIOTHÈQUE D'EMOJIS MÉTÉO COMPLÈTE
// ============================================

class WeatherEmojis {
  // Constructeur privé pour empêcher l'instanciation
  WeatherEmojis._();
  static const String loadingEmoji = '⏳';
  // ============================================
  // 🌟 MAPPING PRINCIPAL DES EMOJIS
  // ============================================

  /// Mapping principal des codes météo vers les emojis
  static const Map<String, String> weatherIcons = {
    '01d': '☀️', // Ciel dégagé jour
    '01n': '🌙', // Ciel dégagé nuit
    '02d': '⛅', // Partiellement nuageux jour
    '02n': '☁️', // Partiellement nuageux nuit
    '03d': '☁️', // Nuageux jour
    '03n': '☁️', // Nuageux nuit
    '04d': '☁️', // Très nuageux jour
    '04n': '☁️', // Très nuageux nuit
    '09d': '🌧️', // Averses jour
    '09n': '🌧️', // Averses nuit
    '10d': '🌦️', // Pluie jour
    '10n': '🌧️', // Pluie nuit
    '11d': '⛈️', // Orage jour
    '11n': '⛈️', // Orage nuit
    '13d': '❄️', // Neige jour
    '13n': '❄️', // Neige nuit
    '50d': '🌫️', // Brouillard jour
    '50n': '🌫️', // Brouillard nuit
  };

  // ============================================
  // 🎨 EMOJIS ALTERNATIFS PAR CATÉGORIE
  // ============================================

  static const Map<String, List<String>> emojiCategories = {
    'sunny': ['☀️', '🌞', '🔆'],
    'cloudy': ['☁️', '⛅', '🌤️'],
    'rainy': ['🌧️', '🌦️', '☔'],
    'stormy': ['⛈️', '🌩️', '⚡'],
    'snowy': ['❄️', '🌨️', '☃️'],
    'foggy': ['🌫️', '🌁'],
    'night': ['🌙', '🌛', '🌜'],
  };

  // ============================================
  // 🌡️ EMOJIS CONTEXTUELS
  // ============================================

  static const Map<String, String> temperatureEmojis = {
    'freezing': '🧊',
    'cold': '🥶',
    'cool': '🧥',
    'mild': '🌤️',
    'warm': '🌡️',
    'hot': '🔥',
  };

  static const Map<String, String> windEmojis = {
    'calm': '🌿',
    'breeze': '🍃',
    'windy': '💨',
    'strong': '🌪️',
  };

  static const Map<String, String> humidityEmojis = {
    'dry': '🏜️',
    'moderate': '🌊',
    'humid': '💦',
    'very_humid': '💧',
  };

  static const Map<String, String> specialEmojis = {
    'sunrise': '🌅',
    'sunset': '🌇',
    'rainbow': '🌈',
    'loading': '⏳',
    'error': '❌',
    'default': '🌤️',
  };

  // ============================================
  // 🎭 EMOJIS ANIMÉS
  // ============================================

  /// Sequences d'animation pour chaque type de temps
  static const Map<String, List<String>> animatedEmojiSequences = {
    '01d': ['☀️', '🌞', '🔆', '☀️'],
    '01n': ['🌙', '🌛', '🌜', '🌙'],
    '02d': ['⛅', '🌤️', '⛅'],
    '02n': ['☁️', '🌑', '☁️'],
    '09d': ['🌧️', '💧', '🌧️'],
    '09n': ['🌧️', '💧', '🌧️'],
    '10d': ['🌦️', '☔', '🌦️'],
    '10n': ['🌧️', '💧', '🌧️'],
    '11d': ['⛈️', '⚡', '⛈️'],
    '11n': ['⛈️', '⚡', '⛈️'],
    '13d': ['❄️', '🌨️', '❄️'],
    '13n': ['❄️', '🌨️', '❄️'],
    '50d': ['🌫️', '🌁', '🌫️'],
    '50n': ['🌫️', '🌁', '🌫️'],
  };

  // ============================================
  // 📱 MÉTHODES PRINCIPALES
  // ============================================

  /// Obtient l'emoji principal pour un code météo
  static String getWeatherEmoji(String iconCode) {
    return weatherIcons[iconCode] ?? specialEmojis['default']!;
  }

  /// Obtient un emoji animé
  static String getAnimatedEmoji(String iconCode, {bool isAnimating = true}) {
    if (!isAnimating) return getWeatherEmoji(iconCode);

    final sequence = animatedEmojiSequences[iconCode];
    if (sequence != null && sequence.isNotEmpty) {
      final now = DateTime.now();
      final frameIndex = now.second % sequence.length;
      return sequence[frameIndex];
    }
    return getWeatherEmoji(iconCode);
  }

  /// Obtient un emoji aléatoire d'une catégorie
  static String getRandomEmoji(String category) {
    final emojis = emojiCategories[category] ?? [specialEmojis['default']!];
    final index = DateTime.now().millisecond % emojis.length;
    return emojis[index];
  }

  /// Obtient un emoji basé sur la température
  static String getTemperatureEmoji(double temperature) {
    if (temperature < -5) return temperatureEmojis['freezing']!;
    if (temperature < 5) return temperatureEmojis['cold']!;
    if (temperature < 15) return temperatureEmojis['cool']!;
    if (temperature < 25) return temperatureEmojis['mild']!;
    if (temperature < 35) return temperatureEmojis['warm']!;
    return temperatureEmojis['hot']!;
  }

  /// Obtient un emoji basé sur le vent
  static String getWindEmoji(double windSpeed) {
    final windKmh = windSpeed * 3.6;
    if (windKmh < 8) return windEmojis['calm']!;
    if (windKmh < 15) return windEmojis['breeze']!;
    if (windKmh < 25) return windEmojis['windy']!;
    return windEmojis['strong']!;
  }

  /// Obtient un emoji basé sur l'humidité
  static String getHumidityEmoji(int humidity) {
    if (humidity < 40) return humidityEmojis['dry']!;
    if (humidity < 60) return humidityEmojis['moderate']!;
    if (humidity < 80) return humidityEmojis['humid']!;
    return humidityEmojis['very_humid']!;
  }

  /// Obtient un emoji intelligent combinant plusieurs facteurs
  static String getSmartEmoji({
    required String iconCode,
    double? temperature,
    double? windSpeed,
    int? humidity,
  }) {
    String baseEmoji = getWeatherEmoji(iconCode);

    if (temperature != null) {
      if (temperature >= 35 && iconCode == '01d') return '🔥';
      if (temperature <= 0 && (iconCode == '09d' || iconCode == '09n')) return '🧊';
    }

    if (windSpeed != null && windSpeed >= 7) {
      if (iconCode.contains('09') || iconCode.contains('10')) return '🌊';
    }

    return baseEmoji;
  }

  // ============================================
  // 🔧 MÉTHODES UTILITAIRES
  // ============================================

  static bool isNightTime(String iconCode) => iconCode.endsWith('n');

  static String getWeatherCategory(String iconCode) {
    final baseCode = iconCode.substring(0, 2);
    switch (baseCode) {
      case '01': return 'sunny';
      case '02': case '03': case '04': return 'cloudy';
      case '09': case '10': return 'rainy';
      case '11': return 'stormy';
      case '13': return 'snowy';
      case '50': return 'foggy';
      default: return 'default';
    }
  }

  static List<String> getEmojisByCategory(String category) {
    return emojiCategories[category] ?? [specialEmojis['default']!];
  }

  static String getSpecialEmoji(String type) {
    return specialEmojis[type] ?? specialEmojis['default']!;
  }

  // ============================================
  // 📊 MÉTHODES D'INFORMATION
  // ============================================

  static String getEmojiDescription(String iconCode) {
    const descriptions = {
      '01d': 'Soleil éclatant',
      '01n': 'Nuit claire',
      '02d': 'Partiellement ensoleillé',
      '02n': 'Partiellement nuageux',
      '03d': 'Nuageux',
      '03n': 'Nuageux',
      '04d': 'Très nuageux',
      '04n': 'Très nuageux',
      '09d': 'Averses',
      '09n': 'Averses',
      '10d': 'Pluie modérée',
      '10n': 'Pluie modérée',
      '11d': 'Orages',
      '11n': 'Orages',
      '13d': 'Chutes de neige',
      '13n': 'Chutes de neige',
      '50d': 'Brouillard',
      '50n': 'Brouillard',
    };
    return descriptions[iconCode] ?? 'Conditions météorologiques';
  }

  static int get totalEmojisCount {
    return weatherIcons.length +
        emojiCategories.values.fold<int>(0, (sum, list) => sum + list.length) +
        temperatureEmojis.length +
        windEmojis.length +
        humidityEmojis.length +
        specialEmojis.length;
  }

  static List<String> get availableCategories => emojiCategories.keys.toList();
}

// ============================================
// 🛠️ EXTENSION POUR FACILITER L'USAGE
// ============================================

extension WeatherEmojiExtension on String {
  String get weatherEmoji => WeatherEmojis.getWeatherEmoji(this);
  String get animatedEmoji => WeatherEmojis.getAnimatedEmoji(this);
  bool get isNightWeather => WeatherEmojis.isNightTime(this);
  String get weatherCategory => WeatherEmojis.getWeatherCategory(this);
  String get emojiDescription => WeatherEmojis.getEmojiDescription(this);
}
