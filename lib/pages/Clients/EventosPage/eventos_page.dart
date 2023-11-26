
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/pages/Clients/EventosPage/detalles_eventos_page.dart';
import 'package:flutter_certamen_aplicacion/services/firestore_service.dart';
import 'package:flutter_certamen_aplicacion/widgets/botones_evento.dart';


class EventosPage extends StatefulWidget {
  final User? usuario;

  const EventosPage({Key? key, required this.usuario}) : super(key: key);

  @override
  _EventosPageState createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  String? dropdownValue;
  String? filtro = '1';
  Set<String> likedEvents = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
                gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [const Color.fromARGB(255, 144, 200, 247), 
                        const Color.fromARGB(255, 252, 201, 123)], 
                        stops: [0.3, 0.9], 
                      ),
              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            // Editar y Nuevo Evento (Esta en la carpeta widgets)
            widget.usuario != null ? BotonesEvento(context, widget.usuario!) : SizedBox(),
      
           
           
           Divider(color: Colors.black,),
           Expanded(
        child: StreamBuilder(
          stream: obtenerGetPorFiltro(filtro, DateTime.now()),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        DateTime now = DateTime.now();
        if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("Esperando que se suban datos....."));
        } else {
          return ListView.separated(
            physics: BouncingScrollPhysics(),
            separatorBuilder: (context, index) => Divider(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var evento = snapshot.data!.docs[index];
      
              // Obtener la fecha y hora
              Timestamp fechaHora = evento['fechaHora'] as Timestamp;
              DateTime dateTime = fechaHora.toDate();
      
              // Obtener los colores de la fecha
              Color textColor = Color.fromARGB(255, 255, 255, 255);
              if (dateTime.isBefore(now)) {
                textColor = Color.fromARGB(255, 241, 85, 28);
              } else if (dateTime.difference(now).inDays <= 3) {
                textColor = Colors.yellow;
              }
      
              return SizedBox(
                height: 200,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 45, 107, 199),
                      border: Border.all(color: textColor)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center, 
                        children: [
                          SizedBox(
                            height: 55,
                            child: Container(
                              
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      '${evento['nombre']}',
                                      style: TextStyle(fontSize: 20.0, color: textColor),
                                      
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetallesEventoPage(evento: evento),
                                ),
                              );
                            },
                            child: Text('Detalles del Evento'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[200], 
                              foregroundColor: Color.fromARGB(181, 18, 19, 19)
                            ),
      
                          ),
                          SizedBox(height: 10), 
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: textColor),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fecha y Hora:',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: textColor
                                  ),
                                ),
                                SizedBox(height: 3.0),
                                Text(
                                  '${dateTime.toString()}',
                                  style: TextStyle(fontSize: 14.0, color: textColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, 
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                  //Si ya esta con el like no olvidar
                                  bool alreadyLiked = likedEvents.contains(evento.id);
                                  if (alreadyLiked) {
                                    likedEvents.remove(evento.id);
                                    evento.reference.update({'likes': evento['likes'] - 1});
                                  } else {
                                    likedEvents.add(evento.id);
                                    evento.reference.update({'likes': evento['likes'] + 1});
                                  }
                               
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.thumb_up,
                                    size: 30.0,
                                    color: likedEvents.contains(evento.id)
                                        ? const Color.fromARGB(255, 241, 162, 42)
                                        : Color.fromARGB(255, 239, 237, 237),
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    '${evento['likes']}',
                                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        },
      ),
    )
    ],
  ),),
  );
}

  Stream<QuerySnapshot>? obtenerGetPorFiltro(filtro, now) {
    switch (filtro) {
      case '1':
        return FirestoreService().getEventos();
      case '2':
        return FirestoreService().getEventosNombre();
      case '3':
        return FirestoreService().getEventosLikes();
      case '4':
        return FirestoreService().getEventosFechaAntes(now);
      case '5':
        return FirestoreService().getEventosFechaDespues(now);
    }
  }
}




