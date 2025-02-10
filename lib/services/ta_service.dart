import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class TaladroReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> generateAndShareTaladroReport(String taladroId, String email) async {
    try {
      // Obtener los datos del taladro desde Firestore
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
              pw.Text('Guarda: ${data['guardasta']}'),
              pw.Text('Interruptor de Acción Martillo: ${data['interruptoraccionmartillo']}'),
              pw.Text('Mango: ${data['mango']}'),
              pw.Text('Botón de Seguro: ${data['botonseguro']}'),
              pw.Text('Uso del Taladro: ${data['usotaladro']}'),
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
          ..subject = 'Reporte del Taladro'
          ..text = 'Adjunto se encuentra el reporte del taladro.'
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