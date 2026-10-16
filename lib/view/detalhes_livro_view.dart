import 'package:flutter/material.dart';

import '../controller/livros_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';
import 'livro_capa.dart';
import 'livros_ui.dart';

class DetalhesLivroView extends StatelessWidget {
  const DetalhesLivroView({super.key});

  Future<void> _propor(
    BuildContext context,
    Livro livro,
    String tipo,
  ) async {
    final resposta = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      builder: (_) => _FormularioProposta(livro: livro, tipo: tipo),
    );

    if (resposta == null || !context.mounted) return;

    g<LivrosController>().registrarProposta(livro, tipo, resposta);
    mostrarMensagem(context, 'Proposta registrada para este livro.');
  }

  @override
  Widget build(BuildContext context) {
    final livro = ModalRoute.of(context)!.settings.arguments as Livro;
    final controller = g<LivrosController>();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalhes do livro'),
            actions: [
              IconButton(
                tooltip: 'Lista de desejos',
                onPressed: () => controller.alternarDesejo(livro),
                icon: Icon(
                  controller.estaNaLista(livro)
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
              ),
            ],
          ),
          body: ConteudoPagina(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                _GaleriaLivro(livro: livro),
                const SizedBox(height: 22),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Etiqueta(texto: livro.genero),
                    Etiqueta(texto: livro.estado),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  livro.titulo,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  livro.autor,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 18),
                Painel(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          livro.preco,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Etiqueta(
                        texto: livro.aceitaTroca
                            ? 'Aceita troca'
                            : 'Somente venda',
                        icone: Icons.swap_horiz,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const TituloSecao(titulo: 'Sinopse'),
                const SizedBox(height: 10),
                Text(
                  livro.sinopse.isEmpty
                      ? 'O anunciante ainda não adicionou uma sinopse.'
                      : livro.sinopse,
                  style: const TextStyle(color: AppColors.muted, height: 1.6),
                ),
                if (livro.aceita.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const TituloSecao(titulo: 'O que aceita em troca'),
                  const SizedBox(height: 10),
                  Text(
                    livro.aceita,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                ],
                const SizedBox(height: 24),
                const TituloSecao(titulo: 'Quem está anunciando'),
                const SizedBox(height: 12),
                Painel(
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.raised,
                      foregroundColor: AppColors.text,
                      child: Text(livro.dono.substring(0, 1)),
                    ),
                    title: Text(livro.meuLivro ? 'Você' : livro.dono),
                    subtitle: Text(
                      '${livro.local}\nLocalização aproximada',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.estante,
                      arguments: livro.meuLivro ? null : livro.dono,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  onPressed: () => controller.alternarLido(livro),
                  icon: Icon(
                    controller.jaFoiLido(livro)
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                  ),
                  label: Text(
                    controller.jaFoiLido(livro)
                        ? 'Remover dos livros lidos'
                        : 'Adicionar aos livros lidos',
                  ),
                ),
                if (!livro.meuLivro) ...[
                  const SizedBox(height: 12),
                  if (livro.aceitaTroca)
                    FilledButton.icon(
                      onPressed: () => _propor(context, livro, 'Troca'),
                      icon: const Icon(Icons.swap_horiz),
                      label: const Text('Propor troca'),
                    ),
                  if (livro.aceitaVenda) ...[
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () => _propor(context, livro, 'Compra'),
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: const Text('Tenho interesse em comprar'),
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GaleriaLivro extends StatefulWidget {
  const _GaleriaLivro({required this.livro});

  final Livro livro;

  @override
  State<_GaleriaLivro> createState() => _GaleriaLivroState();
}

class _GaleriaLivroState extends State<_GaleriaLivro> {
  int _pagina = 0;

  @override
  Widget build(BuildContext context) {
    final fotos = widget.livro.fotos;

    return Painel(
      child: Column(
        children: [
          if (fotos.isEmpty)
            LivroCapa(livro: widget.livro, width: 180, height: 254)
          else
            SizedBox(
              height: 280,
              child: PageView.builder(
                itemCount: fotos.length,
                onPageChanged: (pagina) => setState(() => _pagina = pagina),
                itemBuilder: (context, indice) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(fotos[indice], fit: BoxFit.contain),
                  );
                },
              ),
            ),
          if (fotos.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Foto ${_pagina + 1} de ${fotos.length}',
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}


class _FormularioProposta extends StatefulWidget {
  const _FormularioProposta({required this.livro, required this.tipo});

  final Livro livro;
  final String tipo;

  @override
  State<_FormularioProposta> createState() => _FormularioPropostaState();
}

class _FormularioPropostaState extends State<_FormularioProposta> {
  final _mensagem = TextEditingController();

  @override
  void dispose() {
    _mensagem.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final troca = widget.tipo == 'Troca';

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              troca ? 'Propor uma troca' : 'Interesse de compra',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              widget.livro.titulo,
              style: const TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _mensagem,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Sua mensagem',
                hintText: troca
                    ? 'Qual livro você oferece em troca?'
                    : 'O que gostaria de perguntar ao anunciante?',
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, _mensagem.text.trim());
              },
              child: const Text('Registrar proposta'),
            ),
          ],
        ),
      ),
    );
  }
}
