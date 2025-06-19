import 'dart:math';

import 'package:flutter/material.dart';

class LocationData {
  final double latitude;
  final double longitude;
  final String? cityName;
  final String? country;
  final String? address;
  final String? region; // État/région/province
  final String? postalCode;
  final DateTime? timestamp; // Quand la localisation a été obtenue
  final double? accuracy; // Précision en mètres
  final double? altitude; // Altitude en mètres
  final String? source; // GPS, Network, Passive, etc.

  LocationData({
    required this.latitude,
    required this.longitude,
    this.cityName,
    this.country,
    this.address,
    this.region,
    this.postalCode,
    this.timestamp,
    this.accuracy,
    this.altitude,
    this.source,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      cityName: json['cityName'],
      country: json['country'],
      address: json['address'],
      region: json['region'],
      postalCode: json['postalCode'],
      timestamp: json['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'])
          : null,
      accuracy: json['accuracy']?.toDouble(),
      altitude: json['altitude']?.toDouble(),
      source: json['source'],
    );
  }

  // Factory pour créer depuis les coordonnées GPS
  factory LocationData.fromCoordinates({
    required double latitude,
    required double longitude,
    double? accuracy,
    double? altitude,
    String? source,
  }) {
    return LocationData(
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      altitude: altitude,
      timestamp: DateTime.now(),
      source: source ?? 'GPS',
    );
  }

  // Factory pour créer depuis l'API de géocodage
  factory LocationData.fromGeocoding({
    required double latitude,
    required double longitude,
    required String cityName,
    required String country,
    String? address,
    String? region,
    String? postalCode,
  }) {
    return LocationData(
      latitude: latitude,
      longitude: longitude,
      cityName: cityName,
      country: country,
      address: address,
      region: region,
      postalCode: postalCode,
      timestamp: DateTime.now(),
      source: 'Geocoding',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'cityName': cityName,
      'country': country,
      'address': address,
      'region': region,
      'postalCode': postalCode,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'accuracy': accuracy,
      'altitude': altitude,
      'source': source,
    };
  }

  String get displayName {
    if (cityName != null && country != null) {
      return region != null ? '$cityName, $region, $country' : '$cityName, $country';
    } else if (cityName != null) {
      return cityName!;
    } else if (address != null) {
      return address!;
    } else {
      return 'Localisation inconnue';
    }
  }

  // Nom court pour l'affichage
  String get shortDisplayName {
    if (cityName != null) {
      return cityName!;
    } else if (address != null) {
      // Extraire le nom de la ville de l'adresse si possible
      final parts = address!.split(',');
      return parts.isNotEmpty ? parts.first.trim() : address!;
    } else {
      return 'Localisation inconnue';
    }
  }

  // Coordonnées formatées
  String get coordinatesString {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  // Précision formatée
  String get accuracyString {
    if (accuracy == null) return 'Précision inconnue';
    if (accuracy! < 10) return 'Très précis (${accuracy!.round()}m)';
    if (accuracy! < 50) return 'Précis (${accuracy!.round()}m)';
    if (accuracy! < 100) return 'Moyennement précis (${accuracy!.round()}m)';
    return 'Peu précis (${accuracy!.round()}m)';
  }

  // Altitude formatée
  String get altitudeString {
    if (altitude == null) return 'Altitude inconnue';
    return '${altitude!.round()}m';
  }

  // Vérifier si la localisation est valide
  bool get isValid {
    return latitude.abs() <= 90 && longitude.abs() <= 180;
  }

  // Vérifier si c'est une localisation récente (moins de 5 minutes)
  bool get isRecent {
    if (timestamp == null) return false;
    return DateTime.now().difference(timestamp!).inMinutes < 5;
  }

  // Calculer la distance avec une autre localisation (en mètres)
  double distanceTo(LocationData other) {
    return _calculateDistance(latitude, longitude, other.latitude, other.longitude);
  }

  // Calculer la distance avec des coordonnées (en mètres)
  double distanceToCoordinates(double lat, double lng) {
    return _calculateDistance(latitude, longitude, lat, lng);
  }

  // Formule de Haversine pour calculer la distance
  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Rayon de la Terre en mètres

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * (sin(dLon / 2) * sin(dLon / 2));

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Créer une copie avec des modifications
  LocationData copyWith({
    double? latitude,
    double? longitude,
    String? cityName,
    String? country,
    String? address,
    String? region,
    String? postalCode,
    DateTime? timestamp,
    double? accuracy,
    double? altitude,
    String? source,
  }) {
    return LocationData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityName: cityName ?? this.cityName,
      country: country ?? this.country,
      address: address ?? this.address,
      region: region ?? this.region,
      postalCode: postalCode ?? this.postalCode,
      timestamp: timestamp ?? this.timestamp,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      source: source ?? this.source,
    );
  }

  @override
  String toString() {
    return 'LocationData(${coordinatesString}, city: ${cityName ?? 'N/A'}, country: ${country ?? 'N/A'})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationData &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.cityName == cityName &&
        other.country == country;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^
    longitude.hashCode ^
    cityName.hashCode ^
    country.hashCode;
  }
}

// Extension pour des méthodes utilitaires supplémentaires
extension LocationDataExtensions on LocationData {
  // Obtenir l'URL Google Maps
  String get googleMapsUrl {
    return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  }

  // Obtenir l'URL Apple Maps
  String get appleMapsUrl {
    return 'http://maps.apple.com/?q=$latitude,$longitude';
  }

  // Vérifier si c'est dans une zone spécifique (rayon en mètres)
  bool isInRadius(LocationData center, double radiusInMeters) {
    return distanceTo(center) <= radiusInMeters;
  }

  // Formater la distance en texte lisible
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()}m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)}km';
    }
  }
}

// Classe pour gérer les erreurs de localisation
class LocationError {
  final String message;
  final LocationErrorType type;
  final DateTime timestamp;

  LocationError({
    required this.message,
    required this.type,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() => 'LocationError: $message';
}

enum LocationErrorType {
  permissionDenied,
  serviceDisabled,
  timeout,
  unknown,
  networkError,
  geocodingFailed,
}

