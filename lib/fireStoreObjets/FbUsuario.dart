import 'package:cloud_firestore/cloud_firestore.dart';

class FbUsuario {
  final String id;
  final String nombre;
  final String apellidos;
  final int edad;
  final String? urlImagen; //Campo opcional para la URL de la imagen

  FbUsuario({
    this.id = '',
    required this.nombre,
    required this.apellidos,
    required this.edad,
    this.urlImagen, //Parámetro opcional
  });

  factory FbUsuario.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data() ?? {}; //Usa un mapa vacío si no hay datos
    return FbUsuario(
      id: snapshot.id,
      nombre: data['nombre'] ?? "",
      apellidos: data['apellidos'] ?? "",
      edad: data['edad'] ?? 0,
      urlImagen: data['urlImagen'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (nombre != null) "nombre": nombre,
      if (apellidos != null) "apellidos": apellidos,
      if (edad != null) "edad": edad,
      if (urlImagen != null) "urlImagen": urlImagen, // Añade esto
    };
  }
}
