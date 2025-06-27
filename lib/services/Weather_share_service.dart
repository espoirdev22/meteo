import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../core/constants/weather_emojis.dart';
import '../model/weather_data.dart';

class WeatherShareService {
  static const String _appName = 'WeatherPro';
  static const String _appUrl = 'https://play.google.com/store/apps/details?id=com.example.weatherpro';

  // ============================================
  //  MÉTHODES DE PARTAGE PRINCIPAL
  // ============================================

  /// Partage les données météo avec emojis intelligents
  static Future<void> shareWeatherData(
      WeatherData weatherData, {
        String? customMessage,
        bool includeAdvice = true,
        bool includeEmojis = true,
      }) async {
    try {
      final shareText = _buildShareText(
        weatherData,
        customMessage: customMessage,
        includeAdvice: includeAdvice,
        includeEmojis: includeEmojis,
      );

      await Share.share(
        shareText,
        subject: '${includeEmojis ? '🌤️ ' : ''}Météo à ${weatherData.displayName}',
      );
    } catch (e) {
      print('❌ Erreur lors du partage: $e');
      throw Exception('Impossible de partager les données météo');
    }
  }

  /// Partage avec une image générée
  static Future<void> shareWeatherWithImage(
      WeatherData weatherData,
      GlobalKey widgetKey, {
        String? customMessage,
      }) async {
    try {
      // Capturer le widget en image
      final imageBytes = await _captureWidget(widgetKey);

      if (imageBytes != null) {
        // Sauvegarder temporairement l'image
        final tempFile = await _saveImageToTemp(imageBytes, weatherData.displayName);

        final shareText = _buildShareText(weatherData, customMessage: customMessage);

        await Share.shareXFiles(
          [XFile(tempFile.path)],
          text: shareText,
          subject: '🌤️ Météo à ${weatherData.displayName}',
        );
      } else {
        // Fallback vers partage texte
        await shareWeatherData(weatherData, customMessage: customMessage);
      }
    } catch (e) {
      print('❌ Erreur lors du partage avec image: $e');
      // Fallback vers partage texte
      await shareWeatherData(weatherData, customMessage: customMessage);
    }
  }

  /// Copie les données météo dans le presse-papiers
  static Future<void> copyToClipboard(
      WeatherData weatherData, {
        bool includeEmojis = true,
      }) async {
    try {
      final text = _buildShareText(
        weatherData,
        includeAdvice: false,
        includeEmojis: includeEmojis,
      );

      await Clipboard.setData(ClipboardData(text: text));
    } catch (e) {
      print('❌ Erreur lors de la copie: $e');
      throw Exception('Impossible de copier les données');
    }
  }

  // ============================================
  // MÉTHODES DE CONSTRUCTION DU TEXTE
  // ============================================

  static String _buildShareText(
      WeatherData weatherData, {
        String? customMessage,
        bool includeAdvice = true,
        bool includeEmojis = true,
      }) {
    final buffer = StringBuffer();

    // Message personnalisé
    if (customMessage != null && customMessage.isNotEmpty) {
      buffer.writeln(customMessage);
      buffer.writeln();
    }

    // En-tête avec emoji météo
    if (includeEmojis) {
      final weatherEmoji = WeatherEmojis.getWeatherEmoji(weatherData.icon);
      buffer.writeln('$weatherEmoji Météo à ${weatherData.displayName}');
    } else {
      buffer.writeln('Météo à ${weatherData.displayName}');
    }

    buffer.writeln('${_formatDateTime(weatherData.dateTime)}');
    buffer.writeln();

    // Informations principales
    if (includeEmojis) {
      final tempEmoji = WeatherEmojis.getTemperatureEmoji(weatherData.temperature);
      final windEmoji = WeatherEmojis.getWindEmoji(weatherData.windSpeed);
      final humidityEmoji = WeatherEmojis.getHumidityEmoji(weatherData.humidity);

      buffer.writeln('$tempEmoji Température: ${weatherData.temperatureString}');
      buffer.writeln('🌡️ Ressenti: ${weatherData.feelsLikeString}');
      buffer.writeln('📝 ${_capitalizeFirst(weatherData.description)}');
      buffer.writeln('$humidityEmoji Humidité: ${weatherData.humidity}%');
      buffer.writeln('$windEmoji Vent: ${weatherData.windSpeedString}');
      buffer.writeln('📊 Pression: ${weatherData.pressureString}');
    } else {
      buffer.writeln('Température: ${weatherData.temperatureString}');
      buffer.writeln('Ressenti: ${weatherData.feelsLikeString}');
      buffer.writeln('${_capitalizeFirst(weatherData.description)}');
      buffer.writeln('Humidité: ${weatherData.humidity}%');
      buffer.writeln('Vent: ${weatherData.windSpeedString}');
      buffer.writeln('Pression: ${weatherData.pressureString}');
    }

    // Lever/coucher du soleil si disponible
    if (weatherData.sunrise != null && weatherData.sunset != null) {
      buffer.writeln();
      if (includeEmojis) {
        buffer.writeln('🌅 Lever: ${DateFormat('HH:mm').format(weatherData.sunrise!)}');
        buffer.writeln('🌇 Coucher: ${DateFormat('HH:mm').format(weatherData.sunset!)}');
      } else {
        buffer.writeln('Lever du soleil: ${DateFormat('HH:mm').format(weatherData.sunrise!)}');
        buffer.writeln('Coucher du soleil: ${DateFormat('HH:mm').format(weatherData.sunset!)}');
      }
    }

    // Conseil météo
    if (includeAdvice) {
      buffer.writeln();
      final advice = _getWeatherAdvice(weatherData);
      if (includeEmojis) {
        final adviceEmoji = _getAdviceEmoji(weatherData);
        buffer.writeln('$adviceEmoji $advice');
      } else {
        buffer.writeln('Conseil: $advice');
      }
    }

    // Signature de l'app
    buffer.writeln();
    if (includeEmojis) {
      buffer.writeln('📱 Partagé depuis $_appName');
    } else {
      buffer.writeln('Partagé depuis $_appName');
    }

    return buffer.toString();
  }

