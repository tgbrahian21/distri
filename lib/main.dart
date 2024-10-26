import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vista_practica/firebase_options.dart';
import 'package:vista_practica/pages/pagina_main.dart';
import 'package:vista_practica/provider/auth_provider.dart';
import 'package:vista_practica/provider/login_provider.dart';
import 'package:vista_practica/provider/register_provider.dart';
import 'package:vista_practica/routes/app_routes.dart';
import 'package:vista_practica/routes/routes.dart';
import 'package:vista_practica/services/local_storage.dart';
import 'package:vista_practica/services/push_notification.dart';


void main() async {
  Intl.defaultLocale = 'es_ES';
  await initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initializeApp();
  await LocalStorage().init();
  final isLogged = LocalStorage().getIsLoggedIn();
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
            ChangeNotifierProvider(lazy: false,create: (_) => LoginProvider()),
            ChangeNotifierProvider(lazy: false,create: (_) => AuthProviderP()),
            ChangeNotifierProvider(lazy: false,create: (_) => RegisterProvider()),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              // ... app-specific localization delegate[s] here
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
               Locale('en','US'), // English
               Locale('es','ES'), // Hebrew
            ],
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.splash,
            routes: appRoutes,
            // Add other properties as needed
          ),
        );
      },
    );
  }
/*  Widget Imagenfondo() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(File('assets/images/Logo_distriservicios.jpg', )),
          fit: BoxFit.cover
        ),
      ),
      child: Center(child: Text("")),
    );
  }
*/
  
}