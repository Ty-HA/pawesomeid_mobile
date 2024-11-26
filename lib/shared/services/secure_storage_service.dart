// lib/shared/services/secure_storage_service.dart
class SecureStorageService {
  final FlutterSecureStorage _storage;
  
  Future<void> storeDIDKeys(String did, String privateKey) async {
    await _storage.write(key: 'did_$did', value: privateKey);
  }
}