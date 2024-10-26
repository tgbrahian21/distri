import 'package:flutter/material.dart';
import 'package:vista_practica/pages/login/login_view.dart';
import 'package:vista_practica/pages/pagina_main.dart';
import 'package:vista_practica/pages/register/register_view.dart';
import 'package:vista_practica/pages/splash_page.dart';
import 'package:vista_practica/routes/routes.dart';


Map<String, Widget Function(BuildContext)> appRoutes = {
  Routes.inicio: (_) => const Pagemain(),
  
  Routes.register: (_) => const RegisterView(),
  Routes.login: (_) => const LoginView(),
  Routes.splash: (_) => const SplashPage(),

  //Routes.firsh: (_) => const FirshPage(),

  
};