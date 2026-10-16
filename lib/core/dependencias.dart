import 'package:get_it/get_it.dart';

import '../controller/cadastrar_usuario_controller.dart';
import '../controller/login_controller.dart';
import '../controller/livros_controller.dart';
import '../controller/perfil_controller.dart';
import '../controller/recuperar_senha_controller.dart';
import '../controller/sobre_controller.dart';

final g = GetIt.instance;

void configurarDependencias() {
  if (g.isRegistered<CadastrarUsuarioController>()) return;

  g.registerSingleton(CadastrarUsuarioController());
  g.registerSingleton(LoginController());
  g.registerSingleton(PerfilController());
  g.registerSingleton(RecuperarSenhaController());
  g.registerSingleton(SobreController());
  g.registerSingleton(LivrosController());
}
