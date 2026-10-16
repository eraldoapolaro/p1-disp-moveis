import 'package:flutter/material.dart';

import '../core/app_theme.dart';

export '../core/app_theme.dart';

void mostrarMensagem(BuildContext context, String texto) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(texto)));
}

String? campoObrigatorio(String? valor) {
  if (valor == null || valor.trim().isEmpty) {
    return 'Preencha este campo.';
  }
  return null;
}

String? validarEmail(String? valor) {
  final erro = campoObrigatorio(valor);
  if (erro != null) return erro;

  final formato = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  if (!formato.hasMatch(valor!.trim())) return 'Informe um e-mail válido.';
  return null;
}

class ConteudoPagina extends StatelessWidget {
  const ConteudoPagina({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: child,
      ),
    );
  }
}

class MarcaApp extends StatelessWidget {
  const MarcaApp({super.key, this.grande = false});

  final bool grande;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: grande ? 48 : 32,
          height: grande ? 48 : 32,
          decoration: BoxDecoration(
            color: AppColors.text,
            borderRadius: BorderRadius.circular(grande ? 14 : 10),
          ),
          child: Icon(
            Icons.auto_stories_outlined,
            color: AppColors.background,
            size: grande ? 26 : 19,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'troca.página',
          style: TextStyle(
            fontSize: grande ? 24 : 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class Painel extends StatelessWidget {
  const Painel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class TituloSecao extends StatelessWidget {
  const TituloSecao({
    super.key,
    required this.titulo,
    this.detalhe,
  });

  final String titulo;
  final String? detalhe;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(titulo, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (detalhe != null)
          Text(
            detalhe!,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
      ],
    );
  }
}

class Etiqueta extends StatelessWidget {
  const Etiqueta({super.key, required this.texto, this.icone});

  final String texto;
  final IconData? icone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.raised,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icone != null) ...[
            Icon(icone, size: 13, color: AppColors.muted),
            const SizedBox(width: 5),
          ],
          Text(
            texto,
            style: const TextStyle(fontSize: 11, color: AppColors.text),
          ),
        ],
      ),
    );
  }
}

class EstadoVazio extends StatelessWidget {
  const EstadoVazio({
    super.key,
    required this.icone,
    required this.titulo,
    required this.texto,
  });

  final IconData icone;
  final String titulo;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Painel(
      child: Column(
        children: [
          Icon(icone, size: 32, color: AppColors.muted),
          const SizedBox(height: 12),
          Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
