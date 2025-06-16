import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../model/weather_data.dart';

class WeatherService {
  static const Duration _timeoutDuration = Duration(seconds: 10);

  // Cache simple en mémoire
  final Map<String, WeatherData> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheDuration = Duration(minutes: 10);

  Future<WeatherData> getWeatherByCity(String city) async {
    // Vérifier le cache
    if (_isCacheValid(city)) {
      print('📦 Données en cache pour $city');
      return _cache[city]!;
    }

    try {
      // Construire l'URL avec la nouvelle configuration
      final url = ApiConfig.getCurrentWeatherUrl(city: city);
      print('🌐 Appel API: $url');

      final response = await http.get(
        Uri.parse(url),
      ).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final weatherData = WeatherData.fromJson(data);

        // Mettre en cache
        _cache[city] = weatherData;
        _cacheTimestamps[city] = DateTime.now();

        print('✅ Données reçues pour ${weatherData.displayName}');
        return weatherData;
      } else if (response.statusCode == 401) {
        throw Exception('❌ Clé API invalide ou expirée');
      } else if (response.statusCode == 404) {
        throw Exception('❌ Ville "$city" non trouvée');
      } else {
        throw Exception('❌ Erreur serveur (${response.statusCode})');
      }
    } on SocketException {
      throw Exception('❌ Pas de connexion internet');
    } on http.ClientException {
      throw Exception('❌ Erreur de connexion réseau');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('⏱️ Délai d\'attente dépassé');
      }
      throw Exception('❌ Erreur: ${e.toString()}');
    }
  }

  Future<WeatherData> getWeatherByLocation(double lat, double lon) async {
    final locationKey = 'lat_${lat}_lon_$lon';

    // Vérifier le cache
    if (_isCacheValid(locationKey)) {
      print('📦 Données en cache pour les coordonnées ($lat, $lon)');
      return _cache[locationKey]!;
    }

    try {
      final url = ApiConfig.getCurrentWeatherUrl(lat: lat, lon: lon);
      print('🌐 Appel API par coordonnées: $url');

      final response = await http.get(
        Uri.parse(url),
      ).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final weatherData = WeatherData.fromJson(data);

        // Mettre en cache
        _cache[locationKey] = weatherData;
        _cacheTimestamps[locationKey] = DateTime.now();

        print('✅ Données reçues pour ${weatherData.displayName}');
        return weatherData;
      } else if (response.statusCode == 401) {
        throw Exception('❌ Clé API invalide ou expirée');
      } else {
        throw Exception('❌ Erreur serveur (${response.statusCode})');
      }
    } on SocketException {
      throw Exception('❌ Pas de connexion internet');
    } on http.ClientException {
      throw Exception('❌ Erreur de connexion réseau');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('⏱️ Délai d\'attente dépassé');
      }
      throw Exception('❌ Erreur: ${e.toString()}');
    }
  }

  // Méthode pour récupérer plusieurs villes (optimisation API gratuite)
  Future<List<WeatherData>> getMultipleCitiesWeather(List<String> cities) async {
    final List<WeatherData> results = [];

    for (final city in cities) {
      try {
        final weatherData = await getWeatherByCity(city);
        results.add(weatherData);

        // Petit délai pour éviter de surcharger l'API gratuite
        await Future.delayed(const Duration(milliseconds: 200));
      } catch (e) {
        print('⚠️ Erreur pour $city: $e');
        // Continue avec les autres villes
      }
    }

    return results;
  }

  // Vérifier si les données en cache sont encore valides
  bool _isCacheValid(String key) {
    if (!_cache.containsKey(key) || !_cacheTimestamps.containsKey(key)) {
      return false;
    }

    final cacheTime = _cacheTimestamps[key]!;
    final now = DateTime.now();
    return now.difference(cacheTime) < _cacheDuration;
  }

  // Nettoyer le cache
  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
    print('🧹 Cache vidé');
  }

  // Obtenir les statistiques du cache
  Map<String, dynamic> getCacheStats() {
    final validEntries = _cache.keys.where((key) => _isCacheValid(key)).length;
    return {
      'total_entries': _cache.length,
      'valid_entries': validEntries,
      'expired_entries': _cache.length - validEntries,
    };
  }

  // Méthode de test pour vérifier la clé API
  Future<bool> testApiKey() async {
    try {
      final url = ApiConfig.getCurrentWeatherUrl(city: 'Paris,FR');
      final response = await http.get(Uri.parse(url)).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        print('✅ Clé API valide');
        return true;
      } else if (response.statusCode == 401) {
        print('❌ Clé API invalide');
        return false;
      } else {
        print('⚠️ Réponse inattendue: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Erreur test API: $e');
      return false;
    }
  }
}