import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vista_practica/provider/compresor_provider.dart';

class DatosCMPE extends StatefulWidget {
  const DatosCMPE({super.key});

  @override
  State<DatosCMPE> createState() => _DatosPLantaelecState();
}

class _DatosPLantaelecState extends State<DatosCMPE> {

  final _formKey = GlobalKey<FormState>();
  final _fechaController = TextEditingController();
  final _codificacionController = TextEditingController();
  final _localizacionController = TextEditingController();

  void _saveData() {
    // Aquí va la lógica para guardar los datos
    // Por ejemplo, puedes utilizar una base de datos o una API para guardar los datos
    final data = Compresor(
      fecha: _fechaController.text,
      codificacion: _codificacionController.text,
      localizacion: _localizacionController.text,
    );

      Provider.of<CompresorProvider>(context, listen: false).handleFirestoreOperation(action: "add",data: data);

  }

  @override
  void dispose() {
    _fechaController.dispose();
    _codificacionController.dispose();
    _localizacionController.dispose();
    super.dispose();
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
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Preop. Compresor'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/Logo_distriservicios_Black&withe.png'),
                fit: BoxFit.scaleDown,
                opacity: 0.1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinea los elementos a los extremos 
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Alinea el texto a la izquierda
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.0,
                                bottom:10.0), // Ajusta el valor de padding según sea necesario
                            child: Text(
                              'Datos generales',
                              style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 75, 75, 75)
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          border: Border.all(color: const Color.fromARGB(212, 75, 75, 75), width: 4),
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
                    'Inserte fecha',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fechaController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'Inserte la fecha',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    onTap: (){
                      _selecDate();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese la fecha';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),


                  const Text(
                    'Inserte datos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Row(
                  /*
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _marcaController,
                          decoration: const InputDecoration(
                            labelText: 'Marca',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese la marca';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _modeloController,
                          decoration: const InputDecoration(
                            labelText: 'Modelo',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese el modelo';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  */
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _codificacionController,
                    decoration: const InputDecoration(
                      labelText: 'Codificación',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese la codificación';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _localizacionController,
                    decoration: const InputDecoration(
                      labelText: 'Localización',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese la localización';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Guardar datos
                        // Puedes acceder a los valores de los controladores aquí:
                        // _fechaController.text
                        // _marcaController.text
                        _saveData(); // función para guardar datos
                        // ...
                        // Luego, limpia los campos:
                        _fechaController.clear();
                        _codificacionController.clear();
                        _localizacionController.clear();
                        // Muestra un mensaje de éxito o navega a otra pantalla
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
                      }
                      else {
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
                    
                    child: const Text('Guardar datos'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selecDate() async{
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null){
      setState(() {
        _fechaController.text = picked.toString().split(' ')[0];
      });
    }
  }
}
