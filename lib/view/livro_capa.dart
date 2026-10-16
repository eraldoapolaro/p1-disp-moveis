import 'package:flutter/material.dart';

import '../model/livro.dart';

class LivroCapa extends StatelessWidget {
  const LivroCapa({
    super.key,
    required this.livro,
    this.width = 88,
    this.height = 124,
  });

  final Livro livro;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final clara = livro.cor.computeLuminance() > 0.35;
    final tinta = clara ? const Color(0xFF191919) : Colors.white;
    final grande = height > 160;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: width,
        height: height,
        child: livro.fotos.isNotEmpty
            ? Image.memory(livro.fotos.first, fit: BoxFit.cover)
            : Container(
                padding: EdgeInsets.all(grande ? 22 : 10),
                decoration: BoxDecoration(
                  color: livro.cor,
                  border: Border(
                    left: BorderSide(
                      color: tinta.withValues(alpha: 0.2),
                      width: 6,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.auto_stories_outlined,
                      color: tinta,
                      size: grande ? 27 : 16,
                    ),
                    Text(
                      livro.titulo,
                      maxLines: grande ? 5 : 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: tinta,
                        fontSize: grande ? 21 : 12,
                        height: 1.12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      height: 2,
                      width: grande ? 38 : 18,
                      color: tinta,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
