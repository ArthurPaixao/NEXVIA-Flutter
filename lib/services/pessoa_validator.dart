class PessoaValidator {
  static String? obrigatorio(String? valor, String campo) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe $campo.';
    }

    return null;
  }

  static String? nome(String? valor) {
    final erro = obrigatorio(valor, 'o nome');
    if (erro != null) return erro;

    if (valor!.trim().length < 3) {
      return 'O nome precisa ter pelo menos 3 letras.';
    }

    return null;
  }

  static String? idade(String? valor) {
    final erro = obrigatorio(valor, 'a idade');
    if (erro != null) return erro;

    final idade = int.tryParse(valor!.trim());

    if (idade == null || idade < 0 || idade > 120) {
      return 'Informe uma idade entre 0 e 120.';
    }

    return null;
  }

  static String? telefone(String? valor) {
    final erro = obrigatorio(valor, 'o telefone do padrinho');
    if (erro != null) return erro;

    final digitos = valor!.replaceAll(RegExp(r'\D'), '');

    if (digitos.length != 10 && digitos.length != 11) {
      return 'Use DDD + número, ex.: (11) 90000-0000.';
    }

    return null;
  }

  static String? consentimento(bool? valor) {
    if (valor != true) {
      return 'Sem o consentimento, o cadastro não pode ser salvo.';
    }

    return null;
  }
}
