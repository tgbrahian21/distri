import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vista_practica/pages/pagina_main.dart';

import 'package:vista_practica/pages/PE/Estados_PE.dart';
import 'package:vista_practica/provider/camioneta_provider.dart';
import 'package:vista_practica/services/camioneta_service.dart';

import 'Datos_CAR.dart';


import 'Estado_One.dart';
import 'Estado_Two.dart';
import 'Estado_Three.dart';
import 'Estado_Four.dart';
import 'Estado_Five.dart';
import 'Estado_Six.dart';
import 'Estado_Seven.dart';
import 'Estado_Eight.dart';
import 'Estado_Nive.dart';
import 'Estado_Ten.dart';

import 'Fails_VH.dart';

class PaginaCAR extends StatefulWidget {
  static const String routeName = 'Pagina Camioneta';
  const PaginaCAR({super.key});

  @override
  State<PaginaCAR> createState() => _PaginaCARState();
}

class _PaginaCARState extends State<PaginaCAR> {

String? _selectedCamionetaId;
  String? userRole; // Para almacenar el rol del usuario

  @override
  void initState() {
    super.initState();
    final camionetaProvider = Provider.of<CamionetaProvider>(context, listen: false);
    camionetaProvider.handleFirestoreOperation(action: "fetch"); // Carga los datos al iniciar el widget
    _getUserRole(); // Obtener el rol del usuario
  }

  // Método para obtener el rol del usuario actual
  Future<void> _getUserRole() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            userRole = userDoc['role'];
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error al obtener el rol del usuario: $e");
      }
    }
  }

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
      body:SingleChildScrollView( 
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
                        'Camioneta',
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
                      'assets/icons/Camioneta.png',
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
                          AssetImage('assets/icons/Camioneta.png')),
                      title: const Text('Datos generales'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DatosCAR(),
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
                          AssetImage('assets/icons/Camioneta.png')),
                      title: const Text('1. Estado de Comodidad'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EstadosONECAR(),
                            ));
                        // Handle Datos generales tap
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.checklist),
                      title: const Text('2. Niveles y perdidas de líquidos'),
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
                      title: const Text('3. Tablero de Control'),
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
                      title: const Text('4. Seguridad Pasiva'),
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
                      title: const Text('5. Seguridad Activa'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EstadosFIVECAR(),
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
                      title: const Text('6. Estado de Luces'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EstadosSIXCAR(),
                            ));
                        // Handle Datos generales tap
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.checklist),
                      title: const Text('7. Estado Llantas '),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EstadosSEVENCAR(),
                            ));
                        // Handle Estado tap
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.checklist),
                      title: const Text('8. Frenos'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EstadosEIGHTCAR(),
                            ));
                        // Handle Estado tap
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.checklist),
                      title: const Text('9. Otros'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EstadosNINECAR(),
                            ));
                        // Handle Estado tap
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.checklist),
                      title: const Text('10. Equipo de Carretera'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EstadosTENCAR(),
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
                              builder: (context) => const FailVH(),
                            ));
                        // Handle EN CASO DE FALLA DEL EQUIPO tap
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (userRole == 'admin' || userRole == 'superAdmin') ...[
              // Mostrar solo si el usuario tiene el rol adecuado
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10),
                child: const Text('Generar Reporte de la Pulidora'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Column(
                    children: [
                      Consumer<CamionetaProvider>(
                        builder: (context, provider, child) {
                          return DropdownButtonFormField<String>(
                            value: _selectedCamionetaId,
                            hint: const Text('Selecciona un registro para el reporte'),
                            items: provider.camionetaList.map((camioneta) {
                              return DropdownMenuItem<String>(
                                value: camioneta.id,
                                child: Text('${camioneta.fecha} '),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCamionetaId = newValue;
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Registro de Pulidora',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, seleccione un registro';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _selectedCamionetaId == null
                            ? null
                            : () async {
                                final reportService = CamionetaReportService();
                                await reportService.generateAndShareCamionetaReport(_selectedCamionetaId!, 'brahianservidor4@gmail.com');
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 80.0),
                          textStyle: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Generar Reporte PDF'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
    );
  }
}
