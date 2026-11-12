import '../models/filtro_painel.dart';
import '../models/pessoa.dart';
import '../utils/formatadores.dart';
import 'pessoa_repository.dart';

class PessoaService {
  final PessoaRepository _repository;

  PessoaService({PessoaRepository? repository})
      : _repository = repository ?? PessoaRepository();

  Future<List<Pessoa>> listar() async {
    final pessoas = await _repository.buscarTodas();
    return ordenar(pessoas);
  }

  Future<Pessoa> avancarStatus(Pessoa pessoa) async {
    final proximo = pessoa.status.proximo;

    if (proximo == null) {
      return pessoa;
    }

    return _atualizar(
      pessoa.copyWith(status: proximo, statusDesde: DateTime.now()),
    );
  }

  Future<Pessoa> alternarPrioridade(Pessoa pessoa) async {
    return _atualizar(pessoa.copyWith(prioritaria: !pessoa.prioritaria));
  }

  Future<Pessoa> salvar(Pessoa pessoa) async {
    final pessoas = await _repository.buscarTodas();
    final existe = pessoas.any((atual) => atual.id == pessoa.id);

    if (!existe) {
      await _repository.salvarTodas([...pessoas, pessoa]);
      return pessoa;
    }

    return _atualizar(pessoa);
  }

  Future<void> excluir(Pessoa pessoa) async {
    final pessoas = await _repository.buscarTodas();

    await _repository.salvarTodas(
      pessoas.where((atual) => atual.id != pessoa.id).toList(),
    );
  }

  static String novoId() => DateTime.now().microsecondsSinceEpoch.toString();

  Future<void> iniciarNovoSimulado() async {
    final agora = DateTime.now();
    final pessoas = await _repository.buscarTodas();

    final reiniciadas = pessoas
        .map(
          (pessoa) => pessoa.copyWith(
            status: StatusPessoa.aguardando,
            statusDesde: agora,
          ),
        )
        .toList();

    await _repository.salvarTodas(reiniciadas);
  }

  Future<Pessoa> _atualizar(Pessoa atualizada) async {
    final pessoas = await _repository.buscarTodas();

    final novaLista = pessoas
        .map((pessoa) => pessoa.id == atualizada.id ? atualizada : pessoa)
        .toList();

    await _repository.salvarTodas(novaLista);

    return atualizada;
  }

  static List<Pessoa> ordenar(List<Pessoa> pessoas) {
    final ordenadas = List<Pessoa>.from(pessoas);

    ordenadas.sort((a, b) {
      if (a.estaSegura != b.estaSegura) {
        return a.estaSegura ? 1 : -1;
      }

      if (a.prioritaria != b.prioritaria) {
        return a.prioritaria ? -1 : 1;
      }

      final porStatus = a.status.index.compareTo(b.status.index);

      if (porStatus != 0) {
        return porStatus;
      }

      return a.nome.compareTo(b.nome);
    });

    return ordenadas;
  }

  static List<Pessoa> filtrar(
    List<Pessoa> pessoas,
    FiltroPainel filtro,
    String busca,
  ) {
    final termo = normalizarTexto(busca);

    return pessoas.where((pessoa) {
      final passaNoFiltro = switch (filtro) {
        FiltroPainel.todas => true,
        FiltroPainel.faltam => !pessoa.estaSegura,
        FiltroPainel.seguras => pessoa.estaSegura,
        FiltroPainel.prioritarias => pessoa.prioritaria,
      };

      if (!passaNoFiltro) {
        return false;
      }

      if (termo.isEmpty) {
        return true;
      }

      return normalizarTexto(pessoa.nome).contains(termo) ||
          normalizarTexto(pessoa.endereco).contains(termo) ||
          normalizarTexto(pessoa.padrinho).contains(termo);
    }).toList();
  }

  static int contarFaltam(List<Pessoa> pessoas) {
    return pessoas.where((pessoa) => !pessoa.estaSegura).length;
  }

  static Map<StatusPessoa, int> contarPorStatus(List<Pessoa> pessoas) {
    final contagem = {for (final status in StatusPessoa.values) status: 0};

    for (final pessoa in pessoas) {
      contagem[pessoa.status] = contagem[pessoa.status]! + 1;
    }

    return contagem;
  }

  static List<Pessoa> prioritariasPendentes(List<Pessoa> pessoas) {
    final pendentes = pessoas
        .where((pessoa) => pessoa.prioritaria && !pessoa.estaSegura)
        .toList();

    pendentes.sort((a, b) {
      final porStatus = a.status.index.compareTo(b.status.index);
      if (porStatus != 0) return porStatus;
      return a.statusDesde.compareTo(b.statusDesde);
    });

    return pendentes;
  }
}
