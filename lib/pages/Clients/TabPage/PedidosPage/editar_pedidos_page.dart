import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PedidosEditarPage extends StatefulWidget {
  final DocumentSnapshot pedido; // Asegúrate de tener esta declaración

  PedidosEditarPage({required this.pedido}); // Constructor que acepta 'pedido'

  @override
  _PedidosEditarPageState createState() => _PedidosEditarPageState();
}

class _PedidosEditarPageState extends State<PedidosEditarPage> {
  List<String>? almuerzosLunesList;
  List<String>? almuerzosMartesList;
  List<String>? almuerzosMiercolesList;
  List<String>? almuerzosJuevesList;

  String? selectedOption1;
  String? selectedOption2;
  String? selectedOption3;
  String? selectedOption4;


   List<String> almuerzosSeleccionados = [];
  @override
  void initState() {
    super.initState();
    obtenerAlmuerzosSemanales();
    obtenerListaAlmuerzosExistente();
  }

  Future<void> obtenerAlmuerzosSemanales() async {
    try {
      DocumentSnapshot almuerzosSemanalesDoc = await FirebaseFirestore.instance
          .collection('almuerzosSemanales')
          .doc('8mz5tvtm31fVMPUYhFyw')
          .get();

      setState(() {
        almuerzosLunesList = List<String>.from(almuerzosSemanalesDoc['lunes']);
        almuerzosMartesList = List<String>.from(almuerzosSemanalesDoc['martes']);
        almuerzosMiercolesList = List<String>.from(almuerzosSemanalesDoc['miercoles']);
        almuerzosJuevesList = List<String>.from(almuerzosSemanalesDoc['jueves']);
      });
    } catch (error) {
      print('Error al obtener los datos de almuerzos semanales: $error');
    }
  }

   Future<void> obtenerListaAlmuerzosExistente() async {
    try {
      // Obtener la lista de almuerzos existente del pedido
      List<dynamic>? listaAlmuerzos = widget.pedido['listaAlmuerzos'];

      // Asignar los valores iniciales a los DropdownButton
      setState(() {
        selectedOption1 = listaAlmuerzos?[0];
        selectedOption2 = listaAlmuerzos?[1];
        selectedOption3 = listaAlmuerzos?[2];
        selectedOption4 = listaAlmuerzos?[3];
      });
    } catch (error) {
      print('Error al obtener la lista de almuerzos del pedido: $error');
    }
  }

