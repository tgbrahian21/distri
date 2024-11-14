import 'package:flutter/material.dart';

class EstadosCMPA extends StatefulWidget {
  const EstadosCMPA({super.key});

  @override
  State<EstadosCMPA> createState() => _EstadosCMPAState();
}

class _EstadosCMPAState extends State<EstadosCMPA> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedTanqueCombustibleYtapa;
  String? _selectedPalancaAcelerador;

  String? _selectedVarillaAceite;
  String? _selectedFiltroAceite;
  String? _selectedFiltroGasolina;
  String? _selectedFiltroMotor;

  String? _selectedvalvula;
  String? _selectedZapata;
  String? _selectedSilenciador;

  String? _selectedPalancaDescompresion;
  String? _selectedFuelle;
  String? _selectedManillar;
  String? _selectedManija;


  // Nueva función para enviar los datos seleccionados
  void _saveData() {
    // Recolectar los valores seleccionados
    String message = '''
      Tanque combustible y tapa: $_selectedTanqueCombustibleYtapa
      Palanca de acelerador: $_selectedPalancaAcelerador
      Varilla -  nivel de aceite de motor: $_selectedVarillaAceite
      Filtro de aceite: $_selectedFiltroAceite
      Filtro Gasolina: $_selectedFiltroGasolina
      Filtro del aire del motor: $_selectedFiltroMotor
      Válvula de drenaje: $_selectedvalvula
      Zapata: $_selectedZapata
      Silenciador: $_selectedSilenciador
      Palanca de descompresion: $_selectedPalancaDescompresion
      Fuelle: $_selectedFuelle
      Manillar: $_selectedManillar
      Manija de arranque por retroceso: $_selectedManija
    ''';

    // Aquí puedes procesar el mensaje o enviarlo a algún servicio o base de datos
    print(message);

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos enviados correctamente')),
    );
  }

  List<String> estadoOptions = ['Bueno', 'Regular', 'Malo'];

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
                        'assets/icons/Compactador.png',
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

              Row(
                children: [
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    key: _formKey,
                    child: _buildDropdown("Tanque combustible y tapa", _selectedTanqueCombustibleYtapa, estadoOptions),
                        
                  ),
                  
                  const SizedBox(width: 5.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: _buildDropdown("Palanca de \n acelerador",
                        _selectedPalancaAcelerador, estadoOptions),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.only(bottom: 0.1),
                alignment: Alignment.bottomCenter,
                child: const Text(
                  "Varilla -  nivel de aceite de motor",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 75, 75, 75),
                  ),
                ),
              ),
              _buildDropdown("Varilla -  nivel de aceite de motor", _selectedVarillaAceite, estadoOptions),
              _buildDropdown(
                  "Filtro de aceite", _selectedFiltroAceite, estadoOptions),
              _buildDropdown("Sistema electrico", _selectedFiltroGasolina,
                  estadoOptions),
              _buildDropdown(
                  "Estado de bateria", _selectedFiltroMotor, estadoOptions),

              Container(
                padding: const EdgeInsets.only(top: 50.0, bottom: 0.0),
                alignment: Alignment.center,
                child: const Text(
                  "Válvula de drenaje",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 75, 75, 75),
                  ),
                ),
              ),

              _buildDropdown("", _selectedvalvula, estadoOptions),
              _buildDropdown("Soporte de generador", _selectedZapata,
                  estadoOptions),
              _buildDropdown("Estado - Silenciador",
                  _selectedSilenciador, estadoOptions),
              _buildDropdown("Palanca de descompresion",
                  _selectedPalancaDescompresion, estadoOptions),

              Container(
                padding: const EdgeInsets.only(top: 50.0, bottom: 0.0),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Fuelle",
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

              _buildDropdown("",
                  _selectedFuelle, estadoOptions),
              _buildDropdown("manillar", _selectedManillar, estadoOptions),
              _buildDropdown(
                  "Manija de arranque por retroceso", _selectedManija, estadoOptions),

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
                case "Encendido":
                  _selectedTanqueCombustibleYtapa = value;
                  break;
                case "Palanca de acelerador":
                  _selectedPalancaAcelerador = value;
                  break;
                case "Varilla -  nivel de aceite de motor":
                  _selectedVarillaAceite = value;
                  break;
                case "Filtro de aceite":
                  _selectedFiltroAceite = value;
                  break;
                case "Sistema electrico":
                  _selectedFiltroGasolina = value;
                  break;
                case "Filtro del aire del motor":
                  _selectedFiltroMotor = value;
                  break;
                case "Válvula de drenaje":
                  _selectedvalvula = value;
                  break;
                case "Soporte de generador":
                  _selectedZapata = value;
                  break;
                case "Silenciador":
                  _selectedSilenciador = value;
                  break;
                case "Palanca de descompresion":
                  _selectedPalancaDescompresion = value;
                  break;
                case "Fuelle":
                  _selectedFuelle = value;
                  break;
                case "Acoples":
                  _selectedManillar = value;
                  break;
                case "Exhosto":
                  _selectedManija = value;
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
