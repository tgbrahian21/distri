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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: ()async {
              await FirebaseAuth.instance.signOut();
              Navigator.popAndPushNamed(context, Routes.login);
            },
          )
        ],
        
      ),

      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            key: _formdKey,
            children:[
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Logo_distriservicios.png'),
                      fit: BoxFit.scaleDown,opacity: 0.1  // Ajusta la imagen como desees
                    ),
                  ),
                ),
                
                    
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     SizedBox(
                       height: 10.h,
                       width: 80.w,
                       child: Image.asset('assets/images/distriservicios.png')
                     ),

                     
                    const SizedBox(
                      height: 40,
                      child: Text(
                        'Preoperacionales',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon buttons for each tool

                        Container(
                          margin: const EdgeInsets.only(top: 60),
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

                        const SizedBox(height: 30),
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
                        const SizedBox(height: 30),
                        const ButtonCustom(
                          icon: 'assets/icons/Compactador.png',
                          text: 'Compactador',
                          route: PaginaCompacatador(),
                        ),
                      ],
                    )
                  ],
                ),
            ],
        ),  
        ),
      );
  }
}
