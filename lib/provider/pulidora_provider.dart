import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


class Pulidora {
  final String id;
  final String fecha;
  final String codificacion;
  final String localizacion;
  final String conexionesPL;
  final String instDisco;
  final String acoplesPL;
  final String instmangoPL;
  final String interruptorincenPL;
  final String guiaguardaPL;
  final String accesoriosPL;
  final String generalPL;
  final String eppPL;
  final String barrerasPL;
  final String discoPL;
  final String combustible;
  final String aceite;
  final String almacenadoporoperador;
  final String remitidoamantenimiento;
  final String fallas;

  

  Pulidora({
    this.id = '',
    this.fecha = '',
    this.codificacion = '',
    this.localizacion = '',
    this.conexionesPL = '',
    this.instDisco = '',
    this.acoplesPL = '',
    this.instmangoPL = '',
    this.interruptorincenPL = '',
    this.guiaguardaPL = '',
    this.accesoriosPL = '',
    this.generalPL = '',
    this.eppPL = '',
    this.barrerasPL = '',
    this.discoPL = '',
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
        'conexionesPL': conexionesPL,
        'instDisco': instDisco,
        'acoplesPL': acoplesPL,
        'instmangoPL': instmangoPL,
        'interruptorincenPL': interruptorincenPL,
        'guiaguardaPL': guiaguardaPL,
        'accesoriosPL': accesoriosPL,
        'generalPL': generalPL,
        'eppPL': eppPL,
        'barrerasPL': barrerasPL,
        'discoPL': discoPL,
        'combustible': combustible,
        'aceite': aceite,
        'almacenadoporoperador': almacenadoporoperador,
        'remitidoamantenimiento': remitidoamantenimiento,
        'fallas': fallas,

        
      }..removeWhere((_, value) => value == '');

  factory Pulidora.fromMap(Map<String, dynamic> data, String documentId) =>
      Pulidora(
        id: documentId,
        fecha: data['fecha'] ?? '',
        codificacion: data['codificacion'] ?? '',
        localizacion: data['localizacion'] ?? '',
        conexionesPL: data['conexionesPL'] ?? '',
        instDisco: data['instDisco'] ?? '',
        acoplesPL: data['acoplesPL'] ?? '',
        instmangoPL: data['instmangoPL'] ?? '',
        interruptorincenPL: data['interruptorincenPL'] ?? '',
        guiaguardaPL: data['guiaguardaPL'] ?? '',
        accesoriosPL: data['accesoriosPL'] ?? '',
        generalPL: data['generalPL'] ?? '',
        eppPL: data['eppPL'] ?? '',
        barrerasPL: data['barrerasPL'] ?? '',
        discoPL: data['discoPL'] ?? '',
        combustible: data['combustible'] ?? '',
        aceite: data['aceite'] ?? '',
        almacenadoporoperador: data['almacenadoporoperador'] ?? '',
        remitidoamantenimiento: data['remitidoamantenimiento'] ?? '',
        fallas: data['fallas'] ?? '',
        
        
      );
}


class PulidoraProvider extends ChangeNotifier { 
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Pulidora> _pulidoraList = [];

  List<Pulidora> get pulidoraList => _pulidoraList;

  Future<void> handleFirestoreOperation({
    required String action,
    Pulidora? data,
    String? id,
  }) async {
    try {
      final collection = _firestore.collection('Pulidora');
      if (action == 'add' && data != null) {
        await collection.add(data.toMap());
      } else if (action == 'update' && data != null && id != null) {
        await collection.doc(id).update(data.toMap());
      } else if (action == 'fetch') {
        final snapshot = await collection.orderBy('fecha', descending: true).limit(3).get();
        _pulidoraList = snapshot.docs
            .map((doc) => Pulidora.fromMap(doc.data(), doc.id))
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