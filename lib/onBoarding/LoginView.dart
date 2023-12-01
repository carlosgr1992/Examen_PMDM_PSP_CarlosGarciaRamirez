import 'package:examen_pmdm_psp_carlosgarciaramirez/customViews/TextButtonCustom.dart';
import 'package:flutter/material.dart';

import '../customViews/TextFieldCustom.dart';

class LoginView extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
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
                controller: emailController),
            SizedBox(height: 30),
            TextFieldCustom(
                hintText: "introduzca contraseña",
                controller: passController,
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
          TextButtonCustom(onPressed: null, text: "Registrar"),
              ],
            )
          ],
        ),
      ),
    );
  }
  
  void onClickLogin(){
    
    Navigator.of(_context).popAndPushNamed("/homeView");
    
  }
}