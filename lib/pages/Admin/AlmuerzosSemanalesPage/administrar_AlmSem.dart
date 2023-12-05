import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/pages/Admin/AlmuerzosSemanalesPage/nuevo_AlmSem.dart';

class AlmuerzosSemanalesPage extends StatelessWidget {
  const AlmuerzosSemanalesPage({Key? key}) : super(key: key);

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

            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Calendario',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildDayColumn(
                              'Lunes', almuerzosSemanales?['lunes'] ?? []),
                        ),
                        Expanded(
                          child: _buildDayColumn(
                              'Martes', almuerzosSemanales?['martes'] ?? []),
                        ),
                        Expanded(
                          child: _buildDayColumn('Miércoles',
                              almuerzosSemanales?['miercoles'] ?? []),
                        ),
                        Expanded(
                          child: _buildDayColumn(
                              'Jueves', almuerzosSemanales?['jueves'] ?? []),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditarAlmuerzosSemanalesPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildDayColumn(String day, List<dynamic> almuerzos) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
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
                    children:
                        nombresAlmuerzos.map((nombre) => Text(nombre)).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
