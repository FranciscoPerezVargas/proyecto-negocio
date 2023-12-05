import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/services/firestore_service.dart';
import 'dart:io';

class NuevoInsumoPage extends StatefulWidget {
  const NuevoInsumoPage({Key? key}) : super(key: key);
  @override
  State<NuevoInsumoPage> createState() => _NuevoInsumoPageState();
}

class _NuevoInsumoPageState extends State<NuevoInsumoPage> {
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController precioCtrl = TextEditingController();
  TextEditingController stockCtrl = TextEditingController();
  DateTime fechaHora = DateTime.now();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> listaErrores = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Nuevo Insumo',
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
                    controller: stockCtrl,
                    decoration: InputDecoration(
                      labelText: 'Stock',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Campo Stock requerido";
                      }
                    },
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
                    child: Text('Crear Nuevo Insumo',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        print('Todo bien');
                        int stockTotal = int.parse(stockCtrl.text.trim());
                        FirestoreService().insumoAgregar(
                          nombreCtrl.text.trim(),
                          precioCtrl.text.trim(),
                          stockTotal,
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
