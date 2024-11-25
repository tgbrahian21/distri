import 'package:flutter/material.dart';
import 'package:vista_practica/pages/pagina_main.dart';

import'Datos_PT.dart';
import 'Estados_PT.dart';
import 'Fails_PT.dart';



class PaginaPT extends StatefulWidget {
  static const String routeName = 'Pagina Plancha Termofusion';
  const PaginaPT({super.key});

  @override
  State<PaginaPT> createState() => _PaginaPTState();
}

class _PaginaPTState extends State<PaginaPT> {
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
      body: Container(
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
                        'Plancha\nTermofusion',
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
                      'assets/icons/PlanchaTermo.png',
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
                          AssetImage('assets/icons/PlanchaTermo.png')),
                      title: const Text('Datos generales'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DatosPT(),
                            ));
                        // Handle Datos generales tap
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.checklist),
                      title: const Text('Estado'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EstadosPT(),
                            ));
                        // Handle Estado tap
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
                              builder: (context) => const FailPT(),
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
    );
  }
}
