import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/app_theme.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
          const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo principal
              _buildLogo(),

              const SizedBox(height: 40),

              // Nom de l'app
              _buildAppName(),

              const SizedBox(height: 60),

              // Indicateur de chargement
              _buildLoadingIndicator(),

              const SizedBox(height: 20),

              // Texte de chargement
              _buildLoadingText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(75),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          '🌤️',
          style: TextStyle(fontSize: 80),
        ),
      ),
    ).animate()
        .scale(delay: const Duration(milliseconds: 200))
        .then()
        .shimmer(duration: const Duration(seconds: 2));
  }

  Widget _buildAppName() {
    return Column(
      children: [
        Text(
          'WeatherPro',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 3,
          ),
        ).animate().fadeIn(delay: const Duration(milliseconds: 500))
            .slideY(begin: 0.3),

        const SizedBox(height: 12),

        Text(
          'Votre météo personnalisée',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w300,
          ),
        ).animate().fadeIn(delay: const Duration(milliseconds: 700)),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 3,
        backgroundColor: Colors.white.withOpacity(0.2),
      ),
    ).animate(onPlay: (controller) => controller.repeat())
        .rotate(duration: const Duration(seconds: 2));
  }

  Widget _buildLoadingText() {
    return Text(
      'Chargement...',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Colors.white.withOpacity(0.8),
        fontSize: 16,
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 1000))
        .then(delay: const Duration(milliseconds: 500))
        .fadeOut(duration: const Duration(milliseconds: 500))
        .then()
        .fadeIn(duration: const Duration(milliseconds: 500));
  }
}