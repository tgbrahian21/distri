import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Pulidora {
  String id;
  final String fecha;
  final String codificacion;
  final String localizacion;
  final String conexionesPL;
  final String instDisco;
  final String acoplesPL;
  final String instmangoPL;
  final String interruptorincenPL;
  final String guiaguardaPL;
  final String accesoriosPL;
  final String generalPL;
  final String eppPL;
  final String barrerasPL;
  final String discoPL;
  final String combustible;
  final String aceite;
  final String almacenadoporoperador;
  final String remitidoamantenimiento;
  final String fallas;

  Pulidora({
    this.id = '',
    this.fecha = '',
    this.codificacion = '',
    this.localizacion = '',
    this.conexionesPL = '',
    this.instDisco = '',
    this.acoplesPL = '',
    this.instmangoPL = '',
    this.interruptorincenPL = '',
    this.guiaguardaPL = '',
    this.accesoriosPL = '',
    this.generalPL = '',
    this.eppPL = '',
    this.barrerasPL = '',
    this.discoPL = '',
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
        'conexionesPL': conexionesPL,
        'instDisco': instDisco,
        'acoplesPL': acoplesPL,
        'instmangoPL': instmangoPL,
        'interruptorincenPL': interruptorincenPL,
        'guiaguardaPL': guiaguardaPL,
        'accesoriosPL': accesoriosPL,
        'generalPL': generalPL,
        'eppPL': eppPL,
        'barrerasPL': barrerasPL,
        'discoPL': discoPL,
        'combustible': combustible,
        'aceite': aceite,
        'almacenadoporoperador': almacenadoporoperador,
        'remitidoamantenimiento': remitidoamantenimiento,
        'fallas': fallas,
      }..removeWhere((_, value) => value == '');

  factory Pulidora.fromMap(Map<String, dynamic> data, String documentId) =>
      Pulidora(
        id: documentId,
        fecha: data['fecha'] ?? '',
        codificacion: data['codificacion'] ?? '',
        localizacion: data['localizacion'] ?? '',
        conexionesPL: data['conexionesPL'] ?? '',
        instDisco: data['instDisco'] ?? '',
        acoplesPL: data['acoplesPL'] ?? '',
        instmangoPL: data['instmangoPL'] ?? '',
        interruptorincenPL: data['interruptorincenPL'] ?? '',
        guiaguardaPL: data['guiaguardaPL'] ?? '',
        accesoriosPL: data['accesoriosPL'] ?? '',
        generalPL: data['generalPL'] ?? '',
        eppPL: data['eppPL'] ?? '',
        barrerasPL: data['barrerasPL'] ?? '',
        discoPL: data['discoPL'] ?? '',
        combustible: data['combustible'] ?? '',
        aceite: data['aceite'] ?? '',
        almacenadoporoperador: data['almacenadoporoperador'] ?? '',
        remitidoamantenimiento: data['remitidoamantenimiento'] ?? '',
        fallas: data['fallas'] ?? '',
      );
}

class PulidoraProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Pulidora> _pulidoraList = [];
  final Box _hiveBox = Hive.box('pulidora');

  List<Pulidora> get pulidoraList => _pulidoraList;

  Future<void> handleFirestoreOperation({
    required String action,
    Pulidora? data,
    String? id,
  }) async {
    try {
      final collection = _firestore.collection('Pulidora');
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

  Future<void> _addOffline(Pulidora data, CollectionReference collection) async {
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

  Future<void> _updateOffline(Pulidora data, String id, CollectionReference collection) async {
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
      _pulidoraList = snapshot.docs
          .map((doc) => Pulidora.fromMap(Map<String, dynamic>.from(doc.data() as Map), doc.id))
          .toList();

      // Actualizar Hive con los datos obtenidos
      for (var doc in snapshot.docs) {
        await _hiveBox.put(doc.id, doc.data());
      }
    } catch (e) {
      // Si no hay conexión, leer los datos desde Hive
      _pulidoraList = _hiveBox.values
          .map((data) => Pulidora.fromMap(Map<String, dynamic>.from(data), data['id']))
          .toList();
    }
  }

  Future<void> syncOfflineData() async {
    final collection = _firestore.collection('Pulidora');

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

  // Método para generar y compartir un reporte de la pulidora
  Future<void> generateAndShareReport(String pulidoraId) async {
    try {
      final DocumentSnapshot snapshot =
          await _firestore.collection('Pulidora').doc(pulidoraId).get();

      if (!snapshot.exists) {
        throw Exception("Datos de la pulidora no encontrados");
      }

      final data = snapshot.data() as Map<String, dynamic>;

      // Crear el documento PDF
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Reporte de Pulidora', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Fecha: ${data['fecha']}'),
              pw.Text('Codificación: ${data['codificacion']}'),
              pw.Text('Localización: ${data['localizacion']}'),
              pw.Text('Conexiones: ${data['conexionesPL']}'),
              pw.Text('Instalación del Disco: ${data['instDisco']}'),
              pw.Text('Acoples: ${data['acoplesPL']}'),
              pw.Text('Instalación del Mango: ${data['instmangoPL']}'),
              pw.Text('Interruptor de Encendido: ${data['interruptorincenPL']}'),
              pw.Text('Guía y Guarda: ${data['guiaguardaPL']}'),
              pw.Text('Accesorios: ${data['accesoriosPL']}'),
              pw.Text('Estado General: ${data['generalPL']}'),
              pw.Text('EPP: ${data['eppPL']}'),
              pw.Text('Barreras: ${data['barrerasPL']}'),
              pw.Text('Disco: ${data['discoPL']}'),
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
      final file = File("${output.path}/reporte_pulidora.pdf");
      await file.writeAsBytes(await pdf.save());

      // Compartir el PDF
      await Share.shareFiles([file.path], text: 'Reporte de Pulidora');

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

