import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learnify/home/home_screen.dart';
import 'package:learnify/screens/auth/welcome_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Mientras verifica el estado
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Si hay usuario autenticado
        if (snapshot.hasData) {
          return const HomeScreen(); // Tu pantalla principal
        }
        
        // Si no hay usuario autenticado
        return const WelcomeScreen();
      },
    );
  }
}