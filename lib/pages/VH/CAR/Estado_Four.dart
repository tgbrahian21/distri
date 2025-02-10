import 'package:flutter/material.dart';

class EstadosFOURCAR extends StatefulWidget {
  const EstadosFOURCAR({super.key});

  @override
  State<EstadosFOURCAR> createState() => _EstadosFOURCARState();
}

class _EstadosFOURCARState extends State<EstadosFOURCAR> {
  final _formKey = GlobalKey<FormState>();


  String? _selectedCinturones;
  String? _selectedAirbags;
  String? _selectedChasis;
  String? _selectedCristales;
  String? _selectedEspejos;

  String? _selectedVelocimetro;
  String? _selectedEspejoLatDere;
  String? _selectedEspejoLatizq;
  String? _selectedRetrosivor;


  // Nueva función para enviar los datos seleccionados
  void _saveData() {
    // Recolectar los valores seleccionados
    

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos enviados correctamente')),
    );
  }

  List<String> estadoOptions = ['Bueno','Regular', 'Malo'];

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
        title: const Text('Preop. Camioneta'),
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
                            left: 30.0,
                            bottom:
                                10.0), // Ajusta el valor de padding según sea necesario
                        child: Text(
                          '4. Seguridad\nPasiva',
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
                        'assets/icons/Camioneta.png',
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
              _buildDropdown("Luces de Tablero", _selectedCinturones, estadoOptions),
              _buildDropdown("Airbags", _selectedAirbags, estadoOptions),
              _buildDropdown("Chasis y carrocería", _selectedChasis,estadoOptions),
              _buildDropdown("Cristales (Vidrios)", _selectedCristales, estadoOptions),
              _buildDropdown("Estado Espejos", _selectedEspejos, estadoOptions),

              Container(
                padding: const EdgeInsets.only(top: 50.0, bottom: 0.0),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Indicadores",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 75, 75, 75),
                      ),
                    ),
                    SizedBox(height: 8.0), // Espacio entre los textos
                  ],
                ),
              ),

              _buildDropdown("Velocímetro", _selectedVelocimetro, estadoOptions),
              _buildDropdown("Espejo Lateral Derecho", _selectedEspejoLatDere, estadoOptions),
              _buildDropdown("Espejo Lateral Izquierdo", _selectedEspejoLatizq,estadoOptions),
              _buildDropdown("Espejo Retrovisor", _selectedRetrosivor, estadoOptions),

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
                case "Luces de Tablero":
                  _selectedCinturones = value;
                  break;
                case "Airbags":
                  _selectedAirbags = value;
                  break;
                case "Sistema electrico":
                  _selectedChasis = value;
                  break;
                case "Cristales (Vidrios)":
                  _selectedCristales = value;
                  break;
                case "Estado Espejos":
                  _selectedEspejos = value;
                  break;
                case "Velocímetro":
                  _selectedVelocimetro = value;
                  break;
                case "Espejo Lateral Derecho":
                  _selectedEspejoLatDere = value;
                  break;
                case "Espejo Lateral Izquierdo":
                  _selectedEspejoLatizq = value;
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
