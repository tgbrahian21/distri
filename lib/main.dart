import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vista_practica/pages/pagina_main.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Preoperacionales',
          debugShowCheckedModeBanner: false,
          initialRoute: Pagemain.routeName,
          routes: {
            Pagemain.routeName: (context) => const Pagemain(),
            
          },
          // Add other properties as needed
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