import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/logo_nexvia.dart';
import '../widgets/secao_card.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  static const List<String> _ods = [
    'ODS 11 · Cidades e comunidades sustentáveis (meta 11.5)',
    'ODS 13 · Ação contra a mudança global do clima (meta 13.1)',
    'ODS 10 · Redução das desigualdades (meta 10.2)',
    'ODS 3 · Saúde e bem-estar (meta 3.d)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre o NEXVIA')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(child: LogoNexvia(tamanho: 96)),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'NEXVIA',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text(
              'O alerta avisa. O bairro garante que ninguém fique para trás.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textoSecundario),
            ),
          ),
          const SizedBox(height: 20),
          const SecaoCard(
            titulo: 'O problema',
            children: [
              Text(
                'O alerta da Defesa Civil avisa quem está na área de risco, '
                'mas não sabe quem conseguiu sair de casa. Acamados, idosos '
                'que moram sozinhos e pessoas com deficiência dependem de '
                'alguém para agir.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SecaoCard(
            titulo: 'Equipe RiskLess',
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.person_outline),
                title: Text('Arthur Paixão'),
                subtitle: Text('RM 551739'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.person_outline),
                title: Text('Vinicius Fagundes da Silva'),
                subtitle: Text('RM 555270'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SecaoCard(
            titulo: 'Objetivos de Desenvolvimento Sustentável',
            children: _ods.map((ods) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.public,
                      size: 20,
                      color: AppColors.verdeSeguro,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(ods)),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const SecaoCard(
            titulo: 'Aviso',
            children: [
              Text(
                'Protótipo acadêmico da Global Solution FIAP 2026.2. Funciona '
                'em modo simulado: não envia SMS nem se integra à Defesa '
                'Civil. As pessoas cadastradas são fictícias. A previsão de '
                'chuva vem da API pública do Open-Meteo, e as fotos do '
                'carrossel são do Wikimedia Commons, com licença livre.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
