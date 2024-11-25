import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vista_practica/provider/taladro_provider.dart';

class EstadosTA extends StatefulWidget {
  const EstadosTA({super.key});

  @override
  State<EstadosTA> createState() => _EstadosTAState();
}

class _EstadosTAState extends State<EstadosTA> {

String? _selectedTaladroId;

  @override
  void initState() {
    super.initState();
    final taladroProvider = Provider.of<TaladroProvider>(context, listen: false);
    taladroProvider.handleFirestoreOperation(action: "fetch"); // Carga los datos al iniciar el widget
  }

  final _formKey = GlobalKey<FormState>();

  String? _selectedConexiones;
  String? _selectedInterruptor;
  String? _selectedEstadoCuerpo;
  String? _selectedGuardasTa;
  String? _selectedInterruptorAccionMartillo;
  String? _selectedMango;
  String? _selectedBotonSeguro;

  String _usoTaladro = '';

  // Nueva función para enviar los datos seleccionados
  void _saveData() {
    // Recolectar los valores seleccionados
    final data = Taladro(
      conexiones: _selectedConexiones!,
      interruptor: _selectedInterruptor!,
      estadocuerpo: _selectedEstadoCuerpo!,
      guardasta: _selectedGuardasTa!,
      interruptoraccionmartillo: _selectedInterruptorAccionMartillo!,
      mango: _selectedMango!,
      botonseguro: _selectedBotonSeguro!,
      usotaladro: _usoTaladro,

    );

    Provider.of<TaladroProvider>(context, listen: false).handleFirestoreOperation(action: "update",data: data, id: _selectedTaladroId!);

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
        title: const Text('Preop. Taladro'),
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
                Consumer<TaladroProvider>(
        builder: (context, provider, child) {
          return Center(
            child: DropdownButton<String>(
              value: _selectedTaladroId,
              hint: Text('Selecciona una fecha'),
              items: provider.taladroList.map((planta) {
                return DropdownMenuItem<String>(
                  value: planta.id,
                  child: Text(planta.fecha.toString() + ' - ' + planta.codificacion.toString()),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedTaladroId = newValue;
                });
              },
            ),
          );
        },
      ),
      // Fin del Dropdown de plantas eléctricas
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
                          'assets/icons/taladro.png',
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
                  _selectedConexiones,
                  estadoOptions,
                  (value) => setState(() => _selectedConexiones = value),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20.0),
                  alignment: Alignment.center,
                  child: const Column(
                    children: <Widget>[
                      Text(
                        "Estado del interruptor de encendido",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 75, 75, 75),
                        ),
                      ),
                      Text(
                        "(Gatillo)",
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
                  _selectedInterruptor,
                  estadoOptions,
                  (value) => setState(() => _selectedInterruptor = value),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 0.0),
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Estado del cuerpo",
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
                  "Estado del cuerpo",
                  _selectedEstadoCuerpo,
                  estadoOptions,
                  (value) => setState(() => _selectedEstadoCuerpo = value),
                ),
                _buildDropdown(
                  "Estado de la guarda",
                  _selectedGuardasTa,
                  estadoOptions,
                  (value) => setState(() => _selectedGuardasTa = value),
                ),
                _buildDropdown(
                  "Estado del interruptor de accion de martillo",
                  _selectedInterruptorAccionMartillo,
                  estadoOptions,
                  (value) => setState(() => _selectedInterruptorAccionMartillo = value),
                ),
                _buildDropdown(
                  "Estado del mango",
                  _selectedMango,
                  estadoOptions,
                  (value) => setState(() => _selectedMango = value),
                ),
                _buildDropdown(
                  "Estado del boton de seguro",
                  _selectedBotonSeguro,
                  estadoOptions,
                  (value) => setState(() => _selectedBotonSeguro = value),
                ),

                const SizedBox(height: 30.0),

                // Primera opción: Separado y almacenado por el operador
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(
                      child: Text('El taladro se puede usar:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 75, 75, 75),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        const Text('Sí'),
                        Radio<String>(
                          value: 'Sí',
                          groupValue: _usoTaladro,
                          onChanged: (value) {
                            setState(() {
                              _usoTaladro = value!;
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
                          groupValue: _usoTaladro,
                          onChanged: (value) {
                            setState(() {
                              _usoTaladro = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
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
