import 'package:flutter/material.dart';

import '../models/pessoa.dart';
import '../services/pessoa_service.dart';
import '../theme/app_colors.dart';
import '../utils/formatadores.dart';
import '../widgets/info_linha.dart';
import '../widgets/secao_card.dart';
import '../widgets/status_visual.dart';
import 'pessoa_form_screen.dart';

class PessoaDetalheScreen extends StatefulWidget {
  final Pessoa pessoa;

  const PessoaDetalheScreen({super.key, required this.pessoa});

  @override
  State<PessoaDetalheScreen> createState() => _PessoaDetalheScreenState();
}

class _PessoaDetalheScreenState extends State<PessoaDetalheScreen> {
  final PessoaService _pessoaService = PessoaService();

  late Pessoa _pessoa;

  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _pessoa = widget.pessoa;
  }

  Future<void> _avancarStatus() async {
    setState(() {
      _salvando = true;
    });

    final atualizada = await _pessoaService.avancarStatus(_pessoa);

    if (!mounted) return;

    setState(() {
      _pessoa = atualizada;
      _salvando = false;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            atualizada.status == StatusPessoa.aCaminho
                ? 'SMS simulado enviado para ${atualizada.padrinho}: '
                    '"Vá até ${atualizada.endereco}."'
                : '${atualizada.nome} está em segurança.',
          ),
        ),
      );
  }

  Future<void> _alternarPrioridade() async {
    final atualizada = await _pessoaService.alternarPrioridade(_pessoa);

    if (!mounted) return;

    setState(() {
      _pessoa = atualizada;
    });
  }

  Future<void> _editar() async {
    final editada = await Navigator.push<Pessoa>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PessoaFormScreen(pessoa: _pessoa);
        },
      ),
    );

    if (editada == null || !mounted) return;

    setState(() {
      _pessoa = editada;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Cadastro atualizado.')));
  }

  Future<void> _excluir() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            Icons.delete_outline,
            color: AppColors.vermelhoAguardando,
          ),
          title: const Text('Excluir cadastro?'),
          content: Text(
            'O plano de saída de ${_pessoa.nome} será apagado deste aparelho.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.vermelhoAguardando,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmado != true) return;

    await _pessoaService.excluir(_pessoa);

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final acao = _pessoa.status.acao;
    final cor = corDoStatus(_pessoa.status);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        actions: [
          IconButton(
            onPressed: _alternarPrioridade,
            tooltip: _pessoa.prioritaria
                ? 'Remover prioridade'
                : 'Marcar como prioritária',
            icon: Icon(
              _pessoa.prioritaria
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              color: _pessoa.prioritaria ? AppColors.laranjaAtencao : null,
            ),
          ),
          IconButton(
            onPressed: _editar,
            tooltip: 'Editar cadastro',
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: _excluir,
            tooltip: 'Excluir cadastro',
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(_pessoa.nome, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            '${_pessoa.necessidade} · ${_pessoa.idade} anos',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textoSecundario,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(iconeDoStatus(_pessoa.status), color: cor, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _pessoa.status.rotulo,
                              style: TextStyle(
                                color: cor,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Desde ${formatarHora(_pessoa.statusDesde)}',
                              style: const TextStyle(
                                color: AppColors.textoSecundario,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _LinhaDoTempo(atual: _pessoa.status),
                  if (acao != null) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _salvando ? null : _avancarStatus,
                        icon: Icon(
                          _pessoa.status == StatusPessoa.aguardando
                              ? Icons.sms_outlined
                              : Icons.check_circle_outline,
                        ),
                        label: Text(acao),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SecaoCard(
            titulo: 'Plano de saída',
            children: [
              InfoLinha(
                icone: Icons.home_outlined,
                rotulo: 'Endereço',
                valor: _pessoa.endereco,
              ),
              InfoLinha(
                icone: Icons.person_outline,
                rotulo: 'Padrinho',
                valor:
                    '${_pessoa.padrinho} · ${formatarTelefone(_pessoa.telefonePadrinho)}',
              ),
              InfoLinha(
                icone: Icons.people_outline,
                rotulo: 'Padrinho reserva',
                valor: _pessoa.padrinhoReserva,
              ),
              InfoLinha(
                icone: Icons.flag_outlined,
                rotulo: 'Destino seguro',
                valor: _pessoa.destinoSeguro,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SecaoCard(
            titulo: 'Observações',
            children: [
              Text(
                _pessoa.observacoes,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LinhaDoTempo extends StatelessWidget {
  final StatusPessoa atual;

  const _LinhaDoTempo({required this.atual});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: StatusPessoa.values.map((status) {
        final alcancado = status.index <= atual.index;
        final cor = alcancado ? corDoStatus(status) : AppColors.borda;

        return Expanded(
          child: Column(
            children: [
              Container(
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: cor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                status.rotulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: status == atual ? FontWeight.w800 : null,
                  color: alcancado
                      ? AppColors.tinta
                      : AppColors.textoSecundario,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
