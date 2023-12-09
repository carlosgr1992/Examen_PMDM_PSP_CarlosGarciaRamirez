import 'package:flutter/material.dart';
import '../fireStoreObjets/FbUsuario.dart';
import '../onBoarding/AjustesView.dart';

class DrawerCustom extends StatelessWidget {
  final FbUsuario? currentUser;

  DrawerCustom({this.currentUser});

  @override
  Widget build(BuildContext context) {
    // Verifica si la URL es válida
    bool esUrlValida = Uri.tryParse(currentUser?.urlImagen ?? '')?.hasAbsolutePath ?? false;

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Mostrar imagen de perfil o ícono por defecto
                esUrlValida
                    ? CircleAvatar(
                  backgroundImage: NetworkImage(currentUser!.urlImagen!),
                  radius: 40,
                )
                    : CircleAvatar(
                  child: Icon(Icons.person, size: 40),
                  radius: 40,
                ),
                SizedBox(height: 10), // Espacio entre la imagen y el texto
                Text(
                  'Bienvenido, ${currentUser?.nombre ?? 'Invitado'}',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
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
              // Navegar a la vista de detalles del usuario
              if (currentUser != null) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AjustesView(usuario: currentUser!, uid: currentUser!.id,),
                ));
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
