

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/services/firestore_service.dart';

class AdministrarEstudiantes extends StatelessWidget {
  final User usuario;

  const AdministrarEstudiantes({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrar Estudiantes'),
      ),
      body: FutureBuilder(
        future: FirestoreService().getEstudiantes(usuario.uid),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al obtener los datos'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No hay estudiantes disponibles'),
            );
          } else {
            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var estudiante = snapshot.data!.docs[index];
                  var nombre = estudiante['nombre']; // Reemplazar con el nombre del campo en tu base de datos Firestore
                  var curso = estudiante['curso']; // Reemplazar con el nombre del campo correspondiente
                  var disgustos = estudiante['disgustos']; // Reemplazar con el campo adecuado

                  return Container(
                    padding: EdgeInsets.all(20.0),
                    color: Colors.green,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Información de Estudiante',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Nombre: $nombre',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Curso: $curso',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Disgustos: $disgustos',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        // Puedes agregar más información del estudiante aquí
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
