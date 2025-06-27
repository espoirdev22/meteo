// ============================================
//  BIBLIOTHÈQUE D'EMOJIS MÉTÉO COMPLÈTE
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
  // 🔧 MÉTHODES UTILITAIRES DE VALIDATION
  // ============================================

  /// Valide et normalise un code météo
  static String _validateWeatherCode(String iconCode) {
    if (iconCode.isEmpty) return '01d';
    if (iconCode.length < 2) return '01d';
    if (iconCode.length == 2) return iconCode + 'd'; // Ajouter 'd' par défaut
    if (iconCode.length > 3) return iconCode.substring(0, 3); // Tronquer si trop long
    return iconCode;
  }

  /// Extrait le code de base (2 premiers caractères) de manière sécurisée
  static String _getBaseCode(String iconCode) {
    final validCode = _validateWeatherCode(iconCode);
    return validCode.length >= 2 ? validCode.substring(0, 2) : '01';
  }

  // ============================================
  // 📱 MÉTHODES PRINCIPALES
  // ============================================

  /// Obtient l'emoji principal pour un code météo
  static String getWeatherEmoji(String iconCode) {
    final validCode = _validateWeatherCode(iconCode);
    return weatherIcons[validCode] ?? specialEmojis['default']!;
  }

  /// Obtient un emoji animé
  static String getAnimatedEmoji(String iconCode, {bool isAnimating = true}) {
    if (!isAnimating) return getWeatherEmoji(iconCode);

    final validCode = _validateWeatherCode(iconCode);
    final sequence = animatedEmojiSequences[validCode];
    if (sequence != null && sequence.isNotEmpty) {
      final now = DateTime.now();
      final frameIndex = now.second % sequence.length;
      return sequence[frameIndex];
    }
    return getWeatherEmoji(validCode);
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
    final validCode = _validateWeatherCode(iconCode);
    String baseEmoji = getWeatherEmoji(validCode);

    // Combinaisons spéciales basées sur la température
    if (temperature != null) {
      if (temperature >= 35 && validCode == '01d') return '🔥';
      if (temperature <= 0 && (validCode == '09d' || validCode == '09n')) return '🧊';
      if (temperature >= 30 && (validCode == '02d' || validCode == '03d')) return '🌡️';
    }

    // Combinaisons spéciales basées sur le vent
    if (windSpeed != null && windSpeed >= 7) {
      if (validCode.contains('09') || validCode.contains('10')) return '🌊';
      if (validCode == '01d' || validCode == '02d') return '💨';
    }

    return baseEmoji;
  }

  // ============================================
  // 🔧 MÉTHODES UTILITAIRES
  // ============================================

  static bool isNightTime(String iconCode) {
    final validCode = _validateWeatherCode(iconCode);
    return validCode.endsWith('n');
  }

  static String getWeatherCategory(String iconCode) {
    final baseCode = _getBaseCode(iconCode);
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
    final validCode = _validateWeatherCode(iconCode);
    return descriptions[validCode] ?? 'Conditions météorologiques';
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

  // ============================================
  // 🧪 MÉTHODES DE DEBUG
  // ============================================

  /// Méthode pour tester la validité d'un code météo
  static bool isValidWeatherCode(String iconCode) {
    if (iconCode.isEmpty) return false;
    if (iconCode.length < 2 || iconCode.length > 3) return false;

    final baseCode = iconCode.substring(0, 2);
    final validBaseCodes = ['01', '02', '03', '04', '09', '10', '11', '13', '50'];

    if (!validBaseCodes.contains(baseCode)) return false;

    if (iconCode.length == 3) {
      final suffix = iconCode.substring(2);
      return suffix == 'd' || suffix == 'n';
    }

    return true;
  }

  /// Méthode pour obtenir des informations de debug
  static Map<String, dynamic> getDebugInfo(String iconCode) {
    return {
      'originalCode': iconCode,
      'validatedCode': _validateWeatherCode(iconCode),
      'baseCode': _getBaseCode(iconCode),
      'isValid': isValidWeatherCode(iconCode),
      'isNight': isNightTime(iconCode),
      'category': getWeatherCategory(iconCode),
      'emoji': getWeatherEmoji(iconCode),
      'description': getEmojiDescription(iconCode),
    };
  }
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
  bool get isValidWeatherCode => WeatherEmojis.isValidWeatherCode(this);
  Map<String, dynamic> get weatherDebugInfo => WeatherEmojis.getDebugInfo(this);
}