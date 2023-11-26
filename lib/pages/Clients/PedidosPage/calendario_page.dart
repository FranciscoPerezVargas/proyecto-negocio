// Página del Calendario
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CalendarioPage extends StatelessWidget {
  final User? usuario;

  const CalendarioPage({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Calendario Page',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Usuario: ${usuario?.displayName ?? 'Usuario no identificado'}',
              style: TextStyle(fontSize: 16),
            ),
            // Aquí puedes agregar cualquier contenido relacionado con el calendario
          ],
        ),
      ),
    );
  }
}