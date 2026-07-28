import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class UsuarioService {
  /// Retorna null se deu certo. Se der erro, retorna a mensagem para mostrar ao usuário.
  Future<String?> criarConta({
    required String nome,
    required String telefone,
    required String senha,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/usuarios');

    final resposta = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'papel': 'responsavel', // cadastro pelo app é sempre de responsável
        'telefone': telefone,
        'senha': senha,
      }),
    );

    if (resposta.statusCode == 201) {
      return null;
    }

    try {
      final corpo = jsonDecode(utf8.decode(resposta.bodyBytes));
      final detalhe = corpo['detail'];
      if (detalhe is String && detalhe.toLowerCase().contains('unique')) {
        return 'Esse telefone já está cadastrado.';
      }
      return detalhe?.toString() ?? 'Erro ao criar conta.';
    } catch (_) {
      return 'Erro ao criar conta.';
    }
  }
}