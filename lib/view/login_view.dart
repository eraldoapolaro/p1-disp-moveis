import 'package:flutter/material.dart';

import '../controller/perfil_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';
import 'livros_ui.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formulario = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  bool _ocultarSenha = true;

  @override
  void dispose() {
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  void _entrar() {
    if (!_formulario.currentState!.validate()) return;
    g<PerfilController>().autenticar(_email.text);
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.feed, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formulario,
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(28),
                children: [
                  const MarcaApp(grande: true),
                  const SizedBox(height: 44),
                  Text(
                    'Boas histórias\nmerecem circular.',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Compre, venda e troque livros com leitores '
                    'da sua região.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 32),
                  const TituloSecao(titulo: 'Entre na sua conta'),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _email,
                    validator: validarEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.mail_outline, size: 20),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _senha,
                    obscureText: _ocultarSenha,
                    validator: campoObrigatorio,
                    onFieldSubmitted: (_) => _entrar(),
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      suffixIcon: IconButton(
                        tooltip: _ocultarSenha
                            ? 'Mostrar senha'
                            : 'Ocultar senha',
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
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.recuperarSenha,
                      ),
                      child: const Text('Esqueceu a senha?'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: _entrar,
                    child: const Text('Entrar'),
                  ),
                  const SizedBox(height: 26),
                  const Divider(),
                  const SizedBox(height: 18),
                  const Text(
                    'Ainda não tem uma conta?',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.cadastrarUsuario,
                    ),
                    child: const Text('Criar minha conta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
