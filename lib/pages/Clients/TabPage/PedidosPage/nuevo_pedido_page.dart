import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/pages/Clients/TabPage/CalendarioPage/prueba_calendario_page.dart';
import 'package:flutter_certamen_aplicacion/services/firestore_service.dart';



///Son 2 cosas las que tiene que agregar
///primero que cuando sea Pedido Diario la lista Almuerzo se guarde en orden
///segundo que si el estudiante ya tiene un pedido no puede hacer un nuevo pedido, si no que puede modificarlo


class NuevoPedidoPage extends StatefulWidget {
  final User usuario;

  const NuevoPedidoPage({Key? key, required this.usuario}) : super(key: key);

  @override
  State<NuevoPedidoPage> createState() => _NuevoPedidoPageState();
}

class _NuevoPedidoPageState extends State<NuevoPedidoPage> {
  String? _selectedStudent; 
  List<Map<String, String>> _studentsList = [];
  List<DateTime> fechasSeleccionadas = []; 
  String _selectedOrderType = '';

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<void> _fetchStudents() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('estudiantes')
        .where('usuario', isEqualTo: widget.usuario.uid)
        .get();

    setState(() {
      _studentsList = snapshot.docs.map((doc) {
        return {
          'nombre': doc['nombre'] as String,
          'uid': doc.id, // UID del estudiante
        };
      }).toList();
    });
  } catch (error) {
    print('Error al obtener la lista de estudiantes: $error');
  }
}

  String obtenerDiaSemana(DateTime fecha) {
  List<String> diasSemana = ['Domingo', 'lunes', 'martes', 'miercoles', 'jueves', 'Viernes', 'Sábado'];
  int numeroDia = fecha.weekday;
  return diasSemana[numeroDia];
}

Future<String?> obtenerAlmuerzoPorDia(String diaSemana) async {
  String? almuerzo;
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('almuerzosSemanales')
        .doc('8mz5tvtm31fVMPUYhFyw') 
        .get();
    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      // Verificar si los datos son válidos y el día de la semana existe
      if (data != null && data.containsKey(diaSemana)) {
        // Obtener los almuerzos para el día de la semana
        List<dynamic>? diaAlmuerzos = data[diaSemana] as List<dynamic>?;
        // Verificar si hay almuerzos para ese día
        if (diaAlmuerzos != null && diaAlmuerzos.isNotEmpty) {
          almuerzo = diaAlmuerzos[0].toString();
        }
      }
    }
  } catch (error) {
    print('Error al obtener el almuerzo: $error');
  }
  return almuerzo;
}



Future<List<String>> obtenerPrimerosAlmuerzos() async {
  List<String> listaPrimerosAlmuerzos = [];
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('almuerzosSemanales')
        .doc('8mz5tvtm31fVMPUYhFyw') // ID de tu documento
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        List<String> diasSemana = [
          'lunes', 'martes', 'miercoles', 'jueves'
        ];

        for (String dia in diasSemana) {
          List<dynamic>? almuerzosDia = data[dia] as List<dynamic>?;

          if (almuerzosDia != null && almuerzosDia.isNotEmpty) {
            listaPrimerosAlmuerzos.add(almuerzosDia.first.toString());
          }
        }
      }
    }
  } catch (error) {
    print('Error al obtener los primeros almuerzos: $error');
  }
  return listaPrimerosAlmuerzos;
}


