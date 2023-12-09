import 'package:examen_pmdm_psp_carlosgarciaramirez/singletone/DataHolder.dart';
import 'package:flutter/material.dart';
import '../fireStoreObjets/FbUsuario.dart';
import '../onBoarding/EditUserView.dart'; // Asegúrate de tener esta vista para la edición del usuario

class UsuarioDetailsView extends StatefulWidget {
  final FbUsuario usuario;
  final String uid;

  UsuarioDetailsView({required this.usuario, required this.uid});

  @override
  _UsuarioDetailsViewState createState() => _UsuarioDetailsViewState();
}

class _UsuarioDetailsViewState extends State<UsuarioDetailsView> {
  FbUsuario? usuario;

  @override
  void initState() {
    super.initState();
    usuario = widget.usuario;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Usuario'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            usuario!.urlImagen != null && usuario!.urlImagen!.isNotEmpty
                ? Image.network(usuario!.urlImagen!, width: 100, height: 100, fit: BoxFit.cover)
                : Icon(Icons.person, size: 100),
            SizedBox(height: 20),
            Text('Nombre: ${usuario!.nombre}'),
            Text('Apellidos: ${usuario!.apellidos}'),
            Text('Edad: ${usuario!.edad}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditUserView(usuario: usuario!, uid: widget.uid),
            ),
          );

          if (result == true) {
            final currentUser = await DataHolder.firebaseAdmin.getCurrentUser();
            setState(() {
              usuario = currentUser;
            });
          }
        },
      ),
    );
  }
}
