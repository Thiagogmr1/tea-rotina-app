import 'package:flutter/material.dart';
import '../services/vinculo_service.dart';

class VincularCodigoScreen extends StatefulWidget {
  const VincularCodigoScreen({super.key});

  @override
  State<VincularCodigoScreen> createState() => _VincularCodigoScreenState();
}

class _VincularCodigoScreenState extends State<VincularCodigoScreen> {
  final _codigoController = TextEditingController();
  final _vinculoService = VinculoService();
  bool _carregando = false;
  String? _erro;

  Future<void> _confirmarCodigo() async {
    if (_codigoController.text.trim().isEmpty) {
      setState(() => _erro = 'Digite o código recebido da escola.');
      return;
    }

    setState(() {
      _carregando = true;
      _erro = null;
    });

    final erro = await _vinculoService.usarCodigo(_codigoController.text);

    setState(() => _carregando = false);

    if (erro == null && mounted) {
      Navigator.of(context).pop(true); // avisa a tela anterior que deu certo
    } else {
      setState(() => _erro = erro);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vincular estudante')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.qr_code, size: 72, color: Colors.teal),
            const SizedBox(height: 16),
            const Text(
              'Digite o código que a escola enviou para vincular o estudante à sua conta.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _codigoController,
              textCapitalization: TextCapitalization.characters,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 4),
              decoration: const InputDecoration(
                labelText: 'Código',
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
                onPressed: _carregando ? null : _confirmarCodigo,
                child: _carregando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Confirmar', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}