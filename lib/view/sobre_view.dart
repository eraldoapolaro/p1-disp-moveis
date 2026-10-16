import 'package:flutter/material.dart';

import 'livros_ui.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      body: ConteudoPagina(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 16),
            const MarcaApp(grande: true),
            const SizedBox(height: 30),
            Text(
              'Mais leitores.\nMais histórias.',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            const Text(
              'Um livro que você já leu pode ser a próxima '
              'descoberta de outra pessoa.',
              style: TextStyle(color: AppColors.muted, fontSize: 16),
            ),
            const SizedBox(height: 28),
            const Painel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Objetivo do aplicativo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Aproximar leitores da mesma região para facilitar '
                    'a troca, a compra e a venda de livros usados. '
                    'O catálogo ajuda a encontrar títulos disponíveis '
                    'por perto, enquanto a estante reúne anúncios, '
                    'leituras e avaliações.',
                    style: TextStyle(color: AppColors.muted, height: 1.6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const TituloSecao(titulo: 'O que você pode fazer'),
            const SizedBox(height: 12),
            const _Funcionalidade(
              icone: Icons.explore_outlined,
              titulo: 'Descobrir livros',
              texto: 'Busque títulos e filtre gênero e conservação.',
            ),
            const _Funcionalidade(
              icone: Icons.add_a_photo_outlined,
              titulo: 'Compartilhar sua estante',
              texto: 'Anuncie exemplares com fotos e condições de troca.',
            ),
            const _Funcionalidade(
              icone: Icons.favorite_border,
              titulo: 'Acompanhar desejos',
              texto: 'Veja quando um título procurado aparece na região.',
            ),
            const SizedBox(height: 24),
            const Painel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Projeto acadêmico',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text('Projeto Prático de Flutter · 2026'),
                  SizedBox(height: 8),
                  Text(
                    'Integrante: Eraldo Apolaro',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Flutter e Dart · Estado com ChangeNotifier',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  SizedBox(height: 8),
                  Etiqueta(texto: 'Versão 1.1'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Funcionalidade extends StatelessWidget {
  const _Funcionalidade({
    required this.icone,
    required this.titulo,
    required this.texto,
  });

  final IconData icone;
  final String titulo;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icone, color: AppColors.text),
      title: Text(titulo),
      subtitle: Text(
        texto,
        style: const TextStyle(color: AppColors.muted, fontSize: 12),
      ),
    );
  }
}
