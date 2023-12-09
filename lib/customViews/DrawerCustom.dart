import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../fireStoreObjets/FbUsuario.dart';
import '../onBoarding/AjustesView.dart';
import '../onBoarding/UsuarioDetailsView.dart';

class DrawerCustom extends StatelessWidget {
  final FbUsuario? currentUser;
  final String? uid;

  DrawerCustom({required this.currentUser, this.uid});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: currentUser != null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Bienvenido, ${currentUser!.nombre}', style: TextStyle(color: Colors.white)),
                Text('${currentUser!.apellidos}', style: TextStyle(color: Colors.white)),
              ],
            )
                : Text('Bienvenido, Invitado', style: TextStyle(color: Colors.white)),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).popAndPushNamed("/homeView");
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Ajustes'),
            onTap: () {
              if (currentUser != null) {
                Navigator.of(context).pop(); // Cierra el drawer
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UsuarioDetailsView(usuario: currentUser!, uid: currentUser!.id),
                  ),
                );
              }else {

              }
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).popAndPushNamed("/loginView");
            },
          ),
        ],
      ),
    );
  }
}