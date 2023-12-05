import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/services/firestore_service.dart';

class EditarEstudiantePage extends StatefulWidget {
  final User usuario;
  final QueryDocumentSnapshot<Object?> estudiante;

  const EditarEstudiantePage({
    Key? key,
    required this.usuario,
    required this.estudiante,
  
  }) : super(key: key);

  @override
  State<EditarEstudiantePage> createState() => _EditarEstudiantePageState();
}

class _EditarEstudiantePageState extends State<EditarEstudiantePage> {
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController apellidoCtrl = TextEditingController();
  TextEditingController disgustosCtrl = TextEditingController();
  DateTime fechaHora = DateTime.now();

  String selectedCurso = '1° Basico';
  List<String> curso = ['1° Basico', '2° Basico', '3° Basico', '4° Basico', '5° Basico', '6° Basico', '7° Basico',
  '8° Basico', '1° Medio', '2° Medio', '3° Medio', '4° Medio'];
  
 
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> listaErrores = [];
 
  
  @override

  void initState() {
    super.initState();
    
    
    selectedCurso = widget.estudiante['curso'] ?? '1° Basico';
    nombreCtrl.text = widget.estudiante['nombre'] ?? '';
    
    disgustosCtrl.text = widget.estudiante['disgustos'] ?? '';
  
  
  }





  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Nuevo Estudiante', style: TextStyle(color: const Color.fromARGB(255, 7, 7, 7))),
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

                labelText: 'Nombre Completo',
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
          controller: disgustosCtrl,
          decoration: InputDecoration(
            labelText: 'Disgustos',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          keyboardType: TextInputType.text,
          validator: (String? value) {
          if (value == null || value.isEmpty){
            return "Campo Disgusto requerido";
          }
        },
      ),
    ),
      

 
    Padding(
      padding: const EdgeInsets.only(top: 18.0 , bottom: 10),
        child: DropdownButtonFormField<String>(
        value: selectedCurso,
        items: curso.map((String tipo) {
          return DropdownMenuItem<String>(
            value: tipo,
            child: Text(tipo),
          );
        }).toList(),
        onChanged: (value) {
        setState(() {
          selectedCurso = value!;
        });
      },
      decoration: InputDecoration(
      labelText: 'Curso del Alumno',
      border: OutlineInputBorder(),
        ),              
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
    child: Text('Crear Nuevo Evento', style: TextStyle(color: Colors.white)),
      onPressed: () async {                
        
        if (formKey.currentState!.validate()) 
        {
            print('Todo bien');
            
                             
            FirestoreService().EstudianteEditar(
              widget.estudiante.id,
                {
                  'nombre': nombreCtrl.text.trim(),
                  'curso': selectedCurso.trim(),
                  'disgustos': disgustosCtrl.text.trim(),                      
                },
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
