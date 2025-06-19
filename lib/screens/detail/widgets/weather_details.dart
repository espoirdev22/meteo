import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../model/weather_data.dart';

class WeatherDetails extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherDetails({
    Key? key,
    required this.weatherData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Détails',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Grille des détails
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildDetailCard(
                icon: Icons.water_drop,
                title: 'Humidité',
                value: '${weatherData.humidity}%',
                color: Colors.blue,
              ).animate(delay: 100.ms)
                  .fadeIn(duration: 600.ms)
                  .scaleXY(begin: 0.8, duration: 600.ms),

              _buildDetailCard(
                icon: Icons.air,
                title: 'Vent',
                value: weatherData.windSpeedString,
                color: Colors.green,
              ).animate(delay: 200.ms)
                  .fadeIn(duration: 600.ms)
                  .scaleXY(begin: 0.8, duration: 600.ms),

              _buildDetailCard(
                icon: Icons.speed,
                title: 'Pression',
                value: weatherData.pressureString,
                color: Colors.orange,
              ).animate(delay: 300.ms)
                  .fadeIn(duration: 600.ms)
                  .scaleXY(begin: 0.8, duration: 600.ms),

              _buildDetailCard(
                icon: Icons.visibility,
                title: 'Visibilité',
                value: weatherData.visibilityString,
                color: Colors.purple,
              ).animate(delay: 400.ms)
                  .fadeIn(duration: 600.ms)
                  .scaleXY(begin: 0.8, duration: 600.ms),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(
        minHeight: 50, // Hauteur minimale pour toutes les cartes
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Important pour éviter les débordements
        children: [
          // Icône
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),

          const SizedBox(height: 4), // Réduit l'espacement

          // Titre
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1, // Empêche le texte de prendre plusieurs lignes
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Valeur
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16, // Taille de police légèrement réduite
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}