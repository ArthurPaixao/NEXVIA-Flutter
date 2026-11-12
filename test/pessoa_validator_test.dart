import 'package:flutter_test/flutter_test.dart';
import 'package:nexvia/data/pessoas_exemplo.dart';
import 'package:nexvia/models/filtro_painel.dart';
import 'package:nexvia/services/pessoa_service.dart';
import 'package:nexvia/services/pessoa_validator.dart';
import 'package:nexvia/utils/formatadores.dart';

void main() {
  group('PessoaValidator', () {
    test('nome é obrigatório e precisa de 3 letras', () {
      expect(PessoaValidator.nome(''), isNotNull);
      expect(PessoaValidator.nome('Al'), isNotNull);
      expect(PessoaValidator.nome('Ana Lima'), isNull);
    });

    test('idade precisa ser um número entre 0 e 120', () {
      expect(PessoaValidator.idade('abc'), isNotNull);
      expect(PessoaValidator.idade('130'), isNotNull);
      expect(PessoaValidator.idade('82'), isNull);
    });

    test('telefone precisa ter DDD', () {
      expect(PessoaValidator.telefone('90000-0000'), isNotNull);
      expect(PessoaValidator.telefone('(11) 90000-0000'), isNull);
      expect(PessoaValidator.telefone('11 3000-0000'), isNull);
    });

    test('sem consentimento não salva', () {
      expect(PessoaValidator.consentimento(false), isNotNull);
      expect(PessoaValidator.consentimento(true), isNull);
    });
  });

  group('Formatadores', () {
    test('normalizarTexto ignora acentos e maiúsculas', () {
      expect(normalizarTexto('  São PAULO '), 'sao paulo');
      expect(normalizarTexto('Petrópolis'), 'petropolis');
    });

    test('formatarTelefone coloca DDD e hífen', () {
      expect(formatarTelefone('11900000001'), '(11) 90000-0001');
      expect(formatarTelefone('1130000000'), '(11) 3000-0000');
    });
  });

  test('busca do painel ignora acentos', () {
    final resultado = PessoaService.filtrar(
      pessoasDeExemplo(),
      FiltroPainel.todas,
      'antonio',
    );

    expect(resultado.single.nome, 'Antônio Ribeiro');
  });
}
