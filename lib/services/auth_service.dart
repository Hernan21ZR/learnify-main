import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnify/utils/constants.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? get currentUser => firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();
  bool get isLoggedIn => currentUser != null;

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      String userName = userCredential.user?.displayName ?? 'Usuario';
      return AuthResult.success(
        user: userCredential.user!,
        message: '¡Bienvenido de nuevo, $userName!',
      );
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getAuthErrorMessage(e.code));
    } catch (e) {
      return AuthResult.error('Error inesperado: $e');
    }
  }

  Future<AuthResult> createAccount({
    required String name,
    required String lastName,
    required int age,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'nombre': name.trim(),
        'apellidos': lastName.trim(),
        'edad': age,
        'email': email.trim(),
        'fechaRegistro': FieldValue.serverTimestamp(),
        'nivel': 1,
        'puntos': 0,
        'puntosSemanales': 0,
        'ultimaActualizacionSemana': Timestamp.fromDate(DateTime.now()),
        'racha': 0,
        'leccionesCompletadas': [],
        'unidadActual': 1,
      });

      await userCredential.user!.updateDisplayName(name);
      return AuthResult.success(
        user: userCredential.user!,
        message: '¡Registro exitoso! Bienvenido a ${AppStrings.appName}',
      );
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getAuthErrorMessage(e.code));
    } catch (e) {
      return AuthResult.error('Error inesperado: $e');
    }
  }

  Future<void> signOut() async => await firebaseAuth.signOut();

  Future<AuthResult> resetPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email.trim());
      return AuthResult.success(message: 'Se ha enviado un enlace de recuperación a tu correo');
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(
        e.code == 'user-not-found'
            ? 'No existe una cuenta con este correo'
            : 'Error al enviar el correo de recuperación',
      );
    } catch (e) {
      return AuthResult.error('Error inesperado: $e');
    }
  }

  Future<void> updateAcount({required String username}) async {
    await currentUser!.updateDisplayName(username);
  }

  Future<AuthResult> deleteAccount() async {
    try {
      if (currentUser == null) {
        return AuthResult.error('No hay usuario autenticado');
      }
      await firestore.collection('users').doc(currentUser!.uid).delete();
      await currentUser!.delete();
      return AuthResult.success(message: 'Cuenta eliminada correctamente');
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getAuthErrorMessage(e.code));
    } catch (e) {
      return AuthResult.error('Error al eliminar cuenta: $e');
    }
  }

  Future<bool> updateUserData(Map<String, dynamic> data) async {
    try {
      if (currentUser == null) return false;
      await firestore.collection('users').doc(currentUser!.uid).update(data);
      return true;
    } catch (_) {
      return false;
    }
  }
}

String _getAuthErrorMessage(String code) {
  switch (code) {
    case 'weak-password':
      return 'La contraseña es muy débil';
    case 'email-already-in-use':
      return 'Este correo ya está registrado';
    case 'invalid-email':
      return 'El correo no es válido';
    case 'user-not-found':
      return 'No existe una cuenta con este correo';
    case 'wrong-password':
      return 'Contraseña incorrecta';
    default:
      return 'Error de autenticación: $code';
  }
}

class AuthResult {
  final bool success;
  final String message;
  final User? user;

  AuthResult.success({this.user, required this.message}) : success = true;
  AuthResult.error(this.message)
      : success = false,
        user = null;
}
