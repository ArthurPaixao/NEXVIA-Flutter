import 'dart:async';

import 'package:flutter/material.dart';

import '../models/dica_preparo.dart';
import '../theme/app_colors.dart';

class BannerCarrossel extends StatefulWidget {
  final List<DicaPreparo> dicas;

  const BannerCarrossel({super.key, required this.dicas});

  @override
  State<BannerCarrossel> createState() => _BannerCarrosselState();
}

class _BannerCarrosselState extends State<BannerCarrossel> {
  static const Duration _intervalo = Duration(seconds: 6);

  final PageController _pageController = PageController();

  Timer? _timer;

  int _paginaAtual = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_intervalo, (_) => _avancar());
  }

  void _avancar() {
    if (!_pageController.hasClients || widget.dicas.length < 2) return;

    final proxima = (_paginaAtual + 1) % widget.dicas.length;

    _pageController.animateToPage(
      proxima,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dicas.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.dicas.length,
            onPageChanged: (pagina) {
              setState(() {
                _paginaAtual = pagina;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: _BannerPagina(dica: widget.dicas[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.dicas.length, (indice) {
            final ativo = indice == _paginaAtual;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: ativo ? 22 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: ativo ? AppColors.asfalto : AppColors.borda,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}

class _BannerPagina extends StatelessWidget {
  final DicaPreparo dica;

  const _BannerPagina({required this.dica});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            dica.imagemUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progresso) {
              if (progresso == null) return child;

              return Container(
                color: AppColors.asfalto,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: AppColors.faixaAmarela,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.asfalto,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.all(16),
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              );
            },
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x14000000), Color(0x8C121416), Color(0xF2121416)],
                stops: [0.0, 0.45, 1],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dica.titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dica.descricao,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  dica.credito,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
