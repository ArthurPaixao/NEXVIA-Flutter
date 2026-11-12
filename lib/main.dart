import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const NexviaApp());
}

class NexviaApp extends StatelessWidget {
  const NexviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NEXVIA',
      theme: AppTheme.tema,
      home: const SplashScreen(),
    );
  }
}
