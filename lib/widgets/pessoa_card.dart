import 'package:flutter/material.dart';

import '../models/pessoa.dart';
import '../theme/app_colors.dart';
import '../utils/formatadores.dart';
import 'selo.dart';
import 'status_visual.dart';

class PessoaCard extends StatelessWidget {
  final Pessoa pessoa;
  final VoidCallback onTap;
  final VoidCallback onAlternarPrioridade;
  final VoidCallback onAvancarStatus;

  const PessoaCard({
    super.key,
    required this.pessoa,
    required this.onTap,
    required this.onAlternarPrioridade,
    required this.onAvancarStatus,
  });

  @override
  Widget build(BuildContext context) {
    final acao = pessoa.status.acao;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: corDoStatus(pessoa.status), width: 6),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pessoa.nome,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${pessoa.necessidade} · ${pessoa.idade} anos',
                          style: const TextStyle(
                            color: AppColors.textoSecundario,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onAlternarPrioridade,
                    tooltip: pessoa.prioritaria
                        ? 'Remover prioridade'
                        : 'Marcar como prioritária',
                    icon: Icon(
                      pessoa.prioritaria
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: pessoa.prioritaria
                          ? AppColors.laranjaAtencao
                          : AppColors.textoSecundario,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: AppColors.textoSecundario,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      pessoa.endereco,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: Selo(
                      texto:
                          '${pessoa.status.rotulo} · ${formatarHora(pessoa.statusDesde)}',
                      icone: iconeDoStatus(pessoa.status),
                      cor: corDoStatus(pessoa.status),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (acao != null)
                    TextButton(
                      onPressed: onAvancarStatus,
                      child: Text(
                        pessoa.status == StatusPessoa.aguardando
                            ? 'Acionar'
                            : 'Seguro',
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
