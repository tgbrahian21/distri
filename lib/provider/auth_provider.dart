import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProviderP extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream de cambios de autenticación
  Stream<bool> get authStateChanges => _auth.authStateChanges().map((User? user) {
        return user != null;
      });

  // Función para iniciar sesión
  Future<bool> login(String usernameOrEmail, String password) async {
    try {
      // Convertir a minúsculas para la comparación
      final String usernameOrEmailLowerCase = usernameOrEmail.toLowerCase();

      // Verificar si es un nombre de usuario o correo electrónico
      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('username_lowercase', isEqualTo: usernameOrEmailLowerCase)
          .limit(1)
          .get();

      // Si se encontró un nombre de usuario, iniciar sesión con el correo electrónico vinculado
      if (result.docs.isNotEmpty) {
        final String email = result.docs.first.get('email');
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        return true;
      }

      // Verificar si el campo ingresado es un correo electrónico
      final QuerySnapshot resultEmail = await _firestore
          .collection('users')
          .where('email', isEqualTo: usernameOrEmailLowerCase)
          .limit(1)
          .get();

      if (resultEmail.docs.isNotEmpty) {
        final String email = resultEmail.docs.first.get('email');
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        return true;
      }

      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return false;
      }
      rethrow;
    }
  }

  // Obtener datos del usuario
  Future<dynamic> getUserData(String email) async {
    final QuerySnapshot<Map<String, dynamic>> result = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (result.docs.isNotEmpty) {
      return result.docs[0].data();
    }
    return null;
  }
}