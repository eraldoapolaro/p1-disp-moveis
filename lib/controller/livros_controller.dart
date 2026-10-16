import 'package:flutter/material.dart';

import '../model/livro.dart';

export '../model/livro.dart';

class LivrosController extends ChangeNotifier {
  final List<Livro> livros = [
    Livro(
      titulo: 'A Biblioteca da Meia-Noite',
      autor: 'Matt Haig',
      genero: 'Ficção',
      estado: 'Muito bom',
      preco: 'R\$ 32,00',
      dono: 'Marina',
      local: 'Centro · 2 km',
      cor: const Color(0xFF343434),
      aceita: 'Romances e livros de ficção.',
      sinopse: 'Entre a vida e a morte, Nora encontra uma biblioteca com '
          'as vidas que poderia ter vivido. Cada livro oferece a chance '
          'de experimentar uma escolha diferente.',
    ),
    Livro(
      titulo: 'O Pequeno Príncipe',
      autor: 'Antoine de Saint-Exupéry',
      genero: 'Infantil',
      estado: 'Bom',
      preco: 'Troca',
      dono: 'Rafael',
      local: 'Jardim Paulista · 4 km',
      cor: const Color(0xFFDDDDDD),
      aceita: 'Literatura infantil e fantasia.',
      sinopse: 'Um piloto conhece um pequeno viajante no deserto. '
          'Ao contar suas aventuras por outros planetas, o menino '
          'fala sobre amizade, cuidado e o modo como vemos o mundo.',
    ),
    Livro(
      titulo: 'Torto Arado',
      autor: 'Itamar Vieira Junior',
      genero: 'Romance',
      estado: 'Muito bom',
      preco: 'R\$ 28,00',
      dono: 'Bianca',
      local: 'Sumarezinho · 3 km',
      cor: const Color(0xFF888888),
      aceita: 'Literatura brasileira.',
      sinopse: 'As irmãs Bibiana e Belonísia crescem em uma comunidade '
          'rural da Bahia. Um acidente na infância marca suas vidas, '
          'enquanto a relação com a terra atravessa suas histórias.',
    ),
    Livro(
      titulo: 'Hábitos Atômicos',
      autor: 'James Clear',
      genero: 'Desenvolvimento',
      estado: 'Como novo',
      preco: 'R\$ 40,00',
      dono: 'Lucas',
      local: 'Ribeirânia · 6 km',
      cor: const Color(0xFFB8B8B8),
      aceitaTroca: false,
      sinopse: 'O livro apresenta formas de criar bons hábitos e '
          'abandonar hábitos indesejados, com pequenas mudanças '
          'que podem ser aplicadas na rotina.',
    ),
  ];

  final List<Livro> desejos = [];
  final List<Livro> lidos = [];
  final List<String> propostas = [];

  String genero = 'Todos';
  String conservacao = 'Qualquer estado';
  String busca = '';

  String _normalizar(String titulo) {
    return titulo.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  List<Livro> get resultados {
    return livros.where((livro) {
      final combinaGenero = genero == 'Todos' || livro.genero == genero;
      final combinaEstado = conservacao == 'Qualquer estado' ||
          livro.estado == conservacao;
      final texto = '${livro.titulo} ${livro.autor}'.toLowerCase();
      final combinaBusca = texto.contains(busca.trim().toLowerCase());
      return combinaGenero && combinaEstado && combinaBusca;
    }).toList();
  }

  List<Livro> get meusLivros {
    return livros.where((livro) => livro.meuLivro).toList();
  }

  bool estaNaLista(Livro livro) {
    return desejos.any(
      (item) => _normalizar(item.titulo) == _normalizar(livro.titulo),
    );
  }

  List<Livro> livrosDisponiveis(Livro desejo) {
    return livros.where((livro) {
      return _normalizar(livro.titulo) == _normalizar(desejo.titulo);
    }).toList();
  }

  bool adicionarDesejo(String titulo) {
    final nome = titulo.trim();
    if (nome.isEmpty) return false;
    final jaExiste = desejos.any(
      (livro) => _normalizar(livro.titulo) == _normalizar(nome),
    );
    if (jaExiste) {
      return false;
    }

    desejos.add(
      Livro(
        titulo: nome,
        autor: '',
        genero: '',
        estado: '',
        preco: 'Troca',
        dono: '',
        local: 'Ribeirão Preto',
        cor: const Color(0xFF343434),
      ),
    );
    notifyListeners();
    return true;
  }

  void removerDesejo(Livro livro) {
    desejos.removeWhere(
      (item) => _normalizar(item.titulo) == _normalizar(livro.titulo),
    );
    notifyListeners();
  }

  void alternarDesejo(Livro livro) {
    if (estaNaLista(livro)) {
      removerDesejo(livro);
    } else {
      adicionarDesejo(livro.titulo);
    }
  }

  void anunciar(Livro livro) {
    livros.insert(0, livro);
    busca = '';
    genero = 'Todos';
    conservacao = 'Qualquer estado';
    notifyListeners();
  }

  bool jaFoiLido(Livro livro) {
    return lidos.any(
      (item) => _normalizar(item.titulo) == _normalizar(livro.titulo),
    );
  }

  void alternarLido(Livro livro) {
    if (jaFoiLido(livro)) {
      lidos.removeWhere(
        (item) => _normalizar(item.titulo) == _normalizar(livro.titulo),
      );
    } else {
      lidos.add(livro);
    }
    notifyListeners();
  }

  void atualizarBusca(String valor) {
    busca = valor;
    notifyListeners();
  }

  void atualizarGenero(String valor) {
    genero = valor;
    notifyListeners();
  }

  void atualizarConservacao(String valor) {
    conservacao = valor;
    notifyListeners();
  }

  void registrarProposta(Livro livro, String tipo, String mensagem) {
    propostas.add('$tipo · ${livro.titulo} · $mensagem');
    notifyListeners();
  }
}
