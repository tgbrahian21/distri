import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vista_practica/provider/compresor_provider.dart';

class EstadosCMPE extends StatefulWidget {
  const EstadosCMPE({super.key});

  @override
  State<EstadosCMPE> createState() => _EstadosCMPEState();
}

class _EstadosCMPEState extends State<EstadosCMPE> {
  String? _selectedCompresorId;

  @override
  void initState() {
    super.initState();
    final compresorProvider = Provider.of<CompresorProvider>(context, listen: false);
    compresorProvider.handleFirestoreOperation(action: "fetch"); // Carga los datos al iniciar el widget
  }
  final _formKey = GlobalKey<FormState>();

  String? _selectedInterPresionCMPE;
  String? _selectedManometroCMPE;
  String? _selectedHorometroCMPE;
  String? _selectedValvulaCMPE;
  String? _selectedSoportesCMPE;


  // Nueva función para enviar los datos seleccionados
  void _saveData() {
    // Recolectar los valores seleccionados
    final data = Compresor(
      interpresioncmpe: _selectedInterPresionCMPE!,
      manometrocmpe: _selectedManometroCMPE!,
      horometrocmpe: _selectedHorometroCMPE!,
      valvulacmpe: _selectedValvulaCMPE!,
      soportescmpe: _selectedSoportesCMPE!,
    );

    Provider.of<CompresorProvider>(context, listen: false).handleFirestoreOperation(action: "update",data: data, id: _selectedCompresorId!);

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
        title: const Text('Preop. Compresor'),
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
                // Dropdown para seleccionar la planta eléctrica
                Consumer<CompresorProvider>(
        builder: (context, provider, child) {
          return Center(
            child: DropdownButton<String>(
              value: _selectedCompresorId,
              hint: Text('Selecciona una fecha'),
              items: provider.compresorList.map((planta) {
                return DropdownMenuItem<String>(
                  value: planta.id,
                  child: Text(planta.fecha.toString()),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCompresorId = newValue;
                });
              },
            ),
          );
        },
      ),
      // Fin del Dropdown de plantas eléctricas
                const SizedBox(height: 16.0),
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
                          'assets/icons/Compresor.png',
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
                        "Interruptor de presion",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 75, 75, 75),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildDropdown(
                  "Interruptor de presion",
                  _selectedInterPresionCMPE,
                  estadoOptions,
                  (value) => setState(() => _selectedInterPresionCMPE = value),
                ),
                _buildDropdown(
                  "Manómetro",
                  _selectedManometroCMPE,
                  estadoOptions,
                  (value) => setState(() => _selectedManometroCMPE = value),
                ),

                Container(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 0.0),
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Estado del Horómetro",
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
                  "Estado del Horómetro",
                  _selectedHorometroCMPE,
                  estadoOptions,
                  (value) => setState(() => _selectedHorometroCMPE = value),
                ),
                _buildDropdown(
                  "Valvula de sobrepresion",
                  _selectedValvulaCMPE,
                  estadoOptions,
                  (value) => setState(() => _selectedValvulaCMPE = value),
                ),
                _buildDropdown(
                  "Soportes",
                  _selectedSoportesCMPE,
                  estadoOptions,
                  (value) => setState(() => _selectedSoportesCMPE = value),
                ),

                const SizedBox(height: 58.0),

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
