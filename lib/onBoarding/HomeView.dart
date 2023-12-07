import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../fireStoreObjets/FbUsuario.dart';
import '../singletone/FireBaseAdmin.dart';

class HomeView extends StatelessWidget {
  final FirebaseAdmin firebaseAdmin = FirebaseAdmin();
  bool isList = true;

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
                return isList ? muestraListView(usuarios) : muestraGridView(usuarios);
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

  Widget muestraGridView(List<FbUsuario> usuarios) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Número de columnas
        crossAxisSpacing: 10,
        mainAxisSpacing: 10, 
      ),
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        FbUsuario usuario = usuarios[index];
        return Card(
          child: Center(
            child: Text('${usuario.nombre} ${usuario.apellidos} - Edad: ${usuario.edad}'),
          ),
        );
      },
    );
  }


}
