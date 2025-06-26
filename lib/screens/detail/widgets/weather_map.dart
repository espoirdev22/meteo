import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../model/weather_data.dart';

class WeatherMap extends StatefulWidget {
  final WeatherData weatherData;

  const WeatherMap({
    Key? key,
    required this.weatherData,
  }) : super(key: key);

  @override
  State<WeatherMap> createState() => _WeatherMapState();
}

class _WeatherMapState extends State<WeatherMap> {
  late GoogleMapController mapController;
  LatLng? weatherLocation; // Position de la météo
  LatLng? currentPosition; // Position actuelle de l'utilisateur
  bool isLoading = true;
  bool showCurrentLocation = false; // Pour afficher la position actuelle optionnellement

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    // Utiliser les coordonnées de la météo en priorité
    if (widget.weatherData.latitude != null && widget.weatherData.longitude != null) {
      weatherLocation = LatLng(
        widget.weatherData.latitude!,
        widget.weatherData.longitude!,
      );
    }

    // Optionnellement, obtenir la position actuelle pour comparaison
    await _getCurrentLocation();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      // Gérer l'erreur silencieusement
      print('Erreur lors de l\'obtention de la position: $e');
    }
  }

  Set<Marker> _buildMarkers() {
    Set<Marker> markers = {};

    // Marqueur pour la localisation météo (prioritaire)
    if (weatherLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('weatherLocation'),
          position: weatherLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: widget.weatherData.displayName,
            snippet: '${widget.weatherData.temperatureString} • ${widget.weatherData.description}',
          ),
        ),
      );
    }

    // Marqueur pour la position actuelle (optionnel)
    if (showCurrentLocation && currentPosition != null && weatherLocation != null) {
      // Vérifier si les positions sont différentes (distance > 1km)
      double distance = Geolocator.distanceBetween(
        currentPosition!.latitude,
        currentPosition!.longitude,
        weatherLocation!.latitude,
        weatherLocation!.longitude,
      );

      if (distance > 1000) { // Plus de 1km de différence
        markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: currentPosition!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: const InfoWindow(
              title: 'Ma position',
              snippet: 'Position actuelle',
            ),
          ),
        );
      }
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Localisation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Bouton pour toggle la position actuelle
              if (currentPosition != null)
                IconButton(
                  onPressed: () {
                    setState(() {
                      showCurrentLocation = !showCurrentLocation;
                    });
                  },
                  icon: Icon(
                    showCurrentLocation ? Icons.my_location : Icons.my_location_outlined,
                    color: Colors.white70,
                    size: 20,
                  ),
                  tooltip: showCurrentLocation ? 'Masquer ma position' : 'Afficher ma position',
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Carte Google Maps
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: isLoading || weatherLocation == null
                ? const Center(child: CircularProgressIndicator())
                : ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GoogleMap(
                onMapCreated: (controller) {
                  setState(() {
                    mapController = controller;
                  });
                },
                initialCameraPosition: CameraPosition(
                  target: weatherLocation!, // Utiliser la position météo
                  zoom: 12,
                ),
                markers: _buildMarkers(),
                mapType: MapType.normal,
                myLocationEnabled: false, // Désactivé car on gère manuellement
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              ),
            ),
          ),

          // Infos météo
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.weatherData.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.weatherData.temperatureString} • ${widget.weatherData.description}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        // Afficher les coordonnées pour debug (optionnel)
                        if (weatherLocation != null)
                          Text(
                            'Lat: ${weatherLocation!.latitude.toStringAsFixed(4)}, Lng: ${weatherLocation!.longitude.toStringAsFixed(4)}',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}