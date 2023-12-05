import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_certamen_aplicacion/pages/Clients/TabPage/PedidosPage/nuevo_pedido_page.dart';

Widget BotonPedido(BuildContext context, User usuario) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NuevoPedidoPage(usuario: usuario),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 228, 193, 18),
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        'Hacer Nuevo Pedido',
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    ),
  );
}
