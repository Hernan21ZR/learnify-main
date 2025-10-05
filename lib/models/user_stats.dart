class UserStats {
  final int puntos;
  final int nivel;
  final int racha;
  final List<dynamic> leccionesCompletadas;
  final int unidadActual;

  UserStats({
    required this.puntos,
    required this.nivel,
    required this.racha,
    required this.leccionesCompletadas,
    required this.unidadActual,
  });

  factory UserStats.fromMap(Map<String, dynamic> data) {
    return UserStats(
      puntos: data['puntos'] ?? 0,
      nivel: data['nivel'] ?? 1,
      racha: data['racha'] ?? 0,
      leccionesCompletadas: data['leccionesCompletadas'] ?? [],
      unidadActual: data['unidadActual'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'puntos': puntos,
      'nivel': nivel,
      'racha': racha,
      'leccionesCompletadas': leccionesCompletadas,
      'unidadActual': unidadActual,
    };
  }
}
