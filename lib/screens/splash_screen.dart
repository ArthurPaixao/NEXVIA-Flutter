import 'package:flutter/material.dart';

import '../services/preferences_service.dart';
import '../theme/app_colors.dart';
import '../widgets/logo_nexvia.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Duration _tempoDeExibicao = Duration(seconds: 2);

  final PreferencesService _preferencesService = PreferencesService();

  @override
  void initState() {
    super.initState();
    _decidirProximaTela();
  }

  Future<void> _decidirProximaTela() async {
    final resultados = await Future.wait([
      _preferencesService.getNaoMostrarIntroducao(),
      Future.delayed(_tempoDeExibicao),
    ]);

    final naoMostrarIntroducao = resultados.first as bool;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return naoMostrarIntroducao
              ? const HomeScreen()
              : const OnboardingScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.asfalto,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LogoNexvia(tamanho: 140),
            SizedBox(height: 28),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'NEX', style: TextStyle(color: Colors.white)),
                  TextSpan(
                    text: 'VIA',
                    style: TextStyle(color: AppColors.faixaAmarela),
                  ),
                ],
              ),
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Ninguém fica para trás',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.faixaAmarela,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
