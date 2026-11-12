import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nexvia/data/locais_monitorados.dart';
import 'package:nexvia/models/nivel_risco.dart';
import 'package:nexvia/services/previsao_service.dart';

Map<String, dynamic> _resposta(List<double?> chuvas) {
  return {
    'daily': {
      'time': ['2026-11-10', '2026-11-11', '2026-11-12'],
      'precipitation_sum': chuvas,
      'precipitation_probability_max': [90, 80, null],
      'weather_code': [63, 95, 0],
    },
  };
}

void main() {
  group('NivelRisco.calcular', () {
    test('classifica pelos limites de chuva', () {
      expect(NivelRisco.calcular(5, 90), NivelRisco.baixo);
      expect(NivelRisco.calcular(25, 40), NivelRisco.atencao);
      expect(NivelRisco.calcular(60, 80), NivelRisco.alto);
      expect(NivelRisco.calcular(60, 20), NivelRisco.atencao);
    });
  });

  group('PrevisaoService', () {
    final locais = locaisMonitorados.take(2).toList();

    test('converte a lista JSON em PrevisaoLocal', () async {
      final client = MockClient((request) async {
        expect(request.url.host, 'api.open-meteo.com');
        expect(request.url.queryParameters['latitude'], contains(','));

        return http.Response(
          jsonEncode([
            _resposta([2, 1, 0]),
            _resposta([30, 70, null]),
          ]),
          200,
        );
      });

      final service = PrevisaoService(client: client);
      final previsoes = await service.buscarPrevisoes(locais);

      expect(previsoes.length, 2);
      expect(previsoes[0].local.nome, locais[0].nome);
      expect(previsoes[0].maiorRisco, NivelRisco.baixo);
      expect(previsoes[1].maiorRisco, NivelRisco.alto);
      expect(previsoes[1].dias.last.chuvaMm, 0);
      expect(previsoes[1].chuvaProximosDias, 100);
    });

    test('ordena por risco e filtra por município sem acento', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode([
            _resposta([2, 1, 0]),
            _resposta([30, 70, null]),
          ]),
          200,
        );
      });

      final previsoes =
          await PrevisaoService(client: client).buscarPrevisoes(locais);
      final ordenadas = PrevisaoService.ordenarPorRisco(previsoes);

      expect(ordenadas.first.maiorRisco, NivelRisco.alto);
      expect(PrevisaoService.filtrar(ordenadas, 'petropolis').length, 1);
      expect(PrevisaoService.filtrar(ordenadas, 'MG').length, 1);
      expect(PrevisaoService.filtrar(ordenadas, '').length, 2);
    });

    test('lança PrevisaoException quando a API responde com erro', () async {
      final client = MockClient((request) async => http.Response('', 500));
      final service = PrevisaoService(client: client);

      expect(
        service.buscarPrevisoes(locais),
        throwsA(isA<PrevisaoException>()),
      );
    });

    test('lança PrevisaoException sem conexão', () async {
      final client = MockClient((request) async {
        throw http.ClientException('sem rede');
      });
      final service = PrevisaoService(client: client);

      expect(
        service.buscarPrevisoes(locais),
        throwsA(isA<PrevisaoException>()),
      );
    });
  });
}
