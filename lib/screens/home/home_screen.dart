import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../progress/progress_screen.dart';
import 'widgets/feature_indicators.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient(context), // Remove const and call the method
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Logo animé
                _buildAnimatedLogo(),

                const SizedBox(height: 40),

                // Titre principal
                _buildWelcomeText(),

                const SizedBox(height: 50),

                // Bouton principal
                _buildMainButton(),

                // Indicateurs de fonctionnalités
                const FeatureIndicators(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(60),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: const Center(
        child: Text(
          '☀️',
          style: TextStyle(fontSize: 60),
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: const Duration(seconds: 2))
        .then()
        .shake(hz: 0.5, curve: Curves.easeInOut);
  }

  Widget _buildWelcomeText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Text(
            'Bienvenue dans',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color: Colors.white
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 300)),

          const SizedBox(height: 8),

          Text(
            'WeatherPro',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 500))
              .slideY(begin: 0.3, duration: const Duration(milliseconds: 600)),

          const SizedBox(height: 20),

          Text(
            'Découvrez la météo mondiale en temps réel\nUne expérience météo unique vous attend',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                height: 1.5,
                color: Colors.white
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 700)),
        ],
      ),
    );
  }

  Widget _buildMainButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: AppTheme.buttonGradient(context),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isLoading ? null : _startWeatherDiscovery,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              alignment: Alignment.center,
              child: _isLoading
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.explore,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'DÉCOUVRIR LA MÉTÉO',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 900))
        .slideY(begin: 0.3, duration: const Duration(milliseconds: 600));
  }

  void _startWeatherDiscovery() async {
    setState(() {
      _isLoading = true;
    });

    // Délai pour l'animation
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
          const ProgressScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }
}