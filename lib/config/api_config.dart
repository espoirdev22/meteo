class ApiConfig {
  //  REMPLACEZ par votre vraie clé API gratuite
  static const String API_KEY = 'ebb972f5ce33c3dedcfa4681c371001f';

  //  API 2.5 - GRATUITE UNIQUEMENT
  static const String BASE_URL = 'https://api.openweathermap.org/data/2.5';

  // Endpoints gratuits disponibles
  static const String WEATHER_ENDPOINT = '/weather';        // Météo actuelle
  static const String FORECAST_ENDPOINT = '/forecast';      // Prévisions 5 jours
  static const String GROUP_ENDPOINT = '/group';           // Plusieurs villes à la fois

  //  Geocoding gratuit (pour convertir nom ville → coordonnées)
  static const String GEOCODING_URL = 'http://api.openweathermap.org/geo/1.0/direct';
  static const String REVERSE_GEOCODING_URL = 'http://api.openweathermap.org/geo/1.0/reverse';

  //  Paramètres
  static const String UNITS = 'metric';  // Celsius (metric), Fahrenheit (imperial), Kelvin (standard)
  static const String LANG = 'fr';       // Français

  //  Villes de démonstration
  static const List<String> DEFAULT_CITIES = [
    'Paris,FR',
    'Dakar,SN',      // Ville locale
    //'London,GB',
    'New York,US',
    'Tokyo,JP',
    //'Berlin,DE',
    //'Cairo,EG',
    'Nouakchott,MR',
  ];

  //  Limites du plan GRATUIT
  static const int FREE_CALLS_PER_MINUTE = 60;
  static const int FREE_CALLS_PER_MONTH = 1000000;  // 1M appels/mois
  static const Duration TIMEOUT_DURATION = Duration(seconds: 10);
  static const int MAX_RETRIES = 2;

  //  Cache recommandé pour économiser les appels
  static const Duration CACHE_WEATHER_DURATION = Duration(minutes: 10);
  static const Duration CACHE_FORECAST_DURATION = Duration(hours: 1);

  //  Validation de la clé API
  static bool get isApiKeyValid {
    return API_KEY.isNotEmpty &&
        API_KEY != 'YOUR_FREE_API_KEY_HERE' &&
        API_KEY.length == 32;  // Format standard OpenWeatherMap
  }

  //  URL météo actuelle
  static String getCurrentWeatherUrl({
    String? city,
    double? lat,
    double? lon,
  }) {
    String url = '$BASE_URL$WEATHER_ENDPOINT?appid=$API_KEY&units=$UNITS&lang=$LANG';

    if (city != null) {
      url += '&q=${Uri.encodeComponent(city)}';
    } else if (lat != null && lon != null) {
      url += '&lat=$lat&lon=$lon';
    }

    return url;
  }

  //  URL prévisions 5 jours (gratuit)
  static String getForecastUrl({
    String? city,
    double? lat,
    double? lon,
    int? count,  // Max 40 pour le gratuit
  }) {
    String url = '$BASE_URL$FORECAST_ENDPOINT?appid=$API_KEY&units=$UNITS&lang=$LANG';

    if (city != null) {
      url += '&q=${Uri.encodeComponent(city)}';
    } else if (lat != null && lon != null) {
      url += '&lat=$lat&lon=$lon';
    }

    if (count != null && count <= 40) {
      url += '&cnt=$count';
    }

    return url;
  }

  //  URL geocoding (nom ville → coordonnées)
  static String getGeocodingUrl(String cityName, {int limit = 5}) {
    return '$GEOCODING_URL?q=${Uri.encodeComponent(cityName)}&limit=$limit&appid=$API_KEY';
  }

  //  URL geocoding inverse (coordonnées → nom ville)
  static String getReverseGeocodingUrl(double lat, double lon, {int limit = 1}) {
    return '$REVERSE_GEOCODING_URL?lat=$lat&lon=$lon&limit=$limit&appid=$API_KEY';
  }

  //  URL pour plusieurs villes (économise les appels API)
  static String getGroupWeatherUrl(List<String> cityIds) {
    final ids = cityIds.join(',');
    return '$BASE_URL$GROUP_ENDPOINT?id=$ids&appid=$API_KEY&units=$UNITS&lang=$LANG';
  }

  //  Exemples d'utilisation des URLs
  static void printExampleUrls() {
    print('=== EXEMPLES D\'URLS API GRATUITE ===');
    print('Météo Paris: ${getCurrentWeatherUrl(city: 'Paris,FR')}');
    print('Météo Dakar: ${getCurrentWeatherUrl(city: 'Dakar,SN')}');
    print('Prévisions 5j: ${getForecastUrl(city: 'Paris,FR', count: 5)}');
    print('Recherche ville: ${getGeocodingUrl('Dakar')}');
  }

  //  Conseils d'optimisation pour l'API gratuite
  static const List<String> OPTIMIZATION_TIPS = [
    '✅ Mettez en cache les réponses (10-30 min pour météo actuelle)',
    '✅ Utilisez les coordonnées GPS plutôt que les noms de villes',
    '✅ Groupez les appels avec /group quand possible',
    '✅ Limitez les prévisions à ce dont vous avez besoin (cnt=5 au lieu de 40)',
    '⚠️ Attention aux limites : 60 appels/minute max',
    '⚠️ L\'API One Call 3.0 est PAYANTE, utilisez /forecast pour les prévisions',
  ];

  // 🚫 APIs NON disponibles en gratuit
  static const List<String> PAID_ONLY_FEATURES = [
    'One Call API 3.0 (/onecall)',
    'Prévisions météo au-delà de 5 jours',
    'Données météo historiques',
    'Cartes météo haute résolution',
    'Alertes météo push',
    'Données météo agricoles',
  ];
}