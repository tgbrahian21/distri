import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Taladro {
  String id;
  final String fecha;
  final String codificacion;
  final String localizacion;
  final String conexiones;
  final String interruptor;
  final String estadocuerpo;
  final String guardasta;
  final String interruptoraccionmartillo;
  final String mango;
  final String botonseguro;
  final String usotaladro;
  final String combustible;
  final String aceite;
  final String almacenadoporoperador;
  final String remitidoamantenimiento;
  final String fallas;

  Taladro({
    this.id = '',
    this.fecha = '',
    this.codificacion = '',
    this.localizacion = '',
    this.conexiones = '',
    this.interruptor = '',
    this.estadocuerpo = '',
    this.guardasta = '',
    this.interruptoraccionmartillo = '',
    this.mango = '',
    this.botonseguro = '',
    this.usotaladro = '',
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
        'conexiones': conexiones,
        'interruptor': interruptor,
        'estadocuerpo': estadocuerpo,
        'guardasta': guardasta,
        'interruptoraccionmartillo': interruptoraccionmartillo,
        'mango': mango,
        'botonseguro': botonseguro,
        'usotaladro': usotaladro,
        'combustible': combustible,
        'aceite': aceite,
        'almacenadoporoperador': almacenadoporoperador,
        'remitidoamantenimiento': remitidoamantenimiento,
        'fallas': fallas,
      }..removeWhere((_, value) => value == '');

  factory Taladro.fromMap(Map<String, dynamic> data, String documentId) =>
      Taladro(
        id: documentId,
        fecha: data['fecha'] ?? '',
        codificacion: data['codificacion'] ?? '',
        localizacion: data['localizacion'] ?? '',
        conexiones: data['conexiones'] ?? '',
        interruptor: data['interruptor'] ?? '',
        estadocuerpo: data['estadocuerpo'] ?? '',
        guardasta: data['guardasta'] ?? '',
        interruptoraccionmartillo: data['interruptoraccionmartillo'] ?? '',
        mango: data['mango'] ?? '',
        botonseguro: data['botonseguro'] ?? '',
        usotaladro: data['usotaladro'] ?? '',
        combustible: data['combustible'] ?? '',
        aceite: data['aceite'] ?? '',
        almacenadoporoperador: data['almacenadoporoperador'] ?? '',
        remitidoamantenimiento: data['remitidoamantenimiento'] ?? '',
        fallas: data['fallas'] ?? '',
      );
}

class TaladroProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Taladro> _taladroList = [];
  final Box _hiveBox = Hive.box('taladro');

  List<Taladro> get taladroList => _taladroList;

  Future<void> handleFirestoreOperation({
    required String action,
    Taladro? data,
    String? id,
  }) async {
    try {
      final collection = _firestore.collection('Taladro');
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

  Future<void> _addOffline(Taladro data, CollectionReference collection) async {
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

  Future<void> _updateOffline(Taladro data, String id, CollectionReference collection) async {
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
      final snapshot = await collection.orderBy('fecha', descending: true).limit(3).get();
      _taladroList = snapshot.docs
          .map((doc) => Taladro.fromMap(Map<String, dynamic>.from(doc.data() as Map), doc.id))
          .toList();

      // Actualizar Hive con los datos obtenidos
      for (var doc in snapshot.docs) {
        await _hiveBox.put(doc.id, doc.data());
      }
    } catch (e) {
      // Si no hay conexión, leer los datos desde Hive
      _taladroList = _hiveBox.values
          .map((data) => Taladro.fromMap(Map<String, dynamic>.from(data), data['id']))
          .toList();
    }
  }

  Future<void> syncOfflineData() async {
    final collection = _firestore.collection('Taladro');

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

Future<void> generateAndShareReport(String taladroId) async {
    try {
      final DocumentSnapshot snapshot =
          await _firestore.collection('Taladro').doc(taladroId).get();

      if (!snapshot.exists) {
        throw Exception("Datos del taladro no encontrados");
      }

      final data = snapshot.data() as Map<String, dynamic>;

      // Crear el documento PDF
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Reporte del Taladro', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Fecha: ${data['fecha']}'),
              pw.Text('Codificación: ${data['codificacion']}'),
              pw.Text('Localización: ${data['localizacion']}'),
              pw.Text('Conexiones: ${data['conexiones']}'),
              pw.Text('Interruptor: ${data['interruptor']}'),
              pw.Text('Estado del Cuerpo: ${data['estadocuerpo']}'),
              pw.Text('Guarda STA: ${data['guardasta']}'),
              pw.Text('Interruptor Acción Martillo: ${data['interruptoraccionmartillo']}'),
              pw.Text('Mango: ${data['mango']}'),
              pw.Text('Botón Seguro: ${data['botonseguro']}'),
              pw.Text('Uso Taladro: ${data['usotaladro']}'),
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
      final file = File("${output.path}/reporte_taladro.pdf");
      await file.writeAsBytes(await pdf.save());

      // Compartir el PDF
      await Share.shareFiles([file.path], text: 'Reporte del Taladro');

      // Enviar el PDF a los administradores
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
          ..subject = 'Reporte de Pulidora'
          ..text = 'Adjunto se encuentra el reporte de la pulidora.'
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
