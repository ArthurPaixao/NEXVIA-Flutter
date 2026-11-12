import 'nivel_risco.dart';

class PrevisaoDia {
  final DateTime data;
  final double chuvaMm;
  final int probabilidade;
  final int codigoTempo;

  PrevisaoDia({
    required this.data,
    required this.chuvaMm,
    required this.probabilidade,
    required this.codigoTempo,
  });

  NivelRisco get risco => NivelRisco.calcular(chuvaMm, probabilidade);

  String get descricaoTempo {
    if (codigoTempo == 0) return 'Céu limpo';
    if (codigoTempo <= 3) return 'Parcialmente nublado';
    if (codigoTempo <= 48) return 'Neblina';
    if (codigoTempo <= 57) return 'Garoa';
    if (codigoTempo <= 67) return 'Chuva';
    if (codigoTempo <= 77) return 'Neve';
    if (codigoTempo <= 82) return 'Pancadas de chuva';
    return 'Tempestade';
  }
}
