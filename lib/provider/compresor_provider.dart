import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Compresor {
  String id;
  final String fecha;
  final String codificacion;
  final String localizacion;
  final String interpresioncmpe;
  final String manometrocmpe;
  final String horometrocmpe;
  final String valvulacmpe;
  final String soportescmpe;
  final String combustible;
  final String aceite;
  final String almacenadoporoperador;
  final String remitidoamantenimiento;
  final String fallas;

  Compresor({
    this.id = '',
    this.fecha = '',
    this.codificacion = '',
    this.localizacion = '',
    this.interpresioncmpe = '',
    this.manometrocmpe = '',
    this.horometrocmpe = '',
    this.valvulacmpe = '',
    this.soportescmpe = '',
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
        'interpresioncmpe': interpresioncmpe,
        'manometrocmpe': manometrocmpe,
        'horometrocmpe': horometrocmpe,
        'valvulacmpe': valvulacmpe,
        'soportescmpe': soportescmpe,
        'combustible': combustible,
        'aceite': aceite,
        'almacenadoporoperador': almacenadoporoperador,
        'remitidoamantenimiento': remitidoamantenimiento,
        'fallas': fallas,
      }..removeWhere((_, value) => value == '');

  factory Compresor.fromMap(Map<String, dynamic> data, String documentId) =>
      Compresor(
        id: documentId,
        fecha: data['fecha'] ?? '',
        codificacion: data['codificacion'] ?? '',
        localizacion: data['localizacion'] ?? '',
        interpresioncmpe: data['interpresioncmpe'] ?? '',
        manometrocmpe: data['manometrocmpe'] ?? '',
        horometrocmpe: data['horometrocmpe'] ?? '',
        valvulacmpe: data['valvulacmpe'] ?? '',
        soportescmpe: data['soportescmpe'] ?? '',
        combustible: data['combustible'] ?? '',
        aceite: data['aceite'] ?? '',
        almacenadoporoperador: data['almacenadoporoperador'] ?? '',
        remitidoamantenimiento: data['remitidoamantenimiento'] ?? '',
        fallas: data['fallas'] ?? '',
      );
}

class CompresorProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Compresor> _compresorList = [];
  final Box _hiveBox = Hive.box('compresor');

  List<Compresor> get compresorList => _compresorList;

  Future<void> handleFirestoreOperation({
    required String action,
    Compresor? data,
    String? id,
  }) async {
    try {
      final collection = _firestore.collection('Compresor');
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

  Future<void> _addOffline(Compresor data, CollectionReference collection) async {
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

  Future<void> _updateOffline(Compresor data, String id, CollectionReference collection) async {
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
      _compresorList = snapshot.docs
          .map((doc) => Compresor.fromMap(Map<String, dynamic>.from(doc.data() as Map), doc.id))
          .toList();

      // Actualizar Hive con los datos obtenidos
      for (var doc in snapshot.docs) {
        await _hiveBox.put(doc.id, doc.data());
      }
    } catch (e) {
      // Si no hay conexión, leer los datos desde Hive
      _compresorList = _hiveBox.values
          .map((data) => Compresor.fromMap(Map<String, dynamic>.from(data), data['id']))
          .toList();
    }
  }

  Future<void> syncOfflineData() async {
    final collection = _firestore.collection('Compresor');

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

  // Método para generar y compartir un reporte del compresor
  Future<void> generateAndShareReport(String compresorId) async {
    try {
      final DocumentSnapshot snapshot =
          await _firestore.collection('Compresor').doc(compresorId).get();

      if (!snapshot.exists) {
        throw Exception("Datos del compresor no encontrados");
      }

      final data = snapshot.data() as Map<String, dynamic>;

      // Crear el documento PDF
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Reporte del Compresor', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Fecha: ${data['fecha']}'),
              pw.Text('Codificación: ${data['codificacion']}'),
              pw.Text('Localización: ${data['localizacion']}'),
              pw.Text('Interpresión: ${data['interpresioncmpe']}'),
              pw.Text('Manómetro: ${data['manometrocmpe']}'),
              pw.Text('Horómetro: ${data['horometrocmpe']}'),
              pw.Text('Válvula: ${data['valvulacmpe']}'),
              pw.Text('Soportes: ${data['soportescmpe']}'),
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
      final file = File("${output.path}/reporte_compresor.pdf");
      await file.writeAsBytes(await pdf.save());

      // Compartir el PDF
      await Share.shareFiles([file.path], text: 'Reporte del Compresor');

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

      final smtpServer = gmail('brahianservidor4@gmail.com', 'nerr jlhn apbh pyxs');

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
