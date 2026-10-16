import 'package:flutter/material.dart';

import '../controller/livros_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';
import 'livro_card.dart';
import 'livros_ui.dart';
import 'menu_livros.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final _controller = g<LivrosController>();
  late final TextEditingController _busca;

  @override
  void initState() {
    super.initState();
    _busca = TextEditingController(text: _controller.busca);
  }

  @override
  void dispose() {
    _busca.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MarcaApp(),
        actions: [
          IconButton(
            tooltip: 'Sobre',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.sobre),
            icon: const Icon(Icons.info_outline),
          ),
          const SizedBox(width: 6),
        ],
      ),
      bottomNavigationBar: const MenuLivros(indice: 0),
      body: ConteudoPagina(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final livros = _controller.resultados;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                const Text(
                  'ENCONTRE. TROQUE. LEIA.',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Sua próxima\nboa leitura.',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 18),
                const Wrap(
                  spacing: 8,
                  children: [
                    Etiqueta(
                      texto: 'Ribeirão Preto',
                      icone: Icons.location_on_outlined,
                    ),
                    Etiqueta(texto: 'Livros usados, novas histórias'),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _busca,
                  onChanged: _controller.atualizarBusca,
                  decoration: InputDecoration(
                    hintText: 'Título ou autor',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _busca.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Limpar busca',
                            onPressed: () {
                              _busca.clear();
                              _controller.atualizarBusca('');
                            },
                            icon: const Icon(Icons.close, size: 18),
                          ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      'Todos',
                      'Ficção',
                      'Romance',
                      'Infantil',
                      'Desenvolvimento',
                      'Outro',
                    ].map((genero) {
                      final selecionado = _controller.genero == genero;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(genero),
                          showCheckmark: false,
                          selected: selecionado,
                          selectedColor: AppColors.text,
                          backgroundColor: AppColors.surface,
                          labelStyle: TextStyle(
                            color: selecionado
                                ? AppColors.background
                                : AppColors.muted,
                            fontSize: 12,
                          ),
                          side: const BorderSide(color: AppColors.border),
                          onSelected: (_) {
                            _controller.atualizarGenero(genero);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _controller.conservacao,
                  decoration: const InputDecoration(
                    labelText: 'Conservação',
                    prefixIcon: Icon(Icons.tune, size: 20),
                  ),
                  items: [
                    'Qualquer estado',
                    'Como novo',
                    'Muito bom',
                    'Bom',
                    'Com marcas de uso',
                  ].map((estado) {
                    return DropdownMenuItem(
                      value: estado,
                      child: Text(estado),
                    );
                  }).toList(),
                  onChanged: (valor) {
                    _controller.atualizarConservacao(valor!);
                  },
                ),
                const SizedBox(height: 26),
                TituloSecao(
                  titulo: 'Perto de você',
                  detalhe: '${livros.length} livros',
                ),
                const SizedBox(height: 14),
                if (livros.isEmpty)
                  const EstadoVazio(
                    icone: Icons.search_off,
                    titulo: 'Nenhum livro encontrado',
                    texto: 'Tente outro título ou mude os filtros.',
                  )
                else
                  ...livros.map((livro) => LivroCard(livro: livro)),
              ],
            );
          },
        ),
      ),
    );
  }
}
