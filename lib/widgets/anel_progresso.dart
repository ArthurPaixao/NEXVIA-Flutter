import 'package:flutter/material.dart';

class AnelProgresso extends StatelessWidget {
  final double progresso;
  final double tamanho;
  final Color cor;
  final Color corFundo;
  final Widget centro;

  const AnelProgresso({
    super.key,
    required this.progresso,
    required this.centro,
    required this.cor,
    required this.corFundo,
    this.tamanho = 132,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: tamanho,
      height: tamanho,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: tamanho,
            height: tamanho,
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: progresso.clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, valor, child) {
                return CircularProgressIndicator(
                  value: valor,
                  strokeWidth: 12,
                  strokeCap: StrokeCap.round,
                  backgroundColor: corFundo,
                  color: cor,
                );
              },
            ),
          ),
          centro,
        ],
      ),
    );
  }
}
