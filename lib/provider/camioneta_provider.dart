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

class Camioneta {
  String id;
  final String fecha;
  final String aireacondicionado;
  final String silleteria;
  final String encendedor;
  final String luzinterior;
  final String aceitemotor;
  final String liquidofrenos;
  final String aguaradiador;
  final String aguabateria;
  final String aceitehidraulico;
  final String fugaacpm;
  final String fugasagua;
  final String fugaaceitetransmision;
  final String fugaaceitecaja;
  final String fugaliquidofrenos;
  final String lucestablero;
  final String nivelcombustible;
  final String odometro;
  final String pito;
  final String tacometro;
  final String velocimetro;
  final String indicadoraceite;
  final String indicadortemperatura;
  final String almacenadoporoperador;
  final String remitidoamantenimiento;
  final String fallas;

  Camioneta({
    this.id = '',
    this.fecha = '',
    this.aireacondicionado = '',
    this.silleteria = '',
    this.encendedor = '',
    this.luzinterior = '',
    this.aceitemotor = '',
    this.liquidofrenos = '',
    this.aguaradiador = '',
    this.aguabateria = '',
    this.aceitehidraulico = '',
    this.fugaacpm = '',
    this.fugasagua = '',
    this.fugaaceitetransmision = '',
    this.fugaaceitecaja = '',
    this.fugaliquidofrenos = '',
    this.lucestablero = '',
    this.nivelcombustible = '',
    this.odometro = '',
    this.pito = '',
    this.tacometro = '',
    this.velocimetro = '',
    this.indicadoraceite = '',
    this.indicadortemperatura = '',
    this.almacenadoporoperador = '',
    this.remitidoamantenimiento = '',
    this.fallas = '',
  });

  Map<String, dynamic> toMap() => {
        'fecha': fecha,
        'aireacondicionado': aireacondicionado,
        'silleteria': silleteria,
        'encendedor': encendedor,
        'luzinterior': luzinterior,
        'aceitemotor': aceitemotor,
        'liquidofrenos': liquidofrenos,
        'aguaradiador': aguaradiador,
        'aguabateria': aguabateria,
        'aceitehidraulico': aceitehidraulico,
        'fugaacpm': fugaacpm,
        'fugasagua': fugasagua,
        'fugaaceitetransmision': fugaaceitetransmision,
        'fugaaceitecaja': fugaaceitecaja,
        'fugaliquidofrenos': fugaliquidofrenos,
        'lucestablero': lucestablero,
        'nivelcombustible': nivelcombustible,
        'odometro': odometro,
        'pito': pito,
        'tacometro': tacometro,
        'velocimetro': velocimetro,
        'indicadoraceite': indicadoraceite,
        'indicadortemperatura': indicadortemperatura,
        'almacenadoporoperador': almacenadoporoperador,
        'remitidoamantenimiento': remitidoamantenimiento,
        'fallas': fallas,
      }..removeWhere((_, value) => value == '');

  factory Camioneta.fromMap(Map<String, dynamic> data, String documentId) =>
      Camioneta(
        id: documentId,
        fecha: data['fecha'] ?? '',
        aireacondicionado: data['aireacondicionado'] ?? '',
        silleteria: data['silleteria'] ?? '',
        encendedor: data['encendedor'] ?? '',
        luzinterior: data['luzinterior'] ?? '',
        aceitemotor: data['aceitemotor'] ?? '',
        liquidofrenos: data['liquidofrenos'] ?? '',
        aguaradiador: data['aguaradiador'] ?? '',
        aguabateria: data['aguabateria'] ?? '',
        aceitehidraulico: data['aceitehidraulico'] ?? '',
        fugaacpm: data['fugaacpm'] ?? '',
        fugasagua: data['fugasagua'] ?? '',
        fugaaceitetransmision: data['fugaaceitetransmision'] ?? '',
        fugaaceitecaja: data['fugaaceitecaja'] ?? '',
        fugaliquidofrenos: data['fugaliquidofrenos'] ?? '',
        lucestablero: data['lucestablero'] ?? '',
        nivelcombustible: data['nivelcombustible'] ?? '',
        odometro: data['odometro'] ?? '',
        pito: data['pito'] ?? '',
        tacometro: data['tacometro'] ?? '',
        velocimetro: data['velocimetro'] ?? '',
        indicadoraceite: data['indicadoraceite'] ?? '',
        indicadortemperatura: data['indicadortemperatura'] ?? '',
        almacenadoporoperador: data['almacenadoporoperador'] ?? '',
        remitidoamantenimiento: data['remitidoamantenimiento'] ?? '',
        fallas: data['fallas'] ?? '',
      );

