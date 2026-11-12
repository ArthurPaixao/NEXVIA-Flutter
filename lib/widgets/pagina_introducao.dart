import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PaginaIntroducao extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;

  const PaginaIntroducao({
    super.key,
    required this.icone,
    required this.titulo,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.asfalto,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(icone, size: 80, color: AppColors.faixaAmarela),
          ),
          const SizedBox(height: 36),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            descricao,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              height: 1.45,
              color: AppColors.textoSecundario,
            ),
          ),
        ],
      ),
    );
  }
}
