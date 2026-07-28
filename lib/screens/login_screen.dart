import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'cadastro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authService = AuthService();
  bool _carregando = false;
  String? _erro;

  Future<void> _fazerLogin() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    final sucesso = await _authService.login(
      _telefoneController.text.trim(),
      _senhaController.text.trim(),
    );

    setState(() => _carregando = false);

    if (sucesso && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() => _erro = 'Telefone ou senha incorretos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.checklist_rtl,
                size: 80,
                color: Colors.teal,
              ),
              const SizedBox(height: 16),
              const Text(
                'Rotina TEA',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
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
                  labelText: 'Senha',
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
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _carregando ? null : _fazerLogin,
                  child: _carregando
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Entrar',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final sucesso = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(builder: (_) => const CadastroScreen()),
                  );
                  if (sucesso == true && mounted) {
                    await Future.delayed(const Duration(milliseconds: 300));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Conta criada! Faça login para continuar.')),
                      );
                    }
                  }
                },
                child: const Text('Não tem conta? Criar conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}