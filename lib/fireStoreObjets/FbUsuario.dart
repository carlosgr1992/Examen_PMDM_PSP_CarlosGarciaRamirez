import 'package:cloud_firestore/cloud_firestore.dart';

class FbUsuario {
  final String nombre;
  final String apellidos;
  final int edad;
  final String? urlImagen; //Campo opcional para la URL de la imagen

  FbUsuario({
    required this.nombre,
    required this.apellidos,
    required this.edad,
    this.urlImagen, //Parámetro opcional
  });

  factory FbUsuario.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return FbUsuario(
      nombre: data?['nombre'] ?? "",
      apellidos: data?['apellidos'] ?? "",
      edad: (data?['edad'] ?? 0) is int ? data!['edad'] as int : 0,
      urlImagen: data?['urlImagen'], // Añade esto
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
