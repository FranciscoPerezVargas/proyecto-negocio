

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ListaCocina extends StatelessWidget {
  final List<QueryDocumentSnapshot> pedidos;
  

  ListaCocina({required this.pedidos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Cocina'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getEstudianteData(), // Llamada a función para obtener datos del estudiante
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se encontraron datos para el estudiante'));
          } else {
            Map<String, dynamic> estudianteData = snapshot.data!;

            return ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                QueryDocumentSnapshot pedido = pedidos[index];
                Map<String, dynamic> pedidoData = pedido.data() as Map<String, dynamic>;
                String idEstudiante = pedidoData['idEstudiante'];

                if (estudianteData.containsKey(idEstudiante)) {
                  Map<String, dynamic> estudiante = estudianteData[idEstudiante]!;
                  
                  String almuerzo = _getAlmuerzo(pedido, DateTime.now().weekday);

                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text('ID Estudiante: $idEstudiante'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nombre: ${estudiante['nombre']}'),
                          Text('Curso: ${estudiante['curso']}'),
                          Text('Almuerzo: $almuerzo'),
                          Text('Insumos no usados:'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              pedidoData['insumosNoUsados'].length,
                              (subIndex) {
                                return Text('- ${pedidoData['insumosNoUsados'][subIndex]}');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text('ID Estudiante: $idEstudiante'),
                      subtitle: Text('No se encontraron datos para este estudiante'),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _getEstudianteData() async {
    // Obtener los IdEstudiante de los pedidos
    List<dynamic> idEstudiantes = pedidos.map((pedido) => pedido['idEstudiante']).toList();
    
    // Obtener los datos de los estudiantes correspondientes a los IdEstudiante
    Map<String, dynamic> estudiantesData = {};

    try {
      for (String id in idEstudiantes) {
        print(id);
        print(idEstudiantes);

        DocumentSnapshot estudianteSnapshot = await FirebaseFirestore.instance.collection('estudiantes').doc(id).get();
       
        estudiantesData[id] = estudianteSnapshot.data() as Map<String, dynamic>;
        print(estudiantesData);
      }
    } catch (error) {
      print('Error al obtener datos de estudiantes: $error');
    }

    return estudiantesData;
  }




  String _getAlmuerzo(QueryDocumentSnapshot pedido, int weekday) {
  Map<String, dynamic> pedidoData = pedido.data() as Map<String, dynamic>;
  String tipoPedido = pedidoData['tipo'];

  if (tipoPedido == 'Pedido Diario') {
    List<dynamic> listaAlmuerzos = pedidoData['listaAlmuerzos'];
    
    switch (weekday) {
      case DateTime.monday:
        if (listaAlmuerzos.length >= 1) {
          return listaAlmuerzos[0];
        }
        break;
      case DateTime.tuesday:
        if (listaAlmuerzos.length >= 2) {
          return listaAlmuerzos[1];
        }
        break;
      case DateTime.wednesday:
        if (listaAlmuerzos.length >= 3) {
          return listaAlmuerzos[2];
        }
        break;
      case DateTime.thursday:
        if (listaAlmuerzos.length >= 4) {
          return listaAlmuerzos[3];
        }
        break;
      default:
        return 'Almuerzo no asignado';
    }
  }
  
  return 'Almuerzo no asignado';
}

}
