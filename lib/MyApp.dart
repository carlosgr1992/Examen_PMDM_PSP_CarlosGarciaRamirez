import 'package:examen_pmdm_psp_carlosgarciaramirez/onBoarding/AjustesView.dart';
import 'package:examen_pmdm_psp_carlosgarciaramirez/onBoarding/HomeView.dart';
import 'package:examen_pmdm_psp_carlosgarciaramirez/onBoarding/LoginView.dart';
import 'package:examen_pmdm_psp_carlosgarciaramirez/onBoarding/Splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'onBoarding/RegisterView.dart';

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MyApp",
    routes: {
        "/splashView": (context) => Splash(),
        "/loginView": (context) => LoginView(),
        "/homeView": (context) => HomeView(),
        "/registerView": (context) => RegisterView(),
    },
    initialRoute: "/splashView",
    );
  }
}