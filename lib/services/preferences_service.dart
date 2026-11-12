import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _naoMostrarIntroducaoKey = 'nao_mostrar_introducao';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Future<bool> getNaoMostrarIntroducao() async {
    return await _preferences.getBool(_naoMostrarIntroducaoKey) ?? false;
  }

  Future<void> saveNaoMostrarIntroducao(bool value) async {
    await _preferences.setBool(_naoMostrarIntroducaoKey, value);
  }
}
