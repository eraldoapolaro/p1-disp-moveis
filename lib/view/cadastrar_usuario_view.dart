import 'package:flutter/material.dart';

import '../controller/perfil_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';
import 'livros_ui.dart';

class CadastrarUsuarioView extends StatefulWidget {
  const CadastrarUsuarioView({super.key});

  @override
  State<CadastrarUsuarioView> createState() => _CadastrarUsuarioViewState();
}

class _CadastrarUsuarioViewState extends State<CadastrarUsuarioView> {
  final _formulario = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _telefone = TextEditingController();
  final _senha = TextEditingController();
  final _confirmacao = TextEditingController();
  bool _ocultarSenha = true;

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _telefone.dispose();
    _senha.dispose();
    _confirmacao.dispose();
    super.dispose();
  }

  void _cadastrar() {
    if (!_formulario.currentState!.validate()) return;

    g<PerfilController>().autenticar(
      _email.text,
      nomeInformado: _nome.text,
    );
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.feed, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: ConteudoPagina(
        child: Form(
          key: _formulario,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Sua estante\ncomeça aqui.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              const Text(
                'Um cadastro para conectar você a outros leitores.',
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 28),
              TextFormField(
                controller: _nome,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (valor) {
                  if ((valor ?? '').trim().length < 3) {
                    return 'O nome deve ter pelo menos 3 caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _email,
                validator: validarEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'E-mail'),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _telefone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (valor) {
                  final digitos = (valor ?? '').replaceAll(
                    RegExp(r'\D'),
                    '',
                  );
                  if (digitos.length < 10 || digitos.length > 11) {
                    return 'Informe o telefone com DDD.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _senha,
                obscureText: _ocultarSenha,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  helperText: 'Pelo menos 6 caracteres.',
                  suffixIcon: IconButton(
                    tooltip: 'Mostrar ou ocultar senha',
                    onPressed: () {
                      setState(() => _ocultarSenha = !_ocultarSenha);
                    },
                    icon: Icon(
                      _ocultarSenha
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                  ),
                ),
                validator: (valor) {
                  if ((valor ?? '').length < 6) {
                    return 'Use pelo menos 6 caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _confirmacao,
                obscureText: _ocultarSenha,
                decoration: const InputDecoration(
                  labelText: 'Confirme a senha',
                ),
                validator: (valor) {
                  if (valor != _senha.text) return 'As senhas não coincidem.';
                  return campoObrigatorio(valor);
                },
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: _cadastrar,
                child: const Text('Criar conta e começar'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Já tenho uma conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
