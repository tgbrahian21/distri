import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vista_practica/pages/pagina_plantaelec.dart';
import 'package:vista_practica/widgets/button_custom.dart';

class Pagemain extends StatefulWidget {
  static const String routeName = 'Pagina Principal';
  const Pagemain({super.key});

  @override
  State<Pagemain> createState() => _PagemainState();
}

class _PagemainState extends State<Pagemain> {
  final GlobalKey<ScaffoldState> _formdKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formdKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.h,
                    width: 80.w,
                    child: Image.asset(
                      'assets/images/distriservicios.png',
                      height: 400,
                      width: 400,
                    ),
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
                              route: PaginaPlantaelec(),
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
                            route: PaginaPlantaelec(),
                          ),
                          ButtonCustom(
                            icon: 'assets/icons/Compresor.png',
                            text: 'Compresor',
                            route: PaginaPlantaelec(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const ButtonCustom(
                        icon: 'assets/icons/Compactador.png',
                        text: 'Compactador',
                        route: PaginaPlantaelec(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
