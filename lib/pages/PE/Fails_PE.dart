import 'package:flutter/material.dart';

class FailPE extends StatefulWidget {
  const FailPE({super.key});

  @override
  State<FailPE> createState() => _FailPEState();
}

class _FailPEState extends State<FailPE> {
  bool _showDetails = false; // Controla si se deben mostrar los detalles
  String _almacenadoPorOperador = ''; // Estado para la primera opción
  String _remitidoAMantenimiento = ''; // Estado para la segunda opción
// Variable para los datos del TextField
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario

  void _saveData() {
    // Aquí puedes agregar la lógica para guardar los datos
    print('Datos guardados');
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
        title: const Text('Preop. Planta Electrica'),
      ),
      body: Stack( // Usamos un Stack para la imagen de fondo
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
          SingleChildScrollView( // Mantener el contenido desplazable
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 60.0, bottom: 10.0),
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
                              'assets/icons/planta_electrica.png',
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
                                _showDetails = true; // Mostrar el resto del contenido
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
                                _showDetails = false; // Ocultar el contenido
                              });
                            },
                            child: const Text('No'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Mostrar el resto del contenido solo si _showDetails es verdadero
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
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('El equipo fue:', style: TextStyle(fontSize: 16)),

                      // Primera opción: Separado y almacenado por el operador
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
                                    _almacenadoPorOperador = value!;
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
                                    _almacenadoPorOperador = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Segunda opción: Separado y almacenado por el operador
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
                                    _remitidoAMantenimiento = value!;
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
                                    _remitidoAMantenimiento = value!;
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
