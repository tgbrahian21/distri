import 'package:flutter/material.dart';

class EstadosPL extends StatefulWidget {
  const EstadosPL({super.key});

  @override
  State<EstadosPL> createState() => _EstadosPLState();
}

class _EstadosPLState extends State<EstadosPL> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedConexionesPL;
  String? _selectedInstDisco;
  String? _selectedAcoplesPL;


  String? _selectedInstMangoPL;
  String? _selectedInterruptorIncenPL;
  String? _selectedGuiaGuardaPL;
  String? _selectedAccesoriosPL;

  String? _selectedGeneralPL;
  String? _selectedEppPL;
  String? _selectedBarrerasPL;
  String? _selectedDiscoPL;


  // Nueva función para enviar los datos seleccionados
  void _saveData() {
    // Recolectar los valores seleccionados
    String message = '''
      Se verificó el estado de conexiones eléctricas: $_selectedConexionesPL
      Estado del interruptor de encendido: $_selectedInstDisco
      Cuenta con acoples adecuados para los accesorios: $_selectedAcoplesPL
      
      Estado del cuerpo $_selectedInstMangoPL
      Estado de la guarda: $_selectedInterruptorIncenPL
      Estado del interruptor de accion de martillo: $_selectedGuiaGuardaPL
      Estado del mango: $_selectedAccesoriosPL

      Estado general de la pulidora: $_selectedGeneralPL
      Se utilizan adecuadamente los epp para la labor: $_selectedEppPL
      Se han instalado barreras y/o aislamientos apropiados: $_selectedBarrerasPL
      Estado del disco: $_selectedDiscoPL  


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
        title: const Text('Preop. Pulidora'),
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
          child: Form(
            key: _formKey, // El _formKey debe ir aquí en el Form
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
                          'assets/icons/pulidora.png',
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
                Container(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 0.0),
                  alignment: Alignment.center,
                  child: const Column(
                    children: <Widget>[
                      Text(
                        "Se verificó el estado de conexiones eléctricas",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 75, 75, 75),
                        ),
                      ),
                      Text(
                        "(Extensiones, cables, toma)",
                        style: TextStyle(
                          fontSize: 14.5, // Tamaño de texto más pequeño
                          color: Colors.grey, // Color del texto pequeño
                        ),
                      ),
                    ],
                  ),
                ),
                _buildDropdown(
                  "Seleccione el estado",
                  _selectedConexionesPL,
                  estadoOptions,
                  (value) => setState(() => _selectedConexionesPL = value),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20.0),
                  alignment: Alignment.center,
                  child: const Column(
                    children: <Widget>[
                      Text(
                        "Estado de instalacion del disco",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 75, 75, 75),
                        ),
                      ),
                      Text(
                        "(Insertacion)",
                        style: TextStyle(
                          fontSize: 14.5, // Tamaño de texto más pequeño
                          color: Colors.grey, // Color del texto pequeño
                        ),
                      ),
                    ],
                  ),
                ),
                _buildDropdown(
                  "Seleccione el estado",
                  _selectedInstDisco,
                  estadoOptions,
                  (value) => setState(() => _selectedInstDisco = value),
                ),
                _buildDropdown(
                  "Cuenta con acoples adecuados para los accesorios",
                  _selectedAcoplesPL,
                  estadoOptions,
                  (value) => setState(() => _selectedAcoplesPL = value),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 0.0),
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Estado e instalacion del mango",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 75, 75, 75),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildDropdown(
                  "Estado e instalacion del mango",
                  _selectedInstMangoPL,
                  estadoOptions,
                  (value) => setState(() => _selectedInstMangoPL = value),
                ),
                _buildDropdown(
                  "Estado del interruptor de incendio y su seguro",
                  _selectedInterruptorIncenPL,
                  estadoOptions,
                  (value) => setState(() => _selectedInterruptorIncenPL = value),
                ),
                _buildDropdown(
                  "Estado de la guia de la guarda",
                  _selectedGuiaGuardaPL,
                  estadoOptions,
                  (value) => setState(() => _selectedGuiaGuardaPL = value),
                ),
                _buildDropdown(
                  "Se utiliza accesorios apropiados para la tarea",
                  _selectedAccesoriosPL,
                  estadoOptions,
                  (value) => setState(() => _selectedAccesoriosPL = value),
                ),

                
                Container(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 0.0),
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Estado general de la pulidora",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 75, 75, 75),
                        ),
                      ),
                      Text(
                        "(Fisuras, posturas, aseo, etc...)",
                        style: TextStyle(
                          fontSize: 14.5, // Tamaño de texto más pequeño
                          color: Colors.grey, // Color del texto pequeño
                        ),
                      ),
                    ],
                  ),
                ),
                _buildDropdown(
                  "Estado general de la pulidora",
                  _selectedGeneralPL,
                  estadoOptions,
                  (value) => setState(() => _selectedGeneralPL = value),
                ),
                _buildDropdown(
                  "Se utilizan adecuadamente los epp para la labor",
                  _selectedEppPL,
                  estadoOptions,
                  (value) => setState(() => _selectedEppPL = value),
                ),
                _buildDropdown(
                  "Se han instalado barreras y/o aislamientos apropiados",
                  _selectedBarrerasPL,
                  estadoOptions,
                  (value) => setState(() => _selectedBarrerasPL = value),
                ),
                _buildDropdown(
                  "Estado del disco",
                  _selectedDiscoPL,
                  estadoOptions,
                  (value) => setState(() => _selectedDiscoPL = value),
                ),

                const SizedBox(height: 50.0),


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
      ),
    );
  }

  Widget _buildDropdown(
    String title,
    String? selectedValue,
    List<String> options,
    Function(String?) onChanged,
  ) {
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
          onChanged: onChanged,
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
