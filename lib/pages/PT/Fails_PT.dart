import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vista_practica/provider/plancha_provider.dart';

class FailPT extends StatefulWidget {
  const FailPT({super.key});

  @override
  State<FailPT> createState() => _FailPTState();
}

class _FailPTState extends State<FailPT> {
  String? _selectedPlanchaId;

  @override
  void initState() {
    super.initState();
    final planchaProvider = Provider.of<PlanchaProvider>(context, listen: false);
    planchaProvider.handleFirestoreOperation(action: "fetch"); // Carga los datos al iniciar el widget
  }
  bool _showDetails = false; // Controla si se deben mostrar los detalles
  String? _almacenadoPorOperador; // Usamos String? para permitir null
  String? _remitidoAMantenimiento;
  final _fallasController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _saveData() {
    // Aquí puedes agregar la lógica para guardar los datos
  if (!_showDetails) {
    final data = Plancha(
    almacenadoporoperador: "No aplica",
    remitidoamantenimiento: "No aplica",
    fallas: "No aplica",

  );    

    Provider.of<PlanchaProvider>(context, listen: false)
        .handleFirestoreOperation(
            action: "update", data: data, id: _selectedPlanchaId);
   ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos enviados correctamente')),
    );         

  } else {
    final data = Plancha(
    almacenadoporoperador: _almacenadoPorOperador ?? '',
    remitidoamantenimiento: _remitidoAMantenimiento ?? '',
    fallas: _fallasController.text,

  );    

    Provider.of<PlanchaProvider>(context, listen: false)
        .handleFirestoreOperation(
            action: "update", data: data, id: _selectedPlanchaId);

            

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
            Navigator.pop(context);
          },
        ),
        title: const Text('Preop. Placha \nTermofusion'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Logo_distriservicios.png'),
                fit: BoxFit.scaleDown,
                opacity: 0.1,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Dropdown para seleccionar la planta eléctrica
                  Consumer<PlanchaProvider>(
                    builder: (context, provider, child) {
                      return Center(
                        child: DropdownButton<String>(
                          value: _selectedPlanchaId,
                          hint: Text('Selecciona una fecha'),
                          items: provider.planchaList.map((planta) {
                            return DropdownMenuItem<String>(
                              value: planta.id,
                              child: Text(planta.fecha.toString()),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedPlanchaId = newValue;
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
                              padding:
                                  EdgeInsets.only(left: 60.0, bottom: 10.0),
                              child: Text(
                                'En caso\nde fallas',
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 75, 75, 75)),
                              ),
                            ),
                            SizedBox(height: 8),
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
                              'assets/icons/PlanchaTermo.png',
                              height: 70.0,
                              width: 70.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                      ],
                    ),
                    const Text(
                      '¿El equipo presenta fallas?',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showDetails = true;
                              });
                            },
                            child: const Text('Sí'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showDetails = false;
                              });
                              _saveData();
                            },
                            child: const Text('No'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_showDetails) ...[
                      const Text(
                        '*Llenar únicamente si el equipo presenta fallas*',
                        style: TextStyle(color: Colors.red, fontSize: 14.9),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Inserte datos',
                          hintText: '*Punto crítico que inhabilita el equipo para operar*',
                          hintStyle: TextStyle(color: Color.fromARGB(120, 0, 0, 0)),
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese los datos.';
                          }
                          return null;
                        },
                         onChanged: (value) {
                          _fallasController.text = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('El equipo fue:', style: TextStyle(fontSize: 16)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Expanded(
                            child: Text('Separado y remitido a mantenimiento:'),
                          ),
                          Column(
                            children: [
                              const Text('Sí'),
                              Radio<String>(
                                value: 'Sí',
                                groupValue: _almacenadoPorOperador,
                                onChanged: (value) {
                                  setState(() {
                                    _almacenadoPorOperador = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('No'),
                              Radio<String>(
                                value: 'No',
                                groupValue: _almacenadoPorOperador,
                                onChanged: (value) {
                                  setState(() {
                                    _almacenadoPorOperador = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Expanded(
                            child: Text('Separado y almacenado por el operador:'),
                          ),
                          Column(
                            children: [
                              const Text('Sí'),
                              Radio<String>(
                                value: 'Sí',
                                groupValue: _remitidoAMantenimiento,
                                onChanged: (value) {
                                  setState(() {
                                    _remitidoAMantenimiento = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('No'),
                              Radio<String>(
                                value: 'No',
                                groupValue: _remitidoAMantenimiento,
                                onChanged: (value) {
                                  setState(() {
                                    _remitidoAMantenimiento = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      

                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _saveData();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Éxito'),
                                    content: const Text('Datos guardados con éxito'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context); // cerrar ventana emergente
                                          Navigator.pop(context); // regresar al inicio
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
                                    content: const Text('Por favor, llene todos los campos'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context); // cerrar ventana emergente
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
                            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
                            textStyle: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Enviar datos'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
