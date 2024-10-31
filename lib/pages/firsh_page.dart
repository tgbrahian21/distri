import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:vista_practica/pages/pagina_main.dart';
import 'package:vista_practica/provider/login_provider.dart';
import 'package:vista_practica/routes/routes.dart';
import 'package:vista_practica/widgets/circularprogress_widget.dart';

class FirshPage extends StatefulWidget {
  const FirshPage({super.key});

  @override
  _FirshPageState createState() => _FirshPageState();
}

class _FirshPageState extends State<FirshPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late bool isFirstTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPrefs();
    _checkAuthStatus();
  }


  Future<void> _initPrefs() async {
    final userBox = await Hive.openBox('user');
    isFirstTime = !userBox.containsKey('isLogged');
  }

  void _checkAuthStatus() async {
  final loginProvider = Provider.of<LoginProvider>(context, listen: false);
  await Future.delayed(const Duration(seconds: 1));
  if (isFirstTime) {
    final userBox = await Hive.openBox('user');
    userBox.put('isLogged', true);
    Navigator.pushReplacementNamed(context, Routes.splash);
  } else {
    final userBox = await Hive.openBox('user');
    final bool isLogged = userBox.get('isLogged', defaultValue: false);
    final user = _auth.currentUser;
    if (user != null && user.email != null && user.emailVerified) {
      dynamic userData = await loginProvider.getUserData(context, user.email!); // Corrección aquí

      if (isLogged) {
        Navigator.push(context, 
          MaterialPageRoute(builder: (context) => Pagemain(userData: userData)));
      }

    } else {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: Center(
        child: CircularProgressWidget(text: "Cargando..."),
      ),

    );
  }
}