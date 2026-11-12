String _doisDigitos(int valor) => valor.toString().padLeft(2, '0');

String formatarHora(DateTime data) {
  return '${_doisDigitos(data.hour)}:${_doisDigitos(data.minute)}';
}

const List<String> _diasDaSemana = [
  'segunda',
  'terça',
  'quarta',
  'quinta',
  'sexta',
  'sábado',
  'domingo',
];

String formatarDia(DateTime data) {
  final semana = _diasDaSemana[data.weekday - 1];
  return '$semana, ${_doisDigitos(data.day)}/${_doisDigitos(data.month)}';
}

String formatarTelefone(String texto) {
  final digitos = texto.replaceAll(RegExp(r'\D'), '');

  if (digitos.length == 11) {
    return '(${digitos.substring(0, 2)}) ${digitos.substring(2, 7)}-${digitos.substring(7)}';
  }

  if (digitos.length == 10) {
    return '(${digitos.substring(0, 2)}) ${digitos.substring(2, 6)}-${digitos.substring(6)}';
  }

  return texto;
}

String saudacao(DateTime agora) {
  if (agora.hour >= 5 && agora.hour < 12) return 'Bom dia';
  if (agora.hour >= 12 && agora.hour < 18) return 'Boa tarde';
  return 'Boa noite';
}

const List<String> _meses = [
  'janeiro',
  'fevereiro',
  'março',
  'abril',
  'maio',
  'junho',
  'julho',
  'agosto',
  'setembro',
  'outubro',
  'novembro',
  'dezembro',
];

String formatarDataLonga(DateTime data) {
  final semana = _diasDaSemana[data.weekday - 1];
  return '$semana, ${data.day} de ${_meses[data.month - 1]}';
}

String normalizarTexto(String texto) {
  const comAcento = 'áàâãäéèêëíìîïóòôõöúùûüç';
  const semAcento = 'aaaaaeeeeiiiiooooouuuuc';

  final minusculo = texto.toLowerCase().trim();
  final buffer = StringBuffer();

  for (final letra in minusculo.split('')) {
    final indice = comAcento.indexOf(letra);
    buffer.write(indice >= 0 ? semAcento[indice] : letra);
  }

  return buffer.toString();
}

String formatarChuva(double milimetros) {
  return '${milimetros.toStringAsFixed(1).replaceAll('.', ',')} mm';
}