  get codificacion => null;
}

class CamionetaProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Camioneta> _camionetaList = [];
  final Box _hiveBox = Hive.box('camioneta');

  List<Camioneta> get camionetaList => _camionetaList;

  Future<void> handleFirestoreOperation({
    required String action,
    Camioneta? data,
    String? id,
  }) async {
    try {
      final collection = _firestore.collection('Camioneta');
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

  Future<void> _addOffline(Camioneta data, CollectionReference collection) async {
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

  Future<void> _updateOffline(Camioneta data, String id, CollectionReference collection) async {
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
      _camionetaList = snapshot.docs
          .map((doc) => Camioneta.fromMap(Map<String, dynamic>.from(doc.data() as Map), doc.id))
          .toList();

      // Actualizar Hive con los datos obtenidos
      for (var doc in snapshot.docs) {
        await _hiveBox.put(doc.id, doc.data());
      }
    } catch (e) {
      // Si no hay conexión, leer los datos desde Hive
      _camionetaList = _hiveBox.values
          .map((data) => Camioneta.fromMap(Map<String, dynamic>.from(data), data['id']))
          .toList();
    }
  }

  Future<void> syncOfflineData() async {
    final collection = _firestore.collection('Camioneta');

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
  Future<void> generateAndShareReport(String camionetaId) async {
    try {
      final DocumentSnapshot snapshot =
          await _firestore.collection('Camioneta').doc(camionetaId).get();

      if (!snapshot.exists) {
        throw Exception("Datos de la camioneta no encontrados");
      }

      final data = snapshot.data() as Map<String, dynamic>;

      // Crear el documento PDF
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Reporte de la camioneta', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Fecha: ${data['fecha']}'),
              pw.Text('Aire Acondicionado: ${data['aireacondicionado']}'),
              pw.Text('Silletería: ${data['silleteria']}'),
              pw.Text('Encendedor: ${data['encendedor']}'),
              pw.Text('Luz Interior: ${data['luzinterior']}'),
              pw.Text('Aceite Motor: ${data['aceitemotor']}'),
              pw.Text('Líquido Frenos: ${data['liquidofrenos']}'),
              pw.Text('Agua Radiador: ${data['aguaradiador']}'),
              pw.Text('Agua Batería: ${data['aguabateria']}'),
              pw.Text('Aceite Hidráulico: ${data['aceitehidraulico']}'),
              pw.Text('Fuga ACPM: ${data['fugaacpm']}'),
              pw.Text('Fugas Agua: ${data['fugasagua']}'),
              pw.Text('Fuga Aceite Transmisión: ${data['fugaaceitetransmision']}'),
              pw.Text('Fuga Aceite Caja: ${data['fugaaceitecaja']}'),
              pw.Text('Fuga Líquido Frenos: ${data['fugaliquidofrenos']}'),
              pw.Text('Luces Tablero: ${data['lucestablero']}'),
              pw.Text('Nivel Combustible: ${data['nivelcombustible']}'),
              pw.Text('Odómetro: ${data['odometro']}'),
              pw.Text('Pito: ${data['pito']}'),
              pw.Text('Tacómetro: ${data['tacometro']}'),
              pw.Text('Velocímetro: ${data['velocimetro']}'),
              pw.Text('Indicador Aceite: ${data['indicadoraceite']}'),
              pw.Text('Indicador Temperatura: ${data['indicadortemperatura']}'),
              pw.Text('Almacenado por Operador: ${data['almacenadoporoperador']}'),
              pw.Text('Remitido a Mantenimiento: ${data['remitidoamantenimiento']}'),
              pw.Text('Fallas: ${data['fallas']}'),
            ],
          ),
        ),
      );

      // Guardar el PDF en el dispositivo
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/reporte_camioneta.pdf");
      await file.writeAsBytes(await pdf.save());

      // Compartir el PDF
      await Share.shareFiles([file.path], text: 'Reporte de la Camioneta');

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
          ..subject = 'Reporte de la Camioneta'
          ..text = 'Adjunto se encuentra el reporte de la camioneta.'
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
