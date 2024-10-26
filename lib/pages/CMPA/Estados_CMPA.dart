import 'package:flutter/material.dart';

class EstadosCMPA extends StatefulWidget {
  const EstadosCMPA({super.key});

  @override
  State<EstadosCMPA> createState() => _EstadosCMPAState();
}

class _EstadosCMPAState extends State<EstadosCMPA> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estados CMPA'),
      ),
      body: Center(
        child: Text('Content goes here'),
      ),
    );
  }
}
