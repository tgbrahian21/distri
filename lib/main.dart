import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:vista_practica/firebase_options.dart';
import 'package:vista_practica/pages/pagina_main.dart';
import 'package:vista_practica/provider/auth_provider.dart';
import 'package:vista_practica/provider/compactador_provider.dart';
import 'package:vista_practica/provider/compresor_provider.dart';
import 'package:vista_practica/provider/login_provider.dart';
import 'package:vista_practica/provider/plantaelec_provider.dart';
import 'package:vista_practica/provider/pulidora_provider.dart';
import 'package:vista_practica/provider/register_provider.dart';
import 'package:vista_practica/provider/taladro_provider.dart';
import 'package:vista_practica/routes/app_routes.dart';
import 'package:vista_practica/routes/routes.dart';
import 'package:vista_practica/services/local_storage.dart';
import 'package:vista_practica/services/push_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter(); // Inicializa Hive usando Hive Flutter
  await Hive.openBox('plantaelec'); // Abre una caja llamada 'plantaelec'
  await PushNotificationService.initializeApp();
  await LocalStorage().init();
  final isLogged = LocalStorage().getIsLoggedIn();

  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);

  runApp(MyApp(isLogged: isLogged));
}

class MyApp extends StatelessWidget {
  final bool isLogged;
  const MyApp({super.key, required this.isLogged});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(lazy: false, create: (_) => LoginProvider()),
            ChangeNotifierProvider(lazy: false, create: (_) => AuthProviderP()),
            ChangeNotifierProvider(lazy: false, create: (_) => RegisterProvider()),
            ChangeNotifierProvider(lazy: false, create: (_) => PlantaelecProvider()),
            ChangeNotifierProvider(lazy: false, create: (_) => PulidoraProvider()),
            ChangeNotifierProvider(lazy: false, create: (_) => TaladroProvider()),
            ChangeNotifierProvider(lazy: false, create: (_) => CompresorProvider()),
            ChangeNotifierProvider(lazy: false, create: (_) => CompactadorProvider()),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'), // English
              Locale('es', 'ES'), // Spanish
            ],
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.firsh,
            routes: appRoutes,
          ),
        );
      },
    );
  }
}