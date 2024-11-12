import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vista_practica/provider/plantaelec_provider.dart';

class EstadosPE extends StatefulWidget {
  const EstadosPE({super.key});

  @override
  State<EstadosPE> createState() => _EstadosPEState();
}

class _EstadosPEState extends State<EstadosPE> {
  String? _selectedPlantaId;

  @override
  void initState() {
    super.initState();
    final plantaelecProvider = Provider.of<PlantaelecProvider>(context, listen: false);
    plantaelecProvider.handleFirestoreOperation(action: "fetch"); // Carga los datos al iniciar el widget
  }
  final _formKey = GlobalKey<FormState>();
  String? _selectedEncendido;
  String? _selectedYoyoArranque;

  String? _selectedMotor;
  String? _selectedSoportesMotor;
  String? _selectedSistemaElectrico;
  String? _selectedEstadoBateria;

  String? _selectedEstadoGenerador;
  String? _selectedSoporteGenerador;
  String? _selectedTanqueCombustible;
  String? _selectedManguerasCombustible;
  String? _selectedConexionesElectricas;

  String? _selectedEstadoAcoples;
  String? _selectedEstadoExhosto;
  String? _selectedGuardas;
  String? _selectedNivelAceites;

  String? _selectedCondicionEquipo;
  String? _selectedIndicadores;
  String? _selectedLlantas;

  // Nueva función para enviar los datos seleccionados
  void _saveData() {
    // Recolectar los valores seleccionados
    final data = Plantaelec(
      encendido: _selectedEncendido!,
      yoyoarranque: _selectedYoyoArranque!,
      motor: _selectedMotor!,
      soportemotor: _selectedSoportesMotor!,
      sistemaelectrico: _selectedSistemaElectrico!,
      estadobateria: _selectedEstadoBateria!,
      estadogenerador: _selectedEstadoGenerador!,
      soportegenerador: _selectedSoporteGenerador!,
      tanquecombustible: _selectedTanqueCombustible!,
      manguerascombustible: _selectedManguerasCombustible!,
      conexioneselectricas: _selectedConexionesElectricas!,
      estadoacoples: _selectedEstadoAcoples!,
      estadoexhosto: _selectedEstadoExhosto!,
      nivelaceites: _selectedNivelAceites!,
      condicionequipo: _selectedCondicionEquipo!,
      indicadores: _selectedIndicadores!,
      llantas: _selectedLlantas!,
    );


    Provider.of<PlantaelecProvider>(context, listen: false).handleFirestoreOperation(action: "update",data: data, id: _selectedPlantaId!);
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
        title: const Text('Preop. Planta Electrica'),
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
                Consumer<PlantaelecProvider>(
        builder: (context, provider, child) {
          return Center(
            child: DropdownButton<String>(
              value: _selectedPlantaId,
              hint: Text('Selecciona una fecha'),
              items: provider.plantaelecList.map((planta) {
                return DropdownMenuItem<String>(
                  value: planta.id,
                  child: Text('${planta.fecha} - ${planta.codificacion}'),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedPlantaId = newValue;
                });
              },
            ),
          );
        },
      ),// Fin del Dropdown de plantas eléctricas
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
                          'assets/icons/planta_electrica.png',
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
                      child: _buildDropdown(
                        "Encendido", 
                        _selectedEncendido, 
                        estadoOptions,
                        (value) => setState(() => _selectedEncendido = value),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: _buildDropdown(
                        "Yoyo de arranque", 
                        _selectedYoyoArranque, 
                        estadoOptions,
                        (value) => setState(() => _selectedYoyoArranque = value),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.only(bottom: 0.1),
                alignment: Alignment.bottomCenter,
                child: const Text(
                  "Motor",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 75, 75, 75),
                  ),
                ),
              ),
              _buildDropdown("Motor", _selectedMotor, estadoOptions,
                (value) => setState(() => _selectedMotor = value),
              ),
              _buildDropdown(
                  "Soportes de motor", _selectedSoportesMotor, estadoOptions,
                  (value) => setState(() => _selectedSoportesMotor = value),
              ),
              _buildDropdown("Sistema electrico", _selectedSistemaElectrico,
                  estadoOptions, (value) => setState(() => _selectedSistemaElectrico = value),
              ),
              _buildDropdown(
                  "Estado de bateria", _selectedEstadoBateria, estadoOptions,
                  (value) => setState(() => _selectedEstadoBateria = value),
              ),

