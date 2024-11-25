import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vista_practica/provider/compactador_provider.dart';
import 'package:vista_practica/services/cmpa_service.dart';
import 'Datos_CMPA.dart';
import 'Fails_CMPA.dart';
import 'Liquidos_CMPA.dart';
import 'Estados_CMPA.dart';

class PaginaCompacatador extends StatefulWidget {
  static const String routeName = 'Pagina Compactador';
  const PaginaCompacatador({super.key});

  @override
  State<PaginaCompacatador> createState() => _PaginaCompacatadorState();
}

class _PaginaCompacatadorState extends State<PaginaCompacatador> {
  String? _selectedCompactadorId;
  String? userRole; // Para almacenar el rol del usuario
  String searchQuery = ''; // Para almacenar la consulta de búsqueda
  List<QueryDocumentSnapshot> searchResults = []; // Resultados de búsqueda

  @override
  void initState() {
    super.initState();
    final compactadorProvider = Provider.of<CompactadorProvider>(context, listen: false);
    compactadorProvider.handleFirestoreOperation(action: "fetch"); // Carga los datos al iniciar el widget
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

  // Método para buscar registros en Firestore
  Future<void> _searchCompactadores(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Compactador')
          .where('codificacion', isGreaterThanOrEqualTo: query)
          .where('codificacion', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      setState(() {
        searchResults = snapshot.docs;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error al buscar compactadores: $e");
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
                          'Compactador',
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
                        'assets/icons/Compactador.png',
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
                            AssetImage('assets/icons/Compactador.png')),
                        title: const Text('Datos generales'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DatosCMPA(),
                              ));
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
                                builder: (context) => const EstadosCMPA(),
                              ));
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
                                builder: (context) => const LiquidosCMPA(),
                              ));
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
                                builder: (context) => const FailCMPA(),
                              ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (userRole == 'admin' || userRole == 'superAdmin') ...[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text('Buscar y Generar Reporte del Compactador'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Buscar por codificación o fecha',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                            _searchCompactadores(value);
                          },
                        ),
                        const SizedBox(height: 16),
                        if (searchResults.isNotEmpty)
                          DropdownButtonFormField<String>(
                            value: _selectedCompactadorId,
                            hint: const Text('Selecciona un registro para el reporte'),
                            items: searchResults.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return DropdownMenuItem<String>(
                                value: doc.id,
                                child: Text('${data['fecha']} - ${data['codificacion']}'),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCompactadorId = newValue;
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Registro de Compactador',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, seleccione un registro';
                              }
                              return null;
                            },
                          ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _selectedCompactadorId == null
                              ? null
                              : () async {
                                  final reportService = CompactadorReportService();
                                  await reportService.generateAndShareCompactadorReport(_selectedCompactadorId!, 'brahianservidor4@gmail.com');
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



