import 'package:flutter/material.dart';

class EstadosPT extends StatefulWidget {
  const EstadosPT({super.key});

  @override
  State<EstadosPT> createState() => _EstadosPTState();
}

class _EstadosPTState extends State<EstadosPT> {
  final _formKey = GlobalKey<FormState>();


  String? _selectedClavija;
  String? _selectedCableconexion;

  String? _selectedMangoSuje;
  String? _selectedTermometro;
  String? _selectedSockets;


  // Nueva función para enviar los datos seleccionados
  void _saveData() {
    // Recolectar los valores seleccionados
    String message = '''
      Estado de Clavija: $_selectedClavija
      Estado de cable de conexión: $_selectedCableconexion
      Estado de mango de sujeción: $_selectedMangoSuje
      Estado de termometro: $_selectedTermometro
      Estado de Sockets: $_selectedSockets
    ''';

    // Aquí puedes procesar el mensaje o enviarlo a algún servicio o base de datos
    print(message);

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos enviados correctamente')),
    );
  }

  List<String> estadoOptions = ['Bueno', 'Malo'];

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
        title: const Text('Preop. Plancha Termofusion'),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          'Estado',
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
                        'assets/icons/PlanchaTermo.png',
                        height: 70.0,
                        width: 70.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0), // Espacio derecho
                ],
              ),
              const Text(
                "Inserte datos",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.only(bottom: 0.1),
                alignment: Alignment.bottomCenter,
                child: const Text(
                  "Estados",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 75, 75, 75),
                  ),
                ),
              ),
              _buildDropdown("Estado de Clavija", _selectedClavija, estadoOptions),
              _buildDropdown(
                  "Estado de cable de conexión", _selectedCableconexion, estadoOptions),
              _buildDropdown("Estado de mango de sujeción", _selectedMangoSuje,
                  estadoOptions),
              _buildDropdown(
                  "Estado de termometro", _selectedTermometro, estadoOptions),
              _buildDropdown(
                  "Estado de Sockets", _selectedSockets, estadoOptions),


              const SizedBox(height: 58.0),

              // Botón de envío
              ElevatedButton(
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
                                Navigator.pop(
                                    context); // cerrar ventana emergente
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
                          content:
                              const Text('Por favor, llene todos los campos'),
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
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
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
    );
  }

  Widget _buildDropdown(
      String title, String? selectedValue, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 2.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        DropdownButtonFormField<String>(
          hint: const Text('Estado general'),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              switch (title) {
                case "Estado de Clavija":
                  _selectedClavija = value;
                  break;
                case "Estado de cable de conexión":
                  _selectedCableconexion = value;
                  break;
                case "Sistema electrico":
                  _selectedMangoSuje = value;
                  break;
                case "Estado de termometro":
                  _selectedTermometro = value;
                  break;
                case "Estado de Sockets":
                  _selectedSockets = value;
                  break;
              }
            });
          },
          validator: (value) {
            if (value == null) {
              return "Por favor, seleccione una opción";
            }
            return null;
          },
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}
