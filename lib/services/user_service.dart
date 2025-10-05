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

  /// 🔥 Sumar puntos al usuario actual
  static Future<void> sumarPuntos(int cantidad) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection("users").doc(uid).update({
      "puntos": FieldValue.increment(cantidad),
    });
  }

  /// 🔥 Marcar una lección como completada y dar puntos
  static Future<void> completarLeccion(String leccionId, int puntos) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection("users").doc(uid).update({
      "puntos": FieldValue.increment(puntos),
      "leccionesCompletadas": FieldValue.arrayUnion([leccionId]),
    });
  }
}
