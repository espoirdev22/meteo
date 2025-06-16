import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/app_theme.dart';

class FeatureIndicators extends StatelessWidget {
  const FeatureIndicators({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),

        Text(
          'Fonctionnalités',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,color: Colors.white
          ),
        ),

        const SizedBox(height: 30),

        _buildFeatureItem(
          imagePath: 'assets/images/weather/earth.png',
          title: 'Météo Mondiale',
          description: 'Accédez à la météo de toutes les villes du monde',
          delay: 0,
        ),

        _buildFeatureItem(
          imagePath: 'assets/images/weather/pin.png',
          title: 'Localisation GPS',
          description: 'Météo automatique basée sur votre position',
          delay: 200,
        ),

        _buildFeatureItem(
          imagePath: 'assets/images/weather/bar-chart.png',
          title: 'Temps Réel',
          description: 'Données météo mises à jour en continu',
          delay: 400,
        ),

        _buildFeatureItem(
          imagePath: 'assets/images/weather/flash.png',
          title: 'Détails Complets',
          description: 'Humidité, pression, vent et plus encore',
          delay: 600,
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required String imagePath,
    required String title,
    required String description,
    required int delay,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 30,
                height: 30,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Flèche
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white60,
            size: 16,
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideX(
      begin: 0.3,
      duration: const Duration(milliseconds: 600),
    );
  }
}
