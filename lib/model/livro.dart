import 'dart:typed_data';

import 'package:flutter/material.dart';

class Livro {
  Livro({
    required this.titulo,
    required this.autor,
    required this.genero,
    required this.estado,
    required this.preco,
    required this.dono,
    required this.local,
    required this.cor,
    this.sinopse = '',
    this.aceita = '',
    this.aceitaTroca = true,
    this.meuLivro = false,
    this.fotos = const [],
  });

  final String titulo;
  final String autor;
  final String genero;
  final String estado;
  final String preco;
  final String dono;
  final String local;
  final String sinopse;
  final String aceita;
  final Color cor;
  final bool aceitaTroca;
  final bool meuLivro;
  final List<Uint8List> fotos;

  bool get aceitaVenda => preco != 'Troca';
}
