import 'package:flutter/material.dart';
import 'package:vista_practica/pages/Datos_plantaelec.dart';
import 'package:vista_practica/pages/pagina_main.dart';



class PaginaPlantaelec extends StatefulWidget {
  static const String routeName = 'Pagina Planta';
  const PaginaPlantaelec({super.key});

  @override
  State<PaginaPlantaelec> createState() => _PaginaPlantaelecState();
}

class _PaginaPlantaelecState extends State<PaginaPlantaelec> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(252,248,248,1),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Pagemain(),));
            // Handle back button press
          },
        ),
        title: const Text('Preoperacional'),
       
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Planta eléctrica',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              child: const Text('Informacion General')),
            Padding(
              
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Column(
                  children: [
                    ListTile(
                      leading: const ImageIcon(AssetImage('assets/icons/planta_electrica.png')),
                      title: const Text('Datos generales'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => const DatosPlantaelec(),));
                        // Handle Datos generales tap
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.checklist),
                      title: const Text('Estado'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle Estado tap
                      },
                    ),
                    ListTile(
                      leading: const ImageIcon(AssetImage('assets/icons/liquidos.png')),
                      title: const Text('Liquidos'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle Liquidos tap
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              child: const Text('Operador')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit_note),
                      title: const Text('Firma y observaciones'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle Firma y observaciones tap
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              child: const Text('En caso de fallas del equipo ')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: const Color.fromARGB(255, 255, 255, 255), 
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.error),
                      title: const Text('EN CASO DE FALLAS'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle EN CASO DE FALLA DEL EQUIPO tap
                      },
                    ),
                  ],
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}