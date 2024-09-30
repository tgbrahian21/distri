import 'package:flutter/material.dart';

class DatosPlantaelec extends StatefulWidget {
  const DatosPlantaelec({super.key});

  @override
  State<DatosPlantaelec> createState() => _DatosPLantaelecState();
}

class _DatosPLantaelecState extends State<DatosPlantaelec> {
  final _formKey = GlobalKey<FormState>();
  final _fechaController = TextEditingController();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _codificacionController = TextEditingController();
  final _localizacionController = TextEditingController();
  final _operadorController = TextEditingController();

  @override
  void dispose() {
    _fechaController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _codificacionController.dispose();
    _localizacionController.dispose();
    _operadorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos Generales'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    hintText: 'mm/dd/yyyy',
                    border: OutlineInputBorder(),
                  ),
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
                Row(
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
                TextFormField(
                  controller: _operadorController,
                  decoration: const InputDecoration(
                    labelText: 'Operador',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el operador';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Guardar datos
                      // Puedes acceder a los valores de los controladores aquí:
                      // _fechaController.text
                      // _marcaController.text
                      // ...
                      // Luego, limpia los campos:
                      _fechaController.clear();
                      _marcaController.clear();
                      _modeloController.clear();
                      _codificacionController.clear();
                      _localizacionController.clear();
                      _operadorController.clear();
                      // Muestra un mensaje de éxito o navega a otra pantalla
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
