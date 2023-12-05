import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/pages/Clients/TabPage/PerfilPage/EstudiantePage/administrar_estudiante.dart';
import 'package:flutter_certamen_aplicacion/pages/Clients/TabPage/PerfilPage/EstudiantePage/nuevo_estudiante_page.dart';
import 'package:flutter_certamen_aplicacion/pages/Clients/TabPage/PerfilPage/agregar_rut_page.dart';
import 'package:flutter_certamen_aplicacion/pages/Clients/TabPage/PerfilPage/pedidos_totales_page.dart';
import 'package:flutter_certamen_aplicacion/services/firestore_service.dart';

class PerfilPage extends StatelessWidget {
  final User usuario;

  const PerfilPage({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(
          automaticallyImplyLeading: false,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            color: Colors.blue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Perfil de Usuario',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Nombre: ${usuario?.displayName ?? 'Nombre no disponible'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Correo: ${usuario?.email ?? 'Correo no disponible'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AgregarRutPage(usuario: usuario),
              ),
            );
          },
          child: Text('Agregar Rut'),
        ),
      ),
          SizedBox(height: 10),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                 onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NuevoEstudiantePage(usuario: usuario),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      'Agregar Nuevo Estudiante',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdministrarEstudiantesPage(usuario: usuario),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      'Administrar Estudiantes',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 5),
          FutureBuilder(
  future: FirestoreService().getEstudiantes(usuario.uid),
  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos
    } else if (snapshot.hasError) {
      return Text('Error al obtener los datos'); // Muestra un mensaje de error si hubo un problema
    } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Text('No hay estudiantes disponibles'); // Muestra un mensaje si no hay datos o la lista está vacía
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            var estudiante = snapshot.data!.docs[index];
            var nombre = estudiante['nombre']; // Aquí deberías reemplazar 'nombre' con el nombre del campo en tu base de datos Firestore
            var curso = estudiante['curso']; // Igualmente, reemplaza 'curso' con el nombre del campo correspondiente
            
            return Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.green, // Color de fondo del segundo contenedor
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
      SizedBox(height: 10),
    Center(
      child: ElevatedButton(
        onPressed: () {
          // Lógica para mostrar los pedidos totales
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeudaTotalPage(usuario: usuario),
            ),
          );
        },
        child: Text('Deuda'),
      ),),
        ],
      ),
    );
  }
}
