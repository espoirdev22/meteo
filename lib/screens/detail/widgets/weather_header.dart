import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../model/weather_data.dart';
import '../../../core/constants/weather_emojis.dart';
import 'daily_weather_detail.dart';
import 'dart:ui';

class WeatherHeader extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherHeader({
    Key? key,
    required this.weatherData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // En-tête principal avec ville et météo actuelle
          _buildMainHeader(),

          const SizedBox(height: 30),

          // Prévisions horaires
          _buildHourlyForecast(),

          const SizedBox(height: 30),

          // Détails météo (humidité, vent, etc.)
          _buildWeatherDetails(),

          const SizedBox(height: 30),

          // Prévisions hebdomadaires
          _buildWeeklyForecast(context),
        ],
      ),
    );
  }

  Widget _buildMainHeader() {
    return Column(
      children: [
        // Nom de la ville et température max/min
        Column(
          children: [
            Text(
              weatherData.displayName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Max.: ${(weatherData.temperature + 3).round()}°C  Min.: ${(weatherData.temperature - 5).round()}°C',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ).animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: -0.3, duration: 600.ms),

        const SizedBox(height: 30),

        // Icône météo principale avec emoji intelligent
        Text(
          WeatherEmojis.getSmartEmoji(
            iconCode: weatherData.icon,
            temperature: weatherData.temperature,
          ),
          style: const TextStyle(fontSize: 120),
        ).animate()
            .scale(delay: 200.ms, duration: 800.ms, curve: Curves.elasticOut)
            .then()
            .shimmer(duration: 2000.ms),

        const SizedBox(height: 20),

        // Température principale avec emoji de température
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${weatherData.temperature.round()}°',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 80,
                fontWeight: FontWeight.w200,
                height: 1.0,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              WeatherEmojis.getTemperatureEmoji(weatherData.temperature),
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ).animate()
            .fadeIn(delay: 400.ms, duration: 800.ms)
            .slideY(begin: 0.5, duration: 800.ms),

        const SizedBox(height: 10),

        // Description
        Text(
          weatherData.description,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ).animate()
            .fadeIn(delay: 600.ms, duration: 800.ms),

        const SizedBox(height: 8),

        // Ressenti
        Text(
          'Ressenti ${weatherData.feelsLikeString}',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ).animate()
            .fadeIn(delay: 800.ms, duration: 800.ms),
      ],
    );
  }

  Widget _buildHourlyForecast() {
    return Container(
      height: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Prévisions horaires',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 24,
              itemBuilder: (context, index) {
                final hour = (DateTime.now().hour + index) % 24;
                final temp = (weatherData.temperature + (index % 3 - 1) * 2).round();
                final hourlyData = _generateHourlyData(index);

                return Container(
                  width: 90,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        index == 0 ? 'Maintenant' : '${hour}h',
                        style: TextStyle(
                          color: index == 0 ? Colors.white : Colors.white70,
                          fontSize: 12,
                          fontWeight: index == 0 ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      Text(
                        hourlyData['emoji'] as String,
                        style: const TextStyle(fontSize: 24),
                      ),
                      Text(
                        '${temp}°',
                        style: TextStyle(
                          color: index == 0 ? Colors.white : Colors.white70,
                          fontSize: 16,
                          fontWeight: index == 0 ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(delay: 1000.ms, duration: 800.ms)
        .slideX(begin: -0.3, duration: 800.ms);
  }

  Widget _buildWeatherDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.thermostat, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Il fait actuellement ',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                '${weatherData.temperature.round()}°C',
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 4),
              Text(
                WeatherEmojis.getTemperatureEmoji(weatherData.temperature),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem('UV', '5', 'Modéré', '☀️'),
              _buildDetailItem(
                'HUMIDITÉ',
                weatherData.humidityString,
                '',
                WeatherEmojis.getHumidityEmoji(_extractHumidityValue()),
              ),
              _buildDetailItem(
                'VENT',
                weatherData.windSpeedString,
                '',
                WeatherEmojis.getWindEmoji(_extractWindSpeedValue()),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'La température ne devrait pas changer au cours de la nuit',
            style: TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate()
        .fadeIn(delay: 1200.ms, duration: 800.ms)
        .slideY(begin: 0.3, duration: 800.ms);
  }

  Widget _buildDetailItem(String label, String value, String description, String emoji) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              emoji,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        if (description.isNotEmpty)
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
      ],
    );
  }

  Widget _buildWeeklyForecast(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Prévisions sur 7 jours',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Container(
            constraints: BoxConstraints(maxHeight: 600),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _buildWeeklyForecastItems(context), // Passez le context
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWeeklyForecastItems(BuildContext context) {
    final List<Widget> items = [];
    final forecasts = _generateWeeklyData();
    final now = DateTime.now();

    for (int i = 0; i < forecasts.length; i++) {
      final forecast = forecasts[i];
      final isToday = i == 0;
      final forecastDate = now.add(Duration(days: i));

      items.add(
        InkWell(
          onTap: () {
            // Feedback haptique
            HapticFeedback.lightImpact();

            // Navigation avec animation personnalisée
            _navigateToDetailPage(context, forecastDate, forecast);
          },
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: i < forecasts.length - 1
                  ? Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 0.5,
                ),
              )
                  : null,
            ),
            child: Row(
              children: [
                // Jour de la semaine
                SizedBox(
                  width: 80,
                  child: Text(
                    isToday ? 'Aujourd\'hui' : _getDayName(forecastDate),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(width: 8),

                // Icône météo
                SizedBox(
                  width: 24,
                  child: Text(
                    forecast['emoji'] as String,
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(width: 8),

                // Probabilité de pluie
                if ((forecast['rainChance'] as int) > 0)
                  SizedBox(
                    width: 40,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${forecast['rainChance']}%',
                          style: const TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text('💧', style: TextStyle(fontSize: 8)),
                      ],
                    ),
                  )
                else
                  const SizedBox(width: 36),

                const Spacer(),

                // Température minimale
                Text(
                  '${forecast['minTemp']}°',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(width: 12),

                // Barre de température
                Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.3),
                        Colors.orange.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Température maximale
                SizedBox(
                  width: 30,
                  child: Text(
                    '${forecast['maxTemp']}°',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),

                const SizedBox(width: 8),

                // Icône de navigation
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white54,
                  size: 20,
                ),
              ],
            ),
          ),
        ).animate(delay: (1800 + i * 50).ms)
            .fadeIn(duration: 400.ms)
            .slideX(begin: 0.2, duration: 400.ms),
      );
    }

    return items;
  }

  // Méthode de navigation avec animation personnalisée
  void _navigateToDetailPage(BuildContext context, DateTime date, Map<String, dynamic> forecast) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DailyWeatherDetail(
              weatherData: weatherData,
              selectedDate: date,
              dayForecast: forecast,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  String _getDayName(DateTime date) {
    final formatter = DateFormat('EEEE', 'fr_FR');
    String dayName = formatter.format(date);
    return dayName[0].toUpperCase() + dayName.substring(1);
  }

  // Génération de données horaires avec emojis intelligents
  Map<String, dynamic> _generateHourlyData(int hourOffset) {
    final baseTemp = weatherData.temperature;
    final isNight = DateTime.now().add(Duration(hours: hourOffset)).hour < 6 ||
        DateTime.now().add(Duration(hours: hourOffset)).hour > 20;

    // Simulation de codes météo pour les heures
    final hourlyWeatherCodes = ['01', '02', '03', '04', '09', '10'];
    final randomCode = hourlyWeatherCodes[hourOffset % hourlyWeatherCodes.length];
    final fullCode = randomCode + (isNight ? 'n' : 'd');

    return {
      'emoji': WeatherEmojis.getSmartEmoji(
        iconCode: fullCode,
        temperature: baseTemp + (hourOffset % 3 - 1) * 2,
      ),
      'temperature': (baseTemp + (hourOffset % 3 - 1) * 2).round(),
      'code': fullCode,
    };
  }

  List<Map<String, dynamic>> _generateWeeklyData() {
    final baseTemp = weatherData.temperature;
    final weatherPatterns = [
      {'code': weatherData.icon, 'tempVar': 0},
      {'code': '02d', 'tempVar': 2},
      {'code': '09d', 'tempVar': -1},
      {'code': '01d', 'tempVar': 3},
      {'code': '03d', 'tempVar': 1},
      {'code': '11d', 'tempVar': -2},
      {'code': '02d', 'tempVar': 4},
    ];

    return weatherPatterns.asMap().entries.map((entry) {
      final index = entry.key;
      final pattern = entry.value;
      final maxTemp = (baseTemp + (pattern['tempVar'] as int)).round();
      final minTemp = (maxTemp - 5).round();

      return {
        'maxTemp': maxTemp,
        'minTemp': minTemp,
        'emoji': WeatherEmojis.getSmartEmoji(
          iconCode: pattern['code'] as String,
          temperature: maxTemp.toDouble(),
        ),
        'description': WeatherEmojis.getEmojiDescription(pattern['code'] as String),
        'rainChance': _getRainChance(pattern['code'] as String),
      };
    }).toList();
  }

  int _getRainChance(String icon) {
    if (icon.contains('09') || icon.contains('10')) return 85;
    if (icon.contains('11')) return 95;
    if (icon.contains('02') || icon.contains('03')) return 25;
    if (icon.contains('04')) return 40;
    return 0;
  }

  // Méthodes utilitaires pour extraire les valeurs numériques
  int _extractHumidityValue() {
    // Extrait la valeur numérique de humidityString (ex: "65%" -> 65)
    final match = RegExp(r'\d+').firstMatch(weatherData.humidityString);
    return match != null ? int.tryParse(match.group(0)!) ?? 50 : 50;
  }

  double _extractWindSpeedValue() {
    // Extrait la valeur numérique de windSpeedString (ex: "12 km/h" -> 12.0)
    final match = RegExp(r'\d+\.?\d*').firstMatch(weatherData.windSpeedString);
    return match != null ? double.tryParse(match.group(0)!) ?? 5.0 : 5.0;
  }
}