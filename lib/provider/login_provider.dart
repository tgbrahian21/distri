import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vista_practica/provider/auth_provider.dart';

enum AuthStatus { notAuthenticated, checking, authenticated }

class LoginProvider extends ChangeNotifier {
  AuthStatus authStatus = AuthStatus.notAuthenticated;

  Future<void> loginUser({
    required BuildContext context,
    required String usernameOrEmail,
    required String password,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    final authProvider = Provider.of<AuthProviderP>(context, listen: false);

    try {
      authStatus = AuthStatus.checking;
      notifyListeners();

      // Iniciar sesión delegando a AuthProvider
      bool success = await authProvider.login(usernameOrEmail, password);

      if (success) {
        authStatus = AuthStatus.authenticated;
        onSuccess();
      } else {
        authStatus = AuthStatus.notAuthenticated;
        onError('Usuario o contraseña incorrectos');
      }
      notifyListeners();
    } catch (error) {
      authStatus = AuthStatus.notAuthenticated;
      onError(error.toString());
      notifyListeners();
    }
  }

  // Verificar el estado del usuario (delegado a AuthProvider)
  void checkAuthState(BuildContext context) {
    final authProvider = Provider.of<AuthProviderP>(context, listen: false);
    authProvider.authStateChanges.listen((isAuthenticated) {
      authStatus = isAuthenticated ? AuthStatus.authenticated : AuthStatus.notAuthenticated;
      notifyListeners();
    });
  }

  // Obtener datos del usuario (delegado a AuthProvider)
  Future<dynamic> getUserData(BuildContext context, String email) async {
    final authProvider = Provider.of<AuthProviderP>(context, listen: false);
    return await authProvider.getUserData(email);
  }
}