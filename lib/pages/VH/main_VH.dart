import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vista_practica/routes/routes.dart';
//import 'package:flutter_form_builder/flutter_form_builder.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:sizer/sizer.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'CAR/Inicio_CAR.dart';

import 'package:vista_practica/widgets/button_custom.dart';

class PagemainVH extends StatefulWidget {
  final dynamic userData;
  static const String routeName = 'Pagina Principal';
  const PagemainVH({super.key, this.userData});

  @override
  State<PagemainVH> createState() => _PagemainVHState();
}

class _PagemainVHState extends State<PagemainVH> {
  final GlobalKey<ScaffoldState> _formdKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, Routes.inicio); // Cambia 'Routes.home' según tu ruta de inicio
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 40), // Ajusta el padding si es necesario
            child: Image.asset(
              'assets/images/distriservicios.png',
              height:
                  40, // Ajusta la altura de la imagen según el tamaño deseado
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popAndPushNamed(context, Routes.login);
            },
          ),
        ],
      ),


      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            key: _formdKey,
                padding: const EdgeInsets.all(100),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                    image: AssetImage('assets/icons/car.png'),
                    fit: BoxFit.scaleDown,
                    opacity: 0.1,
                  ),
                ),
               child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 122), // Ajusta el padding según lo que necesites
                    child: SizedBox(
                      height: 40,
                      child: Text(
                        'Vehiculos',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          
                  Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Botón para Camioneta
                      ButtonCustom(
                        icon: 'assets/icons/Camioneta.png',
                        text: 'Camioneta',
                        route: PaginaCAR(),
                      ),
                      SizedBox(height: 10),

                      // Botones para Tractor y Zanjadora en una fila
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuye equitativamente
                        children: [
                          SizedBox(
                            width: 103, // Ancho máximo del botón
                            child: ButtonCustom(
                              icon: 'assets/icons/Tractor.png',
                              text: 'Tractor',
                              route: PaginaCAR(),
                            ),
                          ),
                          SizedBox(
                            width: 103, // Ancho máximo del botón
                            child: ButtonCustom(
                              icon: 'assets/icons/Zj.png',
                              text: 'Zanjadora',
                              route: PaginaCAR(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),


                ],
              ),
          ),
        ],
      ),
    );
  }
}
