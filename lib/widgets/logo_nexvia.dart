import 'package:flutter/material.dart';

class LogoNexvia extends StatelessWidget {
  static const String heroTag = 'logo-nexvia';

  final double tamanho;

  const LogoNexvia({super.key, this.tamanho = 120});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Semantics(
        label: 'Logotipo do NEXVIA',
        image: true,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(tamanho * 0.22),
          child: Image.asset(
            'assets/images/logo.png',
            width: tamanho,
            height: tamanho,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
