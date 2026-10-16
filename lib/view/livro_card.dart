import 'package:flutter/material.dart';

import '../controller/livros_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';
import 'livro_capa.dart';
import 'livros_ui.dart';

class LivroCard extends StatelessWidget {
  const LivroCard({super.key, required this.livro});

  final Livro livro;

  @override
  Widget build(BuildContext context) {
    final controller = g<LivrosController>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.detalhesLivro,
            arguments: livro,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LivroCapa(livro: livro),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              livro.titulo,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              tooltip: 'Salvar na lista de desejos',
                              onPressed: () {
                                controller.alternarDesejo(livro);
                              },
                              icon: Icon(
                                controller.estaNaLista(livro)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        livro.autor,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Etiqueta(texto: livro.estado),
                      const SizedBox(height: 10),
                      Text(
                        livro.preco,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        livro.local,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
