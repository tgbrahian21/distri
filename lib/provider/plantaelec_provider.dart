import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Plantaelec {
  String id;
  final String fecha;
  final String codificacion;
  final String localizacion;
  final String encendido;
  final String yoyoarranque;
  final String motor;
  final String soportemotor;
  final String sistemaelectrico;
  final String estadobateria;
  final String estadogenerador;
  final String soportegenerador;
  final String tanquecombustible;
  final String manguerascombustible;
  final String conexioneselectricas;
  final String estadoacoples;
  final String estadoexhosto;
  final String nivelaceites;
  final String condicionequipo;
  final String indicadores;
  final String llantas;
  final String combustible;
  final String aceite;
  final String almacenadoporoperador;
  final String remitidoamantenimiento;
  final String fallas;

  Plantaelec({
    this.id = '',
    this.fecha = '',
    this.codificacion = '',
    this.localizacion = '',
    this.encendido = '',
    this.yoyoarranque = '',
    this.motor = '',
    this.soportemotor = '',
    this.sistemaelectrico = '',
    this.estadobateria = '',
    this.estadogenerador = '',
    this.soportegenerador = '',
    this.tanquecombustible = '',
    this.manguerascombustible = '',
    this.conexioneselectricas = '',
    this.estadoacoples = '',
    this.estadoexhosto = '',
    this.nivelaceites = '',
    this.condicionequipo = '',
    this.indicadores = '',
    this.llantas = '',
    this.combustible = '',
    this.aceite = '',
    this.almacenadoporoperador = '',
    this.remitidoamantenimiento = '',
    this.fallas = '',
  });

  Map<String, dynamic> toMap() => {
        'fecha': fecha,
        'codificacion': codificacion,
        'localizacion': localizacion,
        'encendido': encendido,
        'yoyoarranque': yoyoarranque,
        'motor': motor,
        'soportemotor': soportemotor,
        'sistemaelectrico': sistemaelectrico,
        'estadobateria': estadobateria,
        'estadogenerador': estadogenerador,
        'soportegenerador': soportegenerador,
        'tanquecombustible': tanquecombustible,
        'manguerascombustible': manguerascombustible,
        'conexioneselectricas': conexioneselectricas,
        'estadoacoples': estadoacoples,
        'estadoexhosto': estadoexhosto,
        'nivelaceites': nivelaceites,
        'condicionequipo': condicionequipo,
        'indicadores': indicadores,
        'llantas': llantas,
        'combustible': combustible,
        'aceite': aceite,
        'almacenadoporoperador': almacenadoporoperador,
        'remitidoamantenimiento': remitidoamantenimiento,
        'fallas': fallas,
      }..removeWhere((_, value) => value == '');

  factory Plantaelec.fromMap(Map<String, dynamic> data, String documentId) =>
      Plantaelec(
        id: documentId,
        fecha: data['fecha'] ?? '',
        codificacion: data['codificacion'] ?? '',
        localizacion: data['localizacion'] ?? '',
        encendido: data['encendido'] ?? '',
        yoyoarranque: data['yoyoarranque'] ?? '',
        motor: data['motor'] ?? '',
        soportemotor: data['soportemotor'] ?? '',
        sistemaelectrico: data['sistemaelectrico'] ?? '',
        estadobateria: data['estadobateria'] ?? '',
        estadogenerador: data['estadogenerador'] ?? '',
        soportegenerador: data['soportegenerador'] ?? '',
        tanquecombustible: data['tanquecombustible'] ?? '',
        manguerascombustible: data['manguerascombustible'] ?? '',
        conexioneselectricas: data['conexioneselectricas'] ?? '',
        estadoacoples: data['estadoacoples'] ?? '',
        estadoexhosto: data['estadoexhosto'] ?? '',
        nivelaceites: data['nivelaceites'] ?? '',
        condicionequipo: data['condicionequipo'] ?? '',
        indicadores: data['indicadores'] ?? '',
        llantas: data['llantas'] ?? '',
        combustible: data['combustible'] ?? '',
        aceite: data['aceite'] ?? '',
        almacenadoporoperador: data['almacenadoporoperador'] ?? '',
        remitidoamantenimiento: data['remitidoamantenimiento'] ?? '',
        fallas: data['fallas'] ?? '',
      );
}


class PlantaelecProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Plantaelec> _plantaelecList = [];
  final Box _hiveBox = Hive.box('plantaelec');

  List<Plantaelec> get plantaelecList => _plantaelecList;

  Future<void> handleFirestoreOperation({
    required String action,
    Plantaelec? data,
    String? id,
  }) async {
    try {
      final collection = _firestore.collection('plantaelec');

      if (action == 'add' && data != null) {
        await _addOffline(data, collection);
      } else if (action == 'update' && data != null && id != null) {
        await _updateOffline(data, id, collection);
      } else if (action == 'fetch') {
        await _fetchOffline(collection);
      }

      notifyListeners();
    } catch (e) {
      _handleError(e, 'operación $action');
    }
  }

  Future<void> _addOffline(Plantaelec data, CollectionReference collection) async {
    try {
      final docRef = await collection.add(data.toMap());
      data.id = docRef.id;
      await _hiveBox.put(docRef.id, data.toMap());
    } catch (e) {
      // Añadir a Hive cuando no hay conexión
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      data.id = newId;
      await _hiveBox.put(newId, data.toMap());
    }
  }

  Future<void> _updateOffline(Plantaelec data, String id, CollectionReference collection) async {
    try {
      await collection.doc(id).update(data.toMap());
      await _hiveBox.put(id, data.toMap());
    } catch (e) {
      // Si no hay conexión, actualizar solo en Hive
      await _hiveBox.put(id, data.toMap());
    }
  }

  Future<void> _fetchOffline(CollectionReference collection) async {
    try {
      final snapshot = await collection.orderBy('fecha', descending: true).limit(4).get();
      _plantaelecList = snapshot.docs
          .map((doc) => Plantaelec.fromMap(Map<String, dynamic>.from(doc.data() as Map), doc.id))
          .toList();

      // Actualizar Hive con los datos obtenidos
      for (var doc in snapshot.docs) {
        await _hiveBox.put(doc.id, doc.data());
      }
    } catch (e) {
      // Si no hay conexión, leer los datos desde Hive
      _plantaelecList = _hiveBox.values
          .map((data) => Plantaelec.fromMap(Map<String, dynamic>.from(data), data['id']))
          .toList();
    }
  }

  Future<void> syncOfflineData() async {
    final collection = _firestore.collection('plantaelec');

    for (var key in _hiveBox.keys) {
      final data = _hiveBox.get(key) as Map<String, dynamic>;
      final documentId = data['id'];

      try {
        // Si el documento existe en Firestore, actualizarlo
        await collection.doc(documentId).set(data);
        await _hiveBox.delete(key);
      } catch (e) {
        if (kDebugMode) print('Error sincronizando datos $documentId: $e');
      }
    }
  }

  void _handleError(Object error, String context) {
    if (kDebugMode) print('Error en $context: $error');
  }

// Método para generar y compartir un reporte de planta eléctrica
  Future<void> generateAndShareReport(String plantaelecId) async {
    try {
      final DocumentSnapshot snapshot =
          await _firestore.collection('plantaelec').doc(plantaelecId).get();

      if (!snapshot.exists) {
        throw Exception("Datos de la planta eléctrica no encontrados");
      }

      final data = snapshot.data() as Map<String, dynamic>;

      // Crear el documento PDF
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Reporte de Planta Eléctrica', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Fecha: ${data['fecha']}'),
              pw.Text('Codificación: ${data['codificacion']}'),
              pw.Text('Localización: ${data['localizacion']}'),
              pw.Text('Encendido: ${data['encendido']}'),
              pw.Text('Yoyo de Arranque: ${data['yoyoarranque']}'),
              pw.Text('Motor: ${data['motor']}'),
              pw.Text('Soporte Motor: ${data['soportemotor']}'),
              pw.Text('Sistema Eléctrico: ${data['sistemaelectrico']}'),
              pw.Text('Estado Batería: ${data['estadobateria']}'),
              pw.Text('Estado Generador: ${data['estadogenerador']}'),
              pw.Text('Soporte Generador: ${data['soportegenerador']}'),
              pw.Text('Tanque Combustible: ${data['tanquecombustible']}'),
              pw.Text('Mangueras Combustible: ${data['manguerascombustible']}'),
              pw.Text('Conexiones Eléctricas: ${data['conexioneselectricas']}'),
              pw.Text('Estado Acoples: ${data['estadoacoples']}'),
              pw.Text('Estado Exhosto: ${data['estadoexhosto']}'),
              pw.Text('Nivel Aceites: ${data['nivelaceites']}'),
              pw.Text('Condición Equipo: ${data['condicionequipo']}'),
              pw.Text('Indicadores: ${data['indicadores']}'),
              pw.Text('Llantas: ${data['llantas']}'),
              pw.Text('Combustible: ${data['combustible']}'),
              pw.Text('Aceite: ${data['aceite']}'),
              pw.Text('Almacenado por Operador: ${data['almacenadoporoperador']}'),
              pw.Text('Remitido a Mantenimiento: ${data['remitidoamantenimiento']}'),
              pw.Text('Fallas: ${data['fallas']}'),
            ],
          ),
        ),
      );

      // Guardar el PDF en el dispositivo
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/reporte_plantaelec.pdf");
      await file.writeAsBytes(await pdf.save());

      // Compartir el PDF
      await Share.shareFiles([file.path], text: 'Reporte de Planta Eléctrica');

      await sendReportToAdmins(file);
    } catch (e) {
      if (kDebugMode) {
        print('Error al generar o compartir el reporte: $e');
      }
    }
}

Future<void> sendReportToAdmins(File pdfFile) async {
    try {
      final adminsQuerySnapshot = await _firestore
          .collection('users')
          .where('role', whereIn: ['admin', 'superAdmin'])
          .get();

      final smtpServer = gmail('brahianservidor4@gmail.com', 'ksmj pzeq kige mcbx');

      for (var doc in adminsQuerySnapshot.docs) {
        final email = doc['email'];

        final message = Message()
          ..from = const Address('brahianservidor4@gmail.com', 'distriservicios')
          ..recipients.add(email)
          ..subject = 'Reporte del Compresor'
          ..text = 'Adjunto se encuentra el reporte del compresor.'
          ..attachments.add(FileAttachment(pdfFile));

        await send(message, smtpServer);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al enviar el reporte a los administradores: $e');
      }
    }
  }

}
