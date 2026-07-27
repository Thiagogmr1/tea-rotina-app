import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'token_storage.dart';

class TarefaService {
  Future<List<Map<String, dynamic>>> listarTarefasDoDia(String estudanteId) async {
    final token = await TokenStorage.lerToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/estudantes/$estudanteId/tarefas-do-dia');

    final resposta = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (resposta.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(utf8.decode(resposta.bodyBytes));
      return lista.cast<Map<String, dynamic>>();
    }

    throw Exception('Erro ao buscar tarefas: ${resposta.statusCode}');
  }

  Future<void> concluirTarefa(String tarefaId) async {
    final token = await TokenStorage.lerToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/execucoes/concluir');

    final resposta = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'tarefa_id': tarefaId}),
    );

    if (resposta.statusCode != 201) {
      throw Exception('Erro ao concluir tarefa: ${resposta.statusCode}');
    }
  }
}