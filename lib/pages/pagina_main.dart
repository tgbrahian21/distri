import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vista_practica/routes/routes.dart';
//import 'package:flutter_form_builder/flutter_form_builder.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:sizer/sizer.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'PE/Inicio_PE.dart';
import 'TA/Inicio_TA.dart';
import 'PL/Inicio_PL.dart';
import 'CMPE/Inicio_CMPE.dart';
import 'CMPA/Inicio_CMPA.dart';
import 'PT/Inicio_PT.dart';
import 'VH/main_VH.dart';

import 'package:vista_practica/widgets/button_custom.dart';

class Pagemain extends StatefulWidget {
  final dynamic userData;
  static const String routeName = 'Pagina Principal';
  const Pagemain({super.key, this.userData});
  
  @override
  State<Pagemain> createState() => _PagemainState();
}

class _PagemainState extends State<Pagemain> {
  final GlobalKey<ScaffoldState> _formdKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          key: _formdKey,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                  image: AssetImage('assets/images/Logo_distriservicios.png'),
                  fit: BoxFit.scaleDown,
                  opacity: 0.1,
                ),
              ),
             child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 30), // Ajusta el padding según lo que necesites
                  child: SizedBox(
                    height: 40,
                    child: Text(
                      'Preoperacionales',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon buttons for each tool

                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ButtonCustom(
                            icon: 'assets/icons/planta_electrica.png',
                            text: 'Planta eléctrica',
                            route: PaginaPlantaelec(),
                          ),
                          ButtonCustom(
                            icon: 'assets/icons/taladro.png',
                            text: 'Taladro',
                            route: PaginaTaladro(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ButtonCustom(
                          icon: 'assets/icons/pulidora.png',
                          text: 'Pulidora',
                          route: PaginaPulidora(),
                        ),
                        ButtonCustom(
                          icon: 'assets/icons/Compresor.png',
                          text: 'Compresor',
                          route: PaginaCMPE(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ButtonCustom(
                          icon: 'assets/icons/Compactador.png',
                          text: 'Compactador',
                          route: PaginaCompacatador(),
                        ),
                        ButtonCustom(
                          icon: 'assets/icons/PlanchaTermo.png',
                          text: 'Plancha Term.',
                          route: PaginaPT(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    const ButtonCustom(
                      icon: 'assets/icons/car.png',
                      text: 'Vehículos',
                      route: PagemainVH(),
                    ),
                  ],
                )
              ],
            ),
        ),
      ),
    );
  }
}
