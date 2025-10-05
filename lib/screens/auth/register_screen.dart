import 'package:flutter/material.dart';
import 'package:learnify/services/auth_service.dart';
import 'package:learnify/utils/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _validations = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  // Función para registrar usuario con Firebase
  Future<void> _registerUser() async {
    if (!_validations.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final authService = AuthService();

    final result = await authService.createAccount(
      name: _nameController.text,
      lastName: _lastNameController.text,
      age: int.parse(_ageController.text),
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (mounted) {
      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: AppColors.primary,
          ),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message), backgroundColor: Colors.red),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Registrate", style: TextStyle(color: AppColors.white),),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _validations,
          child: ListView(
            children: [
              const SizedBox(height: 10),

              // Nombre
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white),
                  ),
                  labelText: "Nombre",
                  labelStyle: TextStyle(color: AppColors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline, color: AppColors.white),
                ),
                style: TextStyle(color: AppColors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese su nombre";
                  }
                  return null;
                },
              ),

              
              const SizedBox(height: 15),

              // Apellido
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white),
                  ),
                  labelText: "Apellido",
                  labelStyle: TextStyle(color: AppColors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline, color: AppColors.white),
                ),
                style: TextStyle(color: AppColors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese su apellido";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Edad
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white),
                  ),
                  labelText: "Edad",
                  labelStyle: TextStyle(color: AppColors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake_outlined, color: AppColors.white),
                ),
                style: TextStyle(color: AppColors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese su edad";
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 12) {
                    return "Ingrese una edad válida";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Correo
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white),
                  ),
                  labelText: "Correo",
                  labelStyle: TextStyle(color: AppColors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined, color: AppColors.white),
                ),
                style: TextStyle(color: AppColors.white),
                validator: (correo) {
                  if (correo == null || correo.isEmpty) {
                    return "Ingrese un correo";
                  }
                  String correoValido = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                  RegExp regExp = RegExp(correoValido);
                  if (!regExp.hasMatch(correo)) {
                    return "Ingrese un correo válido";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Contraseña
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white),
                  ),
                  labelText: "Contraseña",
                  labelStyle: TextStyle(color: AppColors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline, color: AppColors.white),
                ),
                style: TextStyle(color: AppColors.white),
                validator: (password) {
                  if (password == null || password.isEmpty) {
                    return "Ingrese una contraseña";
                  }
                  if (password.length < 6) {
                    return "La contraseña debe tener al menos 6 caracteres";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Confirmar contraseña
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white),
                  ),
                  labelText: "Confirmar Contraseña",
                  labelStyle: TextStyle(color: AppColors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline, color: AppColors.white),
                ),
                style: TextStyle(color: AppColors.white),
                validator: (confirm) {
                  if (confirm == null || confirm.isEmpty) {
                    return "Confirme su contraseña";
                  }
                  if (confirm != _passwordController.text) {
                    return "Las contraseñas no coinciden";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Boton para registrarse
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _registerUser,       
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Registrarse",
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Ir a login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("¿Ya tienes cuenta?",
                      style: TextStyle(color: AppColors.white)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      "Inicia sesión",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
    ));
  }
}
