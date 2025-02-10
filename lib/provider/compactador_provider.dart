import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Compactador {
  String id;
  final String fecha;
  final String codificacion;
  final String localizacion;
  final String tanquecombustibleytapa;
  final String palancaacelerador;
  final String varillaaceite;
  final String filtroaceite;
  final String filtrogasolina;
  final String filtromotor;
  final String valvula;
  final String zapata;
  final String silenciador;
  final String palancadescompresion;
  final String fuelle;
  final String manillar;
  final String manija;
  final String combustible;
  final String aceite;
  final String almacenadoporoperador;
  final String remitidoamantenimiento;
  final String fallas;

  Compactador({
    this.id = '',
    this.fecha = '',
    this.codificacion = '',
    this.localizacion = '',
    this.tanquecombustibleytapa = '',
    this.palancaacelerador = '',
    this.varillaaceite = '',
    this.filtroaceite = '',
    this.filtrogasolina = '',
    this.filtromotor = '',
    this.valvula = '',
    this.zapata = '',
    this.silenciador = '',
    this.palancadescompresion = '',
    this.fuelle = '',
    this.manillar = '',
    this.manija = '',
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
        'tanquecombustibleytapa': tanquecombustibleytapa,
        'palancaacelerador': palancaacelerador,
        'varillaaceite': varillaaceite,
        'filtroaceite': filtroaceite,
        'filtrogasolina': filtrogasolina,
        'filtromotor': filtromotor,
        'valvula': valvula,
        'zapata': zapata,
        'silenciador': silenciador,
        'palancadescompresion': palancadescompresion,
        'fuelle': fuelle,
        'manillar': manillar,
        'manija': manija,
        'combustible': combustible,
        'aceite': aceite,
        'almacenadoporoperador': almacenadoporoperador,
        'remitidoamantenimiento': remitidoamantenimiento,
        'fallas': fallas,
      }..removeWhere((_, value) => value == '');

  factory Compactador.fromMap(Map<String, dynamic> data, String documentId) =>
      Compactador(
        id: documentId,
        fecha: data['fecha'] ?? '',
        codificacion: data['codificacion'] ?? '',
        localizacion: data['localizacion'] ?? '',
        tanquecombustibleytapa: data['tanquecombustibleytapa'] ?? '',
        palancaacelerador: data['palancaacelerador'] ?? '',
        varillaaceite: data['varillaaceite'] ?? '',
        filtroaceite: data['filtroaceite'] ?? '',
        filtrogasolina: data['filtrogasolina'] ?? '',
        filtromotor: data['filtromotor'] ?? '',
        valvula: data['valvula'] ?? '',
        zapata: data['zapata'] ?? '',
        silenciador: data['silenciador'] ?? '',
        palancadescompresion: data['palancadescompresion'] ?? '',
        fuelle: data['fuelle'] ?? '',
        manillar: data['manillar'] ?? '',
        manija: data['manija'] ?? '',
        combustible: data['combustible'] ?? '',
        aceite: data['aceite'] ?? '',
        almacenadoporoperador: data['almacenadoporoperador'] ?? '',
        remitidoamantenimiento: data['remitidoamantenimiento'] ?? '',
        fallas: data['fallas'] ?? '',
      );
}

class CompactadorProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Compactador> _compactadorList = [];
  final Box _hiveBox = Hive.box('compactador');

  List<Compactador> get compactadorList => _compactadorList;

  Future<void> handleFirestoreOperation({
    required String action,
    Compactador? data,
    String? id,
  }) async {
    try {
      final collection = _firestore.collection('Compactador');
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

  Future<void> _addOffline(Compactador data, CollectionReference collection) async {
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

  Future<void> _updateOffline(Compactador data, String id, CollectionReference collection) async {
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
      _compactadorList = snapshot.docs
          .map((doc) => Compactador.fromMap(Map<String, dynamic>.from(doc.data() as Map), doc.id))
          .toList();

      // Actualizar Hive con los datos obtenidos
      for (var doc in snapshot.docs) {
        await _hiveBox.put(doc.id, doc.data());
      }
    } catch (e) {
      // Si no hay conexión, leer los datos desde Hive
      _compactadorList = _hiveBox.values
          .map((data) => Compactador.fromMap(Map<String, dynamic>.from(data), data['id']))
          .toList();
    }
  }

  Future<void> syncOfflineData() async {
    final collection = _firestore.collection('Compactador');

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

  // Método para generar y compartir un reporte del compactador
  Future<void> generateAndShareReport(String compactadorId) async {
    try {
      final DocumentSnapshot snapshot =
          await _firestore.collection('Compactador').doc(compactadorId).get();

      if (!snapshot.exists) {
        throw Exception("Datos del compactador no encontrados");
      }

      final data = snapshot.data() as Map<String, dynamic>;

      // Crear el documento PDF
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Reporte del Compactador', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Fecha: ${data['fecha']}'),
              pw.Text('Codificación: ${data['codificacion']}'),
              pw.Text('Localización: ${data['localizacion']}'),
              pw.Text('Tanque Combustible y Tapa: ${data['tanquecombustibleytapa']}'),
              pw.Text('Palanca Acelerador: ${data['palancaacelerador']}'),
              pw.Text('Varilla Aceite: ${data['varillaaceite']}'),
              pw.Text('Filtro Aceite: ${data['filtroaceite']}'),
              pw.Text('Filtro Gasolina: ${data['filtrogasolina']}'),
              pw.Text('Filtro Motor: ${data['filtromotor']}'),
              pw.Text('Válvula: ${data['valvula']}'),
              pw.Text('Zapata: ${data['zapata']}'),
              pw.Text('Silenciador: ${data['silenciador']}'),
              pw.Text('Palanca Descompresión: ${data['palancadescompresion']}'),
              pw.Text('Fuelle: ${data['fuelle']}'),
              pw.Text('Manillar: ${data['manillar']}'),
              pw.Text('Manija: ${data['manija']}'),
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
      final file = File("${output.path}/reporte_compactador.pdf");
      await file.writeAsBytes(await pdf.save());

      // Compartir el PDF
      await Share.shareFiles([file.path], text: 'Reporte del Compactador');

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
          ..subject = 'Reporte del Compactador'
          ..text = 'Adjunto se encuentra el reporte del compactador.'
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

// 'brahianservidor4@gmail.com', 'nerr jlhn apbh pyxs'
