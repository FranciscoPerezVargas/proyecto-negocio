import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_certamen_aplicacion/services/firestore_service.dart';

class PedidosTotalesPage extends StatelessWidget {
  final User usuario;

  const PedidosTotalesPage({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos Totales'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirestoreService().getPedidosTotalesUsuario(usuario.uid),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay pedidos totales para mostrar'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                var pedido = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                // Renderizar la información del pedido, por ejemplo:
                return ListTile(
                  title: Text('Tipo: ${pedido['tipo']}'),
                  subtitle: Text('Detalles: ${pedido['detalles']}'),
                  // ... (Agrega más elementos según la estructura de tu documento de pedido)
                );
              },
            );
          }
        },
      ),
    );
  }
}
