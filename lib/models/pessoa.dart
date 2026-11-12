enum StatusPessoa {
  aguardando('Aguardando ajuda', 'Acionar padrinho'),
  aCaminho('Padrinho a caminho', 'Marcar em segurança'),
  seguro('Em segurança', null);

  final String rotulo;

  final String? acao;

  const StatusPessoa(this.rotulo, this.acao);

  StatusPessoa? get proximo {
    final indice = index + 1;
    return indice < StatusPessoa.values.length ? StatusPessoa.values[indice] : null;
  }

  static StatusPessoa fromName(String? name) {
    return StatusPessoa.values.firstWhere(
      (status) => status.name == name,
      orElse: () => StatusPessoa.aguardando,
    );
  }
}

class Pessoa {
  final String id;
  final String nome;
  final int idade;
  final String endereco;
  final String necessidade;
  final String padrinho;
  final String telefonePadrinho;
  final String padrinhoReserva;
  final String destinoSeguro;
  final String observacoes;

  final bool consentimento;
  final bool prioritaria;
  final StatusPessoa status;
  final DateTime statusDesde;

  Pessoa({
    required this.id,
    required this.nome,
    required this.idade,
    required this.endereco,
    required this.necessidade,
    required this.padrinho,
    required this.telefonePadrinho,
    required this.padrinhoReserva,
    required this.destinoSeguro,
    required this.observacoes,
    this.consentimento = true,
    this.prioritaria = false,
    this.status = StatusPessoa.aguardando,
    required this.statusDesde,
  });

  bool get estaSegura => status == StatusPessoa.seguro;

  Pessoa copyWith({
    bool? prioritaria,
    StatusPessoa? status,
    DateTime? statusDesde,
  }) {
    return Pessoa(
      id: id,
      nome: nome,
      idade: idade,
      endereco: endereco,
      necessidade: necessidade,
      padrinho: padrinho,
      telefonePadrinho: telefonePadrinho,
      padrinhoReserva: padrinhoReserva,
      destinoSeguro: destinoSeguro,
      observacoes: observacoes,
      consentimento: consentimento,
      prioritaria: prioritaria ?? this.prioritaria,
      status: status ?? this.status,
      statusDesde: statusDesde ?? this.statusDesde,
    );
  }

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      id: json['id'] ?? '',
      nome: json['nome'] ?? '',
      idade: json['idade'] ?? 0,
      endereco: json['endereco'] ?? '',
      necessidade: json['necessidade'] ?? '',
      padrinho: json['padrinho'] ?? '',
      telefonePadrinho: json['telefonePadrinho'] ?? '',
      padrinhoReserva: json['padrinhoReserva'] ?? '',
      destinoSeguro: json['destinoSeguro'] ?? '',
      observacoes: json['observacoes'] ?? '',
      consentimento: json['consentimento'] ?? true,
      prioritaria: json['prioritaria'] ?? false,
      status: StatusPessoa.fromName(json['status']),
      statusDesde:
          DateTime.tryParse(json['statusDesde'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'idade': idade,
      'endereco': endereco,
      'necessidade': necessidade,
      'padrinho': padrinho,
      'telefonePadrinho': telefonePadrinho,
      'padrinhoReserva': padrinhoReserva,
      'destinoSeguro': destinoSeguro,
      'observacoes': observacoes,
      'consentimento': consentimento,
      'prioritaria': prioritaria,
      'status': status.name,
      'statusDesde': statusDesde.toIso8601String(),
    };
  }
}
