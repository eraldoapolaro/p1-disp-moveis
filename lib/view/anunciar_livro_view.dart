import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/livros_controller.dart';
import '../core/app_routes.dart';
import '../core/dependencias.dart';
import 'livros_ui.dart';
import 'menu_livros.dart';

class AnunciarLivroView extends StatefulWidget {
  const AnunciarLivroView({super.key});

  @override
  State<AnunciarLivroView> createState() => _AnunciarLivroViewState();
}

class _AnunciarLivroViewState extends State<AnunciarLivroView> {
  final _formulario = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _autor = TextEditingController();
  final _sinopse = TextEditingController();
  final _preco = TextEditingController();
  final _troca = TextEditingController();
  final _imagePicker = ImagePicker();
  final List<Uint8List> _fotos = [];

  String _genero = 'Ficção';
  String _estado = 'Muito bom';
  String _tipo = 'Troca ou venda';
  bool _selecionandoFotos = false;

  @override
  void dispose() {
    _titulo.dispose();
    _autor.dispose();
    _sinopse.dispose();
    _preco.dispose();
    _troca.dispose();
    super.dispose();
  }

  Future<void> _selecionarFotos() async {
    if (_selecionandoFotos) return;
    if (_fotos.length >= 6) {
      mostrarMensagem(context, 'Você pode adicionar até 6 fotos.');
      return;
    }

    setState(() => _selecionandoFotos = true);
    try {
      final imagens = await _imagePicker.pickMultiImage(
        maxWidth: 1600,
        imageQuality: 85,
      );
      final vagas = 6 - _fotos.length;
      final arquivos = await Future.wait(
        imagens.take(vagas).map((imagem) => imagem.readAsBytes()),
      );
      if (!mounted) return;
      setState(() => _fotos.addAll(arquivos));
    } catch (_) {
      if (mounted) {
        mostrarMensagem(context, 'Não foi possível abrir a galeria.');
      }
    } finally {
      if (mounted) setState(() => _selecionandoFotos = false);
    }
  }

  String? _validarPreco(String? texto) {
    if (_tipo == 'Troca') return null;
    final valor = double.tryParse((texto ?? '').replaceAll(',', '.'));
    if (valor == null || !valor.isFinite || valor <= 0) {
      return 'Informe um preço maior que zero.';
    }
    return null;
  }

  void _publicarAnuncio() {
    if (!_formulario.currentState!.validate()) return;
    final valor = double.tryParse(_preco.text.replaceAll(',', '.'));
    final preco = _tipo == 'Troca'
        ? 'Troca'
        : 'R\$ ${valor!.toStringAsFixed(2).replaceAll('.', ',')}';

    final livro = Livro(
      titulo: _titulo.text.trim(),
      autor: _autor.text.trim(),
      sinopse: _sinopse.text.trim(),
      genero: _genero,
      estado: _estado,
      preco: preco,
      aceita: _tipo == 'Venda' ? '' : _troca.text.trim(),
      aceitaTroca: _tipo != 'Venda',
      dono: 'Você',
      meuLivro: true,
      local: 'Ribeirão Preto · mesma região',
      cor: const Color(0xFF444444),
      fotos: List.unmodifiable(_fotos),
    );

    g<LivrosController>().anunciar(livro);
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.feed,
      (_) => false,
    );
    mostrarMensagem(context, 'Seu livro foi publicado no catálogo.');
  }

  Widget _campo(
    TextEditingController controller,
    String rotulo, {
    bool obrigatorio = false,
    int linhas = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: linhas,
        validator: obrigatorio ? campoObrigatorio : null,
        decoration: InputDecoration(labelText: rotulo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anunciar livro')),
      bottomNavigationBar: const MenuLivros(indice: 2),
      body: ConteudoPagina(
        child: Form(
          key: _formulario,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Um livro.\nUm novo leitor.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Conte sobre o seu exemplar e escolha como deseja negociar.',
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 24),
              Painel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.add_a_photo_outlined,
                      size: 30,
                      color: AppColors.muted,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Fotos do exemplar',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Mostre a capa e o estado das páginas. Até 6 fotos.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _selecionandoFotos ? null : _selecionarFotos,
                      child: Text(
                        _selecionandoFotos
                            ? 'Carregando fotos...'
                            : 'Escolher fotos',
                      ),
                    ),
                    if (_fotos.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 116,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _fotos.length,
                          separatorBuilder: (_, _) {
                            return const SizedBox(width: 10);
                          },
                          itemBuilder: (context, indice) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                    _fotos[indice],
                                    width: 86,
                                    height: 116,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 2,
                                  top: 2,
                                  child: IconButton(
                                    tooltip: 'Remover foto',
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.background,
                                    ),
                                    onPressed: () {
                                      setState(() => _fotos.removeAt(indice));
                                    },
                                    icon: const Icon(Icons.close, size: 16),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const TituloSecao(titulo: 'Sobre o livro'),
              const SizedBox(height: 14),
              _campo(_titulo, 'Título *', obrigatorio: true),
              _campo(_autor, 'Autor *', obrigatorio: true),
              _campo(_sinopse, 'Sinopse ou descrição', linhas: 3),
              DropdownButtonFormField<String>(
                initialValue: _genero,
                decoration: const InputDecoration(labelText: 'Gênero'),
                items: [
                  'Ficção',
                  'Romance',
                  'Infantil',
                  'Desenvolvimento',
                  'Outro',
                ].map((item) {
                  return DropdownMenuItem(value: item, child: Text(item));
                }).toList(),
                onChanged: (valor) => setState(() => _genero = valor!),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _estado,
                decoration: const InputDecoration(labelText: 'Conservação'),
                items: [
                  'Como novo',
                  'Muito bom',
                  'Bom',
                  'Com marcas de uso',
                ].map((item) {
                  return DropdownMenuItem(value: item, child: Text(item));
                }).toList(),
                onChanged: (valor) => setState(() => _estado = valor!),
              ),
              const SizedBox(height: 24),
              const TituloSecao(titulo: 'Como negociar'),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _tipo,
                decoration: const InputDecoration(labelText: 'Tipo de anúncio'),
                items: ['Troca ou venda', 'Troca', 'Venda'].map((item) {
                  return DropdownMenuItem(value: item, child: Text(item));
                }).toList(),
                onChanged: (valor) => setState(() => _tipo = valor!),
              ),
              const SizedBox(height: 14),
              if (_tipo != 'Troca') ...[
                TextFormField(
                  controller: _preco,
                  validator: _validarPreco,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Preço *',
                    prefixText: 'R\$ ',
                    hintText: '30,00',
                  ),
                ),
                const SizedBox(height: 14),
              ],
              if (_tipo != 'Venda')
                _campo(_troca, 'O que você aceita em troca?', linhas: 2),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _selecionandoFotos ? null : _publicarAnuncio,
                icon: const Icon(Icons.add),
                label: const Text('Publicar livro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
