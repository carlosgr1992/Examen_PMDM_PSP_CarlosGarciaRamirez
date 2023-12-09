import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../fireStoreObjets/FbUsuario.dart';
import '../singletone/FireBaseAdmin.dart';

class EditUserView extends StatefulWidget {
  final FbUsuario usuario;
  final String uid;

  EditUserView({required this.usuario, required this.uid});

  @override
  _EditUserViewState createState() => _EditUserViewState();
}

class _EditUserViewState extends State<EditUserView> {
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _edadController = TextEditingController();
  final _imagenController = TextEditingController(); // Controlador para URL de imagen

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.usuario.nombre;
    _apellidosController.text = widget.usuario.apellidos;
    _edadController.text = widget.usuario.edad.toString();
    _imagenController.text = widget.usuario.urlImagen ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _apellidosController,
              decoration: InputDecoration(labelText: 'Apellidos'),
            ),
            TextField(
              controller: _edadController,
              decoration: InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _imagenController,
              decoration: InputDecoration(labelText: 'URL de Imagen'),
            ),
            ElevatedButton(
              onPressed: _updateUser,
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateUser() async {
    // Suponiendo que tienes una instancia de FirebaseAdmin llamada firebaseAdmin
    var firebaseAdmin = FirebaseAdmin();
    await firebaseAdmin.updateUser(
      widget.uid,
      _nombreController.text,
      _apellidosController.text,
      int.parse(_edadController.text),
      _imagenController.text,
    );

    Navigator.pop(context);
  }
}