import 'dart:convert';

class WeatherData {
  final String location;
  final double temperature;
  final String condition;
  final String description;
  final double humidity;
  final double windSpeed;
  final String icon;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      location: json['name'] ?? 'Unknown',
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['main'] ?? 'Unknown',
      description: json['weather'][0]['description'] ?? 'No description',
      humidity: (json['main']['humidity'] as num).toDouble(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      icon: json['weather'][0]['icon'] ?? '01d',
    );
  }
}

class WeatherService {
  static const String _apiKey = 'YOUR_API_KEY_HERE'; // Replace with your OpenWeatherMap API key
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherData> getWeatherByCity(String city) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // For demo purposes, return mock data
    // In production, uncomment the API call below
    return _getMockWeatherData(city);

    /* Uncomment this for real API calls:
    try {
      final url = '$_baseUrl?q=$city&appid=$_apiKey&units=metric';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
    */
  }

  Future<WeatherData> getWeatherByLocation(double lat, double lon) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // For demo purposes, return mock data
    return _getMockWeatherData('Current Location');

    /* Uncomment this for real API calls:
    try {
      final url = '$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
    */
  }

  WeatherData _getMockWeatherData(String location) {
    // Mock data for demo
    return WeatherData(
      location: location,
      temperature: 22.5,
      condition: 'Sunny',
      description: 'Clear sky',
      humidity: 65.0,
      windSpeed: 5.2,
      icon: '01d',
    );
  }
}