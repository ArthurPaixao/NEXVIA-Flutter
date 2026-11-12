import 'package:flutter/material.dart';

import '../data/locais_monitorados.dart';
import '../models/estado_carregamento.dart';
import '../models/previsao_local.dart';
import '../services/previsao_service.dart';
import '../theme/app_colors.dart';
import '../utils/formatadores.dart';
import '../widgets/mensagem_estado.dart';
import '../widgets/previsao_card.dart';
import 'previsao_detalhe_screen.dart';

class PrevisaoScreen extends StatefulWidget {
  const PrevisaoScreen({super.key});

  @override
  State<PrevisaoScreen> createState() => _PrevisaoScreenState();
}

class _PrevisaoScreenState extends State<PrevisaoScreen> {
  final PrevisaoService _previsaoService = PrevisaoService();

  EstadoCarregamento _estado = EstadoCarregamento.inicial;

  List<PrevisaoLocal> _previsoes = [];

  String _mensagemErro = '';

  DateTime? _atualizadoEm;

  final TextEditingController _buscaController = TextEditingController();

  String _busca = '';

  Future<void> _carregarPrevisoes() async {
    setState(() {
      _estado = EstadoCarregamento.carregando;
    });

    try {
      final previsoes =
          await _previsaoService.buscarPrevisoes(locaisMonitorados);

      if (!mounted) return;

      setState(() {
        _previsoes = PrevisaoService.ordenarPorRisco(previsoes);
        _atualizadoEm = DateTime.now();
        _estado = EstadoCarregamento.sucesso;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _mensagemErro = error.toString();
        _estado = EstadoCarregamento.erro;
      });
    }
  }

  void _abrirDetalhe(PrevisaoLocal previsao) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PrevisaoDetalheScreen(previsao: previsao);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previsão de chuva'),
        actions: [
          if (_estado == EstadoCarregamento.sucesso)
            IconButton(
              onPressed: _carregarPrevisoes,
              tooltip: 'Atualizar',
              icon: const Icon(Icons.refresh),
            ),
        ],
      ),
      body: _construirConteudo(),
    );
  }

  Widget _construirConteudo() {
    switch (_estado) {
      case EstadoCarregamento.inicial:
        return MensagemEstado(
          icone: Icons.cloud_outlined,
          titulo: 'Previsão por município',
          descricao:
              'Consulte a chuva prevista para os próximos dias em '
              '${locaisMonitorados.length} municípios com histórico de enchentes '
              'e deslizamentos.',
          textoBotao: 'Consultar previsão',
          iconeBotao: Icons.cloud_download_outlined,
          onPressed: _carregarPrevisoes,
        );

      case EstadoCarregamento.carregando:
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Consultando o Open-Meteo...'),
            ],
          ),
        );

      case EstadoCarregamento.erro:
        return MensagemEstado(
          icone: Icons.wifi_off_rounded,
          cor: AppColors.vermelhoAguardando,
          titulo: 'Não foi possível carregar',
          descricao: _mensagemErro,
          textoBotao: 'Tentar novamente',
          iconeBotao: Icons.refresh,
          onPressed: _carregarPrevisoes,
        );

      case EstadoCarregamento.sucesso:
        final visiveis = PrevisaoService.filtrar(_previsoes, _busca);

        return RefreshIndicator(
          onRefresh: _carregarPrevisoes,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            itemCount: visiveis.length + 1,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 12);
            },
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _buscaController,
                      textInputAction: TextInputAction.search,
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      onChanged: (valor) {
                        setState(() {
                          _busca = valor;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Buscar município ou UF',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _busca.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  _buscaController.clear();
                                  setState(() {
                                    _busca = '';
                                  });
                                },
                                tooltip: 'Limpar busca',
                                icon: const Icon(Icons.close),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _Cabecalho(atualizadoEm: _atualizadoEm),
                    if (visiveis.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 32),
                        child: Center(
                          child: Text(
                            'Nenhum município monitorado com esse nome.',
                            style: TextStyle(color: AppColors.textoSecundario),
                          ),
                        ),
                      ),
                  ],
                );
              }

              final previsao = visiveis[index - 1];

              return PrevisaoCard(
                previsao: previsao,
                onTap: () => _abrirDetalhe(previsao),
              );
            },
          ),
        );
    }
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }
}

class _Cabecalho extends StatelessWidget {
  final DateTime? atualizadoEm;

  const _Cabecalho({required this.atualizadoEm});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.info_outline,
          size: 18,
          color: AppColors.textoSecundario,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            atualizadoEm == null
                ? 'Risco calculado sobre os próximos 3 dias.'
                : 'Risco dos próximos 3 dias · atualizado às '
                    '${formatarHora(atualizadoEm!)}',
            style: const TextStyle(color: AppColors.textoSecundario),
          ),
        ),
      ],
    );
  }
}
