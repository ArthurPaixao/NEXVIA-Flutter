import 'package:flutter/material.dart';

import '../models/previsao_local.dart';
import '../theme/app_colors.dart';
import '../utils/formatadores.dart';
import 'selo.dart';
import 'status_visual.dart';

class PrevisaoCard extends StatelessWidget {
  final PrevisaoLocal previsao;
  final VoidCallback onTap;

  const PrevisaoCard({
    super.key,
    required this.previsao,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final risco = previsao.maiorRisco;
    final hoje = previsao.hoje;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: corDoRisco(risco).withValues(alpha: 0.12),
                child: Icon(
                  hoje == null
                      ? iconeDoRisco(risco)
                      : iconeDoTempo(hoje.codigoTempo),
                  color: corDoRisco(risco),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      previsao.local.nomeCompleto,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hoje == null
                          ? 'Sem dados para hoje'
                          : 'Hoje: ${hoje.descricaoTempo}, ${formatarChuva(hoje.chuvaMm)}',
                      style: const TextStyle(color: AppColors.textoSecundario),
                    ),
                    Text(
                      '3 dias: ${formatarChuva(previsao.chuvaProximosDias)}',
                      style: const TextStyle(color: AppColors.textoSecundario),
                    ),
                    const SizedBox(height: 8),
                    Selo(
                      texto: risco.rotulo,
                      icone: iconeDoRisco(risco),
                      cor: corDoRisco(risco),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textoSecundario),
            ],
          ),
        ),
      ),
    );
  }
}
