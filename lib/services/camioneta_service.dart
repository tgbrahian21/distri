import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class CamionetaReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> generateAndShareCamionetaReport(String camionetaId, String email) async {
    try {
      // Obtener los datos de la plancha desde Firestore
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
      // Obtener la lista de administradores
      final adminsQuerySnapshot = await _firestore
          .collection('users')
          .where('role', whereIn: ['admin', 'superAdmin'])
          .get();

      // Configurar el servidor SMTP
      final smtpServer = gmail('brahianservidor4@gmail.com', 'ksmj pzeq kige mcbx');

      for (var doc in adminsQuerySnapshot.docs) {
        final email = doc['email'];

        final message = Message()
          ..from = const Address('brahianservidor4@gmail.com', 'distriservicios')
          ..recipients.add(email)
          ..subject = 'Reporte de la Camioneta'
          ..text = 'Adjunto se encuentra el reporte de la Camioneta.'
          ..attachments.add(FileAttachment(pdfFile));

        // Enviar el correo
        await send(message, smtpServer);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al enviar el reporte a los administradores: $e');
      }
    }
  }
}