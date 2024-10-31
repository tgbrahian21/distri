import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Plantaelec {
  final String id;
  final String fecha;
  final String codificacion;
  final String localizacion;
  final String encendido;
  final String yoyoarranque;
  final String motor;
  final String soportemotor;
  final String sistemaelectrico;
  final String estadobateria;
  final String estadogenerador;
  final String soportegenerador;
  final String tanquecombustible;
  final String manguerascombustible;
  final String conexioneselectricas;
  final String estadoacoples;
  final String estadoexhosto;
  final String nivelaceites;
  final String condicionequipo;
  final String indicadores;
  final String llantas;
  final String combustible;
  final String aceite;
  final String fallas;
  final String almacenadoporoperador;
  final String remitidoamantenimiento;

  Plantaelec({
    this.id = '',
    this.fecha = '',
    this.codificacion = '',
    this.localizacion = '',
    this.encendido = '',
    this.yoyoarranque = '',
    this.motor = '',
    this.soportemotor = '',
    this.sistemaelectrico = '',
    this.estadobateria = '',
    this.estadogenerador = '',
    this.soportegenerador = '',
    this.tanquecombustible = '',
    this.manguerascombustible = '',
    this.conexioneselectricas = '',
    this.estadoacoples = '',
    this.estadoexhosto = '',
    this.nivelaceites = '',
    this.condicionequipo = '',
    this.indicadores = '',
    this.llantas = '',
    this.combustible = '',
    this.aceite = '',
    this.fallas = '',
    this.almacenadoporoperador = '',
    this.remitidoamantenimiento = '',
  });

  Map<String, dynamic> toMap() => {
        'fecha': fecha,
        'codificacion': codificacion,
        'localizacion': localizacion,
        'encendido': encendido,
        'yoyoarranque': yoyoarranque,
        'motor': motor,
        'soportemotor': soportemotor,
        'sistemaelectrico': sistemaelectrico,
        'estadobateria': estadobateria,
        'estadogenerador': estadogenerador,
        'soportegenerador': soportegenerador,
        'tanquecombustible': tanquecombustible,
        'manguerascombustible': manguerascombustible,
        'conexioneselectricas': conexioneselectricas,
        'estadoacoples': estadoacoples,
        'estadoexhosto': estadoexhosto,
        'nivelaceites': nivelaceites,
        'condicionequipo': condicionequipo,
        'indicadores': indicadores,
        'llantas': llantas,
        'combustible': combustible,
        'aceite': aceite,
        'fallas': fallas,
        'almacenadoporoperador': almacenadoporoperador,
        'remitidoamantenimiento': remitidoamantenimiento,
      }..removeWhere((_, value) => value == '');

  factory Plantaelec.fromMap(Map<String, dynamic> data, String documentId) =>
      Plantaelec(
        id: documentId,
        fecha: data['fecha'] ?? '',
        codificacion: data['codificacion'] ?? '',
        localizacion: data['localizacion'] ?? '',
        encendido: data['encendido'] ?? '',
        yoyoarranque: data['yoyoarranque'] ?? '',
        motor: data['motor'] ?? '',
        soportemotor: data['soportemotor'] ?? '',
        sistemaelectrico: data['sistemaelectrico'] ?? '',
        estadobateria: data['estadobateria'] ?? '',
        estadogenerador: data['estadogenerador'] ?? '',
        soportegenerador: data['soportegenerador'] ?? '',
        tanquecombustible: data['tanquecombustible'] ?? '',
        manguerascombustible: data['manguerascombustible'] ?? '',
        conexioneselectricas: data['conexioneselectricas'] ?? '',
        estadoacoples: data['estadoacoples'] ?? '',
        estadoexhosto: data['estadoexhosto'] ?? '',
        nivelaceites: data['nivelaceites'] ?? '',
        condicionequipo: data['condicionequipo'] ?? '',
        indicadores: data['indicadores'] ?? '',
        llantas: data['llantas'] ?? '',
        combustible: data['combustible'] ?? '',
        aceite: data['aceite'] ?? '',
      );
}

class PlantaelecProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Plantaelec> _plantaelecList = [];

  List<Plantaelec> get plantaelecList => _plantaelecList;

  Future<void> handleFirestoreOperation({
    required String action,
    Plantaelec? data,
    String? id,
  }) async {
    try {
      final collection = _firestore.collection('plantaelec');
      if (action == 'add' && data != null) {
        await collection.add(data.toMap());
      } else if (action == 'update' && data != null && id != null) {
        await collection.doc(id).update(data.toMap());
      } else if (action == 'fetch') {
        final snapshot = await collection.get();
        _plantaelecList = snapshot.docs
            .map((doc) => Plantaelec.fromMap(doc.data(), doc.id))
            .toList();
      }
      notifyListeners();
    } catch (e) {
      _handleError(e, 'operación $action');
    }
  }

  void _handleError(Object error, String context) {
    if (kDebugMode) print('Error en $context: $error');
  }
}
