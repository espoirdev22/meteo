import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/location_data.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  /// Vérifie et demande les permissions de localisation
  Future<bool> checkAndRequestPermission() async {
    try {
      final permission = await Permission.location.status;

      if (permission.isDenied) {
        final result = await Permission.location.request();
        return result.isGranted;
      }

      return permission.isGranted;
    } catch (e) {
      print('Erreur lors de la vérification des permissions: $e');
      return false;
    }
  }

  /// Obtient la position actuelle
  Future<LocationData> getCurrentLocation() async {
    try {
      // Vérifier les permissions
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) {
        throw Exception('Permission de localisation refusée');
      }

      // Vérifier si le service de localisation est activé
      final isEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isEnabled) {
        throw Exception('Service de localisation désactivé');
      }

      // Obtenir la position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Géocodage inverse pour obtenir l'adresse
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          return LocationData(
            latitude: position.latitude,
            longitude: position.longitude,
            cityName: place.locality,
            country: place.country,
            address: '${place.locality}, ${place.country}',
          );
        }
      } catch (e) {
        print('Erreur lors du géocodage: $e');
      }

      // Retourner seulement les coordonnées si le géocodage échoue
      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      throw Exception('Impossible d\'obtenir la localisation: $e');
    }
  }

  /// Obtient l'adresse à partir des coordonnées
  Future<String?> getAddressFromCoordinates(double lat, double lon) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.locality}, ${place.country}';
      }
    } catch (e) {
      print('Erreur lors du géocodage: $e');
    }
    return null;
  }
}