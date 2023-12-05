import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/services/firestore_service.dart';


class AgregarRutPage extends StatefulWidget {
  final User usuario;

  AgregarRutPage({required this.usuario});

  @override
  _AgregarRutPageState createState() => _AgregarRutPageState();
}

class _AgregarRutPageState extends State<AgregarRutPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _rutController;

  @override
  void initState() {
    super.initState();
    _rutController = TextEditingController();
  }

  @override
  void dispose() {
    _rutController.dispose();
    super.dispose();
  }

 String? _validarRut(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa el Rut';
    }

    // Validación básica del formato de Rut (puedes modificarlo según el formato esperado)
    final RegExp regex = RegExp(r'^\d{1,8}-[\dkK]$');
    if (!regex.hasMatch(value)) {
      return 'Formato de Rut inválido';
    }

    // Validación del dígito verificador (opcional dependiendo del país)
    if (!validarDigitoVerificador(value)) {
      return 'Rut inválido';
    }
   

    return null;
  }

   bool validarDigitoVerificador(String rutCompleto) {
    // Limpieza del Rut para quedarse solo con los números y el dígito verificador
    final rutLimpio = rutCompleto.replaceAll(RegExp(r'[.-]'), '');
    final rutNumerico = int.parse(rutLimpio.substring(0, rutLimpio.length - 1));
    final digitoVerificador = rutLimpio[rutLimpio.length - 1].toUpperCase();

    // Cálculo del dígito verificador
    int suma = 0;
    int multiplicador = 2;
    for (int i = rutNumerico; i > 0; i ~/= 10) {
      suma += (i % 10) * multiplicador;
      multiplicador = multiplicador < 7 ? multiplicador + 1 : 2;
    }

    final int resto = suma % 11;
    final String digitoCalculado = (11 - resto).toString();

    // Verificación del dígito verificador
    return (digitoVerificador == 'K' && digitoCalculado == '10') ||
        (digitoVerificador == '0' && digitoCalculado == '11') ||
        (digitoVerificador == digitoCalculado);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Rut'),
      ),
     body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text('Formato: '),
                    Text('00000000-0'),
                  ],
                ),
                TextFormField(
                  controller: _rutController,
                  decoration: InputDecoration(
                    labelText: 'Rut',
                    hintText: 'Ingrese su Rut',
                  ),
                  validator: _validarRut,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String rutIngresado = _rutController.text;
                      print('Rut ingresado: $rutIngresado');

                      FirestoreService().AgregarRut(

                        rutIngresado,     
                        widget.usuario.uid,
                      );
                    Navigator.pop(context);

                    }
                  },
                  child: Text('Guardar Rut'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}