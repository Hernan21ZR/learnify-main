import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnify/models/lesson.dart';
import 'package:learnify/models/unit.dart';

class UnitsService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Obtener las unidades de firestore
  static Future<List<Unit>> obtenerUnidades() async {
    final snapshot = await _db.collection('unidades').orderBy('orden').get();

    List<Unit> unidades = [];

    for (var doc in snapshot.docs) {
      // Obtener lecciones de cada unidad
      final leccionesSnapshot = await _db
          .collection('unidades/${doc.id}/lecciones')
          .orderBy('orden')
          .get();

      final lecciones = leccionesSnapshot.docs.map((lDoc) {
        return Lesson.fromFirestore(lDoc.id, lDoc.data());
      }).toList();

      unidades.add(Unit.fromFirestore(doc.id, doc.data(), lecciones));
    }

    return unidades;
  }
}
