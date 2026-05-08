import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  final List<Map<String, dynamic>> _cinemas = [
    {
      'name': 'Cineplex Odeon Cambridge',
      'lat': 43.3616,
      'lng': -80.3144,
      'address': '350 Hespeler Rd, Cambridge, ON',
    },
    {
      'name': 'Galaxy Cinemas Cambridge',
      'lat': 43.3753,
      'lng': -80.3267,
      'address': '175 Holiday Inn Dr, Cambridge, ON',
    },
    {
      'name': 'Empire Theatres Guelph',
      'lat': 43.5448,
      'lng': -80.2482,
      'address': 'Stone Road Mall, Guelph, ON',
    },
  ];

  Set<Marker> _buildMarkers() {
    return _cinemas.map((cinema) {
      return Marker(
        markerId: MarkerId(cinema['name']),
        position: LatLng(cinema['lat'], cinema['lng']),
        infoWindow: InfoWindow(
          title: cinema['name'],
          snippet: cinema['address'],
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5BB8A0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D8B7A),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 36),
            const SizedBox(width: 8),
            const Text(
              'Nearby Cinemas',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Map
          Expanded(
            flex: 3,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(43.3616, -80.3144),
                zoom: 11,
              ),
              markers: _buildMarkers(),
              mapType: MapType.normal,
              onMapCreated: (controller) =>
                  setState(() => _mapController = controller),
            ),
          ),

          // Cinema list
          Expanded(
            flex: 2,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _cinemas.length,
              itemBuilder: (context, index) {
                final cinema = _cinemas[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D8B7A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.location_on, color: Colors.white),
                    ),
                    title: Text(
                      cinema['name'],
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      cinema['address'],
                      style: const TextStyle(color: Colors.white70),
                    ),
                    onTap: () {
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(
                          LatLng(cinema['lat'], cinema['lng']),
                          15,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
