import 'package:flutter/material.dart';
import 'approutes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String? errorMessage;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String traducirError(dynamic error) {
    String errorString = error.toString().toLowerCase();
    
    if (errorString.contains('email-already-in-use')) {
      return 'Este correo electrónico ya está registrado';
    } else if (errorString.contains('weak-password')) {
      return 'La contraseña debe tener al menos 6 caracteres';
    } else if (errorString.contains('invalid-email')) {
      return 'El formato del correo electrónico no es válido';
    } else if (errorString.contains('missing-email')) {
      return 'Por favor ingresa un correo electrónico';
    } else if (errorString.contains('missing-password')) {
      return 'Por favor ingresa una contraseña';
    } else if (errorString.contains('operation-not-allowed')) {
      return 'El registro con correo/contraseña no está habilitado';
    } else if (errorString.contains('network-request-failed')) {
      return 'Error de conexión. Verifica tu internet';
    } else if (errorString.contains('too-many-requests')) {
      return 'Demasiados intentos. Espera un momento e intenta de nuevo';
    } else if (errorString.contains('requires-recent-login')) {
      return 'Por seguridad, necesitas iniciar sesión de nuevo';
    } else if (errorString.contains('admin-restricted-operation')) {
      return 'Esta operación está restringida por el administrador';
    } else {
      return 'Error al registrar usuario. Verifica tus datos';
    }
  }

    Future<void> signUp() async {
    try {
      await Auth().signUp(_emailController.text, _passwordController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } catch (e) {
      setState(() {
        errorMessage = traducirError(e);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    double anchura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Stack(
            children: [
              Image(
                image: AssetImage('assets/images/collage-manga.png'),
                width: anchura,
                height: altura,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),

              Center(
                child: Container(
                  alignment: Alignment.center,
                  height: altura * 0.9,
                  width: anchura*0.8,
                  padding: EdgeInsets.all(30),
                  
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFC430F8).withValues(alpha: 0.8),
                        Color(0xFF0298FB).withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                        spacing: 30,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Registro de usuario',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.black,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.white, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),

                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.black,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.white, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),

                      SizedBox(height: 50),
                      
                      GestureDetector(
                        onTap: signUp,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF0298FB),
                                Color(0xFFC430F8),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            'Registrarme',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: Text(
                          'Volver',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      Text(
                        errorMessage == null ? "" :
                        "$errorMessage",
                        style: TextStyle(color: const Color.fromARGB(255, 255, 17, 0),
                        fontSize: 20, fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 5,
                            offset: Offset(0, 0),
                          ),
                        ],
                        ),
                          )
                        ],
                      ),
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
