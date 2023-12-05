
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/pages/Clients/TabPage/PedidosPage/detalles_pedidos_page.dart';

import 'package:flutter_certamen_aplicacion/services/firestore_service.dart';
import 'package:flutter_certamen_aplicacion/widgets/botones_pedido.dart';


class PedidosPage extends StatefulWidget {
  final User usuario;

  const PedidosPage({Key? key, required this.usuario}) : super(key: key);

  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  String? dropdownValue;
  List<String> estudiantes = []; 
  String? idEstudianteSeleccionado; 
  bool botonHabilitado = false;

  

  @override
  void initState() {
    super.initState();
    verificarRutUsuario();
   /* FirestoreService().obtenerListaEstudiantes(widget.usuario.uid).then((lista) {
      setState(() {
        estudiantes = lista; 
        dropdownValue = estudiantes.isNotEmpty ? estudiantes[0] : null; // Establece el valor inicial del DropdownButton
      });
    });*/


  }

/////OBTENER RUT
  Future<void> verificarRutUsuario() async {
  QuerySnapshot usuarioFire = await FirestoreService().GetRut(widget.usuario.uid);

  if (usuarioFire.docs.isNotEmpty) {
    print('entro en el primer if');
    final usuarioData = usuarioFire.docs.first.data() as Map<String, dynamic>;

    if (usuarioData != null && usuarioData['rut'] != null && usuarioData['rut'] != '') {
      setState(() {
        botonHabilitado = true;
      });
    } else {
      print('entro en el primer else');
      setState(() {
        botonHabilitado = false;
      });
    }
  } else {
    setState(() {
      botonHabilitado = false;
    });
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80,),
            



            botonHabilitado
          ? BotonPedido(context, widget.usuario) // Botón habilitado
          : Text('No puedes realizar pedidos sin un Rut registrado, dirigete a Perfil'),

            Divider(color: Colors.black),
            Expanded(
              child: FutureBuilder(
                future: FirestoreService().getEstudiantes(widget.usuario.uid),
                //future: FirestoreService().obtenerPedidosPorEstudiante(idEstudianteSeleccionado, widget.usuario.uid),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text("Esperando que se suban datos..."));
                  } else {
                    return ListView.separated(
          physics: BouncingScrollPhysics(),
          separatorBuilder: (context, index) => Divider(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var estudiante = snapshot.data!.docs[index];
            Color textColor = Colors.red;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Pedidos de ${estudiante['nombre']}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: textColor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetallesPedidosPage(idEstudiante: estudiante.id, usuario: widget.usuario.uid),
                              ),
                            );
                          },
                          child: Text('Detalles de Pedidos'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    },
  ),
),
          ],
        ),
      ),
    );
  }
}




