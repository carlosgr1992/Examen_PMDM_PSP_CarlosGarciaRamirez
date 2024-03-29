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
  bool isList = false;
  FbUsuario? currentUser;
  Map<String, FbUsuario> usuariosMap = {};

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

  void _navigateToUsuarioDetailsView(FbUsuario usuario) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UsuarioDetailsView(usuario: usuario, uid: usuario.id),
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
                  'urlImagen': '',
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
    body: Container(
    color: Color(0xFFDFFCFF),
    child: Column(
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
    ),
        floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 50),
    child: FloatingActionButton(
    onPressed: _showAddUserDialog,
    child: Icon(Icons.add),
    ),
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
          onTap: () => _navigateToUsuarioDetailsView(usuario),
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
          onTap: () => _navigateToUsuarioDetailsView(usuario),
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                usuario.urlImagen != null && usuario.urlImagen!.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12.0), // Redondea las esquinas
                  child: Image.network(
                    usuario.urlImagen!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, size: 80); // Ícono por defecto si la imagen falla
                    },
                  ),
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

  void _showPokemonInfoDialog(BuildContext context, Map<String, dynamic> pokemonData) {
    List<String> abilities = [];
    
    if (pokemonData.containsKey('abilities')) {
      List<dynamic> abilitiesList = pokemonData['abilities'];
      
      abilities = abilitiesList
          .map<String>((ability) => ability['ability']['name'])
          .toList();
    }
  }
}