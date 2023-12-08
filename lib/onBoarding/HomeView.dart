import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examen_pmdm_psp_carlosgarciaramirez/singletone/DataHolder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../customViews/ButtonBarCustom.dart';
import '../customViews/DrawerCustom.dart';
import '../fireStoreObjets/FbUsuario.dart';
import 'AjustesView.dart';
import 'UsuarioDetailsView.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isList = true;
  FbUsuario? currentUser;

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

  void _navigateToAjustesView(String uid, FbUsuario usuario) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AjustesView(usuario: usuario, uid: uid),
      ),
    );
  }

  void _showAddUserDialog() {
    String nombre = '';
    String apellidos = '';
    int edad = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Añadir nuevo usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) => nombre = value,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                onChanged: (value) => apellidos = value,
                decoration: InputDecoration(labelText: 'Apellidos'),
              ),
              TextField(
                onChanged: (value) => edad = int.tryParse(value) ?? 0,
                decoration: InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Añadir'),
              onPressed: () {
                FirebaseFirestore.instance.collection('Usuarios').add({
                  'nombre': nombre,
                  'apellidos': apellidos,
                  'edad': edad,
                  'urlImagen': '', // Dejar en blanco o poner una URL por defecto
                });
                Navigator.of(context).pop();
              },
            ),
          ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUserDialog,
        child: Icon(Icons.add),
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
            // Aquí necesitarás encontrar el UID del usuario. Puedes modificar tu enfoque para obtenerlo.
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
            // Aquí necesitarás encontrar el UID del usuario. Puedes modificar tu enfoque para obtenerlo.
          },
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
}
