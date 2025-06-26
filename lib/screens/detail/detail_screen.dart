import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/constants/weather_emojis.dart';
import '../../model/weather_data.dart';
import '../../config/app_theme.dart';
import '../../services/weather_share_service.dart';
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

  // Clé globale pour la capture d'écran
  final GlobalKey _screenShotKey = GlobalKey();

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
      body: RepaintBoundary(
        key: _screenShotKey,
        child: Container(
          decoration: BoxDecoration(
            gradient: _getGradientForWeather(),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Barre d'outils avec emoji météo intelligent
                _buildEnhancedAppBar(),

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
                            // En-tête météo avec emojis avancés
                            WeatherHeader(weatherData: widget.weatherData)
                                .animate(delay: 200.ms)
                                .fadeIn(duration: 800.ms)
                                .slideY(begin: 0.3, duration: 800.ms),

                            const SizedBox(height: 20),

                            // Détails météo avec emojis contextuels
                            WeatherDetails(weatherData: widget.weatherData)
                                .animate(delay: 400.ms)
                                .fadeIn(duration: 800.ms)
                                .slideY(begin: 0.3, duration: 800.ms),

                            const SizedBox(height: 20),

                            // Carte météo
                            WeatherMap(weatherData: widget.weatherData)
                                .animate(delay: 600.ms)
                                .fadeIn(duration: 800.ms)
                                .slideY(begin: 0.3, duration: 800.ms),

                            const SizedBox(height: 20),

                            // Informations supplémentaires avec emojis intelligents
                            _buildEnhancedAdditionalInfo()
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
      ),
    );
  }

  /// Barre d'outils améliorée avec emoji météo intelligent
  Widget _buildEnhancedAppBar() {
    final weatherEmoji = WeatherEmojis.getAnimatedEmoji(widget.weatherData.icon);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Bouton retour avec animation
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

          // Titre avec emoji météo animé
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                weatherEmoji,
                style: const TextStyle(fontSize: 24),
              ).animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3)),
              const SizedBox(width: 8),
              const Text(
                'Détails Météo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ).animate()
              .fadeIn(delay: 200.ms, duration: 600.ms),

          const Spacer(),

          // Bouton partage avec animation - NOUVELLE FONCTIONNALITÉ
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: _showShareDialog,
            ),
          ).animate()
              .scale(delay: 300.ms, duration: 500.ms, curve: Curves.elasticOut),
        ],
      ),
    );
  }

  /// Affichage du dialogue de partage
  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (context) => WeatherShareDialog(
        weatherData: widget.weatherData,
        widgetKey: _screenShotKey,
      ),
    );
  }

  /// Informations supplémentaires avec emojis intelligents
  Widget _buildEnhancedAdditionalInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                WeatherEmojis.getSpecialEmoji('default'),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              const Text(
                'Informations complémentaires',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Lever et coucher du soleil avec emojis spéciaux
          if (widget.weatherData.sunrise != null && widget.weatherData.sunset != null)
            _buildEnhancedSunInfo(),

          const SizedBox(height: 16),

          // Dernière mise à jour avec emoji
          _buildEnhancedLastUpdate(),

          const SizedBox(height: 16),

          // Conseils météo avec emoji intelligent
          _buildEnhancedWeatherAdvice(),

          const SizedBox(height: 16),

          // Boutons de partage rapide - NOUVELLE SECTION
          _buildQuickShareActions(),
        ],
      ),
    );
  }

  /// Boutons de partage rapide - NOUVELLE FONCTIONNALITÉ
  Widget _buildQuickShareActions() {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('📤', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  const Text(
                    'Partage rapide',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickShareButton(
                      icon: Icons.share,
                      label: 'Partager',
                      onTap: () => _quickShareText(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickShareButton(
                      icon: Icons.copy,
                      label: 'Copier',
                      onTap: () => _quickCopyToClipboard(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Bouton de partage rapide
  Widget _buildQuickShareButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Partage rapide du texte
  Future<void> _quickShareText() async {
    try {
      await WeatherShareService.shareWeatherData(
        widget.weatherData,
        includeAdvice: true,
        includeEmojis: true,
      );
      _showSuccessMessage('Données météo partagées avec succès !');
    } catch (e) {
      _showErrorMessage('Erreur lors du partage');
    }
  }

  /// Copie rapide dans le presse-papiers
  Future<void> _quickCopyToClipboard() async {
    try {
      await WeatherShareService.copyToClipboard(
        widget.weatherData,
        includeEmojis: true,
      );
      _showSuccessMessage('Données copiées dans le presse-papiers !');
    } catch (e) {
      _showErrorMessage('Erreur lors de la copie');
    }
  }

  /// Affichage message de succès
  void _showSuccessMessage(String message) {
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
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Affichage message d'erreur
  void _showErrorMessage(String message) {
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
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Informations soleil avec emojis spéciaux
  Widget _buildEnhancedSunInfo() {
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
                    Text(
                      WeatherEmojis.getSpecialEmoji('sunrise'),
                      style: const TextStyle(fontSize: 30),
                    ),
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
                    Text(
                      WeatherEmojis.getSpecialEmoji('sunset'),
                      style: const TextStyle(fontSize: 30),
                    ),
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

  /// Dernière mise à jour avec emoji
  Widget _buildEnhancedLastUpdate() {
    final updateTime = DateFormat('dd/MM/yyyy à HH:mm').format(widget.weatherData.dateTime);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Text('🔄', style: TextStyle(fontSize: 24)),
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

  /// Conseils météo avec emoji intelligent
  Widget _buildEnhancedWeatherAdvice() {
    final advice = _getEnhancedWeatherAdvice();
    final adviceEmoji = _getIntelligentAdviceEmoji();

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
              Text(adviceEmoji, style: const TextStyle(fontSize: 24)),
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

  /// Gradient intelligent basé sur la catégorie météo
  LinearGradient _getGradientForWeather() {
    final category = WeatherEmojis.getWeatherCategory(widget.weatherData.icon);

    switch (category) {
      case 'sunny':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF87CEEB), Color(0xFF4682B4)],
        );
      case 'cloudy':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF708090), Color(0xFF2F4F4F)],
        );
      case 'rainy':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4682B4), Color(0xFF191970)],
        );
      case 'stormy':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2F4F4F), Color(0xFF000000)],
        );
      case 'snowy':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB0C4DE), Color(0xFF4682B4)],
        );
      case 'foggy':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF778899), Color(0xFF2F4F4F)],
        );
      default:
        return AppTheme.primaryGradient(context);
    }
  }

  /// Emoji intelligent pour les conseils
  String _getIntelligentAdviceEmoji() {
    final icon = widget.weatherData.icon;
    final temp = widget.weatherData.temperature;
    final windSpeed = widget.weatherData.windSpeed;

    // Logique intelligente basée sur plusieurs facteurs
    if (icon.contains('01')) return '😎'; // Soleil
    if (icon.contains('09') || icon.contains('10')) return '☂️'; // Pluie
    if (icon.contains('11')) return '⚠️'; // Orage
    if (icon.contains('13')) return '🧥'; // Neige
    if (temp < 0) return '🥶'; // Très froid
    if (temp > 30) return '🌡️'; // Très chaud
    if (windSpeed > 7) return '🌪️'; // Vent fort
    return '💡'; // Défaut
  }

  /// Conseils météo améliorés
  String _getEnhancedWeatherAdvice() {
    final temp = widget.weatherData.temperature;
    final icon = widget.weatherData.icon;
    final humidity = widget.weatherData.humidity;
    final windSpeed = widget.weatherData.windSpeed;

    // Logique de conseil plus sophistiquée
    if (icon.contains('01')) {
      if (temp > 30) {
        return 'Journée ensoleillée mais très chaude ! Protégez-vous du soleil, buvez beaucoup d\'eau et évitez les heures les plus chaudes.';
      }
      return 'Profitez de cette belle journée ensoleillée ! N\'oubliez pas votre crème solaire et restez hydraté.';
    } else if (icon.contains('09') || icon.contains('10')) {
      if (windSpeed > 5) {
        return 'Pluie avec du vent ! Emportez un parapluie solide et attention aux rafales. Évitez les grands espaces ouverts.';
      }
      return 'Emportez un parapluie et portez des vêtements imperméables. Évitez les activités extérieures prolongées.';
    } else if (icon.contains('11')) {
      return 'Orages prévus ! Restez à l\'intérieur, évitez les activités en extérieur et débranchez vos appareils électriques.';
    } else if (icon.contains('13')) {
      return 'Chutes de neige ! Portez des vêtements chauds, attention aux routes glissantes et prévoyez plus de temps pour vos déplacements.';
    } else if (temp < 0) {
      return 'Températures glaciales ! Couvrez-vous bien, limitez le temps dehors et attention aux engelures.';
    } else if (temp > 35) {
      return 'Canicule ! Restez hydraté, cherchez l\'ombre, évitez les efforts intenses et surveillez les personnes vulnérables.';
    } else if (humidity > 80 && temp > 25) {
      return 'Temps lourd et humide ! Privilégiez les vêtements légers et respirants, restez hydraté.';
    } else {
      return 'Conditions météorologiques agréables. Profitez de votre journée !';
    }
  }
}