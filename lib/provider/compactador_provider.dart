import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


class Compactador {
  final String id;
  final String fecha;
  final String codificacion;
  final String localizacion;
  final String interpresioncmpe;
  final String manometrocmpe;
  final String horometrocmpe;
  final String valvulacmpe;
  final String soportescmpe;
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
    this.interpresioncmpe = '',
    this.manometrocmpe = '',
    this.horometrocmpe = '',
    this.valvulacmpe = '',
    this.soportescmpe = '',
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
        'interpresioncmpe': interpresioncmpe,
        'manometrocmpe': manometrocmpe,
        'horometrocmpe': horometrocmpe,
        'valvulacmpe': valvulacmpe,
        'soportescmpe': soportescmpe,
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
        interpresioncmpe: data['interpresioncmpe'] ?? '',
        manometrocmpe: data['manometrocmpe'] ?? '',
        horometrocmpe: data['horometrocmpe'] ?? '',
        valvulacmpe: data['valvulacmpe'] ?? '',
        soportescmpe: data['soportescmpe'] ?? '',
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

  List<Compactador> get compactadorList => _compactadorList;

  Future<void> handleFirestoreOperation({
    required String action,
    Compactador? data,
    String? id,
  }) async {
    try {
      final collection = _firestore.collection('Compactador');
      if (action == 'add' && data != null) {
        await collection.add(data.toMap());
      } else if (action == 'update' && data != null && id != null) {
        await collection.doc(id).update(data.toMap());
      } else if (action == 'fetch') {
        final snapshot = await collection.orderBy('fecha', descending: true).limit(3).get();
        _compactadorList = snapshot.docs
            .map((doc) => Compactador.fromMap(doc.data(), doc.id))
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