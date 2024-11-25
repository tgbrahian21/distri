import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vista_practica/services/pe_service.dart';
import 'Datos_plantaelec.dart';
import 'Estados_PE.dart';
import 'Liquidos_PE.dart';
import 'Fails_PE.dart';
import 'package:vista_practica/provider/plantaelec_provider.dart';

class PaginaPlantaelec extends StatefulWidget {
  static const String routeName = 'Pagina Planta';
  const PaginaPlantaelec({super.key});

  @override
  State<PaginaPlantaelec> createState() => _PaginaPlantaelecState();
}

class _PaginaPlantaelecState extends State<PaginaPlantaelec> {
  String? _selectedPlantaelecId;
  String? userRole; // Para almacenar el rol del usuario

  @override
  void initState() {
    super.initState();
    final plantaelecProvider = Provider.of<PlantaelecProvider>(context, listen: false);
    plantaelecProvider.handleFirestoreOperation(action: "fetch"); // Carga los datos al iniciar el widget
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
            Navigator.of(context).pop();
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinea los elementos a los extremos
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinea el texto a la izquierda
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 60.0,
                          bottom: 10.0), // Ajusta el valor de padding según sea necesario
                      child: Text(
                        'Planta eléctrica',
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
                      'assets/icons/planta_electrica.png',
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
                child: const Text('Información General')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Column(
                  children: [
                    ListTile(
                      leading: const ImageIcon(
                          AssetImage('assets/icons/planta_electrica.png')),
                      title: const Text('Datos generales'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DatosPlantaelec(),
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
                              builder: (context) => const EstadosPE(),
                            ));
                        // Handle Estado tap
                      },
                    ),
                    ListTile(
                      leading: const ImageIcon(
                          AssetImage('assets/icons/liquidos.png')),
                      title: const Text('Líquidos y Observaciones'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LiquidosPE(),
                            ));
                        // Handle Líquidos tap
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                              builder: (context) => const FailPE(),
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
                child: const Text('Generar Reporte de la Planta Eléctrica'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Column(
                    children: [
                      Consumer<PlantaelecProvider>(
                        builder: (context, provider, child) {
                          return DropdownButtonFormField<String>(
                            value: _selectedPlantaelecId,
                            hint: const Text('Selecciona un registro para el reporte'),
                            items: provider.plantaelecList.map((plantaelec) {
                              return DropdownMenuItem<String>(
                                value: plantaelec.id,
                                child: Text('${plantaelec.fecha} - ${plantaelec.codificacion}'),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedPlantaelecId = newValue;
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Registro de Planta Eléctrica',
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
                        onPressed: _selectedPlantaelecId == null
                            ? null
                            : () async {
                                final reportService = PlantaelecReportService();
                                await reportService.generateAndSharePlantaelecReport(_selectedPlantaelecId!, 'brahianservidor4@gmail.com');
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
    );
  }
}

