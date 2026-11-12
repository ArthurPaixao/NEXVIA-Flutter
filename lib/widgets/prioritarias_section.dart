import 'package:flutter/material.dart';

import '../models/pessoa.dart';
import '../theme/app_colors.dart';
import '../utils/formatadores.dart';
import 'status_visual.dart';

class PrioritariasSection extends StatelessWidget {
  final List<Pessoa> pessoas;
  final ValueChanged<Pessoa> onTap;

  const PrioritariasSection({
    super.key,
    required this.pessoas,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (pessoas.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.verdeSeguro.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.verdeSeguro),
            SizedBox(width: 10),
            Expanded(
              child: Text('Todas as pessoas prioritárias estão seguras.'),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: pessoas.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final pessoa = pessoas[index];
          final cor = corDoStatus(pessoa.status);

          return SizedBox(
            width: 210,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => onTap(pessoa),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: cor.withValues(alpha: 0.12),
                            child: Text(
                              _iniciais(pessoa.nome),
                              style: TextStyle(
                                color: cor,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.laranjaAtencao,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        pessoa.nome,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        pessoa.necessidade,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textoSecundario,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(iconeDoStatus(pessoa.status), size: 16, color: cor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${pessoa.status.rotulo} · ${formatarHora(pessoa.statusDesde)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: cor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static String _iniciais(String nome) {
    final partes = nome.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '?';
    final primeira = partes.first[0];
    final ultima = partes.length > 1 ? partes.last[0] : '';
    return (primeira + ultima).toUpperCase();
  }
}
