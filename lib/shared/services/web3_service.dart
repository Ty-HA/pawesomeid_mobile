// lib/shared/services/web3_service.dart
class Web3Service {
  final String amoyRpcUrl = 'https://rpc.amoy.polygon.technology';
  final Web3Client web3client;
  
  Future<String> createDID(AnimalDID animal) async {
    try {
      final response = await _api.post('/did/create', data: animal.toJson());
      return response.data['did'];
    } catch (e) {
      throw DIDException(e.toString());
    }
  }
}