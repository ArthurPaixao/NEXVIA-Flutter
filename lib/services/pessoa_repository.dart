import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/pessoas_exemplo.dart';
import '../models/pessoa.dart';

class PessoaRepository {
  static const String _pessoasKey = 'pessoas';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Future<List<Pessoa>> buscarTodas() async {
    final texto = await _preferences.getString(_pessoasKey);

    if (texto == null) {
      final exemplos = pessoasDeExemplo();
      await salvarTodas(exemplos);
      return exemplos;
    }

    final List<dynamic> jsonList = jsonDecode(texto);

    return jsonList
        .map((json) => Pessoa.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> salvarTodas(List<Pessoa> pessoas) async {
    final texto = jsonEncode(pessoas.map((pessoa) => pessoa.toJson()).toList());

    await _preferences.setString(_pessoasKey, texto);
  }
}
