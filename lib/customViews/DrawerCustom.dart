import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../fireStoreObjets/FbUsuario.dart';
import '../onBoarding/AjustesView.dart';

class DrawerCustom extends StatelessWidget {
  final FbUsuario currentUser;

  DrawerCustom({required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menú'),
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
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AjustesView(usuario: currentUser),
              ));
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