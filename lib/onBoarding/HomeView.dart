import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../customViews/ButtonBarCustom.dart';
import '../fireStoreObjets/FbUsuario.dart';
import '../singletone/FireBaseAdmin.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isList = true; // Variable de estado para controlar la vista
  final FirebaseAdmin firebaseAdmin = FirebaseAdmin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios de la red social'),
      ),
      body: Column(
        children: [
          Expanded(
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
          Align(
            alignment: Alignment.bottomCenter,
            child: ButtonBarCustom(
              onListPressed: () {
                setState(() {
                  isList = true;
                });
              },
              onGridPressed: () {
                setState(() {
                  isList = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget muestraListView(List<FbUsuario> usuarios) {
    return ListView.builder(
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
        crossAxisCount: 2,
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