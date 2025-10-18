import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learnify/models/user_stats.dart';

class UserService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<UserStats?> obtenerUserStats(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    if (!doc.exists) return null;
    return UserStats.fromMap(doc.data()!);
  }

  static Future<void> sumarPuntos(int cantidad) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _firestore.collection("users").doc(uid).update({
      "puntos": FieldValue.increment(cantidad),
    });
  }

  /// Nuevo método: registra el resultado de una lección con puntaje acumulativo
  static Future<void> registrarResultadoLeccion(
      String leccionId, int nuevoPuntaje, int totalPreguntas) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final docRef = _firestore.collection("users").doc(uid);
    final doc = await docRef.get();
    if (!doc.exists) return;

    final userData = doc.data()!;
    final Map<String, dynamic> puntajesLecciones =
        Map<String, dynamic>.from(userData['puntajesLecciones'] ?? {});
    final List<dynamic> completadas =
        List<dynamic>.from(userData['leccionesCompletadas'] ?? []);

    final int puntajePrevio = (puntajesLecciones[leccionId] ?? 0);
    final int puntajeMaximo = totalPreguntas * 10;

    // El usuario solo puede recuperar los puntos que faltan
    final int puntosAcumulados =
        (puntajePrevio + nuevoPuntaje).clamp(0, puntajeMaximo);

    // Calcular porcentaje total
    final double porcentaje = (puntosAcumulados / puntajeMaximo) * 100;

    // Actualizamos Firestore
    await docRef.update({
      "puntajesLecciones.$leccionId": puntosAcumulados,
      "puntos": FieldValue.increment(puntosAcumulados - puntajePrevio),
    });

    // Si llega al 75%, marcar como completada
    if (porcentaje >= 75 && !completadas.contains(leccionId)) {
      await docRef.update({
        "leccionesCompletadas": FieldValue.arrayUnion([leccionId]),
      });
    }
  }
}
