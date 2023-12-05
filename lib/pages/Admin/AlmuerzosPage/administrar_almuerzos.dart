import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_certamen_aplicacion/pages/Admin/AlmuerzosPage/nuevo_almuerzo.dart';

class ListaAlmuerzoPage extends StatefulWidget {
  @override
  _ListaAlmuerzoPageState createState() => _ListaAlmuerzoPageState();
}

class _ListaAlmuerzoPageState extends State<ListaAlmuerzoPage> {
  Future<List<Map<String, dynamic>>> obtenerAlmuerzos() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('almuerzos').get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Almuerzos'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: obtenerAlmuerzos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los almuerzos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay almuerzos disponibles'));
          }

          List<Map<String, dynamic>> almuerzos = snapshot.data!;

          return ListView.builder(
            itemCount: almuerzos.length,
            itemBuilder: (context, index) {
              final nombre = almuerzos[index]['nombre'];
              final precio = almuerzos[index]['precio'];

              return ListTile(
                title: Text(nombre),
                subtitle: Text('Precio: $precio'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí puedes manejar la acción del botón flotante
          // Por ejemplo, navegar a la página de formulario
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NuevoAlmuerzoPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
