import 'package:flutter/material.dart';

import '../core/app_routes.dart';
import 'livros_ui.dart';

class MenuLivros extends StatelessWidget {
  const MenuLivros({super.key, required this.indice});

  final int indice;

  @override
  Widget build(BuildContext context) {
    const rotas = [
      AppRoutes.feed,
      AppRoutes.wishlist,
      AppRoutes.anunciarLivro,
      AppRoutes.estante,
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: NavigationBar(
        selectedIndex: indice,
        onDestinationSelected: (novoIndice) {
          if (novoIndice != indice) {
            Navigator.pushNamedAndRemoveUntil(
            context,
            rotas[novoIndice],
            (_) => false,
          );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Desejos',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            selectedIcon: Icon(Icons.add_box),
            label: 'Anunciar',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories),
            label: 'Estante',
          ),
        ],
      ),
    );
  }
}
