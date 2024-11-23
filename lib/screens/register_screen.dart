import 'package:flutter/material.dart';
import '../services/polygon_id_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final PolygonIDService _polygonIDService = PolygonIDService();
  
  String name = '';
  String species = '';
  int age = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register New Primate'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              onSaved: (value) => name = value ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Species'),
              onSaved: (value) => species = value ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              onSaved: (value) => age = int.tryParse(value ?? '0') ?? 0,
            ),
            ElevatedButton(
              onPressed: _registerPrimate,
              child: Text('Create DID and Register'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerPrimate() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // Create DID and register primate
      try {
        final did = await _polygonIDService.createDID();
        // Handle successful registration
      } catch (e) {
        // Handle error
      }
    }
  }
}