import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_certamen_aplicacion/pages/Clients/TabPage/PedidosPage/editar_pedidos_page.dart';
import 'package:flutter_certamen_aplicacion/pages/Clients/TabPage/PedidosPage/quitar_insumos_pedidos_page.dart'; 
import 'package:intl/intl.dart';

//Te falta agregarle los ingrediente no permitidos a pedidos
//Te falta quitarle disgustos a estudiantes
//Te falta agregar una pagina de pedidos que muestre detalles de pedidos para el admin (cocinero)

class DetallesPedidosPage extends StatefulWidget {
  final String idEstudiante;
  final String usuario;

  DetallesPedidosPage({required this.idEstudiante, required this.usuario});

  @override
  _DetallesPedidosPageState createState() => _DetallesPedidosPageState();
}

class _DetallesPedidosPageState extends State<DetallesPedidosPage> {
  late String idEstudianteSeleccionado;

  @override
  void initState() {
    super.initState();
    idEstudianteSeleccionado = widget.idEstudiante;
  }

  
  String obtenerDiaSemana(DateTime fecha) {
  List<String> diasSemana = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
  ];
  int numeroDia = fecha.weekday;
  return diasSemana[numeroDia - 1];
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Detalles de Pedidos'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('pedidos')
            .where('idEstudiante', isEqualTo: idEstudianteSeleccionado)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay pedidos para mostrar'));
          } else {
            List<DocumentSnapshot> pedidos = snapshot.data!.docs;
            return ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                 var pedido = pedidos[index].data() as Map<String, dynamic>;
                String tipoPedido = pedido['tipo'] as String;

                if (tipoPedido == 'Pedido Diario') {
                  // Mostrar los almuerzos para cada día de la semana
                  return _buildDailyOrders(pedidos[index]);
                } else {
                  // Mostrar detalles de pedido con fechas
                  return _buildOrdersWithDates(pedidos[index]);
                }





               
              },
            );
          }
        },
      ),
    ),
  );
}
Widget _buildDailyOrders(DocumentSnapshot pedidoDoc) {
  var pedido = pedidoDoc.data() as Map<String, dynamic>;
  List<dynamic> listaAlmuerzosDynamic = pedido['listaAlmuerzos'] as List<dynamic>;
  List<String> listaAlmuerzos = listaAlmuerzosDynamic.map((dynamic almuerzo) => almuerzo.toString()).toList();

  List<String> diasSemana = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves'
  ];

  return FutureBuilder<List<String>>(
    future: _getAlmuerzosNames(listaAlmuerzos),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Text('No hay almuerzos disponibles');
      } else {
        List<String> nombresAlmuerzos = snapshot.data!;

        return Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tipo: Pedido Diario',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 10),
              for (int i = 0; i < diasSemana.length; i++)
                ListTile(
                  title: Text('${diasSemana[i]} "${nombresAlmuerzos[i]}"'),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para editar pedido
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PedidosEditarPage(pedido: pedidoDoc),
                        ),
                      );
                    },
                    child: Text('Editar Almuerzos'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _mostrarDialogoEliminar(pedidoDoc.id);
                    },
                    child: Text('Eliminar'),
                  ),
                ],
              ),
              SizedBox(height: 10), // Espaciado entre los elementos

              // Sección de insumos no usados
              FutureBuilder<List<String>>(
                future: _getInsumosNoUsados(pedidoDoc), // Método para obtener insumosNoUsados
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No hay insumos no usados');
                  } else {
                    List<String> insumosNoUsados = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Insumos No Usados:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        for (String insumo in insumosNoUsados)
                          Text(insumo),
                         SizedBox(height: 10), // Espaciado entre la lista de insumos no usados y el botón
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                         onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuitarInsumosPage(pedidoDoc: pedidoDoc), // Reemplaza QuitarInsumosPage() con tu widget de la página
                              ),
                            );
                          },
                        child: Text('Quitar ingredientes'),
                      ),
                    ],
                  ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        );
      }
    },
  );
}
Future<List<String>> _getInsumosNoUsados(DocumentSnapshot pedidoDoc) async {
  var pedido = pedidoDoc.data() as Map<String, dynamic>;
  
  // Verificamos si el campo "insumosNoUsados" existe en el documento de pedidos
  if (pedido.containsKey('insumosNoUsados')) {
    List<dynamic> insumosNoUsadosDynamic = pedido['insumosNoUsados'] as List<dynamic>;
    List<String> insumosNoUsados = insumosNoUsadosDynamic.map((dynamic insumo) => insumo.toString()).toList();
    return insumosNoUsados;
  } else {
    // Si el campo "insumosNoUsados" no existe o está vacío, retornamos una lista vacía
    return [];
  }
}


