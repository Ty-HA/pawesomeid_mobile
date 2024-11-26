// lib/services/identity_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/credential.dart';

class IdentityService {
  final String baseUrl;

  IdentityService({required this.baseUrl});

  Future<Map<String, dynamic>> createAnimalIdentity({
  required String name,
  required String species,
  required String birthDate,
  required String sanctuaryDid,
}) async {
  try {
    print('Sending request to $baseUrl/identity/animal');
    final response = await http.post(
      Uri.parse('$baseUrl/identity/animal'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'species': species,
        'birthDate': birthDate,
        'sanctuaryDid': sanctuaryDid,
      }),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}'); // Ajouté pour debug

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['identity'] != null) {
        print('Parsed identity: ${data['identity']}'); // Ajouté pour debug
        return data['identity'];
      } else {
        throw Exception('Response missing identity data');
      }
    } else {
      throw Exception('Failed to create identity: ${response.body}');
    }
  } catch (e) {
    print('Error in createAnimalIdentity: $e');
    rethrow;
  }
}

  Future<VerifiableCredential> issueCredential({
    required String issuerDid,
    required String animalDid,
    required String credentialType,
    required Map<String, dynamic> credentialData,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/identity/credential/issue'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'issuerDid': issuerDid,
        'animalDid': animalDid,
        'credentialType': credentialType,
        'credentialData': credentialData,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return VerifiableCredential.fromJson(responseData['credential']);
    } else {
      throw Exception('Failed to issue credential: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> verifyCredential(
    VerifiableCredential credential,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/identity/credential/verify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'credential': credential.toJson(),
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to verify credential: ${response.body}');
    }
  }
}