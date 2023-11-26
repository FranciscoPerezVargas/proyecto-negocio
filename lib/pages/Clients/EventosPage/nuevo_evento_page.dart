//Los like son colocados automaitamente en 0
  //recordar en editar eventos pasar el numero de likes 



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/services/firestorage_service.dart';
import 'package:flutter_certamen_aplicacion/services/firestore_service.dart';
import 'dart:io';

class NuevoEventoPage extends StatefulWidget {
  final User usuario;

  const NuevoEventoPage({Key? key, required this.usuario}) : super(key: key);
  @override
  State<NuevoEventoPage> createState() => _NuevoEventoPageState();
}

class _NuevoEventoPageState extends State<NuevoEventoPage> {
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController lugarCtrl = TextEditingController();
  TextEditingController descripcionCtrl = TextEditingController();
  DateTime fechaHora = DateTime.now();

  String selectedTipo = 'Fiesta';
  List<String> tipos = ['Fiesta', 'Evento deportivo', 'Concierto'];
  File? imagenSubir;
  String url = ''; 
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> listaErrores = [];
  Color error = Color.fromARGB(255, 173, 24, 14);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Crear Evento', style: TextStyle(color: const Color.fromARGB(255, 7, 7, 7))),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
          borderRadius: BorderRadius.circular(8.0),
          color: Color.fromRGBO(160, 213, 244, 1)
                        
        ),
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
                if (value == null || value.isEmpty){
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
          controller: descripcionCtrl,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Descripción',
            border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            validator: (String? value) {
            if (value == null || value.isEmpty){
              return "Campo descripción requerido";
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
          controller: lugarCtrl,
          decoration: InputDecoration(
            labelText: 'Lugar',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          keyboardType: TextInputType.text,
          validator: (String? value) {
          if (value == null || value.isEmpty){
            return "Campo lugar requerido";
          }
        },
      ),
    ),
      
    // Tipo de Evento (ComboBox)
    Padding(
      padding: const EdgeInsets.only(top: 18.0 , bottom: 10),
        child: DropdownButtonFormField<String>(
        value: selectedTipo,
        items: tipos.map((String tipo) {
          return DropdownMenuItem<String>(
            value: tipo,
            child: Text(tipo),
          );
        }).toList(),
        onChanged: (value) {
        setState(() {
          selectedTipo = value!;
        });
      },
      decoration: InputDecoration(
      labelText: 'Tipo de Evento',
      border: OutlineInputBorder(),
        ),              
      ),
    ),     
    // fecha y hora
    ElevatedButton(
      onPressed: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            fechaHora = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
          });
        }
      }
    },
    style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10), 
    ),
      backgroundColor: Color.fromARGB(255, 73, 120, 159), 
      foregroundColor: Colors.black, 
    ),
      child: Text('Seleccionar fecha y hora',
        style: TextStyle(fontSize: 18), ),
    ),
      // Texto fecha y hora
    Text(
      'Fecha y Hora: ${fechaHora.toString()}',
        style: TextStyle(fontSize: 16),
      ),

    // Imagen
    Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
      onPressed: () async {
      
        final imagen = await FireStorageService().getImagen(); 
        imagen != null ?
        setState(() {
          imagenSubir = File(imagen.path);                      
        })
        : imagenSubir = null;
      },
      style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), 
      ),
      backgroundColor: const Color.fromARGB(255, 41, 113, 172), 
      foregroundColor: Colors.black, 
      ),
      child: Text(
        'Seleccionar imagen',
        style: TextStyle(fontSize: 18), 
      ),
    ),
  ),
  // Mostrar imagen 
  Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    child: imagenSubir != null
      ? Image.file(
      File(imagenSubir!.path), 
      fit: BoxFit.cover,
      width: 100,
      height: 400,
      ): Text('No se ha seleccionado ninguna imagen', style: TextStyle(color: error),),
  ),
 // BOTON Nuevo Evento
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
    child: Text('Crear Nuevo Evento', style: TextStyle(color: Colors.white)),
      onPressed: () async {                
        
        if (formKey.currentState!.validate() && imagenSubir != null) 
        {
            print('Todo bien');
          
            // Subir la imagen
            url = await FireStorageService().subirImagen(imagenSubir!);                 
            FirestoreService().eventoAgregar(
              nombreCtrl.text.trim(),
              descripcionCtrl.text.trim(),
              lugarCtrl.text.trim(),
              selectedTipo,
              fechaHora,
              url,
              widget.usuario.uid,
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

