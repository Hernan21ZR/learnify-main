import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendsService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<List<Map<String, dynamic>>> getFriends() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('friends')
        .get();

    List<Map<String, dynamic>> friends = [];

    for (var doc in snapshot.docs) {
      final userDoc = await _db.collection('users').doc(doc.id).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        data['id'] = doc.id;
        data['nombre'] = data['nombre'] ?? "Usuario";
        data['apellidos'] = data['apellidos'] ?? "";
        data['email'] = data['email'] ?? "Sin email";
        friends.add(data);
      }
    }

    return friends;
  }

  static Future<List<Map<String, dynamic>>> getFriendRequests() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('friendRequests')
        .get();

    List<Map<String, dynamic>> requests = [];

    for (var doc in snapshot.docs) {
      final userDoc = await _db.collection('users').doc(doc.id).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        data['id'] = doc.id;
        data['nombre'] = data['nombre'] ?? "Usuario";
        data['apellidos'] = data['apellidos'] ?? "";
        data['email'] = data['email'] ?? "Sin email";
        requests.add(data);
      }
    }

    return requests;
  }

  static Future<void> sendFriendRequest(String userId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final user = await _db.collection('users').doc(uid).get();
    if (!user.exists) return;

    final userData = user.data()!;
    await _db
        .collection('users')
        .doc(userId)
        .collection('friendRequests')
        .doc(uid)
        .set({
          'id': uid,
          'nombre': userData['nombre'] ?? "Usuario",
          'apellidos': userData['apellidos'] ?? "",
          'email': userData['email'] ?? "Sin email",
        });
  }

  static Future<void> acceptFriendRequest(String userId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final userData = await _db.collection('users').doc(userId).get();
    final currentUserData = await _db.collection('users').doc(uid).get();

    if (!userData.exists || !currentUserData.exists) return;

    final user = userData.data()!;
    final currentUser = currentUserData.data()!;

    // Añadir a lista de amigos en ambos usuarios
    await _db
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc(userId)
        .set({
          'id': userId,
          'nombre': user['nombre'] ?? "Usuario",
          'apellidos': user['apellidos'] ?? "",
          'email': user['email'] ?? "Sin email",
        });

    await _db
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(uid)
        .set({
          'id': uid,
          'nombre': currentUser['nombre'] ?? "Usuario",
          'apellidos': currentUser['apellidos'] ?? "",
          'email': currentUser['email'] ?? "Sin email",
        });

    // Eliminar solicitud
    await _db
        .collection('users')
        .doc(uid)
        .collection('friendRequests')
        .doc(userId)
        .delete();
  }

  static Future<void> rejectFriendRequest(String userId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db
        .collection('users')
        .doc(uid)
        .collection('friendRequests')
        .doc(userId)
        .delete();
  }

  static Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || query.trim().isEmpty) return [];

    final searchTerm = query.trim().toLowerCase();

    final friendsSnapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('friends')
        .get();
    final requestsSnapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('friendRequests')
        .get();

    final friendsIds = friendsSnapshot.docs.map((d) => d.id).toSet();
    final requestsIds = requestsSnapshot.docs.map((d) => d.id).toSet();

    final snapshot = await _db.collection('users').get();

    final results = snapshot.docs
        .where((doc) {
          if (doc.id == uid) return false;
          final data = doc.data();
          final nombre = (data['nombre'] ?? '').toString().toLowerCase();
          final apellidos = (data['apellidos'] ?? '').toString().toLowerCase();
          final email = (data['email'] ?? '').toString().toLowerCase();

          return nombre.contains(searchTerm) ||
              apellidos.contains(searchTerm) ||
              email.contains(searchTerm);
        })
        .map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          data['nombre'] = data['nombre'] ?? "Usuario";
          data['apellidos'] = data['apellidos'] ?? "";
          data['email'] = data['email'] ?? "Sin email";
          data['isFriend'] = friendsIds.contains(doc.id);
          data['hasRequest'] = requestsIds.contains(doc.id);
          return data;
        })
        .toList();

    return results;
  }

  static Future<Map<String, dynamic>?> getUserProfileById(String userId) async {
    final userDoc = await _db.collection('users').doc(userId).get();
    if (!userDoc.exists) return null;

    final userData = userDoc.data()!;
    return {
      'id': userDoc.id,
      'nombre': userData['nombre'] ?? "Usuario",
      'apellidos': userData['apellidos'] ?? "",
      'email': userData['email'] ?? "Sin email",
      'puntos': userData['puntos'] ?? 0,
      'nivel': userData['nivel'] ?? 1,
      'racha': userData['racha'] ?? 0,
      'leccionesCompletadas': userData['leccionesCompletadas'] ?? [],
      'unidadActual': userData['unidadActual'] ?? 1,
      'puntajesLecciones': Map<String, int>.from(
        userData['puntajesLecciones'] ?? {},
      ),
    };
  }


  static Future<void> toggleFollow(String userId, bool isFollowing) async {
  final uid = _auth.currentUser?.uid;
  if (uid == null) return;

  final followingRef = _db.collection('users').doc(uid).collection('following').doc(userId);

  if (isFollowing) {
    // Si ya sigue, al presionar nuevamente se deja de seguir
    await followingRef.delete();
  } else {
    final userDoc = await _db.collection('users').doc(userId).get();
    if (userDoc.exists) {
      final data = userDoc.data()!;
      await followingRef.set({
        'id': userId,
        'nombre': data['nombre'] ?? "Usuario",
        'apellidos': data['apellidos'] ?? "",
        'email': data['email'] ?? "Sin email",
      });
    }
  }
}

}
