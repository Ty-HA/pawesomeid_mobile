import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'verification_screen.dart';
import 'credentials_screen.dart';
import 'profile_screen.dart';
import 'ttp_screen.dart';
import 'sanctuary_details_screen.dart';
import 'register_screen.dart';
import 'package:pawesomeid_mobile/services/identity_service.dart';
import 'package:pawesomeid_mobile/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  final ApiService apiService;

  const HomeScreen({
    super.key,
    required this.apiService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final String _didAddress =
      'did:algo:J4PCC5KTBIEREW7EVNU6I6FQMRQFM7B57G624ETVT2LXD3RRZFQEVK53HQ';
  final double _identityScore = 75.0;
  final List<Map<String, dynamic>> _credentials = [
    {
      'title': 'Primate Caretaker',
      'issuer': 'Primate Protection Center',
      'date': '2021-09-01',
      'verified': true,
    },
    {
      'title': 'Primate Caretaker',
      'issuer': 'Primate Protection Center',
      'date': '2021-09-01',
      'verified': true,
    },
    {
      'title': 'Primate Caretaker',
      'issuer': 'Primate Protection Center',
      'date': '2021-09-01',
      'verified': true,
    },
  ];
  

  // À ajouter dans la classe _HomeScreenState

  final String _sanctuaryName = 'Tchimpounga sanctuary';
  final String _sanctuaryLocation = 'Kouilou, Congo-Brazzaville';
  final String _keeperName = 'Chimp Guardian John';
  final String _keeperRole = 'Senior Primate Caretaker';
  final String _keeperDid = 'did:algo:J4PCC5KTBIEREW7EVNU6I6FQMRQFM7B57G624ETVT2LXD3RRZFQEVK53HQ';

  Widget _buildSanctuaryInfo() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SanctuaryDetailsScreen(
              sanctuaryName: _sanctuaryName,
              location: _sanctuaryLocation,
            ),
          ),
        );
      },
      child: Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF1A237E).withOpacity(0.1),
                  child: const Icon(Icons.park, size: 30, color: Color(0xFF1A237E)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _sanctuaryName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _sanctuaryLocation,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              height: 32,
              color: const Color(0xFF1A237E).withOpacity(0.2),
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFFecaa00).withOpacity(0.2),
                  child: const Icon(Icons.person, size: 25, color: Color(0xFFecaa00)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _keeperName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _keeperRole,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF1A237E).withOpacity(0.7),
                        ),
                      ),
                      Text(
                        _keeperDid,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF1A237E).withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  Widget _getScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildMainContent();
      case 1:
        return CredentialsScreen(apiService: widget.apiService);
      case 2:
        return TTPScreen(apiService: widget.apiService);
      case 3:
        return VerificationScreen(
            apiService: widget.apiService); // Changé de WalletScreen
      default:
        return _buildMainContent();
    }
  }