Future<List<String>> obtenerAlmuerzosSemanales(List<DateTime> fechasSeleccionadas) async {
  List<String> listaAlmuerzos = [];
  for (DateTime fecha in fechasSeleccionadas) {
    print(fecha);
    String diaSemana = obtenerDiaSemana(fecha);
    print(diaSemana);
    // Obtener los almuerzos para el día de la semana de la colección 'almuerzosSemanales'
    String? almuerzo = await obtenerAlmuerzoPorDia(diaSemana);
    print(almuerzo);
    // Agregar el almuerzo a listaAlmuerzos si se obtiene uno válido
    if (almuerzo != null) {
      listaAlmuerzos.add(almuerzo);
    }
  }
  return listaAlmuerzos;
}

  Future<void> _savePedido() async {
  if (formKey.currentState!.validate()) {
    try {
      if (_selectedOrderType == 'Pedido Diario')
        {
          List<String> listaPrimerosAlmuerzos = await obtenerPrimerosAlmuerzos();
          print('almuerzos diarios');

           await FirebaseFirestore.instance.collection('pedidos').add({
          'tipo': _selectedOrderType,
          'idEstudiante': _selectedStudent,
          'usuario': widget.usuario.uid,    
          'listaAlmuerzos': listaPrimerosAlmuerzos, 
        });
        }
      else{

 // Obtener los almuerzos correspondientes a las fechas seleccionadas
      List<String> listaAlmuerzos = await obtenerAlmuerzosSemanales(fechasSeleccionadas);
      print(fechasSeleccionadas);

      // Guardar el pedido con la lista de fechas y almuerzos
      await FirebaseFirestore.instance.collection('pedidos').add({
        'tipo': _selectedOrderType,
        'idEstudiante': _selectedStudent,
        'usuario': widget.usuario.uid,
        'listaFechas': fechasSeleccionadas,
        'listaAlmuerzos': listaAlmuerzos,
      });
      }     
    } catch (error) {
      print('Error al guardar el pedido: $error');
      // Manejar el error como prefieras
    }
  }
}
Future<bool> _checkStudentOrders() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('pedidos')
        .where('idEstudiante', isEqualTo: _selectedStudent)
        .get();

    return snapshot.docs.isNotEmpty;
  } catch (error) {
    print('Error al verificar los pedidos del estudiante: $error');
    return false;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Pedido'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seleccionar estudiante:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: _selectedStudent,
                onChanged: (value) {
                  setState(() {
                    _selectedStudent = value;
                  });
                },
                items: _studentsList.map((student) {
                  return DropdownMenuItem<String>(
                    value: student['uid'], // Usa la UID como valor del estudiante
                    child: Text(student['nombre'] ?? ''), // Muestra el nombre del estudiante
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Seleccione un estudiante',
                  labelText: 'Estudiante',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Tipo de Pedido:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedOrderType = 'Pedido Diario';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedOrderType == 'Pedido Diario' ? Colors.blue : null,
                    ),
                    child: Text('Pedido Diario'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _selectedOrderType = 'Personalizar fecha';
                      });
                      final List<DateTime>? fechasSeleccionadas = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PruebaCalendarioPage(),
                        ),
                      );
                      // Verificar si se han seleccionado fechas y hacer algo con ellas
                      if (fechasSeleccionadas != null && fechasSeleccionadas.isNotEmpty) {
                        setState(() {
                        print('Fechas seleccionadas: $fechasSeleccionadas');
                         this.fechasSeleccionadas = fechasSeleccionadas;
                         });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedOrderType == 'Personalizar fecha' ? Colors.blue : null,
                    ),
                    child: Text('Personalizar fecha'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
  child: FutureBuilder<bool>(
    future: _checkStudentOrders(), // Función que verifica si el estudiante tiene pedidos
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (snapshot.data == true) {
        return ElevatedButton(
          onPressed: () {
            // Lógica si el estudiante ya tiene pedidos
          },
          child: Text('El estudiante ya tiene un pedido'),
        );
      } else {
         return AbsorbPointer(
          absorbing: _selectedStudent == null,
          child: Opacity(
            opacity: _selectedStudent == null ? 0.5 : 1.0,
            child: ElevatedButton(
  onPressed: _selectedStudent == null ? null : () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar pedido'),
          content: Text('¿Estás seguro de que los datos son correctos?'),
          actions: [
            TextButton(
              onPressed: () {
                // Lógica al presionar Cancelar
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Lógica al presionar Realizar
                Navigator.of(context).pop(); // Cerrar el diálogo
                await _savePedido();
              },
              child: Text('Realizar'),
            ),
          ],
        );
      },
    );
  },
  child: Text('Realizar Pedido'),
),

          ),
        );
      }
    },
  ),
),
              if (fechasSeleccionadas != null && fechasSeleccionadas.isNotEmpty)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text('Fechas seleccionadas: ${fechasSeleccionadas.join(', ')}'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
