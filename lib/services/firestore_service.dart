import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService {

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

  //LISTA EVENTOS
  Stream<QuerySnapshot> getEventos() 
  {
     return FirebaseFirestore.instance.collection('eventos').snapshots();
  }

  //Lista de eventos por likes
  Stream<QuerySnapshot> getEventosLikes() 
  {
     return FirebaseFirestore.
     instance.collection('eventos').orderBy('likes', descending: true).snapshots();
  }

  //  Lista de eventos por nombre
  Stream<QuerySnapshot> getEventosNombre() 
  {
     return FirebaseFirestore.
     instance.collection('eventos').orderBy('nombre').snapshots();
  }

  //Listar eventos por fecha donde (where) la fecha actual sea menor a la fecha de hoy
  Stream<QuerySnapshot> getEventosFechaAntes(DateTime fechaActual) 
  {
     return FirebaseFirestore.
     instance.collection('eventos').orderBy('fechaHora').where('fechaHora', isLessThanOrEqualTo: fechaActual).snapshots();
  }

  //Listar eventos por fecha donde (where) la fecha actual sea mayor a la fecha de hoy
  Stream<QuerySnapshot> getEventosFechaDespues(DateTime fechaActual) 
  {
     return FirebaseFirestore.
     instance.collection('eventos').orderBy('fechaHora').where('fechaHora', isGreaterThan: fechaActual).snapshots();
  }



  /////LISTAR POR USUARIO (para el editar evento +)
  Stream<QuerySnapshot> getEventosUsuario(String usuarioId) 
  {
     return FirebaseFirestore.
     instance.collection('eventos').where('usuario', isEqualTo: usuarioId).snapshots();
  }

  Future<QuerySnapshot> getEstudiantes(String usuarioId) 
  {
     return FirebaseFirestore.
     instance.collection('estudiantes').where('usuario', isEqualTo: usuarioId).get();
  }



    /////////NUEVO EVENTO
    Future<void> eventoAgregar(String nombre, String descripcion, String lugar, String tipo, DateTime fechaHora, String imagenURL, String usuarioId) async {
      return FirebaseFirestore.instance.collection('eventos').doc().set({
        'nombre': nombre,
        'descripcion': descripcion,
        'fechaHora': fechaHora,
        'imagenURL': imagenURL,
        'lugar': lugar,
        'tipo': tipo,
        'likes': 0,
        'usuario': usuarioId,
      });
    }


     Future<void> EstudianteAgregar(String nombre, String disgustos, String curso, String usuarioId) async {
      return FirebaseFirestore.instance.collection('estudiantes').doc().set({
        'nombre': nombre,
        'disgustos': disgustos,
        'curso': curso,
        'usuario': usuarioId,
      });
    }

    //borrar evento
    Future<void> borrarEvento(String eventoId) async
    {
      return FirebaseFirestore.instance.collection('eventos').doc(eventoId).delete();
    }


  /////ACTUALIZAR LIKES
    Future<void> actualizarLikes(String eventoId, int nuevoValor) async {
  await FirebaseFirestore.instance
      .collection('eventos')
      .doc(eventoId)
      .update({'likes': nuevoValor});
}

final CollectionReference eventosCollection = FirebaseFirestore.instance.collection('eventos');


//Actualizar eventos
Future<void> cambiarEvento(String eventoId, Map<String, dynamic> data) async {
    await eventosCollection.doc(eventoId).update(data);
  }

  //Actualizar evento y imagen
Future<void> cambiarEventoImagen(String eventoId, Map<String, dynamic> data) async {
    await eventosCollection.doc(eventoId).update(data);
  }

}