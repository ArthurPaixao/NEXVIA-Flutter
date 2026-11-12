import 'package:flutter/material.dart';

import '../models/filtro_painel.dart';
import '../models/pessoa.dart';
import '../services/pessoa_service.dart';
import '../theme/app_colors.dart';
import '../widgets/mensagem_estado.dart';
import '../widgets/pessoa_card.dart';
import 'pessoa_detalhe_screen.dart';
import 'pessoa_form_screen.dart';

class PainelScreen extends StatefulWidget {
  const PainelScreen({super.key});

  @override
  State<PainelScreen> createState() => _PainelScreenState();
}

class _PainelScreenState extends State<PainelScreen> {
  final PessoaService _pessoaService = PessoaService();

  final TextEditingController _buscaController = TextEditingController();

  List<Pessoa> _pessoas = [];

  FiltroPainel _filtro = FiltroPainel.todas;

  String _busca = '';

  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPessoas();
  }

  Future<void> _carregarPessoas() async {
    final pessoas = await _pessoaService.listar();

    if (!mounted) return;

    setState(() {
      _pessoas = pessoas;
      _carregando = false;
    });
  }

  Future<void> _abrirDetalhe(Pessoa pessoa) async {
    FocusScope.of(context).unfocus();

    final excluida = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PessoaDetalheScreen(pessoa: pessoa);
        },
      ),
    );

    await _carregarPessoas();

    if (excluida == true) {
      _mostrarMensagem('Cadastro de ${pessoa.nome} excluído.');
    }
  }

  Future<void> _cadastrar() async {
    FocusScope.of(context).unfocus();

    final nova = await Navigator.push<Pessoa>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const PessoaFormScreen();
        },
      ),
    );

    if (nova == null) return;

    await _carregarPessoas();
    _mostrarMensagem('Cadastro de ${nova.nome} salvo com plano de saída.');
  }

  Future<void> _alternarPrioridade(Pessoa pessoa) async {
    final atualizada = await _pessoaService.alternarPrioridade(pessoa);
    await _carregarPessoas();

    _mostrarMensagem(
      atualizada.prioritaria
          ? 'Prioridade marcada para ${atualizada.nome}.'
          : 'Prioridade removida de ${atualizada.nome}.',
    );
  }

  Future<void> _avancarStatus(Pessoa pessoa) async {
    final atualizada = await _pessoaService.avancarStatus(pessoa);
    await _carregarPessoas();

    _mostrarMensagem(
      atualizada.status == StatusPessoa.aCaminho
          ? 'SMS simulado enviado para ${atualizada.padrinho}.'
          : '${atualizada.nome} está em segurança.',
    );
  }

  void _mostrarMensagem(String texto) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  void _limparBusca() {
    _buscaController.clear();

    setState(() {
      _busca = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final visiveis = PessoaService.filtrar(_pessoas, _filtro, _busca);
    final faltam = PessoaService.contarFaltam(_pessoas);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quem ainda falta'),
        actions: [
          IconButton(
            onPressed: _carregarPessoas,
            tooltip: 'Atualizar',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _cadastrar,
        backgroundColor: AppColors.asfalto,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1_outlined),
        label: const Text('Cadastrar'),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    controller: _buscaController,
                    textInputAction: TextInputAction.search,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    onChanged: (valor) {
                      setState(() {
                        _busca = valor;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Buscar por nome, rua ou padrinho',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _busca.isEmpty
                          ? null
                          : IconButton(
                              onPressed: _limparBusca,
                              tooltip: 'Limpar busca',
                              icon: const Icon(Icons.close),
                            ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: FiltroPainel.values.map((filtro) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filtro.rotulo),
                          selected: _filtro == filtro,
                          selectedColor: AppColors.faixaAmarela,
                          onSelected: (_) {
                            setState(() {
                              _filtro = filtro;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Row(
                    children: [
                      Text(
                        '$faltam de ${_pessoas.length} ainda faltam',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${visiveis.length} na lista',
                        style: const TextStyle(
                          color: AppColors.textoSecundario,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: visiveis.isEmpty
                      ? MensagemEstado(
                          icone: Icons.search_off,
                          titulo: 'Ninguém encontrado',
                          descricao:
                              'Nenhuma pessoa combina com a busca e o filtro escolhidos.',
                          textoBotao: 'Mostrar todas',
                          iconeBotao: Icons.filter_alt_off_outlined,
                          onPressed: () {
                            _limparBusca();
                            setState(() {
                              _filtro = FiltroPainel.todas;
                            });
                          },
                        )
                      : RefreshIndicator(
                          onRefresh: _carregarPessoas,
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                            itemCount: visiveis.length,
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 12);
                            },
                            itemBuilder: (context, index) {
                              final pessoa = visiveis[index];

                              return PessoaCard(
                                pessoa: pessoa,
                                onTap: () => _abrirDetalhe(pessoa),
                                onAlternarPrioridade: () =>
                                    _alternarPrioridade(pessoa),
                                onAvancarStatus: () => _avancarStatus(pessoa),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }
}
