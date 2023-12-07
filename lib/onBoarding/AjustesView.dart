import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../fireStoreObjets/FbUsuario.dart';

class AjustesView extends StatelessWidget {
  final FbUsuario usuario;

  AjustesView({required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes del Usuario'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Muestra una imagen si la URL está disponible, de lo contrario muestra un ícono
            usuario.urlImagen != null && usuario.urlImagen!.isNotEmpty
                ? CircleAvatar(
              backgroundImage: NetworkImage(usuario.urlImagen!),
              radius: 50.0,
            )
                : CircleAvatar(
              radius: 50.0,
              child: Icon(Icons.person),
            ),
            SizedBox(height: 10),
            Text('Nombre: ${usuario.nombre}'),
            Text('Apellidos: ${usuario.apellidos}'),
            Text('Edad: ${usuario.edad}'),
          ],
        ),
      ),
    );
  }
}