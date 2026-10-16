import 'package:flutter/material.dart';

import '../controller/livros_controller.dart';
import '../controller/perfil_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';
import 'livro_card.dart';
import 'livros_ui.dart';
import 'menu_livros.dart';

class EstanteView extends StatelessWidget {
  const EstanteView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = g<LivrosController>();
    final perfil = g<PerfilController>();
    final visitante = ModalRoute.of(context)?.settings.arguments as String?;
    final minhaEstante = visitante == null;

    return AnimatedBuilder(
      animation: Listenable.merge([controller, perfil]),
      builder: (context, _) {
        final nome = visitante ?? perfil.nome;
        final livros = minhaEstante
            ? controller.meusLivros
            : controller.livros.where((livro) => livro.dono == nome).toList();
        final lidos = minhaEstante ? controller.lidos : <Livro>[];

        return Scaffold(
          appBar: AppBar(
            title: Text(minhaEstante ? 'Minha estante' : 'Estante pública'),
            actions: [
              if (minhaEstante)
                IconButton(
                  tooltip: 'Editar perfil',
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.perfil,
                  ),
                  icon: const Icon(Icons.manage_accounts_outlined),
                ),
              IconButton(
                tooltip: 'Sobre',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.sobre),
                icon: const Icon(Icons.info_outline),
              ),
            ],
          ),
          bottomNavigationBar: minhaEstante
              ? const MenuLivros(indice: 3)
              : null,
          body: ConteudoPagina(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Painel(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: AppColors.text,
                        foregroundColor: AppColors.background,
                        child: Text(
                          nome.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        nome,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Ribeirão Preto · comunidade de leitores',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      const Etiqueta(
                        texto: 'Estante pública',
                        icone: Icons.public,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _Contagem(
                            numero: livros.length,
                            legenda: 'Disponíveis',
                          ),
                          _Contagem(numero: lidos.length, legenda: 'Já lidos'),
                          const _Contagem(numero: 2, legenda: 'Avaliações'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                TituloSecao(
                  titulo: 'Livros disponíveis',
                  detalhe: '${livros.length} na estante',
                ),
                const SizedBox(height: 14),
                if (livros.isEmpty)
                  const EstadoVazio(
                    icone: Icons.add_box_outlined,
                    titulo: 'Sua estante está começando',
                    texto: 'Publique um livro para ele aparecer aqui.',
                  )
                else
                  ...livros.map((livro) => LivroCard(livro: livro)),
                if (minhaEstante && livros.isEmpty) ...[
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.anunciarLivro,
                    ),
                    child: const Text('Anunciar meu primeiro livro'),
                  ),
                ],
                const SizedBox(height: 24),
                TituloSecao(
                  titulo: 'Já lidos',
                  detalhe: '${lidos.length} livros',
                ),
                const SizedBox(height: 14),
                if (lidos.isEmpty)
                  EstadoVazio(
                    icone: Icons.bookmark_border,
                    titulo: 'Histórico de leitura',
                    texto: minhaEstante
                        ? 'Abra os detalhes de um livro para marcá-lo '
                            'como lido.'
                        : 'Este leitor ainda não adicionou livros lidos.',
                  )
                else
                  ...lidos.map((livro) => LivroCard(livro: livro)),
                const SizedBox(height: 24),
                const TituloSecao(titulo: 'Avaliações recebidas'),
                const SizedBox(height: 14),
                const _Avaliacao(
                  nome: 'Marina',
                  texto: 'Livro bem conservado e uma troca tranquila.',
                  estrelas: 5,
                ),
                const SizedBox(height: 10),
                const _Avaliacao(
                  nome: 'Rafael',
                  texto: 'Boa comunicação para combinar a entrega.',
                  estrelas: 4,
                ),
                if (minhaEstante) ...[
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () {
                      perfil.sair();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (_) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Sair da conta'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Contagem extends StatelessWidget {
  const _Contagem({required this.numero, required this.legenda});

  final int numero;
  final String legenda;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$numero',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 3),
          Text(
            legenda,
            style: const TextStyle(fontSize: 11, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _Avaliacao extends StatelessWidget {
  const _Avaliacao({
    required this.nome,
    required this.texto,
    required this.estrelas,
  });

  final String nome;
  final String texto;
  final int estrelas;

  @override
  Widget build(BuildContext context) {
    return Painel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  nome,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              ...List.generate(5, (indice) {
                return Icon(
                  indice < estrelas ? Icons.star : Icons.star_border,
                  size: 15,
                  color: AppColors.text,
                );
              }),
            ],
          ),
          const SizedBox(height: 8),
          Text(texto, style: const TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }
}
