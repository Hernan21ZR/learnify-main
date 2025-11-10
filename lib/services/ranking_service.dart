import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RankingService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  // Ranking global semanal
  static Future<List<Map<String, dynamic>>> getGlobalRanking() async {
    final snapshot = await _db
        .collection('users')
        .orderBy('puntosSemanales', descending: true)
        .limit(30)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  // Ranking entre amigos (usa puntaje semanal)
  static Future<List<Map<String, dynamic>>> getFriendsRanking() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    // Obtener IDs de amigos
    final friendsSnapshot =
        await _db.collection('users').doc(uid).collection('friends').get();
    final friendsIds = friendsSnapshot.docs.map((e) => e.id).toList();

    // Incluir al propio usuario
    friendsIds.add(uid);

    if (friendsIds.isEmpty) return [];

    // Consultar datos
    final snapshot = await _db
        .collection('users')
        .where(FieldPath.documentId, whereIn: friendsIds)
        .orderBy('puntosSemanales', descending: true)
        .get();

    final ranking = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      data['esUsuarioActual'] = doc.id == uid;
      return data;
    }).toList();

    ranking.sort((a, b) =>
        (b['puntosSemanales'] ?? 0).compareTo(a['puntosSemanales'] ?? 0));

    return ranking;
  }
}