  Future<String?> obtenerNombreAlmuerzo(String codigoAlmuerzo) async {
  try {
    DocumentSnapshot almuerzoDoc = await FirebaseFirestore.instance
        .collection('almuerzos')
        .doc(codigoAlmuerzo)
        .get();

    return almuerzoDoc['nombre']; // Retorna el nombre del almuerzo
  } catch (error) {
    print('Error al obtener el nombre del almuerzo: $error');
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + 100), // Ajusta el tamaño del AppBar aquí
      child: AppBar(
        title: Text('Editar Pedido'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: _buildAlmuerzosAppBar(),
        ),
      ),
    ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lunes', style: TextStyle(fontSize: 20)),
                SizedBox(height: 8),
                DropdownButton<String>(
                  value: selectedOption1,
                  onChanged: (String? newValue) {
  setState(() {
    selectedOption1 = newValue; // Puede seguir siendo el código
    if (newValue != null) {
      obtenerNombreAlmuerzo(newValue).then((nombre) {
        if (nombre != null) {
          selectedOption1 = nombre; // Asigna el nombre al seleccionar el código
        }
      });
      almuerzosSeleccionados.add(newValue);
    }
  });
},
                  isExpanded: true,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  items: almuerzosLunesList?.map((String almuerzo) {
                    return DropdownMenuItem<String>(
                      value: almuerzo,
                      child: Text(almuerzo),
                    );
                  }).toList() ?? [],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Martes', style: TextStyle(fontSize: 20)),
                SizedBox(height: 8),
                DropdownButton<String>(
                  value: selectedOption2,
                 onChanged: (String? newValue) {
  setState(() {
    selectedOption2 = newValue; // Puede seguir siendo el código
    if (newValue != null) {
      obtenerNombreAlmuerzo(newValue).then((nombre) {
        if (nombre != null) {
          selectedOption2 = nombre; // Asigna el nombre al seleccionar el código
        }
      });
      almuerzosSeleccionados.add(newValue);
    }
  });
},
                  isExpanded: true,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  items: almuerzosMartesList?.map((String almuerzo) {
                    return DropdownMenuItem<String>(
                      value: almuerzo,
                      child: Text(almuerzo),
                    );
                  }).toList() ?? [],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Miércoles', style: TextStyle(fontSize: 20)),
                SizedBox(height: 8),
                DropdownButton<String>(
                  value: selectedOption3,
                  onChanged: (String? newValue) {
  setState(() {
    selectedOption3 = newValue; // Puede seguir siendo el código
    if (newValue != null) {
      obtenerNombreAlmuerzo(newValue).then((nombre) {
        if (nombre != null) {
          selectedOption3 = nombre; // Asigna el nombre al seleccionar el código
        }
      });
      almuerzosSeleccionados.add(newValue);
    }
  });
},
                  isExpanded: true,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  items: almuerzosMiercolesList?.map((String almuerzo) {
                    return DropdownMenuItem<String>(
                      value: almuerzo,
                      child: Text(almuerzo),
                    );
                  }).toList() ?? [],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Jueves', style: TextStyle(fontSize: 20)),
                SizedBox(height: 8),
                DropdownButton<String>(
                  value: selectedOption4,
                  onChanged: (String? newValue) {
                    setState(() {
                     
                      selectedOption4 = newValue; // Puede seguir siendo el código
                       print(selectedOption4);
                      if (newValue != null) {
                        obtenerNombreAlmuerzo(newValue).then((nombre) {
                          if (nombre != null) {
                             print(selectedOption4);
                            selectedOption4 = nombre; // Asigna el nombre al seleccionar el código
                          }
                        });
                        almuerzosSeleccionados.add(newValue);
                      }
                    });
                  },
                  isExpanded: true,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  items: almuerzosJuevesList?.map((String almuerzo) {
                    return DropdownMenuItem<String>(
                      value: almuerzo,
                      child: Text(almuerzo),
                    );
                  }).toList() ?? [],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          
            SizedBox(height: 16.0),
            ElevatedButton(
  onPressed: () async {
    List<String> almuerzosSeleccionados = []; // Inicializa la lista fuera del bloque if-else

    if (selectedOption1 == null || selectedOption2 == null || selectedOption3 == null || selectedOption4 == null) {
      // Si algún DropdownButton no ha sido seleccionado, obtén los almuerzos del pedido nuevamente
      await obtenerListaAlmuerzosExistente();
    } else {
      // Si todos los DropdownButton están seleccionados, crea la lista de almuerzos seleccionados
      almuerzosSeleccionados = [selectedOption1!, selectedOption2!, selectedOption3!, selectedOption4!];
    }

    try {
      // Actualizar 'listaAlmuerzos' del documento 'pedido' con almuerzosSeleccionados
      await FirebaseFirestore.instance
          .collection('pedidos')
          .doc(widget.pedido.id)
          .update({'listaAlmuerzos': almuerzosSeleccionados});

      // Mensaje de éxito o acción después de la actualización
      print('Lista de almuerzos actualizada exitosamente');
    } catch (error) {
      // Manejo de errores
      print('Error al actualizar la lista de almuerzos: $error');
    }
  },
  child: Text('Cambiar Almuerzos'),
),


          ],
        ),
      
          ],
        ),
      ),
      
    );
  }
}


  Widget _buildAlmuerzosAppBar() {
    return FutureBuilder<DocumentSnapshot>(
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

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildDay('Lunes', almuerzosSemanales?['lunes'] ?? []),
                  _buildDay('Martes', almuerzosSemanales?['martes'] ?? []),
                  _buildDay('Miércoles', almuerzosSemanales?['miercoles'] ?? []),
                  _buildDay('Jueves', almuerzosSemanales?['jueves'] ?? []),
                ],
              ),
            ),
          );
        }
      },
    );
  }Widget _buildDay(String day, List<dynamic> almuerzos) {
  return FutureBuilder<QuerySnapshot>(
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
        List<String> almuerzosInfo = snapshot.data!.docs.map((doc) {
          String nombreAlmuerzo = doc['nombre'] as String;
          String codigoAlmuerzo = doc['codigo'] as String;
          return '$nombreAlmuerzo = $codigoAlmuerzo';
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: almuerzosInfo.map((info) => Chip(label: Text(info))).toList(),
            ),
          ],
        );
      }
    },
  );
}

  
