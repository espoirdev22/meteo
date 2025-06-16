class ApiConfig {
  static const String API_KEY = 'ebb972f5ce33c3dedcfa4681c371001f';

  // URLs de base
  static const String BASE_URL = 'https://api.openweathermap.org/data/2.5';
  static const String WEATHER_ENDPOINT = '/weather';
  static const String FORECAST_ENDPOINT = '/forecast';
  static const String ONECALL_ENDPOINT = '/onecall';

  // Paramètres par défaut
  static const String UNITS = 'metric'; // Celsius
  static const String LANG = 'fr'; // Français

  // Villes par défaut pour la démonstration
  static const List<String> DEFAULT_CITIES = [
    'Paris,FR',
    'London,GB',
    'New York,US',
    'Tokyo,JP',
    'Sydney,AU',
    'Berlin,DE',
    'Cairo,EG',
    'Moscow,RU'
  ];

  // Configuration des timeouts
  static const Duration TIMEOUT_DURATION = Duration(seconds: 10);
  static const int MAX_RETRIES = 3;

  // Validation de la clé API
  static bool get isApiKeyValid => API_KEY != 'ebb972f5ce33c3dedcfa4681c371001f';
}