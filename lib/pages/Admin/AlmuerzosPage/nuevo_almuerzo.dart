import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/services/firestore_service.dart';
import 'dart:io';

class NuevoAlmuerzoPage extends StatefulWidget {
  const NuevoAlmuerzoPage({Key? key}) : super(key: key);
  @override
  State<NuevoAlmuerzoPage> createState() => _NuevoAlmuerzoPageState();
}

class _NuevoAlmuerzoPageState extends State<NuevoAlmuerzoPage> {
  TextEditingController codigoCtrl = TextEditingController();
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController precioCtrl = TextEditingController();
  DateTime fechaHora = DateTime.now();
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
        title: Text('Nuevo Almuerzo',
            style: TextStyle(color: const Color.fromARGB(255, 7, 7, 7))),
      ),
      body: Container(
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
            borderRadius: BorderRadius.circular(8.0),
            color: Color.fromRGBO(160, 213, 244, 1)),
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: TextFormField(
                    controller: nombreCtrl,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      prefixIcon: Icon(Icons.person),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Campo nombre requerido";
                      }
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: TextFormField(
                    controller: precioCtrl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Precio',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Campo Precio requerido";
                      }
                    },
                  ),
                ),
                SizedBox(height: 16.0),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: TextFormField(
                    controller: codigoCtrl,
                    decoration: InputDecoration(
                      labelText: 'codigo',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Campo codigo requerido";
                      }
                    },
                  ),
                ),
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
                        print('ya tiene ese ingrediente');
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
                    child: Text('Crear Nuevo Almuerzo',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        print('Todo bien');

                        FirestoreService().almuerzoAgregar(
                          codigoCtrl.text.trim(),
                          IngredientesSeleccionados,
                          nombreCtrl.text.trim(),
                          precioCtrl.text.trim(),
                        );
                        Navigator.pop(context);
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
