import 'package:flutter/material.dart';

import '../controller/perfil_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';
import 'livros_ui.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  final _formulario = GlobalKey<FormState>();
  final _perfil = g<PerfilController>();
  late final TextEditingController _nome;
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _nome = TextEditingController(text: _perfil.nome);
    _email = TextEditingController(text: _perfil.email);
  }

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formulario.currentState!.validate()) return;
    _perfil.atualizarNome(_nome.text);
    FocusScope.of(context).unfocus();
    mostrarMensagem(context, 'Seu perfil foi atualizado.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: ConteudoPagina(
        child: !_perfil.autenticado
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const EstadoVazio(
                      icone: Icons.person_outline,
                      titulo: 'Entre na sua conta',
                      texto: 'O perfil está disponível após o login.',
                    ),
                    const SizedBox(height: 14),
                    FilledButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (_) => false,
                      ),
                      child: const Text('Ir para o login'),
                    ),
                  ],
                ),
              )
            : Form(
                key: _formulario,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    const Painel(
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.text,
                            foregroundColor: AppColors.background,
                            child: Icon(Icons.person_outline),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'É assim que outros leitores '
                              'encontram você na comunidade.',
                              style: TextStyle(color: AppColors.muted),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Seus dados.',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nome,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (valor) {
                        if ((valor ?? '').trim().length < 3) {
                          return 'Use pelo menos 3 caracteres no nome.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _email,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'E-mail da conta',
                        suffixIcon: Icon(Icons.lock_outline, size: 18),
                        helperText: 'Este endereço é usado no login.',
                      ),
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: _salvar,
                      child: const Text('Salvar alterações'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
