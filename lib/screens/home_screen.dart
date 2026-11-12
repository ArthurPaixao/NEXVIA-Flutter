import 'package:flutter/material.dart';

import '../data/dicas_preparo.dart';
import '../models/pessoa.dart';
import '../services/pessoa_service.dart';
import '../theme/app_colors.dart';
import '../utils/formatadores.dart';
import '../widgets/atalho_card.dart';
import '../widgets/banner_carrossel.dart';
import '../widgets/contador_card.dart';
import '../widgets/logo_nexvia.dart';
import '../widgets/prioritarias_section.dart';
import 'painel_screen.dart';
import 'pessoa_detalhe_screen.dart';
import 'pessoa_form_screen.dart';
import 'previsao_screen.dart';
import 'sobre_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PessoaService _pessoaService = PessoaService();

  List<Pessoa> _pessoas = [];

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

  Future<void> _abrirTela(Widget tela) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return tela;
        },
      ),
    );

    _carregarPessoas();
  }

  Future<void> _cadastrar() async {
    final nova = await Navigator.push<Pessoa>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const PessoaFormScreen();
        },
      ),
    );

    await _carregarPessoas();

    if (nova == null) return;

    _mostrarMensagem('Cadastro de ${nova.nome} salvo com plano de saída.');
  }

  Future<void> _confirmarNovoSimulado() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.restart_alt),
          title: const Text('Começar novo simulado?'),
          content: const Text(
            'Todas as pessoas voltam para "Aguardando ajuda". '
            'Os cadastros não são apagados.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Começar'),
            ),
          ],
        );
      },
    );

    if (confirmado != true) return;

    await _pessoaService.iniciarNovoSimulado();
    await _carregarPessoas();

    _mostrarMensagem('Novo simulado iniciado.');
  }

  void _mostrarMensagem(String texto) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    final faltam = PessoaService.contarFaltam(_pessoas);
    final porStatus = PessoaService.contarPorStatus(_pessoas);
    final prioritarias = PessoaService.prioritariasPendentes(_pessoas);
    final agora = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            LogoNexvia(tamanho: 36),
            SizedBox(width: 12),
            Text(
              'NEXVIA',
              style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _abrirTela(const SobreScreen()),
            tooltip: 'Sobre o app',
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _carregarPessoas,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                children: [
                  Text(
                    '${saudacao(agora)}!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '${formatarDataLonga(agora)} · ninguém fica para trás',
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textoSecundario,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ContadorCard(
                    faltam: faltam,
                    total: _pessoas.length,
                    porStatus: porStatus,
                  ),
                  const SizedBox(height: 24),

                  const _TituloSecao(titulo: 'Ações rápidas'),
                  GridView.count(
                    crossAxisCount: 2,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.45,
                    children: [
                      AtalhoCard(
                        icone: Icons.people_alt_outlined,
                        titulo: 'Abrir o painel',
                        subtitulo: '$faltam ainda faltam',
                        destaque: true,
                        onTap: () => _abrirTela(const PainelScreen()),
                      ),
                      AtalhoCard(
                        icone: Icons.water_drop_outlined,
                        titulo: 'Previsão',
                        subtitulo: 'Chuva em 6 municípios',
                        onTap: () => _abrirTela(const PrevisaoScreen()),
                      ),
                      AtalhoCard(
                        icone: Icons.person_add_alt_1_outlined,
                        titulo: 'Cadastrar',
                        subtitulo: 'Novo plano de saída',
                        onTap: _cadastrar,
                      ),
                      AtalhoCard(
                        icone: Icons.restart_alt,
                        titulo: 'Novo simulado',
                        subtitulo: 'Treinar o bairro',
                        onTap: _confirmarNovoSimulado,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _TituloSecao(
                    titulo: 'Prioridades agora',
                    acao: 'Ver painel',
                    onAcao: () => _abrirTela(const PainelScreen()),
                  ),
                  PrioritariasSection(
                    pessoas: prioritarias,
                    onTap: (pessoa) =>
                        _abrirTela(PessoaDetalheScreen(pessoa: pessoa)),
                  ),
                  const SizedBox(height: 24),

                  const _TituloSecao(titulo: 'Prepare o bairro'),
                  const BannerCarrossel(dicas: dicasPreparo),
                ],
              ),
            ),
    );
  }
}

class _TituloSecao extends StatelessWidget {
  final String titulo;
  final String? acao;
  final VoidCallback? onAcao;

  const _TituloSecao({required this.titulo, this.acao, this.onAcao});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              titulo,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          if (acao != null && onAcao != null)
            TextButton(onPressed: onAcao, child: Text(acao!)),
        ],
      ),
    );
  }
}
