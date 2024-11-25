import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class PlantaelecReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> generateAndSharePlantaelecReport(String plantaelecId, String email) async {
    try {
      // Obtener los datos de la planta eléctrica desde Firestore
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
              pw.Text('Reporte de la Planta Eléctrica', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
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
      await Share.shareFiles([file.path], text: 'Reporte de la Planta Eléctrica');

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
          ..subject = 'Reporte de la Planta Eléctrica'
          ..text = 'Adjunto se encuentra el reporte de la planta eléctrica.'
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
