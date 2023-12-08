import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../fireStoreObjets/FbUsuario.dart';

class FirebaseAdmin {

  final FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _auth.currentUser;
    } catch (e) {
      print("Error en inicio de sesión: $e");
      return null;
    }
  }

  Future<void> updateUser(String uid, String nombre, String apellidos, int edad, String imagen) async {
    await FirebaseFirestore.instance.collection('Usuarios').doc(uid).update({
      'nombre': nombre,
      'apellidos': apellidos,
      'edad': edad,
      'urlImagen' : imagen,
    });
  }

  Future<void> addUserDetails(String email, String password, String nombre, String apellidos, int edad, String urlImagen) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;

      // Guardar detalles adicionales en Firestore
      await FirebaseFirestore.instance.collection('Usuarios').doc(uid).set({
        'nombre': nombre,
        'apellidos': apellidos,
        'edad' : edad,
        'urlImagen' : urlImagen,
      });
    } catch (e) {
      print("Error al registrar usuario: $e");
    }
  }

  Future<FbUsuario?> loadFbUsuario() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('Usuarios').doc(currentUser.uid).get();

        if (snapshot.exists && snapshot.data() != null) {
          var usuarioData = FbUsuario.fromFirestore(snapshot, null);
          return FbUsuario(
              nombre: usuarioData.nombre,
              apellidos: usuarioData.apellidos,
              edad: usuarioData.edad,
              urlImagen: usuarioData.urlImagen
          );
        }
      } catch (e) {
        print('Error al cargar el usuario: $e');
      }
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> addUser(String nombre, String apellidos, int edad) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        await _db.collection('Usuarios').doc(userId).set({
          'nombre': nombre,
          'apellidos': apellidos,
          'edad': edad,
        });
      }
    } catch (e) {
      print("Error al agregar usuario: $e");
    }
  }

  Future<FbUsuario?> getCurrentUser() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection('Usuarios').doc(user.uid).get();
        if (snapshot.exists) {
          print("Usuario encontrado: ${snapshot.data()}");
          return FbUsuario.fromFirestore(snapshot, null);
        }
      } catch (e) {
        print("Error al obtener información del usuario actual: $e");
      }
    }
    return null;
  }

  Future<FbUsuario?> getUserInfo() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection('Usuarios').doc(user.uid).get();
        return FbUsuario.fromFirestore(snapshot, null);
      }
    } catch (e) {
      print("Error al obtener información del usuario: $e");
    }
    return null;
  }

  Future<List<FbUsuario>> obtenerUsuarios() async {
    List<FbUsuario> usuarios = [];

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await db.collection('Usuarios').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
      in querySnapshot.docs) {
        // Crea un nuevo objeto FbUsuario para cada documento y agrégalo a la lista
        FbUsuario usuario = FbUsuario(
          nombre: document.data()['nombre'] ?? '',
          apellidos: document.data()['apellidos'] ?? '',
          edad: document.data()['edad'] ?? 0,
        );

        usuarios.add(usuario);
      }

      return usuarios;
    } catch (e) {
      // Manejo de errores
      print('Error al obtener usuarios: $e');
      return [];
    }
  }
}
