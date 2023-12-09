import 'package:flutter/material.dart';
import '../fireStoreObjets/FbUsuario.dart';
import '../onBoarding/EditUserView.dart'; // Asegúrate de tener esta vista para la edición del usuario

class UsuarioDetailsView extends StatelessWidget {
  final FbUsuario usuario;
  final String uid;

  UsuarioDetailsView({required this.usuario, required this.uid});

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
              width: 100,
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditUserView(usuario: usuario, uid: uid), // Utiliza el uid pasado como parámetro
            ),
          );
        },
      ),
    );
  }


}
