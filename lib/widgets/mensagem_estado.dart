import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class MensagemEstado extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;
  final String? textoBotao;
  final IconData? iconeBotao;
  final VoidCallback? onPressed;
  final Color cor;

  const MensagemEstado({
    super.key,
    required this.icone,
    required this.titulo,
    required this.descricao,
    this.textoBotao,
    this.iconeBotao,
    this.onPressed,
    this.cor = AppColors.asfalto,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: cor.withValues(alpha: 0.10),
              child: Icon(icone, size: 40, color: cor),
            ),
            const SizedBox(height: 20),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              descricao,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textoSecundario,
              ),
            ),
            if (textoBotao != null && onPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(iconeBotao ?? Icons.refresh),
                label: Text(textoBotao!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
