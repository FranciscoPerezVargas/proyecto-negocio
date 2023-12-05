import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_certamen_aplicacion/pages/Admin/InsumosPage/nuevo_insumo.dart';

class ListaInsumoPage extends StatefulWidget {
  @override
  _ListaInsumoPageState createState() => _ListaInsumoPageState();
}

class _ListaInsumoPageState extends State<ListaInsumoPage> {
  Future<List<Map<String, dynamic>>> obtenerInsumos() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('insumos').get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Insumos'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: obtenerInsumos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los insumos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay almuerzos disponibles'));
          }

          List<Map<String, dynamic>> insumos = snapshot.data!;

          return ListView.builder(
            itemCount: insumos.length,
            itemBuilder: (context, index) {
              final nombre = insumos[index]['nombre'];
              final precio = insumos[index]['precio'];
              final stock = insumos[index]['stock'];

              return ListTile(
                title: Text(nombre),
                subtitle: Text('Precio: $precio stock: $stock',
    style: TextStyle(
      color: stock <= 10 ? Colors.red : Colors.black, // Cambia el color a rojo si el stock es <= 10
    ),
  ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NuevoInsumoPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
