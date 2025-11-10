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

  static Future<void> registrarResultadoLeccion(
    String leccionId,
    int nuevoPuntaje,
    int totalPreguntas,
  ) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final docRef = _firestore.collection("users").doc(uid);
    final doc = await docRef.get();
    if (!doc.exists) return;

    final userData = doc.data()!;
    final Map<String, dynamic> puntajesLecciones = Map<String, dynamic>.from(
      userData['puntajesLecciones'] ?? {},
    );
    final List<dynamic> completadas = List<dynamic>.from(
      userData['leccionesCompletadas'] ?? [],
    );

    final int puntajePrevio = (puntajesLecciones[leccionId] ?? 0);
    final int puntajeMaximo = totalPreguntas * 10;
    final int puntosAcumulados = (puntajePrevio + nuevoPuntaje).clamp(
      0,
      puntajeMaximo,
    );
    final double porcentaje = (puntosAcumulados / puntajeMaximo) * 100;

    await docRef.update({
      "puntajesLecciones.$leccionId": puntosAcumulados,
      "puntos": FieldValue.increment(puntosAcumulados - puntajePrevio),
    });

    await sumarPuntosSemanales(puntosAcumulados - puntajePrevio);

    if (porcentaje >= 75 && !completadas.contains(leccionId)) {
      await docRef.update({
        "leccionesCompletadas": FieldValue.arrayUnion([leccionId]),
      });
    }
  }

  static Future<void> sumarPuntosSemanales(int cantidad) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final docRef = _firestore.collection("users").doc(uid);
    final doc = await docRef.get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final Timestamp? ultimaFecha = data['ultimaActualizacionSemana'];
    final now = DateTime.now();

    if (ultimaFecha == null ||
        now.difference(ultimaFecha.toDate()).inDays >= 7) {
      await docRef.update({
        "puntosSemanales": cantidad,
        "ultimaActualizacionSemana": Timestamp.fromDate(now),
      });
    } else {
      await docRef.update({"puntosSemanales": FieldValue.increment(cantidad)});
    }
  }

  // Método de inicialización de campos (para usuarios antiguos)
  static Future<void> inicializarCamposUsuarios() async {
    final users = await _firestore.collection('users').get();
    for (final doc in users.docs) {
      await doc.reference.set({
        'puntosSemanales': doc.data()['puntosSemanales'] ?? 0,
        'ultimaActualizacionSemana':
            doc.data()['ultimaActualizacionSemana'] ??
            Timestamp.fromDate(DateTime.now()),
      }, SetOptions(merge: true));
    }
  }

  // Reinicia los puntos semanales si ha pasado más de 7 días
  static Future<void> verificarYReiniciarPuntosSemanales() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final docRef = _firestore.collection("users").doc(uid);
    final doc = await docRef.get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final Timestamp? ultimaFecha = data['ultimaActualizacionSemana'];
    final now = DateTime.now();

    // Si no hay fecha registrada, inicializamos
    if (ultimaFecha == null) {
      await docRef.update({
        "puntosSemanales": 0,
        "ultimaActualizacionSemana": Timestamp.fromDate(now),
      });
      return;
    }

    // Convertimos la última fecha registrada
    final ultima = ultimaFecha.toDate();

    // Comparamos si ha pasado más de una semana o si ya es lunes
    final bool haPasadoSemana = now.difference(ultima).inDays >= 7;
    final bool esNuevoLunes =
        now.weekday == DateTime.monday && ultima.weekday != DateTime.monday;

    if (haPasadoSemana || esNuevoLunes) {
      await docRef.update({
        "puntosSemanales": 0,
        "ultimaActualizacionSemana": Timestamp.fromDate(now),
      });      
    }
  }

  // obtiene un stream de UserStats
  static Stream<UserStats?> getUserStatsStream(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) return null;
          return UserStats.fromMap(snapshot.data()!);
        });
  }
}
