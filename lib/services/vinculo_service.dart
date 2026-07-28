import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'token_storage.dart';

class VinculoService {
  /// Retorna null se deu certo. Se der erro, retorna a mensagem para mostrar ao usuário.
  Future<String?> usarCodigo(String codigo) async {
    final token = await TokenStorage.lerToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/vinculos/usar-codigo');

    final resposta = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'codigo': codigo.trim().toUpperCase()}),
    );

    if (resposta.statusCode == 201) {
      return null;
    }

    try {
      final corpo = jsonDecode(utf8.decode(resposta.bodyBytes));
      return corpo['detail'] ?? 'Erro ao usar o código.';
    } catch (_) {
      return 'Erro ao usar o código.';
    }
  }
}