import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


class Taladro{
  final String id;
  final String fecha;
  final String codificacion;
  final String localizacion;
  final String conexiones;
  final String interruptor;
  final String estadocuerpo;
  final String guardasta;
  final String interruptoraccionmartillo;
  final String mango;
  final String botonseguro;
  final String usotaladro;
  final String combustible;
  final String aceite;
  final String almacenadoporoperador;
  final String remitidoamantenimiento;
  final String fallas;

  

  Taladro({
    this.id = '',
    this.fecha = '',
    this.codificacion = '',
    this.localizacion = '',
    this.conexiones = '',
    this.interruptor = '',
    this.estadocuerpo = '',
    this.guardasta = '',
    this.interruptoraccionmartillo = '',
    this.mango = '',
    this.botonseguro = '',
    this.usotaladro = '',
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
        'conexiones': conexiones,
        'interruptor': interruptor,
        'estadocuerpo': estadocuerpo,
        'guardasta': guardasta,
        'interruptoraccionmartillo': interruptoraccionmartillo,
        'mango': mango,
        'botonseguro': botonseguro,
        'usotaladro': usotaladro,
        'combustible': combustible,
        'aceite': aceite,
        'almacenadoporoperador': almacenadoporoperador,
        'remitidoamantenimiento': remitidoamantenimiento,
        'fallas': fallas,

        
      }..removeWhere((_, value) => value == '');

  factory Taladro.fromMap(Map<String, dynamic> data, String documentId) =>
      Taladro(
        id: documentId,
        fecha: data['fecha'] ?? '',
        codificacion: data['codificacion'] ?? '',
        localizacion: data['localizacion'] ?? '',
        conexiones: data['conexiones'] ?? '',
        interruptor: data['interruptor'] ?? '',
        estadocuerpo: data['estadocuerpo'] ?? '',
        guardasta: data['guardasta'] ?? '',
        interruptoraccionmartillo: data['interruptoraccionmartillo'] ?? '',
        mango: data['mango'] ?? '',
        botonseguro: data['botonseguro'] ?? '',
        usotaladro: data['usotaladro'] ?? '',
        combustible: data['combustible'] ?? '',
        aceite: data['aceite'] ?? '',
        almacenadoporoperador: data['almacenadoporoperador'] ?? '',
        remitidoamantenimiento: data['remitidoamantenimiento'] ?? '',
        fallas: data['fallas'] ?? '',
        
        
      );
}


class TaladroProvider extends ChangeNotifier { 
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Taladro> _taladroList = [];

  List<Taladro> get taladroList => _taladroList;

  Future<void> handleFirestoreOperation({
    required String action,
    Taladro? data,
    String? id,
  }) async {
    try {
      final collection = _firestore.collection('Taladro');
      if (action == 'add' && data != null) {
        await collection.add(data.toMap());
      } else if (action == 'update' && data != null && id != null) {
        await collection.doc(id).update(data.toMap());
      } else if (action == 'fetch') {
        final snapshot = await collection.orderBy('fecha', descending: true).limit(3).get();
        _taladroList = snapshot.docs
            .map((doc) => Taladro.fromMap(doc.data(), doc.id))
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