import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class CompactadorReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> generateAndShareCompactadorReport(String compactadorId, String email) async {
    try {
      // Obtener los datos del compactador desde Firestore
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
      // Obtener la lista de administradores
      final adminsQuerySnapshot = await _firestore
          .collection('users')
          .where('role', whereIn: ['admin', 'superAdmin'])
          .get();

      // Configurar el servidor SMTP
      final smtpServer = gmail('brahianservidor4@gmail.com', 'nerr jlhn apbh pyxs');

      for (var doc in adminsQuerySnapshot.docs) {
        final email = doc['email'];

        final message = Message()
          ..from = const Address('brahianservidor4@gmail.com', 'distriservicios')
          ..recipients.add(email)
          ..subject = 'Reporte del Compactador'
          ..text = 'Adjunto se encuentra el reporte del compactador.'
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