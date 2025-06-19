import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../model/weather_data.dart';
import '../../config/app_theme.dart';
import 'widgets/weather_header.dart';
import 'widgets/weather_details.dart';
import 'widgets/weather_map.dart';
import 'dart:ui';

class DetailScreen extends StatefulWidget {
  final WeatherData weatherData;

  const DetailScreen({
    Key? key,
    required this.weatherData,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _getGradientForWeather(),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Barre d'outils personnalisée
              _buildAppBar(),

              // Contenu principal
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // En-tête météo
                          WeatherHeader(weatherData: widget.weatherData)
                              .animate(delay: 200.ms)
                              .fadeIn(duration: 800.ms)
                              .slideY(begin: 0.3, duration: 800.ms),

                          const SizedBox(height: 20),

                          // Détails météo
                          WeatherDetails(weatherData: widget.weatherData)
                              .animate(delay: 400.ms)
                              .fadeIn(duration: 800.ms)
                              .slideY(begin: 0.3, duration: 800.ms),

                          const SizedBox(height: 20),

                          // Carte météo (simulation)
                          WeatherMap(weatherData: widget.weatherData)
                              .animate(delay: 600.ms)
                              .fadeIn(duration: 800.ms)
                              .slideY(begin: 0.3, duration: 800.ms),

                          const SizedBox(height: 20),

                          // Informations supplémentaires
                          _buildAdditionalInfo()
                              .animate(delay: 800.ms)
                              .fadeIn(duration: 800.ms)
                              .slideY(begin: 0.3, duration: 800.ms),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Bouton retour
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ).animate()
              .scale(delay: 100.ms, duration: 500.ms, curve: Curves.elasticOut),

          const Spacer(),

          // Titre
          Text(
            'Détails Météo',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ).animate()
              .fadeIn(delay: 200.ms, duration: 600.ms),

          const Spacer(),

          // Bouton partage
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: _shareWeatherData,
            ),
          ).animate()
              .scale(delay: 300.ms, duration: 500.ms, curve: Curves.elasticOut),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informations complémentaires',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Lever et coucher du soleil
          if (widget.weatherData.sunrise != null && widget.weatherData.sunset != null)
            _buildSunInfo(),

          const SizedBox(height: 16),

          // Dernière mise à jour
          _buildLastUpdate(),

          const SizedBox(height: 16),

          // Conseils
          _buildWeatherAdvice(),
        ],
      ),
    );
  }


// Then in your _buildSunInfo() method, replace the decoration with:
  Widget _buildSunInfo() {
    final sunrise = widget.weatherData.sunrise!;
    final sunset = widget.weatherData.sunset!;
    final sunriseTime = DateFormat('HH:mm').format(sunrise);
    final sunsetTime = DateFormat('HH:mm').format(sunset);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Icon(Icons.wb_sunny, color: Colors.orange, size: 30),
                    const SizedBox(height: 8),
                    const Text(
                      'Lever du soleil',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      sunriseTime,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: 1,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Icon(Icons.wb_sunny_outlined, color: Colors.orange, size: 30),
                    const SizedBox(height: 8),
                    const Text(
                      'Coucher du soleil',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      sunsetTime,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLastUpdate() {
    final updateTime = DateFormat('dd/MM/yyyy à HH:mm').format(widget.weatherData.dateTime);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.update, color: Colors.white70, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dernière mise à jour',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                updateTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherAdvice() {
    final advice = _getWeatherAdvice();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: Colors.yellow, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Conseil du jour',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            advice,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getGradientForWeather() {
    final icon = widget.weatherData.icon;

    if (icon.contains('01')) {
      // Ciel dégagé
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF87CEEB), Color(0xFF4682B4)],
      );
    } else if (icon.contains('02') || icon.contains('03')) {
      // Nuageux
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF708090), Color(0xFF2F4F4F)],
      );
    } else if (icon.contains('09') || icon.contains('10')) {
      // Pluvieux
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF4682B4), Color(0xFF191970)],
      );
    } else if (icon.contains('11')) {
      // Orageux
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF2F4F4F), Color(0xFF000000)],
      );
    } else if (icon.contains('13')) {
      // Neigeux
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFB0C4DE), Color(0xFF4682B4)],
      );
    } else {
      // Par défaut
      return AppTheme.primaryGradient;
    }
  }

  String _getWeatherAdvice() {
    final temp = widget.weatherData.temperature;
    final icon = widget.weatherData.icon;

    if (icon.contains('01')) {
      return 'Profitez de cette belle journée ensoleillée ! N\'oubliez pas votre crème solaire et restez hydraté.';
    } else if (icon.contains('09') || icon.contains('10')) {
      return 'Emportez un parapluie et portez des vêtements imperméables. Évitez les activités extérieures prolongées.';
    } else if (icon.contains('11')) {
      return 'Restez à l\'intérieur si possible. Évitez les activités en extérieur et débranchez vos appareils électriques.';
    } else if (icon.contains('13')) {
      return 'Portez des vêtements chauds et faites attention aux routes glissantes. Prévoyez plus de temps pour vos déplacements.';
    } else if (temp < 0) {
      return 'Il fait très froid ! Couvrez-vous bien et limitez le temps passé dehors pour éviter les engelures.';
    } else if (temp > 30) {
      return 'Il fait très chaud ! Restez hydraté, cherchez l\'ombre et évitez les efforts physiques intenses.';
    } else {
      return 'Conditions météorologiques agréables. Profitez de votre journée !';
    }
  }

  void _shareWeatherData() {
    final shareText = '''
🌤️ Météo à ${widget.weatherData.displayName}

🌡️ Température: ${widget.weatherData.temperatureString}
🌅 Ressenti: ${widget.weatherData.feelsLikeString}
📝 ${widget.weatherData.description}
💧 Humidité: ${widget.weatherData.humidity}%
🌪️ Vent: ${widget.weatherData.windSpeedString}
📊 Pression: ${widget.weatherData.pressureString}

📱 Partagé depuis WeatherPro
    ''';

    // Ici vous pourriez utiliser le package share_plus pour partager
    // Share.share(shareText);

    // Pour la démonstration, on affiche un SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Fonctionnalité de partage disponible avec le package share_plus'),
        backgroundColor: Colors.blue,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
