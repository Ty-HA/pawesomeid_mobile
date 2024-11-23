import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'primate_details_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VerificationScreen extends StatefulWidget {
  final ApiService apiService;

  const VerificationScreen({super.key, required this.apiService});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _faceScanned = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Mock data for testing
  final Map<String, dynamic> _mockPrimateData = {
    'id': 'PRM-2024-001',
    'name': 'Charlie',
    'species': 'Chimpanzee',
    'age': 8,
    'sex': 'Male',
    'arrivalDate': '2020-06-15',
    'origin': 'Rescued from illegal pet trade',
    'imageUrl': 'assets/images/chimpanze.jpg',
    'healthStatus': 'Good',
    'lastCheckup': '2024-03-15',
    'weight': '45.5',
    'medicalNotes': 'Regular check-up completed. All vaccinations up to date.',
    'dietType': 'Standard Primate Diet',
    'dietaryNeeds': 'Extra fruits during training',
    'feedingSchedule': '3 times daily',
    'behaviorNotes': 'Friendly and social. Shows great progress in rehabilitation program.',
    'socialStatus': 'Well integrated with group',
    'enrichmentNeeds': 'Enjoys puzzle feeders and rope swings',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Primate Recognition'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (_imageFile != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _imageFile!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Icon(
                        Icons.pets,
                        size: 60,
                        color: const Color(0xFFecaa00),
                      ),
                    const SizedBox(height: 16),
                    const Text(
                      'Primate Face Recognition',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Point the camera at the primate\'s face to identify them',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _faceScanned ? null : _takePicture,
                      icon: const Icon(Icons.camera_alt),
                      label: Text(_faceScanned ? 'Primate Identified' : 'Take Picture'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _faceScanned ? Colors.green : null,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_faceScanned)
              ElevatedButton(
                onPressed: _viewPrimateDetails,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'View Primate Details',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePicture() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (photo == null) return;

      setState(() {
        _imageFile = File(photo.path);
      });

      // Simuler l'analyse de l'image
      await _startPrimateRecognition();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error taking picture: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _startPrimateRecognition() async {
    try {
      // Afficher un dialogue de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Analyzing primate face...'),
              ],
            ),
          );
        },
      );

      // Simuler un délai pour l'analyse
      await Future.delayed(const Duration(seconds: 2));

      // Fermer le dialogue de chargement
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Mettre à jour l'état pour indiquer que le scan est terminé
      setState(() {
        _faceScanned = true;
      });

      // Afficher un message de succès
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Primate successfully identified!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to analyze primate: ${e.toString()}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _viewPrimateDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrimateDetailsScreen(
          primateData: _mockPrimateData,
        ),
      ),
    );
  }
}