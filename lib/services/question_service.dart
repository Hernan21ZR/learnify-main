import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question.dart';

class QuestionsService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<List<Question>> obtenerPreguntas(
    String unidadId,
    String leccionId,
  ) async {
    final snapshot = await _db
        .collection('unidades/$unidadId/lecciones/$leccionId/preguntas')
        .get();

    return snapshot.docs
        .map((doc) => Question.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}
