import 'package:flutter/material.dart';

import '../models/nivel_risco.dart';
import '../models/pessoa.dart';
import '../theme/app_colors.dart';

Color corDoStatus(StatusPessoa status) {
  return switch (status) {
    StatusPessoa.aguardando => AppColors.vermelhoAguardando,
    StatusPessoa.aCaminho => AppColors.azulACaminho,
    StatusPessoa.seguro => AppColors.verdeSeguro,
  };
}

IconData iconeDoStatus(StatusPessoa status) {
  return switch (status) {
    StatusPessoa.aguardando => Icons.warning_rounded,
    StatusPessoa.aCaminho => Icons.directions_walk_rounded,
    StatusPessoa.seguro => Icons.check_circle_rounded,
  };
}

Color corDoRisco(NivelRisco risco) {
  return switch (risco) {
    NivelRisco.baixo => AppColors.verdeSeguro,
    NivelRisco.atencao => AppColors.laranjaAtencao,
    NivelRisco.alto => AppColors.vermelhoAguardando,
  };
}

IconData iconeDoTempo(int codigo) {
  if (codigo == 0) return Icons.wb_sunny_outlined;
  if (codigo <= 3) return Icons.cloud_outlined;
  if (codigo <= 48) return Icons.foggy;
  if (codigo <= 57) return Icons.grain;
  if (codigo <= 67) return Icons.umbrella_outlined;
  if (codigo <= 77) return Icons.ac_unit;
  if (codigo <= 82) return Icons.water_drop_outlined;
  return Icons.thunderstorm_outlined;
}

IconData iconeDoRisco(NivelRisco risco) {
  return switch (risco) {
    NivelRisco.baixo => Icons.wb_cloudy_outlined,
    NivelRisco.atencao => Icons.water_drop_outlined,
    NivelRisco.alto => Icons.thunderstorm_outlined,
  };
}
