import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../fireStoreObjets/FbUsuario.dart';
import '../singletone/FireBaseAdmin.dart';

class HomeView extends StatelessWidget {
  final FirebaseAdmin firebaseAdmin = FirebaseAdmin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios de la red social'),
      ),
      body: Center(
        child: FutureBuilder<List<FbUsuario>>(
          future: firebaseAdmin.obtenerUsuarios(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<FbUsuario>? usuarios = snapshot.data;

              if (usuarios != null && usuarios.isNotEmpty) {
                return muestraListView(usuarios);
              } else {
                return Text('No hay usuarios disponibles.');
              }
            }
          },
        ),
      ),
    );
  }

  Widget muestraListView(List<FbUsuario> usuarios) {
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemExtent: 80,
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        FbUsuario usuario = usuarios[index];
        return ListTile(
          title: Text('${usuario.nombre} ${usuario.apellidos} - Edad: ${usuario.edad}'),
        );
      },
    );
  }
}
