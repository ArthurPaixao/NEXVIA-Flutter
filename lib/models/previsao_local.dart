import 'local_monitorado.dart';
import 'nivel_risco.dart';
import 'previsao_dia.dart';

class PrevisaoLocal {
  final LocalMonitorado local;
  final List<PrevisaoDia> dias;

  PrevisaoLocal({
    required this.local,
    required this.dias,
  });

  factory PrevisaoLocal.fromJson(
    Map<String, dynamic> json,
    LocalMonitorado local,
  ) {
    final daily = json['daily'] as Map<String, dynamic>? ?? {};

    final datas = List<dynamic>.from(daily['time'] ?? []);
    final chuvas = List<dynamic>.from(daily['precipitation_sum'] ?? []);
    final probabilidades =
        List<dynamic>.from(daily['precipitation_probability_max'] ?? []);
    final codigos = List<dynamic>.from(daily['weather_code'] ?? []);

    final dias = <PrevisaoDia>[];

    for (var i = 0; i < datas.length; i++) {
      dias.add(
        PrevisaoDia(
          data: DateTime.parse(datas[i] as String),
          chuvaMm: _numero(chuvas, i).toDouble(),
          probabilidade: _numero(probabilidades, i).round(),
          codigoTempo: _numero(codigos, i).round(),
        ),
      );
    }

    return PrevisaoLocal(local: local, dias: dias);
  }

  static num _numero(List<dynamic> valores, int indice) {
    if (indice >= valores.length) return 0;
    return valores[indice] as num? ?? 0;
  }

  PrevisaoDia? get hoje => dias.isEmpty ? null : dias.first;

  List<PrevisaoDia> get proximosDias => dias.take(3).toList();

  double get chuvaProximosDias {
    return proximosDias.fold(0, (total, dia) => total + dia.chuvaMm);
  }

  NivelRisco get maiorRisco {
    var maior = NivelRisco.baixo;

    for (final dia in proximosDias) {
      if (dia.risco.index > maior.index) {
        maior = dia.risco;
      }
    }

    return maior;
  }
}
