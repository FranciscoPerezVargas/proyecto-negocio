import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../login_page.dart'; 



class ListaPedidosAdminPage extends StatefulWidget {
 

  const ListaPedidosAdminPage();

  @override
  _ListaPedidosAdminPageState createState() => _ListaPedidosAdminPageState();
}

class _ListaPedidosAdminPageState extends State<ListaPedidosAdminPage> {
 
  late List<QueryDocumentSnapshot> _pedidosList = []; // Cambiar el tipo de la lista

  @override
  void initState() {
    super.initState();
    _fetchPedidos();
  }
Future<void> _fetchPedidos() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('pedidos').get();

    setState(() {
      _pedidosList = snapshot.docs
          .where((doc) {
            Map<String, dynamic> pedido = doc.data() as Map<String, dynamic>;
            if (pedido['listaFechas'] != null) {
              List<DateTime> listaFechas = (pedido['listaFechas'] as List)
                  .map((fecha) => (fecha as Timestamp).toDate())
                  .toList();
              DateTime now = DateTime.now();
              DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
              return listaFechas.any((fecha) => fecha.year == yesterday.year && fecha.month == yesterday.month && fecha.day == yesterday.day);
            }
            return false;
          })
          .toList();
    });

    QuerySnapshot snapshotTipoPedido = await FirebaseFirestore.instance
        .collection('pedidos')
        .where('tipo', isEqualTo: 'Pedido Diario')
        .get();

    setState(() {
      _pedidosList.addAll(snapshotTipoPedido.docs);
    });
  } catch (error) {
    print('Error al obtener los pedidos: $error');
  }
} 

  @override
   Widget build(BuildContext context) {
    final FirebaseAuth _authFire = FirebaseAuth.instance;
    final GoogleSignIn _googleSesion = GoogleSignIn();

   Future<void> _cerrarSesion(BuildContext context) async {
      await _authFire.signOut(); 
      await _googleSesion.signOut();
      Navigator.of(context).pushAndRemoveUntil( 
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    } 
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pedidos'),
        
      ),
      body: _pedidosList.isNotEmpty
  ? ListView.builder(
      itemCount: _pedidosList.length,
      itemBuilder: (context, index) {
        QueryDocumentSnapshot<Object?> pedido = _pedidosList[index];

        // Obtener el ID del usuario del pedido
        String usuarioId = pedido['usuario'];

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('usuarios').doc(usuarioId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtiene la información del usuario
            } else if (snapshot.hasError || !snapshot.hasData) {
              return ListTile(
                title: Text('Pedido ${pedido['tipo']}'),
                subtitle: Text('Estudiante: ${pedido['idEstudiante']}'),
                // Agrega más detalles del pedido según sea necesario
              );
            } else {
              // Se obtuvo la información del usuario
              String rutUsuario = snapshot.data!['rut'];

              return ListTile(
                title: Text('Pedido ${pedido['tipo']}'),
                subtitle: Text('rut: $rutUsuario'),
                // Agrega más detalles del pedido según sea necesario
              );
            }
          },
        );
      },
    )
  : Center(
      child: Text('No hay pedidos disponibles'),
    ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        
          _imprimirBoletaUsuario();
        },
        child: Icon(Icons.check),
      ),
    );
  }
  void _imprimirBoletaUsuario() async {
  try {
    if (_pedidosList.isNotEmpty) {
      for (var doc in _pedidosList) {
        String pedidoId = doc.id; // ID del documento del pedido
        print('Código del documento del pedido: $pedidoId');

        String usuarioId = doc['usuario']; // ID del usuario asociado al pedido
        print('Usuario: $usuarioId');

        // Buscar documentos de usuarios que tengan el campo 'usuario' igual a usuarioId
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('usuarios').where('usuario', isEqualTo: usuarioId).get();

        if (userSnapshot.docs.isNotEmpty) {
          String rutUsuario = userSnapshot.docs.first['rut']; // Obtener el campo 'rut' del primer usuario encontrado
          print('RUT del usuario asociado al pedido: $rutUsuario');

          QuerySnapshot deudaSnapshot = await FirebaseFirestore.instance.collection('deudas').where('rut', isEqualTo: rutUsuario).get();

          if (deudaSnapshot.docs.isNotEmpty) {
            // Ya existe una deuda para este usuario
            DocumentSnapshot deudaDoc = deudaSnapshot.docs.first;
            List<String> codigosPedidos = List<String>.from(deudaDoc['codigosPedidos']);
            List<Timestamp> listaFechas = List<Timestamp>.from(deudaDoc['listaFechas']);
            int deudaTotal = deudaDoc['deudaTotal'] ?? 0;


            // Agregar nuevos datos a codigosPedidos y listaFechas
            codigosPedidos.add(pedidoId);
            listaFechas.add(Timestamp.now());

            // Actualizar la deuda existente con los nuevos datos
            await FirebaseFirestore.instance.collection('deudas').doc(deudaDoc.id).update({
              'codigosPedidos': codigosPedidos,
              'listaFechas': listaFechas,
              'deudaTotal': deudaTotal + 3500,
              // Actualizar 'deudaTotal' si es necesario
            });
          } else {
            // No existe una deuda para este usuario, crear una nueva
            List<String> nuevoCodigosPedidos = [pedidoId]; // ID del documento del pedido
            List<Timestamp> nuevaListaFechas = [Timestamp.now()];

            await FirebaseFirestore.instance.collection('deudas').add({
              'rut': rutUsuario,
              'codigosPedidos': nuevoCodigosPedidos,
              'listaFechas': nuevaListaFechas,
              'deudaTotal': 3500, // Puedes inicializar 'deudaTotal' con el valor adecuado
            });
          }
        } else {
          print('No se encontró el usuario con ID $usuarioId en Firestore');
        }
      }
    } else {
      print('No hay pedidos disponibles');
    }
  } catch (error) {
    print('Error al manejar la deuda: $error');
  }
}

}