              Container(
                padding: const EdgeInsets.only(top: 50.0, bottom: 0.0),
                alignment: Alignment.center,
                child: const Text(
                  "Estado del generador",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 75, 75, 75),
                  ),
                ),
              ),

              _buildDropdown("Estado del generador", _selectedEstadoGenerador, estadoOptions,
                (value) => setState(() => _selectedEstadoGenerador = value),
              ),
              _buildDropdown("Soporte de generador", _selectedSoporteGenerador, estadoOptions,
                (value) => setState(() => _selectedSoporteGenerador = value),
              ),
              _buildDropdown("Estado - Tanque de combustible",_selectedTanqueCombustible, estadoOptions,
                (value) => setState(() => _selectedTanqueCombustible = value),
              ),
              _buildDropdown("Mangueras de combustible",_selectedManguerasCombustible, estadoOptions,
                (value) => setState(() => _selectedManguerasCombustible = value),
              ),
              _buildDropdown("Conexiones eléctricas",_selectedConexionesElectricas, estadoOptions,
                (value) => setState(() => _selectedConexionesElectricas = value),
              ),

              Container(
                padding: const EdgeInsets.only(top: 50.0, bottom: 0.0),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Estado general de acoples, sellos, etc.",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 75, 75, 75),
                      ),
                    ),
                    SizedBox(height: 8.0), // Espacio entre los textos
                    Text(
                      "(Verificar la no presencia de fiugas de aceite y/o combultible)",
                      style: TextStyle(
                        fontSize: 12.5, // Tamaño de texto más pequeño
                        color: Colors.grey, // Color del texto pequeño
                      ),
                    ),
                  ],
                ),
              ),

              _buildDropdown("", _selectedEstadoAcoples, estadoOptions,
                (value) => setState(() => _selectedEstadoAcoples = value),
              ),
              _buildDropdown("Estado del exhosto", _selectedEstadoExhosto, estadoOptions, 
                (value) => setState(() => _selectedEstadoExhosto = value),
              ),
              _buildDropdown("Guardas", _selectedGuardas, estadoOptions,
                (value) => setState(() => _selectedGuardas = value),
              ),
              _buildDropdown("Nivel de aceite", _selectedNivelAceites, estadoOptions,
                (value) => setState(() => _selectedNivelAceites = value),
              ),

              Container(
                padding: const EdgeInsets.only(top: 50.0, bottom: 0.0),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Condiciones del equipo",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 75, 75, 75),
                      ),
                    ),
                    SizedBox(height: 8.0), // Espacio entre los textos
                    Text(
                      "(Corrosion, golpes, endiduras, etc.)",
                      style: TextStyle(
                        fontSize: 12.5, // Tamaño de texto más pequeño
                        color: Colors.grey, // Color del texto pequeño
                      ),
                    ),
                  ],
                ),
              ),

              _buildDropdown("", _selectedCondicionEquipo, estadoOptions,
                (value) => setState(() => _selectedCondicionEquipo = value),
              ),
              _buildDropdown("Indicadores (Horometro, aceite, temperatura, voltaje y corriente)", _selectedIndicadores,estadoOptions,
                (value) => setState(() => _selectedIndicadores = value),
              ),
              _buildDropdown("Llantas", _selectedLlantas, estadoOptions,
                (value) => setState(() => _selectedLlantas = value),
              ),

              const SizedBox(height: 58.0),

              

                const SizedBox(height: 20.0),
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
