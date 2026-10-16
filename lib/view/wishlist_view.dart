import 'package:flutter/material.dart';

import '../controller/livros_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';
import 'livro_card.dart';
import 'livros_ui.dart';
import 'menu_livros.dart';

class WishlistView extends StatefulWidget {
  const WishlistView({super.key});

  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  final _titulo = TextEditingController();
  final _controller = g<LivrosController>();

  @override
  void dispose() {
    _titulo.dispose();
    super.dispose();
  }

  void _adicionar() {
    final titulo = _titulo.text.trim();
    if (titulo.isEmpty) {
      mostrarMensagem(context, 'Digite o título que está procurando.');
      return;
    }

    if (!_controller.adicionarDesejo(titulo)) {
      mostrarMensagem(context, 'Esse título já está na sua lista.');
      return;
    }
    _titulo.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de desejos')),
      bottomNavigationBar: const MenuLivros(indice: 1),
      body: ConteudoPagina(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final encontrados = _controller.desejos
                .expand(_controller.livrosDisponiveis)
                .toList();

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'As próximas\npáginas da sua lista.',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Salve os títulos que procura. Quando aparecerem no '
                  'catálogo da região, você verá um aviso aqui.',
                  style: TextStyle(color: AppColors.muted),
                ),
                const SizedBox(height: 24),
                Painel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _titulo,
                        onSubmitted: (_) => _adicionar(),
                        decoration: const InputDecoration(
                          labelText: 'Qual livro você procura?',
                          prefixIcon: Icon(Icons.search, size: 20),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _adicionar,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Adicionar à lista'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                if (encontrados.isNotEmpty) ...[
                  Painel(
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_active_outlined),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            '${encontrados.length} livros da sua lista '
                            'estão disponíveis na região.',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  ...encontrados.map((livro) => LivroCard(livro: livro)),
                  const SizedBox(height: 12),
                ],
                TituloSecao(
                  titulo: 'Títulos que procuro',
                  detalhe: '${_controller.desejos.length} salvos',
                ),
                const SizedBox(height: 14),
                if (_controller.desejos.isEmpty)
                  const EstadoVazio(
                    icone: Icons.favorite_border,
                    titulo: 'Sua lista começa aqui',
                    texto: 'Adicione um título ou toque no coração '
                        'de um livro no catálogo.',
                  )
                else
                  ..._controller.desejos.map((desejo) {
                    final livros = _controller.livrosDisponiveis(desejo);
                    final disponivel = livros.isNotEmpty;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Painel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    desejo.titulo,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Remover da lista',
                                  onPressed: () {
                                    _controller.removerDesejo(desejo);
                                  },
                                  icon: const Icon(Icons.close, size: 18),
                                ),
                              ],
                            ),
                            Text(
                              disponivel
                                  ? 'Encontrado perto de você'
                                  : 'Aguardando um anúncio na região',
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                              ),
                            ),
                            if (disponivel) ...[
                              const SizedBox(height: 12),
                              OutlinedButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.detalhesLivro,
                                  arguments: livros.first,
                                ),
                                child: const Text('Ver livro disponível'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            );
          },
        ),
      ),
    );
  }
}
