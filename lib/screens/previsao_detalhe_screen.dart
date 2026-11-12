import 'package:flutter/material.dart';

import '../models/previsao_dia.dart';
import '../models/previsao_local.dart';
import '../theme/app_colors.dart';
import '../utils/formatadores.dart';
import '../widgets/selo.dart';
import '../widgets/status_visual.dart';

class PrevisaoDetalheScreen extends StatelessWidget {
  final PrevisaoLocal previsao;

  const PrevisaoDetalheScreen({super.key, required this.previsao});

  @override
  Widget build(BuildContext context) {
    final risco = previsao.maiorRisco;
    final cor = corDoRisco(risco);

    return Scaffold(
      appBar: AppBar(
        title: Text(previsao.local.nomeCompleto),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cor.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Icon(iconeDoRisco(risco), color: cor, size: 44),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        risco.rotulo,
                        style: TextStyle(
                          color: cor,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(risco.orientacao),
                      const SizedBox(height: 4),
                      Text(
                        'Chuva nos próximos 3 dias: '
                        '${formatarChuva(previsao.chuvaProximosDias)}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Próximos ${previsao.dias.length} dias',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...previsao.dias.map((dia) => _DiaCard(dia: dia)),
          const SizedBox(height: 12),
          const Text(
            'Dados: Open-Meteo (open-meteo.com). Regra de risco simplificada '
            'do protótipo: 20 mm no dia = atenção; 50 mm com chance de 50% '
            'ou mais = risco alto.',
            style: TextStyle(fontSize: 13, color: AppColors.textoSecundario),
          ),
        ],
      ),
    );
  }
}

class _DiaCard extends StatelessWidget {
  final PrevisaoDia dia;

  const _DiaCard({required this.dia});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                iconeDoTempo(dia.codigoTempo),
                size: 32,
                color: corDoRisco(dia.risco),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatarDia(dia.data),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          formatarChuva(dia.chuvaMm),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${dia.descricaoTempo} · ${dia.probabilidade}% de chance',
                      style: const TextStyle(color: AppColors.textoSecundario),
                    ),
                    const SizedBox(height: 8),
                    Selo(
                      texto: dia.risco.rotulo,
                      icone: iconeDoRisco(dia.risco),
                      cor: corDoRisco(dia.risco),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
