import 'package:flutter/material.dart';

class PerfilController extends ChangeNotifier {
  String nome = 'Eraldo Apolaro';
  String email = '';
  bool autenticado = false;

  void autenticar(String emailInformado, {String? nomeInformado}) {
    email = emailInformado.trim();
    if (nomeInformado != null) nome = nomeInformado.trim();
    autenticado = true;
    notifyListeners();
  }

  void atualizarNome(String novoNome) {
    nome = novoNome.trim();
    notifyListeners();
  }

  void sair() {
    autenticado = false;
    email = '';
    notifyListeners();
  }
}
