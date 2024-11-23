import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pawesomeid_mobile/services/api_service.dart';
import 'issuer_verification_screen.dart';


class NearbyTTPView extends StatefulWidget {
  const NearbyTTPView({super.key});

  @override
  State<NearbyTTPView> createState() => _NearbyTTPViewState();
}

class _NearbyTTPViewState extends State<NearbyTTPView> {
  Position? _currentPosition;
  bool _isLoading = true;
  GoogleMapController? _mapController;

  // TTP simulated with real coordinates
  final List<Map<String, dynamic>> _nearbyTTPs = [
    {
      'name': 'ZooParc de Beauval',
      'type': 'Zoo & Research Center',
      'distance': '2.5 km',
      'lat': 47.2480, // Real coordinates of Beauval
      'lng': 1.3539,
      'color': Colors.green,
      'icon': Icons.pets,
    },
    {
      'name': 'Monkey Valley',
      'type': 'Primate Sanctuary',
      'distance': '3.8 km',
      'lat': 46.3169, // Real coordinates of Monkey Valley
      'lng': 0.3034,
      'color': Colors.brown,
      'icon': Icons.nature_people,
    },
    {
      'name': 'Tete d\'Or Zoo',
      'type': 'Zoo & Sanctuary',
      'distance': '5.2 km',
      'lat': 45.7766, // Real coordinates of Tete d'Or Zoo
      'lng': 4.8525,
      'color': Colors.blue,
      'icon': Icons.park,
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    setState(() => _isLoading = true);

    // Vérifier si les services de localisation sont activés
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    debugPrint('Location services enabled: $serviceEnabled');

    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      return _showError('Location services are disabled.');
    }

    // Vérifier les permissions
    permission = await Geolocator.checkPermission();
    debugPrint('Current permission status: $permission');

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoading = false);
        return _showError('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLoading = false);
      return _showError('Location permissions are permanently denied');
    }

