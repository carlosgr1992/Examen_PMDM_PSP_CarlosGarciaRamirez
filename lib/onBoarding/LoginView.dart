import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: TextField(

                decoration: InputDecoration(
                  fillColor: Color(0xFFBAF9FF),
                  filled: true,
                  hintText: "Introduzca su usuario",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlueAccent),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: TextFormField(

                decoration: InputDecoration(
                  fillColor: Color(0xFFBAF9FF),
                  filled: true,
                  hintText: "Introduzca su contraseña",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlueAccent),
                  ),
                ),
                obscureText: true,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120,
                ),
                TextButton(
                  onPressed: null,
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          BorderSide(color: Colors.lightBlueAccent))),
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                TextButton(
                    onPressed: null,
                    style: ButtonStyle(
                        side: MaterialStateProperty.all(
                            BorderSide(color: Colors.lightBlueAccent))),
                    child: Text(
                      "Registrar",
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}