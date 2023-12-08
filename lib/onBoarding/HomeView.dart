import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examen_pmdm_psp_carlosgarciaramirez/singletone/DataHolder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../customViews/ButtonBarCustom.dart';
import '../customViews/DrawerCustom.dart';
import '../fireStoreObjets/FbUsuario.dart';
import '../singletone/FireBaseAdmin.dart';
import 'AjustesView.dart';
import 'UsuarioDetailsView.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isList = true;
  FbUsuario? currentUser;
  Map<String, FbUsuario> usuariosMap = {}; // Nuevo mapa para usuarios y sus UIDs

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadUsuarios(); // Llamar a la nueva función para cargar usuarios
  }

  void _loadCurrentUser() async {
    FbUsuario? user = await DataHolder.firebaseAdmin.loadFbUsuario();
    if (mounted) {
      setState(() {
        currentUser = user;
      });
    }
  }

  void _loadUsuarios() async {
    // Lógica para cargar usuarios y sus uids
    var snapshot = await FirebaseFirestore.instance.collection('Usuarios').get();
    var usuariosTemp = <String, FbUsuario>{};
    for (var doc in snapshot.docs) {
      usuariosTemp[doc.id] = FbUsuario.fromFirestore(doc);
    }
    setState(() {
      usuariosMap = usuariosTemp;
    });
  }

  void _navigateToAjustesView(String uid, FbUsuario usuario) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AjustesView(usuario: usuario, uid: uid),
      ),
    );
  }

  Widget muestraListView(List<FbUsuario> usuarios) {
    return ListView.builder(
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        FbUsuario usuario = usuarios[index];
        String uid = usuariosMap.keys.firstWhere((key) => usuariosMap[key] == usuario, orElse: () => '');
        return ListTile(
          title: Text('${usuario.nombre} ${usuario.apellidos} - Edad: ${usuario.edad}'),
          onTap: () => _navigateToAjustesView(uid, usuario),
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
        String uid = usuariosMap.keys.firstWhere((key) => usuariosMap[key] == usuario, orElse: () => '');
        return GestureDetector(
          onTap: () => _navigateToAjustesView(uid, usuario),
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                usuario.urlImagen != null && usuario.urlImagen!.isNotEmpty
                    ? Image.network(
                  usuario.urlImagen!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                )
                    : Icon(Icons.person, size: 80),
                SizedBox(height: 10),
                Text('${usuario.nombre} ${usuario.apellidos}'),
                Text('Edad: ${usuario.edad}'),
              ],
            ),
          ),
        );
      },
    );
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Usuarios').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No hay usuarios disponibles.');
                }

                List<FbUsuario> usuarios = snapshot.data!.docs
                    .map((QueryDocumentSnapshot<Object?> doc) =>
                    FbUsuario.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
                    .toList();

                return isList ? muestraListView(usuarios) : muestraGridView(usuarios);
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

}
