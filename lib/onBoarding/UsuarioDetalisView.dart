import 'package:flutter/material.dart';
import '../fireStoreObjets/FbUsuario.dart';

class UsuarioDetailsView extends StatelessWidget {
  final FbUsuario usuario;

  UsuarioDetailsView({required this.usuario});

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
            // Mostrar imagen o ícono si la imagen no está disponible
            usuario.urlImagen != null && usuario.urlImagen!.isNotEmpty
                ? Image.network(
              usuario.urlImagen!,
              width: 100, // o el tamaño que prefieras
              height: 100,
              fit: BoxFit.cover,
            )
                : Icon(
              Icons.person,
              size: 100, // Tamaño del ícono
            ),
            SizedBox(height: 20), // Espacio entre imagen y texto
            Text('Nombre: ${usuario.nombre}'),
            Text('Apellidos: ${usuario.apellidos}'),
            Text('Edad: ${usuario.edad}'),
            // Puedes añadir más detalles aquí
          ],
        ),
      ),
    );
  }
}