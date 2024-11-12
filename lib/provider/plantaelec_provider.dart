import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Plantaelec {
  String id;
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
  final String almacenadoporoperador;
  final String remitidoamantenimiento;
  final String fallas;

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
    this.almacenadoporoperador = '',
    this.remitidoamantenimiento = '',
    this.fallas = '',
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
        'almacenadoporoperador': almacenadoporoperador,
        'remitidoamantenimiento': remitidoamantenimiento,
        'fallas': fallas,
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
        almacenadoporoperador: data['almacenadoporoperador'] ?? '',
        remitidoamantenimiento: data['remitidoamantenimiento'] ?? '',
        fallas: data['fallas'] ?? '',
      );
}


class PlantaelecProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Plantaelec> _plantaelecList = [];
  final Box _hiveBox = Hive.box('plantaelec');

  List<Plantaelec> get plantaelecList => _plantaelecList;

  Future<void> handleFirestoreOperation({
    required String action,
    Plantaelec? data,
    String? id,
  }) async {
    try {
      final collection = _firestore.collection('plantaelec');

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

  Future<void> _addOffline(Plantaelec data, CollectionReference collection) async {
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

  Future<void> _updateOffline(Plantaelec data, String id, CollectionReference collection) async {
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
      _plantaelecList = snapshot.docs
          .map((doc) => Plantaelec.fromMap(Map<String, dynamic>.from(doc.data() as Map), doc.id))
          .toList();

      // Actualizar Hive con los datos obtenidos
      for (var doc in snapshot.docs) {
        await _hiveBox.put(doc.id, doc.data());
      }
    } catch (e) {
      // Si no hay conexión, leer los datos desde Hive
      _plantaelecList = _hiveBox.values
          .map((data) => Plantaelec.fromMap(Map<String, dynamic>.from(data), data['id']))
          .toList();
    }
  }

  Future<void> syncOfflineData() async {
    final collection = _firestore.collection('plantaelec');

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
}

