class LocalMonitorado {
  final String nome;
  final String uf;
  final double latitude;
  final double longitude;

  const LocalMonitorado({
    required this.nome,
    required this.uf,
    required this.latitude,
    required this.longitude,
  });

  String get nomeCompleto => '$nome - $uf';
}
