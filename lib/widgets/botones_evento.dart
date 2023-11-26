import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/pages/Clients/EventosPage/nuevo_evento_page.dart';
import 'package:flutter_certamen_aplicacion/pages/Clients/EventosPage/usuarios_eventos.dart';

BotonesEvento(context, usuario){


  return Container(
  color: Colors.blue[700],
  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
  child: Row(
    children: [
      Expanded(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UsuarioEventosPage(usuario: usuario)),
            );
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mis Eventos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      'Publicados',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                IconButton(
                  onPressed: () {
                    
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Expanded(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NuevoEventoPage(usuario: usuario)),
            );
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Publicar ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      'Evento',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 18.0),
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24.0,
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
);
}