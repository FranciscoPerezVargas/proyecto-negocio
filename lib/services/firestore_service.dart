import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService {
  final CollectionReference estudiantesCollection = FirebaseFirestore.instance.collection('estudiantes');

  //Pedir USUARIO DE GOOGLE QUE ESTA EN FIRESTORE
  Future<DocumentSnapshot<Map<String, dynamic>>?> getUsuario(String usuarioId) async {
  var userDoc = await FirebaseFirestore.instance.collection('usuarios').doc(usuarioId).get();
  if (userDoc.exists) {
    return userDoc; 
  }
   else {
    print('Error: no se encontró el usuario con ID $usuarioId');
    return null; 
  }
 
}


     Future<void> EstudianteAgregar(String nombre, String disgustos, String curso, String usuarioId) async {
      return FirebaseFirestore.instance.collection('estudiantes').doc().set({
        'nombre': nombre,
        'disgustos': disgustos,
        'curso': curso,
        'usuario': usuarioId,
      });
    }


Future<QuerySnapshot> getEstudiantes(String usuarioId) 
  {
     return FirebaseFirestore.
     instance.collection('estudiantes').where('usuario', isEqualTo: usuarioId).get();
  }
  

Future<void> EstudianteEditar(String estudianteId, Map<String, dynamic> data) async {
    await estudiantesCollection.doc(estudianteId).update(data);
  }



    Future<void> borrarEstudiante(String estudianteId) async
    {
      return estudiantesCollection.doc(estudianteId).delete();
    }


Future<QuerySnapshot> getPedidosActuales(List<String>idEstudiante, DateTime fechaActual) {
  return FirebaseFirestore.instance.collection('pedidos').orderBy('fecha')
      .where('idEstudiante', isEqualTo: idEstudiante)
      .where('fecha', isGreaterThan: fechaActual)
      .get();
}

Future<QuerySnapshot> getPedidosDiarios(List<String>idEstudiante) {
  return FirebaseFirestore.instance.collection('pedidos').orderBy('fecha')
      .where('idEstudiante', isEqualTo: idEstudiante)
      .where('tipo', isEqualTo: 'Pedido Diario')
      .get();
}



///RUT

Future<void> AgregarRut(String rut, String usuarioId) async {
      return FirebaseFirestore.instance.collection('usuarios').doc().set({
        'rut': rut,
        'usuario': usuarioId,
        
      });
    }
Future<QuerySnapshot> GetRut(String usuarioId) {
  return FirebaseFirestore.instance.collection('usuarios')
      .where('usuario', isEqualTo: usuarioId)
      .get();
}



Future<QuerySnapshot> obtenerPedidosPorEstudiante(String? idEstudiante, String usuario) async {
  print('id');
  print(idEstudiante);
    try {
      QuerySnapshot pedidosSnapshot = await FirebaseFirestore.instance
          .collection('pedidos')
          .where('idEstudiante', isEqualTo: idEstudiante)
          .where('usuario', isEqualTo: usuario)
          .get();
      return pedidosSnapshot;
    } 
    
    
    catch (error) {
      print('Error al obtener los pedidos del estudiante: $error');
      throw error;
    }
  }
  Future<QuerySnapshot> getPedidosTotalesUsuario(String usuario) async {
 
    try {
      QuerySnapshot pedidosSnapshot = await FirebaseFirestore.instance
          .collection('pedidos')
          .where('usuario', isEqualTo: usuario)
          .get();
      return pedidosSnapshot;
    } 
    
    
    catch (error) {
      print('Error al obtener los pedidos del estudiante: $error');
      throw error;
    }
  }


Future<List<String>> obtenerListaEstudiantes(String usuario) async {
    List<String> listaEstudiantes = []; 
    try {
      QuerySnapshot estudiantesSnapshot = await FirebaseFirestore.instance
          .collection('estudiantes')
          .where('usuario', isEqualTo: usuario)
          .get();

      listaEstudiantes = estudiantesSnapshot.docs
          .map((doc) => doc.id) 
          .toList();
    } catch (error) {
      print('Error al obtener los estudiantes: $error');
    }
    return listaEstudiantes;
  }





  Future<QuerySnapshot> getInsumo() {
    return FirebaseFirestore.instance
        .collection('insumos')
        .orderBy('nombre')
        .get();
  }

  Future<List<String>> getNombresInsumo() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('insumos').get();
    List<String> NombresInsumos = [];

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      String nombre = documentSnapshot.get('nombre');
      NombresInsumos.add(nombre);
    }

    return NombresInsumos;
  }

  Future<List<String>> getCodigosAlmuerzos() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('almuerzos').get();
    List<String> CodigosAlmuerzos = [];

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      String codigo = documentSnapshot.get('codigo');
      CodigosAlmuerzos.add(codigo);
    }

    return CodigosAlmuerzos;
  }

  Future<QuerySnapshot> getAlmuerzosSemanales() async {
    return FirebaseFirestore.instance.collection('almuerzosSemanales').get();
  }


  Future<void> insumoAgregar(String nombre, String precio, int stock) async {
    return FirebaseFirestore.instance
        .collection('insumos')
        .doc()
        .set({'nombre': nombre, 'precio': precio, 'stock': stock});
  }

  Future<void> editaAlmuerzoSemanal(List<String> lunes, List<String> martes,
      List<String> miercoles, List<String> jueves) {
    String TablaId = '8mz5tvtm31fVMPUYhFyw';
    return FirebaseFirestore.instance
        .collection('almuerzosSemanales')
        .doc(TablaId)
        .update({
      'lunes': lunes,
      'martes': martes,
      'miercoles': miercoles,
      'jueves': jueves,
    });
  }

  Future<void> almuerzoAgregar(
      String codigo, List<String> codigoInsumos, String nombre, String precio) {
    if (codigoInsumos == null) {
      codigoInsumos = [];
    }
    return FirebaseFirestore.instance.collection('almuerzos').doc().set({
      'codigo': codigo,
      'codigoInsumos': codigoInsumos,
      'nombre': nombre,
      'precio': precio
    });
  }



  Future<void> AlmuerzoSemanalAgregar(List<String> lunes, List<String> martes,
      List<String> miercoles, List<String> jueves) {
    return FirebaseFirestore.instance.collection('estudiantes').doc().set({
      'lunes': lunes,
      'martes': martes,
      'miercoles': miercoles,
      'jueves': jueves,
    });
  }

  //borrar evento
}