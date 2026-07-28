import 'package:flutter/material.dart';
import '../services/usuario_service.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _usuarioService = UsuarioService();

  bool _carregando = false;
  String? _erro;

  Future<void> _criarConta() async {
    final nome = _nomeController.text.trim();
    final telefone = _telefoneController.text.trim();
    final senha = _senhaController.text.trim();
    final confirmarSenha = _confirmarSenhaController.text.trim();

    if (nome.isEmpty || telefone.isEmpty || senha.isEmpty) {
      setState(() => _erro = 'Preencha todos os campos.');
      return;
    }

    if (senha.length < 6) {
      setState(() => _erro = 'A senha precisa ter pelo menos 6 caracteres.');
      return;
    }

    if (senha != confirmarSenha) {
      setState(() => _erro = 'As senhas não coincidem.');
      return;
    }

    setState(() {
      _carregando = true;
      _erro = null;
    });

    final erro = await _usuarioService.criarConta(
      nome: nome,
      telefone: telefone,
      senha: senha,
    );

    setState(() => _carregando = false);

    if (erro == null && mounted) {
      Navigator.of(context).pop(true); // avisa a tela de login que deu certo
    } else {
      setState(() => _erro = erro);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Crie sua conta de responsável para acompanhar a rotina do seu estudante.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome completo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _telefoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Telefone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha (mínimo 6 caracteres)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmarSenhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            if (_erro != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _erro!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _carregando ? null : _criarConta,
                child: _carregando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Criar conta', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}