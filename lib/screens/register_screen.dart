import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:image_picker/image_picker.dart';
import '../services/identity_service.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  final IdentityService identityService;
  final ApiService apiService;

  const RegisterScreen({
    Key? key,
    required this.identityService,
    required this.apiService,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  String? _fakeImageHash;
  bool _isLoading = false;
  String? _registrationError;

  // Form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  Future<void> _takePicture() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );

      if (image != null) {
        await Future.delayed(const Duration(seconds: 2));

        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final fakeImageData = 'facial_features_$timestamp';
        final hash = sha256.convert(utf8.encode(fakeImageData)).toString();

        setState(() {
          _fakeImageHash = hash;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Face scan completed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during face scan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _openExplorer(String? transactionHash) async {
    if (transactionHash == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction hash not available yet'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final uri = Uri.parse('https://amoy.polygonscan.com/tx/$transactionHash');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open blockchain explorer'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening explorer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _register() async {
 if (!_formKey.currentState!.validate()) {
   return;
 }

 if (_fakeImageHash == null) {
   ScaffoldMessenger.of(context).showSnackBar(
     const SnackBar(
       content: Text('Please complete the face scan first'),
       backgroundColor: Colors.orange,
     ),
   );
   return;
 }

 try {
   setState(() {
     _isLoading = true;
     _registrationError = null;
   });

   // Créer l'identité avec le service
   final identity = await widget.identityService.createAnimalIdentity(
     name: _nameController.text,
     species: _speciesController.text,
     birthDate: _birthDateController.text,
     sanctuaryDid: 'did:polygon:amoy:0xfdb8D26D4faB21C3c506A3781583a46aEDc5833d',
   );

   print('Received registration response: $identity'); // Debug log

   if (identity != null) {
     // Extraire le transaction hash de la structure imbriquée
     String? transactionHash = identity['transaction']?['hash'] as String?;
     int? blockNumber = identity['transaction']?['blockNumber'] as int?;

     if (transactionHash == null) {
       print('Response missing transaction hash: $identity');
       throw Exception('Server response missing transaction hash');
     }

     // Reformater l'identité pour inclure les données au niveau racine
     final formattedIdentity = {
       ...identity,
       'transactionHash': transactionHash,
       'blockNumber': blockNumber,
     };

     if (!mounted) return;

     // Afficher la boîte de dialogue de succès
     await showDialog(
       context: context,
       builder: (context) => AlertDialog(
         title: const Wrap(
           children: [
             Icon(Icons.check_circle, color: Colors.green),
             SizedBox(width: 8),
             Flexible(
               child: Text(
                 'DID Created Successfully',
                 style: TextStyle(fontSize: 18),
               ),
             ),
           ],
         ),
         content: SingleChildScrollView(
           child: Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(
                 'Name: ${_nameController.text}',
                 style: const TextStyle(fontSize: 14),
               ),
               const SizedBox(height: 8),
               SelectableText(
                 'DID: ${identity['did'] ?? 'N/A'}',
                 style: const TextStyle(
                   fontFamily: 'monospace',
                   fontSize: 12,
                 ),
               ),
               const SizedBox(height: 8),
               SelectableText(
                 'Transaction Hash: $transactionHash',
                 style: const TextStyle(
                   fontFamily: 'monospace',
                   fontSize: 12,
                 ),
               ),
               if (blockNumber != null) ...[
                 const SizedBox(height: 8),
                 SelectableText(
                   'Block Number: $blockNumber',
                   style: const TextStyle(
                     fontFamily: 'monospace',
                     fontSize: 12,
                   ),
                 ),
               ],
               const SizedBox(height: 16),
               const Text(
                 'You can view the transaction on the blockchain explorer.',
                 style: TextStyle(fontSize: 14),
               ),
             ],
           ),
         ),
         actions: [
           TextButton(
             onPressed: () => Navigator.of(context).pop(),
             child: const Text('Close'),
           ),
           ElevatedButton.icon(
             icon: const Icon(Icons.open_in_new, size: 18),
             label: const Text('View on Explorer'),
             style: ElevatedButton.styleFrom(
               backgroundColor: const Color(0xFFecaa00),
               padding: const EdgeInsets.symmetric(
                 horizontal: 12,
                 vertical: 8,
               ),
             ),
             onPressed: () {
               _openExplorer(transactionHash);
             },
           ),
         ],
       ),
     );

     // Retourner à la page précédente avec l'identité formatée
     if (!mounted) return;
     Navigator.of(context).pop(formattedIdentity);
   } else {
     throw Exception('Invalid response from server');
   }
 } catch (e) {
   setState(() {
     _registrationError = e.toString();
   });
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text('Registration error: $e'),
       backgroundColor: Colors.red,
     ),
   );
 } finally {
   setState(() {
     _isLoading = false;
   });
 }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Primate'),
        backgroundColor: const Color(0xFF1A237E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          icon: Icon(Icons.pets),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _speciesController,
                        decoration: const InputDecoration(
                          labelText: 'Species',
                          icon: Icon(Icons.category),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the species';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _birthDateController,
                        decoration: const InputDecoration(
                          labelText: 'Birth Date',
                          icon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a birth date';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Face Recognition',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_fakeImageHash != null)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Face scan completed\nHash: ${_fakeImageHash!.substring(0, 8)}...',
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _takePicture,
                        icon: const Icon(Icons.camera_alt),
                        label: Text(_fakeImageHash == null
                            ? 'Start Face Scan'
                            : 'Retake Scan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFecaa00),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_registrationError != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _registrationError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Create DID and Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
