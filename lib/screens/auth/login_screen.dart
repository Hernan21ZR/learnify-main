import 'package:flutter/material.dart';
import 'package:learnify/services/auth_service.dart';
import 'package:learnify/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _validations = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  // Función para iniciar sesión con Firebase
  Future<void> _loginUser() async {
  if (!_validations.currentState!.validate()) return;

  setState(() {
    _isLoading = true;
  });

  final authService = AuthService();
  
  final result = await authService.signIn(
    email: _emailController.text,
    password: _passwordController.text,
  );

  if (mounted) {
    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message), backgroundColor: AppColors.primary),
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

  // Actualizar _resetPassword():
  Future<void> _resetPassword() async {
    String email = _emailController.text.trim();
    
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa tu correo'), backgroundColor: AppColors.orange),
      );
      return;
    }

    final authService = AuthService();
    final result = await authService.resetPassword(email: email);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.success ? AppColors.primary : Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
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
        title: Text("Iniciar Sesión", style: TextStyle(color: AppColors.white),),
        backgroundColor: AppColors.primary,
      ),

      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _validations,
          child: ListView(
            children: [
              const SizedBox(height: 20,),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white),
                  ),
                  labelText: "Correo", labelStyle: TextStyle(color: AppColors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined, color: AppColors.white,)
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

              SizedBox(height: 15,),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(    
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white),
                  ),                   
                  labelText: "Contraseña", 
                  labelStyle: TextStyle(color: AppColors.white),
                  border: OutlineInputBorder() ,
                  prefixIcon: Icon(Icons.lock_outline, color: AppColors.white,),
                  
                ),
                style: TextStyle(color: AppColors.white),
                validator: (contrasena) {

                  if (contrasena == null || contrasena.isEmpty) {
                    return "Ingrese una contraseña";
                  }                 
                  return null;
                },
              ),

              // Enlace "¿Olvidaste tu contraseña?"
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _resetPassword,
                  child: const Text(
                    "¿Olvidaste tu contraseña?",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15,),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                  child: Text("Iniciar Sesión", 
                    style: TextStyle(color: AppColors.white),
                  )),
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("¿No tienes cuenta?",
                    style: TextStyle(color: AppColors.white)
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: Text("Regístrate",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold),))
                 
                ],
              )

            ],
          )),
      ),
    );
  }

}