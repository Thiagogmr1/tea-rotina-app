import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'token_storage.dart';

class EstudanteService {
  Future<List<Map<String, dynamic>>> listarMeusEstudantes() async {
    final token = await TokenStorage.lerToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/estudantes/meus');

    final resposta = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (resposta.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(utf8.decode(resposta.bodyBytes));
      return lista.cast<Map<String, dynamic>>();
    }

    throw Exception('Erro ao buscar estudantes: ${resposta.statusCode}');
  }
}