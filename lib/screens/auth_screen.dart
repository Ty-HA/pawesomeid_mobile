// auth_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pawesomeid_mobile/services/api_service.dart';
import 'verification_screen.dart';
import 'home_screen.dart';

class AuthScreen extends StatelessWidget {
  final ApiService apiService;

  const AuthScreen({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E), // Bleu marine
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Changé en blanc
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () => _handlePeraWalletLogin(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFecaa00), // Jaune assorti
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4, // Ajout d'une ombre
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login as a keeper',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E), // Bleu marine
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => _navigateToRegistration(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                ),
                child: RichText(
                  text: const TextSpan(
                    text: 'New to PawesomeID? ',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: 'Register here',
                        style: TextStyle(
                          color: Color(0xFFecaa00), // Jaune assorti
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePeraWalletLogin(BuildContext context) async {
    try {
      // Debug message
      debugPrint('Attempting to connect to Pera Wallet...');

      // Simulate connection delay
      await Future.delayed(const Duration(seconds: 2));

      if (context.mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text('Successfully connected to PawesomeID!'),
              ],
            ),
            backgroundColor: const Color(0xFF4CAF50), // Vert plus doux
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Navigate to HomeScreen after brief delay to show the success message
        await Future.delayed(const Duration(seconds: 1));

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                apiService: apiService,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 10),
                Text('Login failed: ${e.toString()}'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _navigateToRegistration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationScreen(apiService: apiService),
      ),
    );
  }
}
