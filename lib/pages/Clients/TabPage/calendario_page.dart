// Página del Calendario
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/pages/Clients/TabPage/PerfilPage/pedidos_totales_page.dart';


class CalendarioPage extends StatelessWidget {
  final User usuario;

  const CalendarioPage({Key? key, required this.usuario}) : super(key: key);
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(
          automaticallyImplyLeading: false,
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('almuerzosSemanales')
            .doc('8mz5tvtm31fVMPUYhFyw')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(child: Text('No hay datos disponibles'));
          } else {
            Map<String, dynamic>? almuerzosSemanales =
                snapshot.data!.data() as Map<String, dynamic>?;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Calendario',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(height: 20),
                Table(
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      children: [
                        _buildDayColumn('Lunes',
                            almuerzosSemanales?['lunes'] ?? []),
                        _buildDayColumn('Martes',
                            almuerzosSemanales?['martes'] ?? []),
                        _buildDayColumn('Miércoles',
                            almuerzosSemanales?['miercoles'] ?? []),
                        _buildDayColumn('Jueves',
                            almuerzosSemanales?['jueves'] ?? []),
                      ],
                    ),
                  ],
                ),
           
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildDayColumn(String day, List<dynamic> almuerzos) {
  return Container(
    padding: EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          day,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('almuerzos')
              .where('codigo', whereIn: almuerzos)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('No hay almuerzos disponibles');
            } else {
              List<String> nombresAlmuerzos = snapshot.data!.docs
                  .map((doc) => doc['nombre'] as String)
                  .toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: nombresAlmuerzos
                    .map((nombre) => Text(nombre))
                    .toList(),
              );
            }
          },
          
        ),
       
        
      ],
    ),
  );
}
}