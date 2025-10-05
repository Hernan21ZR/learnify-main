import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnify/utils/constants.dart';

//ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //User actual
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
        'racha': 0,
        'leccionesCompletadas': [],
        'unidadActual': 1,
      });

      await userCredential.user!.updateDisplayName(name);

      return AuthResult.success(
        user: userCredential.user!,
        message: '¡Registro exitoso! Bienvenido a ${AppStrings.appName}'
      );
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getAuthErrorMessage(e.code));
    }
    catch (e) {
      return AuthResult.error('Error inesperado: $e');
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  // Restablecer contraseña
  Future<AuthResult> resetPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email.trim());
      return AuthResult.success(
        message: 'Se ha enviado un enlace de recuperación a tu correo',
      );

    } on FirebaseAuthException catch (e) {
      String errorMessage = e.code == 'user-not-found'
          ? 'No existe una cuenta con este correo'
          : 'Error al enviar el correo de recuperación';
      return AuthResult.error(errorMessage);
    } catch (e) {
      return AuthResult.error('Error inesperado: $e');
    }
  }

  Future<void> updateAcount({required String username}) async {
    await currentUser!.updateDisplayName(username);
  }

  // Eliminar cuenta de usuario
  Future<AuthResult> deleteAccount() async {
    try {
      if (currentUser == null) {
        return AuthResult.error('No hay usuario autenticado');
      }

      // Eliminar datos de Firestore
      await firestore.collection('users').doc(currentUser!.uid).delete();
      
      // Eliminar cuenta de Authentication
      await currentUser!.delete();
      
      return AuthResult.success(message: 'Cuenta eliminada correctamente');

    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getAuthErrorMessage(e.code));

    } catch (e) {
      return AuthResult.error('Error al eliminar cuenta: $e');
    }
  }

  // Actualizar datos del usuario
  Future<bool> updateUserData(Map<String, dynamic> data) async {
    try {
      if (currentUser == null) return false;
      
      await firestore
          .collection('users')
          .doc(currentUser!.uid)
          .update(data);
      
      return true;

    } catch (e) {
      return false;
    }
  }
}

// Convertir códigos de error de Firebase a mensajes legibles
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
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      case 'requires-recent-login':
        return 'Necesitas iniciar sesión recientemente para esta acción';
      default:
        return 'Error de autenticación: $code';
    }
  }

// Clase para manejar resultados de operaciones de autenticación
class AuthResult {
  final bool success;
  final String message;
  final User? user;

  AuthResult.success({this.user, required this.message}) : success = true;
  AuthResult.error(this.message) : success = false, user = null;
}
