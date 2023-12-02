import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../customViews/TextButtonCustom.dart';
import '../customViews/TextFieldCustom.dart';

class RegisterView extends StatelessWidget{
  late BuildContext _context;

  final TextEditingController tecUser = TextEditingController();
  final TextEditingController tecPassword = TextEditingController();
  final TextEditingController tecRepeatPassword = TextEditingController();


  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
      appBar: AppBar(
        title: Text("Registro"),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 25),
            Text(
              "Registro nuevos usuarios",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 50),
            TextFieldCustom(hintText: "Correo electrónico", controller: tecUser),
            SizedBox(height: 30),
            TextFieldCustom(hintText: "Contraseña", controller: tecPassword, obscureText: true,),
            SizedBox(height: 30),
            TextFieldCustom(hintText: "Repita su contraseña", controller: tecRepeatPassword,obscureText: true,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120,
                ),
                TextButtonCustom(onPressed: null, text: "Registrarse"),
                SizedBox(
                  width: 50,
                ),
                TextButtonCustom(onPressed: null, text: "Cancelar")
              ],
            )
          ],
        ),
      ),
    );
  }

}