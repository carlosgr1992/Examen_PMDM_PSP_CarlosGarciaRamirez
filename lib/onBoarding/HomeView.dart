import 'package:examen_pmdm_psp_carlosgarciaramirez/singletone/DataHolder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../customViews/ButtonBarCustom.dart';
import '../customViews/DrawerCustom.dart';
import '../fireStoreObjets/FbUsuario.dart';
import '../singletone/FireBaseAdmin.dart';
import 'UsuarioDetalisView.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isList = true; // Variable de estado para controlar la vista
  FbUsuario? currentUser; // Usuario actual

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() async {
    FbUsuario? user = await DataHolder.firebaseAdmin.loadFbUsuario();
    if (mounted) {
      setState(() {
        currentUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios de la red social'),
      ),
      drawer: DrawerCustom(currentUser: currentUser ?? FbUsuario(nombre: "Invitado", apellidos: "", edad: 0)),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<FbUsuario>>(
              future: DataHolder.firebaseAdmin.obtenerUsuarios(),
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
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UsuarioDetailsView(usuario: usuario),
              ),
            );
          },
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
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UsuarioDetailsView(usuario: usuario),
              ),
            );
          },
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Imagen o ícono
                usuario.urlImagen != null && usuario.urlImagen!.isNotEmpty
                    ? Image.network(
                  usuario.urlImagen!,
                  width: 80, // Ajusta según tu diseño
                  height: 80,
                  fit: BoxFit.cover,
                )
                    : Icon(
                  Icons.person,
                  size: 80, // Tamaño del ícono
                ),
                SizedBox(height: 10), // Espaciado
                Text('${usuario.nombre} ${usuario.apellidos}'),
                Text('Edad: ${usuario.edad}'),
              ],
            ),
          ),
        );
      },
    );
  }
}