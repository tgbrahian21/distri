import 'package:flutter/material.dart';
import 'package:vista_practica/pages/pagina_main.dart';

import 'Datos_TR.dart';

import 'Estado_One.dart';
import 'Estado_Two.dart';
import 'Estado_Three.dart';
import 'Estado_Four.dart';
//import 'Estado_Five.dart';
//import 'Estado_Six.dart';
//import 'Estado_Seven.dart';


import 'Fails_TR.dart';

class PaginaTR extends StatefulWidget {
  static const String routeName = 'Pagina Tractor';
  const PaginaTR({super.key});

  @override
  State<PaginaTR> createState() => _PaginaTRState();
}

class _PaginaTRState extends State<PaginaTR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Pagemain(),
                ));
            // Handle back button press
          },
        ),
        title: const Text('Preoperacional'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Logo_distriservicios.png'),
              fit: BoxFit.scaleDown,
              opacity: 0.1,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Alinea los elementos a los extremos
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Alinea el texto a la izquierda
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 60.0,
                            bottom:
                                10.0), // Ajusta el valor de padding según sea necesario
                        child: Text(
                          'Tractor',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      border: Border.all(
                          color: const Color.fromARGB(211, 0, 0, 0), width: 4),
                    ),
                    child: Opacity(
                      opacity: 0.6,
                      child: Image.asset(
                        'assets/icons/Tractor.png',
                        height: 70.0,
                        width: 70.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0), // Espacio derecho
                ],
              ),
              const SizedBox(height: 40),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text('Informacion General')),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const ImageIcon(
                            AssetImage('assets/icons/Tractor.png')),
                        title: const Text('Datos generales'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DatosTR(),
                              ));
                          // Handle Datos generales tap
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text('Estado del vehiculo')),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const ImageIcon(
                            AssetImage('assets/icons/Tractor.png')),
                        title: const Text('1. Estado general'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EstadosONETR(),
                              ));
                          // Handle Datos generales tap
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.checklist),
                        title: const Text('2. Equipo de carretera'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EstadosTWOCAR(),
                              ));
                          // Handle Estado tap
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.checklist),
                        title: const Text('3. Dispositivo de seguridad'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EstadosTHREECAR(),
                              ));
                          // Handle Estado tap
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.checklist),
                        title: const Text('4. Estado mecánico'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EstadosFOURCAR(),
                              ));
                          // Handle Estado tap
                        },
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.checklist),
                        title: const Text('5. Tablero de control'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EstadosFOURCAR(),
                              ));
                          // Handle Datos generales tap
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.checklist),
                        title: const Text('6. Sistema de frenos '),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EstadosFOURCAR(),
                              ));
                          // Handle Estado tap
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.checklist),
                        title: const Text('7. Revisión final'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EstadosFOURCAR(),
                              ));
                          // Handle Datos generales tap
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // Container(
              //     alignment: Alignment.centerLeft,
              //     padding: const EdgeInsets.only(left: 10),
              //     child: const Text('Operador')),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Card(
              //     color: const Color.fromARGB(255, 255, 255, 255),
              //     child: Column(
              //       children: [
              //         ListTile(
              //           leading: const Icon(Icons.edit_note),
              //           title: const Text('Firma y observaciones'),
              //           trailing: const Icon(Icons.arrow_forward_ios),
              //           onTap: () {
              //             // Handle Firma y observaciones tap
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text('En caso de fallas del equipo ')),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.error),
                        title: const Text('EN CASO DE FALLAS'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FailTR(),
                              ));
                          // Handle EN CASO DE FALLA DEL EQUIPO tap
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
