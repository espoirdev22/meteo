import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/app_theme.dart';

enum LoadingType { circular, linear, dots, weather, custom }

class LoadingIndicator extends StatelessWidget {
  final LoadingType type;
  final String? message;
  final double? size;
  final Color? color;
  final bool showMessage;
  final EdgeInsetsGeometry? padding;

  const LoadingIndicator({
    Key? key,
    this.type = LoadingType.circular,
    this.message,
    this.size,
    this.color,
    this.showMessage = true,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = color ?? theme.primaryColor;

    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLoadingWidget(primaryColor, theme),
          if (showMessage && message != null) ...[
            const SizedBox(height: 16),
            _buildMessageWidget(theme),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingWidget(Color primaryColor, ThemeData theme) {
    switch (type) {
      case LoadingType.circular:
        return _buildCircularLoader(primaryColor);
      case LoadingType.linear:
        return _buildLinearLoader(primaryColor);
      case LoadingType.dots:
        return _buildDotsLoader(primaryColor);
      case LoadingType.weather:
        return _buildWeatherLoader(primaryColor);
      case LoadingType.custom:
        return _buildCustomLoader(primaryColor);
    }
  }

  Widget _buildCircularLoader(Color color) {
    return SizedBox(
      width: size ?? 40,
      height: size ?? 40,
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: 3,
        backgroundColor: color.withOpacity(0.2),
      ),
    );
  }

  Widget _buildLinearLoader(Color color) {
    return SizedBox(
      width: size ?? 200,
      child: LinearProgressIndicator(
        color: color,
        backgroundColor: color.withOpacity(0.2),
        minHeight: 4,
      ),
    );
  }

  Widget _buildDotsLoader(Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ).animate(onPlay: (controller) => controller.repeat())
            .scale(
          delay: Duration(milliseconds: index * 200),
          duration: const Duration(milliseconds: 600),
        )
            .then()
            .scale(
          begin: Offset(1.0, 1.0),
          end: Offset(1.5, 1.5),
          duration: const Duration(milliseconds: 600),
        );
      }),
    );
  }

  Widget _buildWeatherLoader(Color color) {
    return Container(
      width: size ?? 80,
      height: size ?? 80,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular((size ?? 80) / 2),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '🌤️',
          style: TextStyle(fontSize: (size ?? 80) * 0.4),
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat())
        .rotate(duration: const Duration(seconds: 3))
        .then()
        .shimmer(duration: const Duration(seconds: 2));
  }

  Widget _buildCustomLoader(Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size ?? 60,
          height: size ?? 60,
          child: CircularProgressIndicator(
            color: color.withOpacity(0.3),
            strokeWidth: 8,
            backgroundColor: Colors.transparent,
          ),
        ),
        SizedBox(
          width: (size ?? 60) * 0.7,
          height: (size ?? 60) * 0.7,
          child: CircularProgressIndicator(
            color: color,
            strokeWidth: 4,
            backgroundColor: Colors.transparent,
          ),
        ).animate(onPlay: (controller) => controller.repeat())
            .rotate(duration: const Duration(milliseconds: 1500)),
      ],
    );
  }

  Widget _buildMessageWidget(ThemeData theme) {
    return Text(
      message!,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
      ),
      textAlign: TextAlign.center,
    ).animate()
        .fadeIn(duration: const Duration(milliseconds: 300))
        .then(delay: const Duration(milliseconds: 500))
        .fadeOut(duration: const Duration(milliseconds: 300))
        .then()
        .fadeIn(duration: const Duration(milliseconds: 300));
  }
}

// Widgets spécialisés pour l'app météo
class WeatherLoadingIndicators {
  static Widget fetchingWeather({String? city}) {
    return LoadingIndicator(
      type: LoadingType.weather,
      message: city != null
          ? 'Récupération de la météo pour $city...'
          : 'Récupération des données météo...',
      size: 80,
    );
  }

  static Widget locatingUser() {
    return const LoadingIndicator(
      type: LoadingType.custom,
      message: 'Localisation en cours...',
      size: 60,
    );
  }

  static Widget refreshingData() {
    return const LoadingIndicator(
      type: LoadingType.dots,
      message: 'Actualisation des données...',
    );
  }

  static Widget loadingProgress({required double progress}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 200,
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.grey.withOpacity(0.3),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${(progress * 100).toInt()}%',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

// Overlay de chargement plein écran
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingMessage;
  final LoadingType loadingType;

  const LoadingOverlay({
    Key? key,
    required this.child,
    required this.isLoading,
    this.loadingMessage,
    this.loadingType = LoadingType.weather,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: LoadingIndicator(
                  type: loadingType,
                  message: loadingMessage,
                ),
              ),
            ),
          ),
      ],
    );
  }
}