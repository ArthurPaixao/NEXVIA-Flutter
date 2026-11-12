import 'package:flutter/material.dart';

import '../models/pessoa.dart';
import '../theme/app_colors.dart';
import 'anel_progresso.dart';

class ContadorCard extends StatelessWidget {
  final int faltam;
  final int total;

  final Map<StatusPessoa, int>? porStatus;

  const ContadorCard({
    super.key,
    required this.faltam,
    required this.total,
    this.porStatus,
  });

  @override
  Widget build(BuildContext context) {
    final seguras = total - faltam;
    final progresso = total == 0 ? 0.0 : seguras / total;
    final todosSeguros = total > 0 && faltam == 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.asfalto, Color(0xFF2E343B)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'QUEM AINDA FALTA',
            style: TextStyle(
              color: AppColors.faixaAmarela,
              fontSize: 13,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              AnelProgresso(
                progresso: progresso,
                cor: AppColors.verdeSeguroNoite,
                corFundo: Colors.white.withValues(alpha: 0.12),
                centro: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(end: faltam.toDouble()),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOutCubic,
                      builder: (context, valor, child) {
                        return Text(
                          '${valor.round()}',
                          style: TextStyle(
                            color: todosSeguros
                                ? AppColors.verdeSeguroNoite
                                : Colors.white,
                            fontSize: 48,
                            height: 1,
                            fontWeight: FontWeight.w900,
                          ),
                        );
                      },
                    ),
                    Text(
                      faltam == 1 ? 'falta' : 'faltam',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todosSeguros
                          ? 'Todos em segurança'
                          : faltam == 1
                              ? '1 pessoa ainda não está segura'
                              : '$faltam pessoas ainda não estão seguras',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$seguras de $total em segurança',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (porStatus != null) ...[
            const SizedBox(height: 18),
            Row(
              children: [
                _Etapa(
                  rotulo: 'Aguardando',
                  quantidade: porStatus![StatusPessoa.aguardando] ?? 0,
                  cor: AppColors.vermelhoAguardandoNoite,
                  icone: Icons.warning_rounded,
                ),
                const SizedBox(width: 8),
                _Etapa(
                  rotulo: 'A caminho',
                  quantidade: porStatus![StatusPessoa.aCaminho] ?? 0,
                  cor: AppColors.azulACaminhoNoite,
                  icone: Icons.directions_walk_rounded,
                ),
                const SizedBox(width: 8),
                _Etapa(
                  rotulo: 'Seguros',
                  quantidade: porStatus![StatusPessoa.seguro] ?? 0,
                  cor: AppColors.verdeSeguroNoite,
                  icone: Icons.check_circle_rounded,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Etapa extends StatelessWidget {
  final String rotulo;
  final int quantidade;
  final Color cor;
  final IconData icone;

  const _Etapa({
    required this.rotulo,
    required this.quantidade,
    required this.cor,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cor.withValues(alpha: 0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icone, size: 18, color: cor),
                const SizedBox(width: 6),
                Text(
                  '$quantidade',
                  style: TextStyle(
                    color: cor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              rotulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
