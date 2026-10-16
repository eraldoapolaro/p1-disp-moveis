import 'package:flutter/material.dart';

import 'livros_ui.dart';

class RecuperarSenhaView extends StatefulWidget {
  const RecuperarSenhaView({super.key});

  @override
  State<RecuperarSenhaView> createState() => _RecuperarSenhaViewState();
}

class _RecuperarSenhaViewState extends State<RecuperarSenhaView> {
  final _formulario = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _solicitado = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar senha')),
      body: ConteudoPagina(
        child: Form(
          key: _formulario,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 18),
              const Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.raised,
                  foregroundColor: AppColors.text,
                  child: Icon(Icons.lock_reset, size: 32),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Volte para\nsuas histórias.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              const Text(
                'Informe o e-mail da sua conta para solicitar '
                'a recuperação da senha.',
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 28),
              TextFormField(
                controller: _email,
                validator: validarEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail cadastrado',
                  prefixIcon: Icon(Icons.mail_outline, size: 20),
                ),
                onChanged: (_) {
                  if (_solicitado) setState(() => _solicitado = false);
                },
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () {
                  if (_formulario.currentState!.validate()) {
                    setState(() => _solicitado = true);
                  }
                },
                child: const Text('Solicitar recuperação'),
              ),
              if (_solicitado) ...[
                const SizedBox(height: 24),
                Painel(
                  child: Text(
                    'Solicitação de recuperação registrada para '
                    '${_email.text.trim()}.',
                  ),
                ),
              ],
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Voltar para o login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
