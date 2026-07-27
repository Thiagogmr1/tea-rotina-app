import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'token_storage.dart';

class AuthService {
  Future<bool> login(String telefone, String senha) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/auth/login');

    final resposta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'telefone': telefone, 'senha': senha}),
    );

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(utf8.decode(resposta.bodyBytes));
      await TokenStorage.salvarToken(dados['access_token']);
      return true;
    }

    return false;
  }
}