import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';

import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'core/dependencias.dart';
import 'view/anunciar_livro_view.dart';
import 'view/cadastrar_usuario_view.dart';
import 'view/detalhes_livro_view.dart';
import 'view/estante_view.dart';
import 'view/feed_view.dart';
import 'view/login_view.dart';
import 'view/perfil_view.dart';
import 'view/recuperar_senha_view.dart';
import 'view/sobre_view.dart';
import 'view/wishlist_view.dart';

void main() {
  configurarDependencias();
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'troca.página',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: criarTemaEscuro(),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginView(),
        AppRoutes.cadastrarUsuario: (_) => const CadastrarUsuarioView(),
        AppRoutes.recuperarSenha: (_) => const RecuperarSenhaView(),
        AppRoutes.perfil: (_) => const PerfilView(),
        AppRoutes.sobre: (_) => const SobreView(),
        AppRoutes.feed: (_) => const FeedView(),
        AppRoutes.detalhesLivro: (_) => const DetalhesLivroView(),
        AppRoutes.anunciarLivro: (_) => const AnunciarLivroView(),
        AppRoutes.estante: (_) => const EstanteView(),
        AppRoutes.wishlist: (_) => const WishlistView(),
      },
    );
  }
}
