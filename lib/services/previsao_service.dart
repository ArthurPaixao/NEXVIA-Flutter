import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/local_monitorado.dart';
import '../models/previsao_local.dart';
import '../utils/formatadores.dart';

class PrevisaoException implements Exception {
  final String mensagem;

  PrevisaoException(this.mensagem);

  @override
  String toString() => mensagem;
}

class PrevisaoService {
  static const String baseUrl = 'https://api.open-meteo.com';

  static const String endpoint = '/v1/forecast';

  static const Duration tempoLimite = Duration(seconds: 15);

  final http.Client _client;

  PrevisaoService({http.Client? client}) : _client = client ?? http.Client();

  Uri montarUri(List<LocalMonitorado> locais) {
    return Uri.parse('$baseUrl$endpoint').replace(
      queryParameters: {
        'latitude': locais.map((local) => local.latitude).join(','),
        'longitude': locais.map((local) => local.longitude).join(','),
        'daily':
            'precipitation_sum,precipitation_probability_max,weather_code',
        'timezone': 'America/Sao_Paulo',
        'forecast_days': '7',
      },
    );
  }

  static List<PrevisaoLocal> ordenarPorRisco(List<PrevisaoLocal> previsoes) {
    final ordenadas = List<PrevisaoLocal>.from(previsoes);

    ordenadas.sort((a, b) {
      final porRisco = b.maiorRisco.index.compareTo(a.maiorRisco.index);
      if (porRisco != 0) return porRisco;
      return b.chuvaProximosDias.compareTo(a.chuvaProximosDias);
    });

    return ordenadas;
  }

  static List<PrevisaoLocal> filtrar(
    List<PrevisaoLocal> previsoes,
    String busca,
  ) {
    final termo = normalizarTexto(busca);

    if (termo.isEmpty) return previsoes;

    return previsoes
        .where(
          (previsao) =>
              normalizarTexto(previsao.local.nomeCompleto).contains(termo),
        )
        .toList();
  }

  Future<List<PrevisaoLocal>> buscarPrevisoes(
    List<LocalMonitorado> locais,
  ) async {
    final http.Response response;

    try {
      response = await _client.get(montarUri(locais)).timeout(tempoLimite);
    } on TimeoutException {
      throw PrevisaoException(
        'O serviço de previsão demorou demais para responder.',
      );
    } catch (_) {
      throw PrevisaoException(
        'Sem conexão com o serviço de previsão. Verifique a internet.',
      );
    }

    if (response.statusCode != 200) {
      throw PrevisaoException(
        'O serviço de previsão respondeu com erro (${response.statusCode}).',
      );
    }

    try {
      final dynamic dados = jsonDecode(response.body);

      final List<dynamic> lista = dados is List ? dados : [dados];

      final previsoes = <PrevisaoLocal>[];

      for (var i = 0; i < lista.length && i < locais.length; i++) {
        previsoes.add(
          PrevisaoLocal.fromJson(lista[i] as Map<String, dynamic>, locais[i]),
        );
      }

      return previsoes;
    } catch (_) {
      throw PrevisaoException(
        'Os dados recebidos do serviço de previsão vieram num formato inesperado.',
      );
    }
  }
}
