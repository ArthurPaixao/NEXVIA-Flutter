import 'package:flutter_test/flutter_test.dart';
import 'package:nexvia/data/pessoas_exemplo.dart';
import 'package:nexvia/models/filtro_painel.dart';
import 'package:nexvia/models/pessoa.dart';
import 'package:nexvia/services/pessoa_service.dart';

void main() {
  final pessoas = pessoasDeExemplo();

  group('StatusPessoa', () {
    test('segue a ordem aguardando -> a caminho -> seguro', () {
      expect(StatusPessoa.aguardando.proximo, StatusPessoa.aCaminho);
      expect(StatusPessoa.aCaminho.proximo, StatusPessoa.seguro);
      expect(StatusPessoa.seguro.proximo, isNull);
    });
  });

  group('Pessoa', () {
    test('converte para JSON e volta sem perder dados', () {
      final original = pessoas.first.copyWith(status: StatusPessoa.aCaminho);
      final convertida = Pessoa.fromJson(original.toJson());

      expect(convertida.nome, original.nome);
      expect(convertida.status, StatusPessoa.aCaminho);
      expect(convertida.prioritaria, original.prioritaria);
      expect(convertida.statusDesde, original.statusDesde);
    });
  });

  group('PessoaService.filtrar', () {
    test('filtro Faltam esconde quem está seguro', () {
      final lista = [
        pessoas[0].copyWith(status: StatusPessoa.seguro),
        pessoas[1],
      ];

      final resultado = PessoaService.filtrar(lista, FiltroPainel.faltam, '');

      expect(resultado.map((p) => p.id), ['2']);
    });

    test('busca por rua ignora maiúsculas', () {
      final resultado =
          PessoaService.filtrar(pessoas, FiltroPainel.todas, 'ENCOSTA');

      expect(resultado.length, 2);
    });

    test('filtro Prioritárias mostra só as marcadas', () {
      final resultado =
          PessoaService.filtrar(pessoas, FiltroPainel.prioritarias, '');

      expect(resultado.every((p) => p.prioritaria), isTrue);
      expect(resultado, isNotEmpty);
    });
  });

  group('PessoaService.ordenar', () {
    test('prioritárias primeiro e seguras por último', () {
      final lista = [
        pessoas[1],
        pessoas[0].copyWith(status: StatusPessoa.seguro),
        pessoas[3],
      ];

      final ordenadas = PessoaService.ordenar(lista);

      expect(ordenadas.first.prioritaria, isTrue);
      expect(ordenadas.last.estaSegura, isTrue);
    });
  });

  test('contarFaltam ignora quem está seguro', () {
    final lista = [
      pessoas[0].copyWith(status: StatusPessoa.seguro),
      pessoas[1],
      pessoas[2].copyWith(status: StatusPessoa.aCaminho),
    ];

    expect(PessoaService.contarFaltam(lista), 2);
  });

  test('contarPorStatus soma as pessoas de cada etapa', () {
    final lista = [
      pessoas[0].copyWith(status: StatusPessoa.seguro),
      pessoas[1],
      pessoas[2],
      pessoas[3].copyWith(status: StatusPessoa.aCaminho),
    ];

    final contagem = PessoaService.contarPorStatus(lista);

    expect(contagem[StatusPessoa.aguardando], 2);
    expect(contagem[StatusPessoa.aCaminho], 1);
    expect(contagem[StatusPessoa.seguro], 1);
  });

  test('prioritariasPendentes ignora seguras e põe quem aguarda primeiro', () {
    final lista = [
      pessoas[0].copyWith(status: StatusPessoa.aCaminho),
      pessoas[1],
      pessoas[3],
    ];

    final pendentes = PessoaService.prioritariasPendentes(lista);

    expect(pendentes.map((p) => p.id), ['4', '1']);

    final comMariaSegura = [
      pessoas[0].copyWith(status: StatusPessoa.seguro),
      pessoas[3],
    ];

    expect(
      PessoaService.prioritariasPendentes(comMariaSegura).map((p) => p.id),
      ['4'],
    );
  });
}
