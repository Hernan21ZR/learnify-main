import 'package:cloud_firestore/cloud_firestore.dart';

class UserStats {
  final int puntos;
  final int nivel;
  final int racha;
  final List<dynamic> leccionesCompletadas;
  final int unidadActual;
  final Map<String, int> puntajesLecciones;
  final int puntosSemanales; // 👈 Nuevo
  final DateTime? ultimaActualizacionSemana;

  UserStats({
    required this.puntos,
    required this.nivel,
    required this.racha,
    required this.leccionesCompletadas,
    required this.unidadActual,
    required this.puntajesLecciones,
    required this.puntosSemanales,
    this.ultimaActualizacionSemana,
  });

  factory UserStats.fromMap(Map<String, dynamic> data) {
    return UserStats(
      puntos: data['puntos'] ?? 0,
      nivel: data['nivel'] ?? 1,
      racha: data['racha'] ?? 0,
      leccionesCompletadas: data['leccionesCompletadas'] ?? [],
      unidadActual: data['unidadActual'] ?? 1,
      puntajesLecciones: Map<String, int>.from(data['puntajesLecciones'] ?? {}),
      puntosSemanales: data['puntosSemanales'] ?? 0, // ✅ lee Firestore
      ultimaActualizacionSemana: data['ultimaActualizacionSemana'] != null
          ? (data['ultimaActualizacionSemana'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'puntos': puntos,
      'nivel': nivel,
      'racha': racha,
      'leccionesCompletadas': leccionesCompletadas,
      'unidadActual': unidadActual,
      'puntajesLecciones': puntajesLecciones,
      'puntosSemanales': puntosSemanales,
      'ultimaActualizacionSemana': ultimaActualizacionSemana,
    };
  }
}
