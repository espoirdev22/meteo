import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/weather_emojis.dart';
import '../../../model/weather_data.dart';
import '../../../config/app_theme.dart';
import 'dart:ui';

class WeatherCard extends StatelessWidget {
  final WeatherData weatherData;
  final VoidCallback? onTap;
  final bool isSelected;
  final int animationDelay;
  final bool useAnimatedEmojis;
  final bool useSmartEmojis;

  const WeatherCard({
    Key? key,
    required this.weatherData,
    this.onTap,
    this.isSelected = false,
    this.animationDelay = 0,
    this.useAnimatedEmojis = false,
    this.useSmartEmojis = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [
              AppTheme.accentOrange.withOpacity(0.3),
              AppTheme.accentRed.withOpacity(0.3),
            ]
                : [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentOrange.withOpacity(0.5)
                : Colors.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Weather icon avec les nouveaux emojis
                  _buildWeatherIcon(),

                  const SizedBox(width: 16),

                  // Weather information avec emojis additionnels
                  Expanded(
                    child: _buildWeatherInfo(context),
                  ),

                  // Temperature avec emoji température
                  _buildTemperature(context),

                  // Arrow
                  const SizedBox(width: 12),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.7),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(
      delay: Duration(milliseconds: animationDelay),
      duration: const Duration(milliseconds: 600),
    ).slideX(
      begin: 0.3,
      duration: const Duration(milliseconds: 600),
    );
  }

  Widget _buildWeatherIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          _getWeatherEmoji(),
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }

  /// Obtient l'emoji météo en utilisant la classe WeatherEmojis
  String _getWeatherEmoji() {
    if (useSmartEmojis) {
      // Utilise l'emoji intelligent avec les données météo
      return WeatherEmojis.getSmartEmoji(
        iconCode: weatherData.icon,
        temperature: weatherData.temperature,
        windSpeed: weatherData.windSpeed,
        humidity: weatherData.humidity?.round(),
      );
    } else if (useAnimatedEmojis) {
      // Utilise l'emoji animé
      return WeatherEmojis.getAnimatedEmoji(
          weatherData.icon,
          isAnimating: true
      );
    } else {
      // Utilise l'emoji de base ou l'extension
      return weatherData.icon.weatherEmoji;
    }
  }

  Widget _buildWeatherInfo(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            weatherData.displayName,
            style: const TextStyle(
              fontSize: 16, // Reduced size
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            weatherData.icon.emojiDescription,
            style: TextStyle(fontSize: 12, color: Colors.white,), // Reduced size
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Humidity info
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 80),
                child: Row(/* ... */),
              ),
              // Wind info
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 80),
                child: Row(/* ... */),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTemperature(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emoji température
            Text(
              WeatherEmojis.getTemperatureEmoji(weatherData.temperature ?? 0),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 4),
            Text(
              weatherData.temperatureString,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          'Ressenti ${weatherData.feelsLikeString}',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// Widget pour les états de chargement avec emojis
class WeatherCardSkeleton extends StatefulWidget {
  final int animationDelay;

  const WeatherCardSkeleton({
    Key? key,
    this.animationDelay = 0,
  }) : super(key: key);

  @override
  State<WeatherCardSkeleton> createState() => _WeatherCardSkeletonState();
}

class _WeatherCardSkeletonState extends State<WeatherCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Icon skeleton avec emoji de chargement
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  WeatherEmojis.loadingEmoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Information skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSkeletonContainer(double.infinity, 16),
                  const SizedBox(height: 8),
                  _buildSkeletonContainer(120, 12),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSkeletonContainer(60, 12),
                      const SizedBox(width: 16),
                      _buildSkeletonContainer(40, 12),
                    ],
                  ),
                ],
              ),
            ),

            // Temperature skeleton
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildSkeletonContainer(60, 32),
                const SizedBox(height: 4),
                _buildSkeletonContainer(80, 12),
              ],
            ),
          ],
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: const Duration(milliseconds: 1500))
        .fadeIn(delay: Duration(milliseconds: widget.animationDelay));
  }

  Widget _buildSkeletonContainer(double width, double height, {bool isCircle = false}) {
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: isCircle ? null : BorderRadius.circular(8),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
    );
  }
}

// WeatherCard personnalisée avec différents modes d'affichage
class CustomWeatherCard extends WeatherCard {
  final WeatherEmojiMode emojiMode;

  const CustomWeatherCard({
    Key? key,
    required WeatherData weatherData,
    VoidCallback? onTap,
    bool isSelected = false,
    int animationDelay = 0,
    this.emojiMode = WeatherEmojiMode.smart,
  }) : super(
    key: key,
    weatherData: weatherData,
    onTap: onTap,
    isSelected: isSelected,
    animationDelay: animationDelay,
    useAnimatedEmojis: emojiMode == WeatherEmojiMode.animated,
    useSmartEmojis: emojiMode == WeatherEmojiMode.smart,
  );
}

// Modes d'affichage des emojis
enum WeatherEmojiMode {
  basic,      // Emojis de base
  smart,      // Emojis intelligents avec conditions
  animated,   // Emojis animés
}

// Widget spécialisé pour afficher des variations d'emojis
class WeatherEmojiVariation extends StatefulWidget {
  final String iconCode;
  final Duration animationDuration;
  final double size;

  const WeatherEmojiVariation({
    Key? key,
    required this.iconCode,
    this.animationDuration = const Duration(seconds: 3),
    this.size = 28,
  }) : super(key: key);

  @override
  State<WeatherEmojiVariation> createState() => _WeatherEmojiVariationState();
}

class _WeatherEmojiVariationState extends State<WeatherEmojiVariation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;
  String _currentEmoji = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _updateEmoji();
    _timer = Timer.periodic(widget.animationDuration, (_) => _updateEmoji());
  }

  void _updateEmoji() {
    setState(() {
      _currentEmoji = WeatherEmojis.getAnimatedEmoji(
          widget.iconCode,
          isAnimating: true
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Text(
        _currentEmoji,
        key: ValueKey(_currentEmoji),
        style: TextStyle(fontSize: widget.size),
      ),
    );
  }
}

// Extension pour faciliter l'utilisation dans WeatherData
extension WeatherDataEmojiExtension on WeatherData {
  /// Obtient l'emoji météo de base
  String get basicEmoji => icon.weatherEmoji;

  /// Obtient l'emoji intelligent
  String get smartEmoji => WeatherEmojis.getSmartEmoji(
    iconCode: icon,
    temperature: temperature,
    windSpeed: windSpeed,
    humidity: humidity?.round(),
  );

  /// Obtient l'emoji animé
  String getAnimatedEmoji({bool isAnimating = false}) =>
      WeatherEmojis.getAnimatedEmoji(icon, isAnimating: isAnimating);

  /// Obtient l'emoji de température
  String get temperatureEmoji =>
      WeatherEmojis.getTemperatureEmoji(temperature ?? 0);

  /// Obtient l'emoji de vent
  String get windEmoji =>
      WeatherEmojis.getWindEmoji(windSpeed ?? 0);

  /// Obtient l'emoji d'humidité
  String get humidityEmoji =>
      WeatherEmojis.getHumidityEmoji(humidity?.round() ?? 0);
}
