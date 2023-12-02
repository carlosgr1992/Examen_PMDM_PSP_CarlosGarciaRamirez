import 'package:examen_pmdm_psp_carlosgarciaramirez/customViews/TextButtonCustom.dart';
import 'package:flutter/material.dart';

import '../customViews/TextFieldCustom.dart';

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
  
  void onClickLogin(){
    
    Navigator.of(_context).popAndPushNamed("/homeView");
    
  }
}