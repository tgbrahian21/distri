import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vista_practica/provider/compactador_provider.dart';

class LiquidosCMPA extends StatefulWidget {
  const LiquidosCMPA({Key? key}) : super(key: key);

  @override
  _LiquidosCMPAState createState() => _LiquidosCMPAState();
}

class _LiquidosCMPAState extends State<LiquidosCMPA> {

  String? _selectedCompactadorId;

  @override
  void initState() {
    super.initState();
    final compactadorProvider = Provider.of<CompactadorProvider>(context, listen: false);
    compactadorProvider.handleFirestoreOperation(action: "fetch"); // Carga los datos al iniciar el widget
  }
  final _formKey = GlobalKey<FormState>();
   final _combustible = TextEditingController();
  final _aceite = TextEditingController();

  void _saveData() {
    // Aquí puedes agregar la lógica para guardar los datos
    final data = Compactador(
      combustible: _combustible.text,
      aceite: _aceite.text,
    );

    Provider.of<CompactadorProvider>(context, listen: false)
        .handleFirestoreOperation(
            action: "update", data: data, id: _selectedCompactadorId!);

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos enviados correctamente')),
    );


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
            Navigator.pop(context);
          },
        ),
        title: const Text('Preop. Compactador'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/Logo_distriservicios.png'),
                fit: BoxFit.scaleDown,
                opacity: 0.1,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey, // Se agrega el FormKey aquí
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Dropdown para seleccionar la planta eléctrica
                  Consumer<CompactadorProvider>(
                    builder: (context, provider, child) {
                      return Center(
                        child: DropdownButton<String>(
                          value: _selectedCompactadorId,
                          hint: Text('Selecciona una fecha'),
                          items: provider.compactadorList.map((planta) {
                            return DropdownMenuItem<String>(
                              value: planta.id,
                              child: Text(planta.fecha.toString()),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCompactadorId = newValue;
                            });
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 60.0, bottom: 10.0),
                            child: Text(
                              'Líquidos',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 75, 75, 75)),
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
                              color: const Color.fromARGB(212, 75, 75, 75),
                              width: 4),
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
                      const SizedBox(width: 16.0),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Se verifica el nivel líquidos en la máquina',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Inserte datos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // Campo de combustible
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Combustible',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _combustible,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nivel de combustible',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese el nivel de combustible';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Campo de aceite
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Aceite',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _aceite,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Cambios de aceite',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese los cambios de aceite';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Botón de enviar
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveData();
                        _aceite.clear();
                        _combustible.clear();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Éxito'),
                              content: const Text('Datos guardados con éxito'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context); // cerrar ventana emergente
                                    Navigator.pop(
                                        context); // regresar al inicio
                                  },
                                  child: const Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Falta información'),
                              content: const Text(
                                  'Por favor, llene todos los campos'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context); // cerrar ventana emergente
                                  },
                                  child: const Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 80.0),
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Enviar datos'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
