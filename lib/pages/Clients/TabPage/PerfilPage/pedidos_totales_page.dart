import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_certamen_aplicacion/services/firestore_service.dart';


import 'package:flutter/material.dart';

class DeudaTotalPage extends StatelessWidget {
  final User usuario;

  const DeudaTotalPage({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deuda Total'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Aquí puedes agregar la lógica para realizar el pago
          },
          child: Text('Pagar'),
        ),
      ),
    );
  }
}
