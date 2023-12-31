import 'package:examen_pmdm_psp_carlosgarciaramirez/customViews/TextButtonCustom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../customViews/TextFieldCustom.dart';
import '../singletone/DataHolder.dart';

class LoginView extends StatelessWidget {

  final TextEditingController tecEmailController = TextEditingController();
  final TextEditingController tecPassController = TextEditingController();
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context=context;

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Color(0xFFFEFFDE),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Text(
              "Bienvenido al login",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 80),
            TextFieldCustom(
                hintText: "Introduzca su usuario",
                controller: tecEmailController),
            SizedBox(height: 30),
            TextFieldCustom(
                hintText: "introduzca contraseña",
                controller: tecPassController,
                obscureText: true),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120,
                ),
                TextButtonCustom(onPressed: onClickLogin, text: "Login"),
                SizedBox(
                  width: 50,
                ),
          TextButtonCustom(onPressed: onClickRegister, text: "Registrar"),
              ],
            )
          ],
        ),
      ),
    );
  }

  void onClickRegister(){

    Navigator.of(_context).popAndPushNamed("/registerView");

  }

  void onClickLogin() async {
    String email = tecEmailController.text;
    String password = tecPassController.text;

    // Realizar autenticación con FirebaseAdmin
    User? user = await DataHolder.firebaseAdmin.signIn(email, password);

    if (user != null) {
      // Usuario autenticado correctamente
      Navigator.of(_context).popAndPushNamed("/homeView");
    } else {
      // Mostrar Snackbar indicando que el usuario no existe
      final snackBar = SnackBar(
        content: Text('Usuario o contraseña incorrectos'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(_context).showSnackBar(snackBar);
    }
  }
}