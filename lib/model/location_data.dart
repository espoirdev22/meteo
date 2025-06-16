
class LocationData {
  final double latitude;
  final double longitude;
  final String? cityName;
  final String? country;
  final String? address;

  LocationData({
    required this.latitude,
    required this.longitude,
    this.cityName,
    this.country,
    this.address,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      cityName: json['cityName'],
      country: json['country'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'cityName': cityName,
      'country': country,
      'address': address,
    };
  }

  String get displayName {
    if (cityName != null && country != null) {
      return '$cityName, $country';
    } else if (cityName != null) {
      return cityName!;
    } else if (address != null) {
      return address!;
    } else {
      return 'Localisation inconnue';
    }
  }
}
