

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/services/firestore_service.dart';


class QuitarInsumosPage extends StatefulWidget {
   final DocumentSnapshot pedidoDoc; // Documento del pedido

  const QuitarInsumosPage({Key? key, required this.pedidoDoc}) : super(key: key);

  @override
  State<QuitarInsumosPage> createState() => _QuitarInsumosPageState();
}

class _QuitarInsumosPageState extends State<QuitarInsumosPage> {
  
 
  List<String> nombresInsumos = [];
  List<String> IngredientesSeleccionados = [];
  String selectedInsumo = '';

  @override
  void initState() {
    super.initState();
    cargarNombresInsumos();
  }

  Future<void> cargarNombresInsumos() async {
    List<String> nombresInsumos = await FirestoreService().getNombresInsumo();
    setState(() {
      this.nombresInsumos = nombresInsumos;
    });
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> listaErrores = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Quitar Insumos',
            style: TextStyle(color: const Color.fromARGB(255, 7, 7, 7))),
      ),
      body: Container(
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
            borderRadius: BorderRadius.circular(8.0),
            color: Color.fromRGBO(236, 244, 160, 1)),
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
                
                
                DropdownButton<String>(
                  value: selectedInsumo.isNotEmpty &&
                          nombresInsumos.contains(selectedInsumo)
                      ? selectedInsumo
                      : null, // Puedes tener una variable para almacenar el insumo seleccionado
                  items: nombresInsumos.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedInsumo = newValue!;
                      if (!IngredientesSeleccionados.contains(selectedInsumo)) {
                        IngredientesSeleccionados.add(selectedInsumo);
                      } else {
                        print('ya quitaste ese ingrediente');
                      }
                    });
                  },
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Ingredientes Seleccionados:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: IngredientesSeleccionados.length,
                        itemBuilder: (BuildContext context, int index) {
                          final selectedInsumo =
                              IngredientesSeleccionados[index];
                          return ListTile(
                            title: Text(selectedInsumo),
                            trailing: ElevatedButton(
                              onPressed: () {
                                // Eliminar el insumo seleccionado de la lista
                                setState(() {
                                  IngredientesSeleccionados.removeAt(index);
                                });
                              },
                              child: Text('Eliminar'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // BOTON Agregar Nuevo Estudiante
                Container(
                  margin: EdgeInsets.only(top: 30),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Agregar A ingredientes No utilizados',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
  if (formKey.currentState!.validate()) {
    // Actualizar insumosNoUsados en el documento del pedido
    List<String> insumosNoUsadosActualizados = []; // Lista de insumos actualizados

    // Agregar los insumos seleccionados a insumosNoUsadosActualizados
    for (String insumo in IngredientesSeleccionados) {
      if (!insumosNoUsadosActualizados.contains(insumo)) {
        insumosNoUsadosActualizados.add(insumo);
      }
    }

    try {
      // Actualizar el campo insumosNoUsados en Firestore
      await FirebaseFirestore.instance
          .collection('pedidos')
          .doc(widget.pedidoDoc.id) // ID del documento del pedido
          .update({'insumosNoUsados': insumosNoUsadosActualizados});

      // Mostrar mensaje o realizar otras acciones si es necesario

      // Regresar a la página anterior
      Navigator.pop(context);
    } catch (e) {
      print('Error al actualizar los insumos no utilizados: $e');
      // Manejar el error de actualización si es necesario
    }
  }
},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
