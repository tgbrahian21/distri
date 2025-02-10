import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class PlanchaReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> generateAndSharePlanchaReport(String planchaId, String email) async {
    try {
      // Obtener los datos de la plancha desde Firestore
      final DocumentSnapshot snapshot =
          await _firestore.collection('Plancha').doc(planchaId).get();

      if (!snapshot.exists) {
        throw Exception("Datos de la plancha no encontrados");
      }

      final data = snapshot.data() as Map<String, dynamic>;

      // Crear el documento PDF
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Reporte de la Plancha de Termofusión', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Fecha: ${data['fecha']}'),
              pw.Text('Codificación: ${data['codificacion']}'),
              pw.Text('Localización: ${data['localizacion']}'),
              pw.Text('Clavija: ${data['clavija']}'),
              pw.Text('Cable de conexión: ${data['cableconexion']}'),
              pw.Text('Mango de sujeción: ${data['mangosuje']}'),
              pw.Text('Termómetro: ${data['termometro']}'),
              pw.Text('Sockets: ${data['sockets']}'),
              pw.Text('Almacenado por operador: ${data['almacenadoporoperador']}'),
              pw.Text('Remitido a mantenimiento: ${data['remitidoamantenimiento']}'),
              pw.Text('Fallas: ${data['fallas']}'),
            ],
          ),
        ),
      );

      // Guardar el PDF en el dispositivo
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/reporte_plancha_termofusion.pdf");
      await file.writeAsBytes(await pdf.save());

      // Compartir el PDF
      await Share.shareFiles([file.path], text: 'Reporte de la Plancha de Termofusión');

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
          ..subject = 'Reporte de la Plancha de Termofusión'
          ..text = 'Adjunto se encuentra el reporte de la plancha de termofusión.'
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