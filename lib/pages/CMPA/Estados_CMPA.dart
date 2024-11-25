import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vista_practica/provider/compactador_provider.dart';

class EstadosCMPA extends StatefulWidget {
  const EstadosCMPA({super.key});

  @override
  State<EstadosCMPA> createState() => _EstadosCMPAState();
}

class _EstadosCMPAState extends State<EstadosCMPA> {
  String? _selectedCompactadorId;

  @override
  void initState() {
    super.initState();
    final compactadorProvider = Provider.of<CompactadorProvider>(context, listen: false);
    compactadorProvider.handleFirestoreOperation(action: "fetch"); // Carga los datos al iniciar el widget
  }

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

  // Nueva funcion para enviar los datos seleccionados
  void _saveData() {
    // Recolectar los valores seleccionados
    final data = Compactador(
      tanquecombustibleytapa: _selectedTanqueCombustibleYtapa ?? '',
      palancaacelerador: _selectedPalancaAcelerador ?? '',
      varillaaceite: _selectedVarillaAceite ?? '',
      filtroaceite: _selectedFiltroAceite ?? '',
      filtrogasolina: _selectedFiltroGasolina ?? '',
      filtromotor: _selectedFiltroMotor ?? '',
      valvula: _selectedvalvula ?? '',
      zapata: _selectedZapata ?? '',
      silenciador: _selectedSilenciador ?? '',
      palancadescompresion: _selectedPalancaDescompresion ?? '',
      fuelle: _selectedFuelle ?? '',
      manillar: _selectedManillar ?? '',
      manija: _selectedManija ?? '',
    );

    Provider.of<CompactadorProvider>(context, listen: false)
        .handleFirestoreOperation(
            action: "update", data: data, id: _selectedCompactadorId!);

    // Mostrar mensaje de exito
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Consumer<CompactadorProvider>(
                  builder: (context, provider, child) {
                    return Center(
                      child: DropdownButton<String>(
                        value: _selectedCompactadorId,
                        hint: Text('Selecciona una fecha'),
                        items: provider.compactadorList.map((planta) {
                          return DropdownMenuItem<String>(
                            value: planta.id,
                            child: Text(planta.fecha.toString() + ' - ' + planta.codificacion.toString()),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCompactadorId = newValue;
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
                          padding: EdgeInsets.only(left: 60.0, bottom: 10.0),
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
                    const SizedBox(width: 16.0),
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
                _buildDropdown("Válvula de drenaje", _selectedvalvula, estadoOptions),
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
                      SizedBox(height: 8.0),
                    ],
                  ),
                ),
                _buildDropdown("Fuelle", _selectedFuelle, estadoOptions),
                _buildDropdown("manillar", _selectedManillar, estadoOptions),
                _buildDropdown(
                    "Manija de arranque por retroceso", _selectedManija, estadoOptions),
                const SizedBox(height: 58.0),
                // Boton de envio
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveData();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Exito'),
                            content: const Text('Datos guardados con exito'),
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
                case "Tanque combustible y tapa":
                  _selectedTanqueCombustibleYtapa = value;
                  break;
                case "Palanca de \n acelerador":
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
                case "Estado de bateria":
                  _selectedFiltroMotor = value;
                  break;
                case "Válvula de drenaje":
                  _selectedvalvula = value;
                  break;
                case "Soporte de generador":
                  _selectedZapata = value;
                  break;
                case "Estado - Silenciador":
                  _selectedSilenciador = value;
                  break;
                case "Palanca de descompresion":
                  _selectedPalancaDescompresion = value;
                  break;
                case "Fuelle":
                  _selectedFuelle = value;
                  break;
                case "manillar":
                  _selectedManillar = value;
                  break;
                case "Manija de arranque por retroceso":
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
