import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnify/data/units_seed.dart';
import 'package:learnify/data/question_seed.dart';

class FirestoreSeeder {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> subirUnidades() async {
    for (var unidad in UnitsSeed.unidades) {
      final unidadRef = _db.collection('unidades').doc(unidad.id);

      await unidadRef.set(unidad.toFirestore());

      for (var leccion in unidad.lecciones) {
        final leccionRef = unidadRef.collection('lecciones').doc(leccion.id);

        await leccionRef.set(leccion.toFirestore());

        // Subir preguntas de la lección
        final preguntas = QuestionsSeed.preguntasPorLeccion[leccion.id] ?? [];
        for (var pregunta in preguntas) {
          await leccionRef
              .collection('preguntas')
              .doc(pregunta.id)
              .set(pregunta.toFirestore());
        }
      }
    }    
  }
}
