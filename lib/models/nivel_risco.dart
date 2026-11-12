enum NivelRisco {
  baixo('Risco baixo', 'Chuva fraca ou ausente.'),
  atencao('Atenção', 'Chuva moderada: revise os planos de saída.'),
  alto('Risco alto', 'Chuva forte: prepare o acionamento dos padrinhos.');

  final String rotulo;
  final String orientacao;

  const NivelRisco(this.rotulo, this.orientacao);

  static const double limiteAtencaoMm = 20;
  static const double limiteAltoMm = 50;

  static NivelRisco calcular(double chuvaMm, int probabilidade) {
    if (chuvaMm >= limiteAltoMm && probabilidade >= 50) {
      return NivelRisco.alto;
    }

    if (chuvaMm >= limiteAtencaoMm) {
      return NivelRisco.atencao;
    }

    return NivelRisco.baixo;
  }
}
