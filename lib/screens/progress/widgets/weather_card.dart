import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../model/weather_data.dart';
import '../../../config/app_theme.dart';
import 'dart:ui';

class WeatherCard extends StatelessWidget {
  final WeatherData weatherData;
  final VoidCallback? onTap;
  final bool isSelected;
  final int animationDelay;

  const WeatherCard({
    Key? key,
    required this.weatherData,
    this.onTap,
    this.isSelected = false,
    this.animationDelay = 0,
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
                  // Weather icon
                  _buildWeatherIcon(),

                  const SizedBox(width: 16),

                  // Weather information
                  Expanded(
                    child: _buildWeatherInfo(context),
                  ),

                  // Temperature
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
          _getWeatherEmoji(weatherData.icon),
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }

  // Alternative method using local assets
  Widget _buildWeatherIconAsset() {
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
      child: ClipOval(
        child: weatherData.getAssetIconWidget(size: 40),
      ),
    );
  }

  // Alternative method using emoji-style icons
  Widget _buildWeatherIconEmoji() {
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
          _getWeatherEmoji(weatherData.icon),
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }

  String _getWeatherEmoji(String iconCode) {
    switch (iconCode.substring(0, 2)) {
      case '01':
        return iconCode.endsWith('d') ? '☀️' : '🌙';
      case '02':
        return iconCode.endsWith('d') ? '⛅' : '☁️';
      case '03':
      case '04':
        return '☁️';
      case '09':
        return '🌧️';
      case '10':
        return '🌦️';
      case '11':
        return '⛈️';
      case '13':
        return '❄️';
      case '50':
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  Widget _buildWeatherInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          weatherData.displayName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          weatherData.description.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 13,
            letterSpacing: 0.5,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.water_drop,
              color: Colors.white.withOpacity(0.6),
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              weatherData.humidityString,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.air,
              color: Colors.white.withOpacity(0.6),
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              weatherData.windSpeedString,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTemperature(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          weatherData.temperatureString,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
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

// Widget for loading state cards
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
            // Icon skeleton
            _buildSkeletonContainer(60, 60, isCircle: true),

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

// Custom WeatherCard that allows choosing icon display method
class CustomWeatherCard extends WeatherCard {
  final WeatherIconType iconType;

  const CustomWeatherCard({
    Key? key,
    required WeatherData weatherData,
    VoidCallback? onTap,
    bool isSelected = false,
    int animationDelay = 0,
    this.iconType = WeatherIconType.network,
  }) : super(
    key: key,
    weatherData: weatherData,
    onTap: onTap,
    isSelected: isSelected,
    animationDelay: animationDelay,
  );

  @override
  Widget _buildWeatherIcon() {
    switch (iconType) {
      case WeatherIconType.network:
        return super._buildWeatherIcon();
      case WeatherIconType.asset:
        return _buildWeatherIconAsset();
      case WeatherIconType.emoji:
        return _buildWeatherIconEmoji();
    }
  }
}

enum WeatherIconType {
  network,
  asset,
  emoji,
}