    // Obtenir la position
    try {
      debugPrint('Attempting to get position...');
      final position = await Geolocator.getCurrentPosition();
      debugPrint(
          'Position obtained: ${position.latitude}, ${position.longitude}');
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error getting location: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        'Building NearbyTTPView. Loading: $_isLoading, Position: $_currentPosition');

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_currentPosition == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Unable to get location'),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Carte
        SizedBox(
          height: 300,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
              ),
              zoom: 14,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: {
              // Marqueur pour la position actuelle
              Marker(
                markerId: const MarkerId('currentLocation'),
                position: LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                ),
                infoWindow: const InfoWindow(title: 'You are here'),
              ),
              // Marqueurs pour les TTPs
              ..._nearbyTTPs.map((ttp) => Marker(
                    markerId: MarkerId(ttp['name']),
                    position: LatLng(ttp['lat'], ttp['lng']),
                    infoWindow: InfoWindow(title: ttp['name']),
                  )),
            },
          ),
        ),
        // Liste des TTPs proches
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _nearbyTTPs.length,
            itemBuilder: (context, index) {
              final ttp = _nearbyTTPs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: ttp['color'].withOpacity(0.2),
                    child: Icon(ttp['icon'], color: ttp['color']),
                  ),
                  title: Text(
                    ttp['name'],
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(ttp['type']),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ttp['distance'],
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {
                    // Centrer la carte sur ce TTP
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLng(
                        LatLng(ttp['lat'], ttp['lng']),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TTPScreen extends StatelessWidget {
  final ApiService apiService;

   const TTPScreen({
    super.key,
    required this.apiService // Rendu requis
  });

  final List<Map<String, dynamic>> _ttps = const [
    {
      'name': 'ZooParc de Beauval',
      'type': 'Zoo & Research Center',
      'rating': 4.9,
      'verified': true,
      'description': 'France\'s leading zoo, globally recognized for its conservation and breeding programs for endangered species, especially great apes.',
      'services': [
        'Primate Health Records',
        'Conservation Status',
        'Research Data',
        'Birth Certificates'
      ],
      'location': 'Saint-Aignan, France',
      'icon': Icons.pets,
      'color': Colors.green,
    },
    {
      'name': 'Monkey Valley',
      'type': 'Primate Sanctuary',
      'rating': 4.8,
      'verified': true,
      'description': 'France\'s largest primate sanctuary, specializing in conservation and study of semi-free great apes',
      'services': [
        'Primate ID Verification',
        'Health Monitoring',
        'Behavioral Studies',
        'Species Conservation'
      ],
      'location': 'Romagne, France',
      'icon': Icons.nature_people,
      'color': Colors.brown,
    },
    {
      'name': 'Tete d\'Or Zoo',
      'type': 'Zoo & Sanctuary',
      'rating': 4.7,
      'verified': true,
      'description': 'One of France\'s oldest zoos, committed to primate protection and welfare',
      'services': [
        'Animal Healthcare',
        'Species Registry',
        'Medical Records',
        'Conservation Status'
      ],
      'location': 'Lyon, France',
      'icon': Icons.park,
      'color': Colors.blue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Trusted Partners'),
           actions: [
          Row(
            children: [
              const Text(
                "Issuer Simulator",
                style: TextStyle(color: Colors.purple), // Texte en couleur violette
              ),
              IconButton(
                icon: const Icon(Icons.qr_code_scanner, color: Colors.purple), // Icône en couleur violette
                onPressed: () => _showIssuerScanner(context),
                tooltip: 'Simulate Issuer',
              ),
            ],
          ),
        ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Nearby'),
              Tab(text: 'Favorites'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTTPList(context),
            const NearbyTTPView(),
            const Center(child: Text('Favorites Coming Soon')),
          ],
        ),
      ),
    );
  }

  void _showIssuerScanner(BuildContext context) {
    // Remplacer l'ancienne implémentation par celle-ci
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IssuerVerificationScreen(
          apiService: apiService,
        ),
      ),
    );
  }


  Widget _buildTTPList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _ttps.length,
      itemBuilder: (context, index) {
        final ttp = _ttps[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () => _showTTPDetails(context, ttp),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: ttp['color'].withOpacity(0.2),
                    child: Icon(ttp['icon'], color: ttp['color']),
                  ),
                  title: Row(
                    mainAxisSize:
                        MainAxisSize.min, // Ajouté pour minimiser l'espace
                    children: [
                      Flexible(
                        // Ajouté pour permettre le wrapping du texte
                        child: Text(
                          ttp['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow
                              .ellipsis, // Ajouté pour gérer le texte trop long
                        ),
                      ),
                      if (ttp['verified'])
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(Icons.verified,
                              color: Colors.blue, size: 20),
                        ),
                    ],
                  ),
                  subtitle: Text(
                    ttp['type'],
                    overflow: TextOverflow.ellipsis, // Ajouté ici aussi
                  ),
                  trailing: Container(
                    constraints: const BoxConstraints(
                        maxWidth: 80), // Ajouté pour limiter la largeur
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          ttp['rating'].toString(),
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ttp['description'],
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final service in ttp['services'])
                            Chip(
                              label: Text(
                                service,
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: ttp['color'].withOpacity(0.1),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTTPDetails(BuildContext context, Map<String, dynamic> ttp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: ttp['color'].withOpacity(0.2),
                    child: Icon(ttp['icon'], color: ttp['color'], size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ttp['name'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ttp['location'],
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailSection('Description', ttp['description']),
              _buildDetailSection('Services Provided', ''),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final service in ttp['services'])
                    Chip(
                      label: Text(service),
                      backgroundColor: ttp['color'].withOpacity(0.1),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              _buildRatingSection(ttp['rating']),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Action pour demander un credential
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Request Credential'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildRatingSection(double rating) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 24,
          );
        }),
        const SizedBox(width: 8),
        Text(
          rating.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }


}


