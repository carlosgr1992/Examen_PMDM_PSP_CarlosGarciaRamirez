import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../fireStoreObjets/FbUsuario.dart';

class FirebaseAdmin {
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
}
