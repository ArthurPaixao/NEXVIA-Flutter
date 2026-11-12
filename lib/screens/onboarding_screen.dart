import 'package:flutter/material.dart';

import '../services/preferences_service.dart';
import '../theme/app_colors.dart';
import '../widgets/pagina_introducao.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const Duration _duracaoTransicao = Duration(milliseconds: 300);

  static const List<PaginaIntroducao> _paginas = [
    PaginaIntroducao(
      icone: Icons.campaign_outlined,
      titulo: 'O alerta avisa',
      descricao:
          'Quando a chuva aperta, o alerta da Defesa Civil chega ao celular. '
          'Mas ninguém fica sabendo quem conseguiu sair de casa.',
    ),
    PaginaIntroducao(
      icone: Icons.volunteer_activism_outlined,
      titulo: 'Cada pessoa tem um padrinho',
      descricao:
          'Acamados, idosos que moram sozinhos e pessoas com deficiência têm '
          'um plano de saída: um vizinho que vai buscá-los, um reserva e um '
          'destino seguro.',
    ),
    PaginaIntroducao(
      icone: Icons.fact_check_outlined,
      titulo: 'Ninguém fica para trás',
      descricao:
          'Acompanhe a previsão de chuva e o painel "quem ainda falta" até o '
          'número chegar a zero.',
    ),
  ];

  final PageController _pageController = PageController();

  final PreferencesService _preferencesService = PreferencesService();

  int _paginaAtual = 0;

  bool _naoMostrarNovamente = false;

  bool get _ehUltimaPagina => _paginaAtual == _paginas.length - 1;

  void _voltar() {
    _pageController.previousPage(
      duration: _duracaoTransicao,
      curve: Curves.easeOut,
    );
  }

  void _avancar() {
    if (_ehUltimaPagina) {
      _concluir();
      return;
    }

    _pageController.nextPage(
      duration: _duracaoTransicao,
      curve: Curves.easeOut,
    );
  }

  Future<void> _concluir() async {
    await _preferencesService.saveNaoMostrarIntroducao(_naoMostrarNovamente);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const HomeScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _concluir,
                child: const Text('Pular'),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (pagina) {
                  setState(() {
                    _paginaAtual = pagina;
                  });
                },
                children: _paginas,
              ),
            ),
            _IndicadorPaginas(
              total: _paginas.length,
              atual: _paginaAtual,
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: _naoMostrarNovamente,
              onChanged: (valor) {
                setState(() {
                  _naoMostrarNovamente = valor ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              activeColor: AppColors.asfalto,
              title: const Text('Não mostrar novamente'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _paginaAtual == 0 ? null : _voltar,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Voltar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _avancar,
                      icon: Icon(
                        _ehUltimaPagina ? Icons.check : Icons.arrow_forward,
                      ),
                      label: Text(_ehUltimaPagina ? 'Começar' : 'Avançar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class _IndicadorPaginas extends StatelessWidget {
  final int total;
  final int atual;

  const _IndicadorPaginas({required this.total, required this.atual});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Página ${atual + 1} de $total',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(total, (indice) {
          final ativo = indice == atual;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: ativo ? 28 : 10,
            height: 10,
            decoration: BoxDecoration(
              color: ativo ? AppColors.asfalto : AppColors.borda,
              borderRadius: BorderRadius.circular(5),
            ),
          );
        }),
      ),
    );
  }
}