// Modification de _buildMainContent
  Widget _buildMainContent() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSanctuaryInfo(),
            const SizedBox(height: 24),
            _buildScanButton(), // Nouveau widget ajouté
            const SizedBox(height: 24),
            // _buildIdentityCard(),
            const SizedBox(height: 16),

            _buildInfoCards(),
            const SizedBox(height: 24),
            _buildDidInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildScanButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationScreen(
                  apiService: widget.apiService,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 31, 112, 218),
            foregroundColor: Colors.white,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.pets, size: 24),
              const SizedBox(height: 4),
              Text(
                'Scan Pet',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton(
          onPressed: _navigateToRegister,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFecaa00),
            foregroundColor: Colors.white,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline, size: 24),
              const SizedBox(height: 4),
              Text(
                'New Pet',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

  Widget _buildIdentityCard() {
    return Center(
        child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'Keeper John',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                _didAddress,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // _buildIdentityScore(),
          ],
        ),
      ),
    ));
  }

  Widget _buildIdentityScore() {
    return Column(
      children: [
        const Text(
          'Identity Score',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                value: 0.25, // Changed to 25%
                backgroundColor: Colors.grey[300],
                strokeWidth: 10,
                color: Colors.orange, // Changed color to reflect lower score
              ),
            ),
            const Text(
              '25%', // Changed to 25%
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Keeper Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildInfoCard(
              title: 'KYC Status',
              value: 'Initial',
              icon: Icons.verified_user,
              color: const Color(0xFFecaa00),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CredentialsScreen(
                      apiService: widget.apiService,
                    ),
                  ),
                );
              },
              child: _buildInfoCard(
                title: 'Credentials',
                value: '1 Verified',
                icon: Icons.badge,
                color: const Color(0xFF1A237E),
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDidInfoSection() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFFecaa00)), // Jaune pour l'icône
                SizedBox(width: 8),
                Text(
                  'About Your DID',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E), // Bleu marine
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              title: 'Identity Status',
              content: 'Basic DID created. KYC verification needed to access full features.',
            ),
            _buildInfoRow(
              title: 'Available Actions',
              content: 'Complete KYC verification to increase your trust score and access more features.',
            ),
            _buildInfoRow(
              title: 'Benefits',
              content: 'After verification: Create and manage verifiable credentials, participate in the trusted network.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF1A237E).withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _startVerification(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            icon: const Icon(Icons.verified_user),
            label: const Text('Verify Identity'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _viewAllCredentials(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            icon: const Icon(Icons.badge),
            label: const Text('Credentials'),
          ),
        ),
      ],
    );
  }

  Widget _buildCredentialsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Credentials',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _credentials.length,
          itemBuilder: (context, index) {
            final credential = _credentials[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      credential['verified'] ? Colors.green : Colors.orange,
                  child: Icon(
                    credential['verified'] ? Icons.verified : Icons.pending,
                    color: Colors.white,
                  ),
                ),
                title: Text(credential['title']),
                subtitle: Text(
                  'Issued by: ${credential['issuer']}\n${credential['date']}',
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFecaa00),
                    size: 20,
                  ),
                  onPressed: () => _viewCredentialDetails(credential),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _showQRCode() async {
    try {
      // Créer un mock des données DID pour le QR code
      final mockProfileData = {
        'did': _didAddress,
        'didDocument': {
          '@context': ['https://www.w3.org/ns/did/v1'],
          'id': _didAddress,
          'verificationMethod': [
            {
              'id': '$_didAddress#key-1',
              'type': 'Ed25519VerificationKey2018',
              'controller': _didAddress,
              'publicKeyBase58': _didAddress.replaceAll('did:algo:', '')
            }
          ],
          'authentication': ['$_didAddress#key-1']
        },
        'transaction_id':
            'DJ7PFIKRVZSZQYGAEDIORY2M4DLE3O7JHBWYT4SPM7QO445BTSPQ',
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Convertir en JSON string
      final qrData = json.encode(mockProfileData);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Your DID QR Code',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 280,
                    backgroundColor: Colors.white,
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Scan this code to verify your identity',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'DID: $_didAddress',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Copy Data'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: qrData));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('QR data copied to clipboard'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.close),
              label: const Text('Close'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }


void _navigateToRegister() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RegisterScreen(
        identityService: IdentityService(baseUrl: 'http://192.168.1.86:3000/api'),
        apiService: widget.apiService,
      ),
    ),
  );

  if (result != null && mounted) {
    // Afficher une notification de succès
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Pet registered successfully!'),
                  Text('DID: ${result['did']}',
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.white,
          onPressed: () {
            // Naviguer vers les détails si nécessaire
          },
        ),
      ),
    );

    // Rafraîchir l'interface
    setState(() {
      // Mettre à jour votre liste d'identités ou l'état si nécessaire
    });
  }
}

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfileScreen(apiService: widget.apiService)),
    );
  }

  void _startVerification() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationScreen(
          apiService: widget.apiService,
        ),
      ),
    );
  }

  void _viewAllCredentials() {
    setState(() => _selectedIndex = 1); // Switch to Credentials tab
  }

  void _viewCredentialDetails(Map<String, dynamic> credential) {
    debugPrint('Viewing credential details: ${credential['title']}');
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF5F6F9),
    appBar: AppBar(
      backgroundColor: const Color(0xFF1A237E), // Bleu marine
      title: Image.asset(
        'assets/images/logo.png',
        height: 32.0,
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFFecaa00), // Jaune pour les icônes
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.qr_code,
            color: Color(0xFFecaa00), // Jaune
          ),
          onPressed: () => _showQRCode(),
        ),
        IconButton(
          icon: const Icon(
            Icons.person,
            color: Color(0xFFecaa00), // Jaune
          ),
          onPressed: () => _navigateToProfile(),
        ),
      ],
      elevation: 0, // Enlever l'ombre pour un look plus moderne
    ),
    body: _getScreen(),
    
    bottomNavigationBar: Theme(
      data: Theme.of(context).copyWith(
        canvasColor: const Color(0xFF1A237E), // Bleu marine
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationScreen(
                  apiService: widget.apiService,
                ),
              ),
            );
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A237E), // Bleu marine
        selectedItemColor: const Color(0xFFecaa00), // Jaune pour l'icône active
        unselectedItemColor: Colors.white, // Blanc pour les icônes inactives
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.badge),
            label: 'Credentials',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            label: 'TTPs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Scan',
          ),
        ],
      ),
    ),
  );
}
}