  // ============================================
  // 🖼️ MÉTHODES DE CAPTURE D'IMAGE
  // ============================================

  static Future<Uint8List?> _captureWidget(GlobalKey widgetKey) async {
    try {
      final RenderRepaintBoundary? boundary =
      widgetKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) return null;

      final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('❌ Erreur capture widget: $e');
      return null;
    }
  }

  static Future<File> _saveImageToTemp(Uint8List imageBytes, String cityName) async {
    final tempDir = await getTemporaryDirectory();
    final fileName = 'weather_${cityName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('${tempDir.path}/$fileName');

    return await file.writeAsBytes(imageBytes);
  }

  // ============================================
  // 🎨 MÉTHODES UTILITAIRES
  // ============================================

  static String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy à HH:mm').format(dateTime);
  }

  static String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  static String _getAdviceEmoji(WeatherData weatherData) {
    final icon = weatherData.icon;
    final temp = weatherData.temperature;
    final windSpeed = weatherData.windSpeed;

    if (icon.contains('01')) return '😎';
    if (icon.contains('09') || icon.contains('10')) return '☂️';
    if (icon.contains('11')) return '⚠️';
    if (icon.contains('13')) return '🧥';
    if (temp < 0) return '🥶';
    if (temp > 30) return '🌡️';
    if (windSpeed > 7) return '🌪️';
    return '💡';
  }

  static String _getWeatherAdvice(WeatherData weatherData) {
    final temp = weatherData.temperature;
    final icon = weatherData.icon;
    final windSpeed = weatherData.windSpeed;

    if (icon.contains('01')) {
      if (temp > 30) {
        return 'Journée ensoleillée mais très chaude ! Protégez-vous du soleil.';
      }
      return 'Profitez de cette belle journée ensoleillée !';
    } else if (icon.contains('09') || icon.contains('10')) {
      if (windSpeed > 5) {
        return 'Pluie avec du vent ! Emportez un parapluie solide.';
      }
      return 'Emportez un parapluie et des vêtements imperméables.';
    } else if (icon.contains('11')) {
      return 'Orages prévus ! Restez à l\'intérieur.';
    } else if (icon.contains('13')) {
      return 'Chutes de neige ! Portez des vêtements chauds.';
    } else if (temp < 0) {
      return 'Températures glaciales ! Couvrez-vous bien.';
    } else if (temp > 35) {
      return 'Canicule ! Restez hydraté et cherchez l\'ombre.';
    } else {
      return 'Conditions météorologiques agréables.';
    }
  }
}

// ============================================
// 🎭 WIDGET DE DIALOGUE DE PARTAGE
// ============================================

class WeatherShareDialog extends StatelessWidget {
  final WeatherData weatherData;
  final GlobalKey? widgetKey;

  const WeatherShareDialog({
    Key? key,
    required this.weatherData,
    this.widgetKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text(WeatherEmojis.getWeatherEmoji(weatherData.icon)),
          const SizedBox(width: 8),
          const Text('Partager la météo'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.share, color: Colors.blue),
            title: const Text('Partager le texte'),
            subtitle: const Text('Partager les informations météo'),
            onTap: () async {
              Navigator.of(context).pop();
              try {
                await WeatherShareService.shareWeatherData(weatherData);
                _showSuccessSnackBar(context, 'Données partagées avec succès !');
              } catch (e) {
                _showErrorSnackBar(context, 'Erreur lors du partage');
              }
            },
          ),
          if (widgetKey != null)
            ListTile(
              leading: const Icon(Icons.image, color: Colors.green),
              title: const Text('Partager avec image'),
              subtitle: const Text('Partager avec capture d\'écran'),
              onTap: () async {
                Navigator.of(context).pop();
                try {
                  await WeatherShareService.shareWeatherWithImage(
                    weatherData,
                    widgetKey!,
                  );
                  _showSuccessSnackBar(context, 'Image partagée avec succès !');
                } catch (e) {
                  _showErrorSnackBar(context, 'Erreur lors du partage de l\'image');
                }
              },
            ),
          ListTile(
            leading: const Icon(Icons.copy, color: Colors.orange),
            title: const Text('Copier'),
            subtitle: const Text('Copier dans le presse-papiers'),
            onTap: () async {
              Navigator.of(context).pop();
              try {
                await WeatherShareService.copyToClipboard(weatherData);
                _showSuccessSnackBar(context, 'Données copiées !');
              } catch (e) {
                _showErrorSnackBar(context, 'Erreur lors de la copie');
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
      ],
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}