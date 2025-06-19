import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../config/app_theme.dart';
import '../../config/api_config.dart';
import '../../model/weather_data.dart';
import '../../services/weather_service.dart';
import '../detail/detail_screen.dart';
import '../home/home_screen.dart';
import 'widgets/circular_progress.dart';
import 'widgets/weather_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  double _progress = 0.0;
  String _currentMessage = '';
  List<WeatherData> _weatherData = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  final List<String> _loadingMessages = [
    'Connexion aux serveurs météo...',
    'Récupération des données...',
    'Traitement des informations...',
    'Presque terminé...',
    'Finalisation...',
  ];

  final WeatherService _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    _startWeatherLoading();
  }

  Future<void> _startWeatherLoading() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _progress = 0.0;
        _currentMessage = _loadingMessages[0];
      });

      await _loadWeatherData();
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadWeatherData() async {
    final cities = ApiConfig.DEFAULT_CITIES;
    final weatherList = <WeatherData>[];

    for (int i = 0; i < cities.length; i++) {
      try {
        // Mise à jour du message et de la progression
        final messageIndex = (i * _loadingMessages.length) ~/ cities.length;
        setState(() {
          _currentMessage = _loadingMessages[messageIndex.clamp(0, _loadingMessages.length - 1)];
          _progress = (i + 1) / cities.length;
        });

        // Simulation d'un délai réaliste
        await Future.delayed(const Duration(milliseconds: 800));

        // Récupération des données météo
        final weatherData = await _weatherService.getWeatherByCity(cities[i]);
        weatherList.add(weatherData);
      } catch (e) {
        print('Erreur pour la ville ${cities[i]}: $e');
        // Continue avec les autres villes
      }
    }

    // Finalisation
    setState(() {
      _weatherData = weatherList;
      _isLoading = false;
      _currentMessage = 'Données récupérées avec succès !';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // En-tête avec bouton retour
              _buildHeader(),

              // Contenu principal
              Expanded(
                child: _hasError ? _buildErrorContent() : _buildMainContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              'Météo Mondiale',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Espace pour équilibrer le bouton retour
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return _buildLoadingContent();
    } else {
      return _buildWeatherResults();
    }
  }

  Widget _buildLoadingContent() {
    return Column(
      children: [
        const SizedBox(height: 60),

        // Indicateur de progression circulaire
        CircularProgress(
          progress: _progress,
          size: 200,
          strokeWidth: 8,
          progressColor: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(_progress * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Chargement...',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // Message de chargement
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            _currentMessage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ).animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: const Duration(seconds: 2)),
        ),

        const SizedBox(height: 60),

        // Cartes skeleton
        Expanded(
          child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return WeatherCardSkeleton(
                animationDelay: index * 200,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherResults() {
    return Column(
      children: [
        const SizedBox(height: 20),

        // Message de succès
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            '${_weatherData.length} villes trouvées',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
        ),

        const SizedBox(height: 20),

        // Liste des cartes météo
        Expanded(
          child: ListView.builder(
            itemCount: _weatherData.length,
            itemBuilder: (context, index) {
              return WeatherCard(
                weatherData: _weatherData[index],
                animationDelay: index * 150,
                onTap: () => _navigateToDetails(_weatherData[index]),
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        // Bouton pour actualiser
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _startWeatherLoading,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white24, Colors.white12],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ACTUALISER',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: const Duration(milliseconds: 600)),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildErrorContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icône d'erreur
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.red.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 50,
            ),
          ),
        ).animate().fadeIn().shake(),

        const SizedBox(height: 30),

        // Titre d'erreur
        Text(
          'Erreur de connexion',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: const Duration(milliseconds: 200)),

        const SizedBox(height: 16),

        // Message d'erreur
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Impossible de récupérer les données météo.\nVérifiez votre connexion internet.',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: const Duration(milliseconds: 400)),
        ),

        const SizedBox(height: 40),

        // Bouton de nouvelle tentative
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _startWeatherLoading,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Ink(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.redAccent],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.reply,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'RÉESSAYER',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: const Duration(milliseconds: 600)),
      ],
    );
  }

  void _navigateToDetails(WeatherData weatherData) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DetailScreen(weatherData: weatherData),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}