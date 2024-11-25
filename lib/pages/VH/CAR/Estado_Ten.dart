import 'package:flutter/material.dart';

class EstadosTENCAR extends StatefulWidget {
  const EstadosTENCAR({super.key});

  @override
  State<EstadosTENCAR> createState() => _EstadosTENCARState();
}

class _EstadosTENCARState extends State<EstadosTENCAR> {
  final _formKey = GlobalKey<FormState>();


  String? _selectedGato;
  String? _selectedChalecoReflectivo;
  String? _selectedTaco;
  String? _selectedSenale;
  String? _selectedCruceta;

  String? _selectedCableIniciar;
  String? _selectedExtinguidor;
  String? _selectedConos;
  String? _selectedLinternaAuto;
  String? _selectedCajaHerramientas;

  String? _selectedBotiquin;


  // Nueva función para enviar los datos seleccionados
  void _saveData() {
    // Recolectar los valores seleccionados
    String message = '''
      1 gato  con capacidad para elevar el vehículo: $_selectedGato
      1 chaleco reflectivo: $_selectedChalecoReflectivo
      2 tacos para bloquear el vehículo: $_selectedTaco
      2 señales de carretera triangulares: $_selectedSenale
      1 cruceta: $_selectedCruceta

      1 cable de iniciar: $_selectedCableIniciar
      1 extinguidor de fuego( capacidad mín. 10 lb), Tipo BC preferiblemente CO2: $_selectedExtinguidor
      2 conos plásticos reflectivos de 50 cm de alto: $_selectedConos
      1 linterna auto recargable con adaptador al encendedor de cigarrillos: $_selectedLinternaAuto
      1 caja de herramientas (alicates, destornilladores de pala y estrella, llave de expansión y fijas: $_selectedCajaHerramientas

      Botiquin de primeros auxilios: $_selectedBotiquin
    ''';

    // Aquí puedes procesar el mensaje o enviarlo a algún servicio o base de datos
    print(message);

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
                          '10. Equipo de\ncarretera',
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
              _buildDropdown("1 gato  con capacidad para elevar el vehículo", _selectedGato, estadoOptions),
              _buildDropdown("1 chaleco reflectivo", _selectedChalecoReflectivo, estadoOptions),
              _buildDropdown("2 tacos para bloquear el vehículo", _selectedTaco,estadoOptions),
              _buildDropdown("2 señales de carretera triangulares", _selectedSenale, estadoOptions),
              _buildDropdown("1 cruceta", _selectedCruceta, estadoOptions),

              Container(
                padding: const EdgeInsets.only(top: 50.0, bottom: 0.0),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Demás elementos",
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

              _buildDropdown("1 cable de iniciar", _selectedCableIniciar, estadoOptions),
              _buildDropdown("1 extinguidor de fuego( capacidad mín. 10 lb), Tipo BC preferiblemente CO2", _selectedExtinguidor, estadoOptions),
              _buildDropdown("2 conos plásticos reflectivos de 50 cm de alto", _selectedConos,estadoOptions),

              Container(
                padding: const EdgeInsets.only(top: 50.0, bottom: 0.0),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Botiquin",
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

              _buildDropdown("Botiquin de primeros auxilios.", _selectedBotiquin, estadoOptions),


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
                case "1 gato  con capacidad para elevar el vehículo":
                  _selectedGato = value;
                  break;
                case "1 chaleco reflectivo":
                  _selectedChalecoReflectivo = value;
                  break;
                case "2 tacos para bloquear el vehículo":
                  _selectedTaco = value;
                  break;
                case "2 señales de carretera triangulares":
                  _selectedSenale = value;
                  break;
                case "1 cruceta":
                  _selectedCruceta = value;
                  break;
                case "1 cable de iniciar":
                  _selectedCableIniciar = value;
                  break;
                case "1 extinguidor de fuego( capacidad mín. 10 lb), Tipo BC preferiblemente CO2":
                  _selectedExtinguidor = value;
                  break;
                case "2 conos plásticos reflectivos de 50 cm de alto":
                  _selectedConos = value;
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
