import 'package:flutter/material.dart';
import '../services/estudante_service.dart';
import '../services/tarefa_service.dart';
import '../services/token_storage.dart';
import 'login_screen.dart';
import 'vincular_codigo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _estudanteService = EstudanteService();
  final _tarefaService = TarefaService();

  bool _carregando = true;
  String? _erro;
  List<Map<String, dynamic>> _estudantes = [];
  Map<String, dynamic>? _estudanteSelecionado;
  List<Map<String, dynamic>> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregarEstudantes();
  }

  Future<void> _carregarEstudantes() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final estudantes = await _estudanteService.listarMeusEstudantes();

      if (estudantes.isEmpty) {
        setState(() {
          _estudantes = [];
          _estudanteSelecionado = null;
          _tarefas = [];
          _carregando = false;
        });
        return;
      }

      setState(() {
        _estudantes = estudantes;
        _estudanteSelecionado = estudantes.first;
      });

      await _carregarTarefas(estudantes.first['id']);
    } catch (e) {
      setState(() {
        _erro = 'Erro ao carregar estudantes: $e';
        _carregando = false;
      });
    }
  }

  Future<void> _carregarTarefas(String estudanteId) async {
    setState(() => _carregando = true);

    try {
      final tarefas = await _tarefaService.listarTarefasDoDia(estudanteId);

      setState(() {
        _tarefas = tarefas;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _erro = 'Erro ao carregar tarefas: $e';
        _carregando = false;
      });
    }
  }

  Future<void> _concluirTarefa(String tarefaId) async {
    try {
      await _tarefaService.concluirTarefa(tarefaId);

      if (_estudanteSelecionado != null) {
        await _carregarTarefas(_estudanteSelecionado!['id']);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao concluir: $e')),
        );
      }
    }
  }

  Future<void> _abrirTelaDeCodigo() async {
    final sucesso = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const VincularCodigoScreen(),
      ),
    );

    if (sucesso == true) {
      _carregarEstudantes();
    }
  }

  Future<void> _sair() async {
    await TokenStorage.apagarToken();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Color _corDoStatus(String status) {
    switch (status) {
      case 'concluida':
        return Colors.green;
      case 'nao_realizada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _iconeDoStatus(String status) {
    switch (status) {
      case 'concluida':
        return Icons.check_circle;
      case 'nao_realizada':
        return Icons.cancel;
      default:
        return Icons.radio_button_unchecked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _estudanteSelecionado != null
              ? 'Rotina de ${_estudanteSelecionado!['nome']}'
              : 'Minhas Tarefas',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarEstudantes,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _sair,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _estudantes.isEmpty && _erro == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.link_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Nenhum estudante vinculado ainda.',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _abrirTelaDeCodigo,
                          icon: const Icon(Icons.qr_code),
                          label: const Text('Inserir código de vínculo'),
                        ),
                      ],
                    ),
                  ),
                )
              : _erro != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          _erro!,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : _tarefas.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhuma tarefa prevista para hoje.',
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _tarefas.length,
                          itemBuilder: (context, index) {
                            final tarefa = _tarefas[index];
                            final status = tarefa['status'] as String;
                            final concluida = status == 'concluida';

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: Icon(
                                  _iconeDoStatus(status),
                                  color: _corDoStatus(status),
                                  size: 36,
                                ),
                                title: Text(
                                  tarefa['titulo'],
                                  style: const TextStyle(fontSize: 18),
                                ),
                                subtitle: Text(
                                  tarefa['horario_previsto'],
                                ),
                                trailing: concluida
                                    ? null
                                    : ElevatedButton(
                                        onPressed: () => _concluirTarefa(
                                          tarefa['tarefa_id'],
                                        ),
                                        child: const Text('Concluí'),
                                      ),
                              ),
                            );
                          },
                        ),
    );
  }
}