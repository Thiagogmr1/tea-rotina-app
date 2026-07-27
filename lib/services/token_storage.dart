import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _chaveToken = 'access_token';

  static Future<void> salvarToken(String token) async {
    await _storage.write(key: _chaveToken, value: token);
  }

  static Future<String?> lerToken() async {
    return await _storage.read(key: _chaveToken);
  }

  static Future<void> apagarToken() async {
    await _storage.delete(key: _chaveToken);
  }
}