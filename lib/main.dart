import 'package:flutter/material.dart';
import 'package:learnify/home/home_screen.dart';
import 'package:learnify/screens/auth/login_screen.dart';
import 'package:learnify/screens/auth/register_screen.dart';
import 'package:learnify/screens/auth/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learnify/services/firestore_seeder.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ⚙️ Ejecuta el seeder SOLO si estás en modo desarrollo.
  // Ponlo en true solo cuando quieras subir datos nuevos.
  const bool ejecutarSeeder = true;

  if (ejecutarSeeder) {
    await FirestoreSeeder.subirUnidades();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learnify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const WelcomeScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
