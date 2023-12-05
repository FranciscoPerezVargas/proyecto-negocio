

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/pages/Clients/TabPage/PerfilPage/EstudiantePage/editar_estudiante.dart';
import 'package:flutter_certamen_aplicacion/services/firestore_service.dart';

class AdministrarEstudiantesPage extends StatelessWidget {
  final User usuario;

  const AdministrarEstudiantesPage({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrar Estudiantes'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(),
          SizedBox(height: 15),
          FutureBuilder(
            future: FirestoreService().getEstudiantes(usuario.uid),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error al obtener los datos');
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text('No hay estudiantes disponibles');
              } else {
                return Expanded(
                  child: ListView.builder(

                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var estudiante = snapshot.data!.docs[index];
                      var nombre = estudiante['nombre'];
                      var curso = estudiante['curso'];
                      var disgustos = estudiante['disgustos'];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(height: 10,),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
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
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(height: 10),
                              ElevatedButton(

                                onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditarEstudiantePage(
                                          usuario: usuario,
                                          estudiante: estudiante,
                                          
                                        
                                        ),
                                      ),
                                    );
                                  },
                                child: Text('Editar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                              ),



                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  FirestoreService().borrarEstudiante(estudiante.id);
                           
                                },
                                child: Text('Borrar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