Future<List<String>> _getAlmuerzosNames(List<String> listaAlmuerzos) async {
  List<String> nombresAlmuerzos = [];
  for (String codigoAlmuerzo in listaAlmuerzos) {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('almuerzos')
        .where('codigo', isEqualTo: codigoAlmuerzo)
        .get();
    if (snapshot.docs.isNotEmpty) {
      nombresAlmuerzos.add(snapshot.docs.first['nombre']);
    }
  }
  return nombresAlmuerzos;
}

Future<DateTime> _getDiaSiguiente(DateTime fecha) async {
  final duracion = Duration(days: 1);
  final fechaSiguiente = fecha.add(duracion);
  return fechaSiguiente;
}


Widget _buildOrdersWithDates(DocumentSnapshot pedidoDoc) {
  var pedido = pedidoDoc.data() as Map<String, dynamic>;
  List<String> listaAlmuerzos = (pedido['listaAlmuerzos'] as List).cast<String>();

  return FutureBuilder<List<String>>(
    future: _getAlmuerzosNames(listaAlmuerzos),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Text('No hay almuerzos disponibles');
      } else {
        List<String> nombresAlmuerzos = snapshot.data!;
        List<Timestamp> listaFechasTimestamp = (pedido['listaFechas'] as List).cast<Timestamp>();
        List<DateTime> listaFechas = listaFechasTimestamp.map((timestamp) => timestamp.toDate()).toList();

        return Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tipo: ${pedido['tipo']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              for (int i = 0; i < listaFechas.length; i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: FutureBuilder<String>(
                        future: _getDiaSiguienteFechaYDia(listaFechas[i], nombresAlmuerzos[i]),
                        builder: (context, snapshotDiaSiguiente) {
                          if (snapshotDiaSiguiente.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshotDiaSiguiente.hasError) {
                            return Text('Error: ${snapshotDiaSiguiente.error}');
                          } else if (!snapshotDiaSiguiente.hasData) {
                            return Text('Fecha desconocida');
                          } else {
                            // Obtener la fecha actual
                            DateTime fechaActual = DateTime.now();

                            // Comparar la fecha del pedido con la fecha actual
                            bool fechaAntesDeHoy = listaFechas[i].isBefore(DateTime(
                              fechaActual.year,
                              fechaActual.month,
                              fechaActual.day,
                            ));

                            // Establecer el color del texto según la condición
                            Color textColor = fechaAntesDeHoy ? Colors.red : Colors.black;

                            return Text(
                              snapshotDiaSiguiente.data!,
                              style: TextStyle(color: textColor), // Aplicar el color al texto
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para editar pedido
                    },
                    child: Text('Editar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
            _mostrarDialogoEliminar(pedidoDoc.id);
          },
                    child: Text('Eliminar'),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    },
  );
}

Future<String> _getDiaSiguienteFechaYDia(DateTime fecha, String nombreAlmuerzo) async {
  final fechaSiguiente = await _getDiaSiguiente(fecha);
  final diaSemanaSiguiente = obtenerDiaSemana(fechaSiguiente);
  final formattedFechaSiguiente = DateFormat('dd-MM-yyyy').format(fechaSiguiente);
  return '$diaSemanaSiguiente $formattedFechaSiguiente "$nombreAlmuerzo"';
}

void _mostrarDialogoEliminar(String pedidoId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmar Eliminación'),
        content: Text('¿Estás seguro de que deseas eliminar este pedido?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
            },
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _eliminarPedido(pedidoId); // Elimina el pedido
              Navigator.of(context).pop(); // Cierra el diálogo
            },
            child: Text('Aceptar'),
          ),
        ],
      );
    },
  );
}



void _eliminarPedido(String pedidoId) async {
  try {
    await FirebaseFirestore.instance
        .collection('pedidos')
        .doc(pedidoId) // Utiliza el ID del pedido para eliminar el documento
        .delete();
  } catch (error) {
    print('Error al eliminar el pedido: $error');
  }
}
 


}