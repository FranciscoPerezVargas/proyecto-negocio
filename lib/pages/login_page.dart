import 'package:flutter/material.dart';
import 'package:flutter_certamen_aplicacion/pages/Admin/home_admin_page.dart';
import 'package:flutter_certamen_aplicacion/pages/Clients/home_page.dart';
import 'package:flutter_certamen_aplicacion/services/login_google.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  final LoginGoogle loginGoogle = LoginGoogle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 50, 128, 192),
        title: Text(
          'Colaciones Himena',
          style: TextStyle(
            color: Colors.cyan[100],
           
            fontSize: 24.0,
          ),
        ),
        centerTitle: true, 
      ),
      
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/aire.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                 
                
                SizedBox(
                  height: 300,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '¡Crea contenido en nuestra aplicación de eventos!',
                                    style: TextStyle(fontSize: 20.0),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'También puedes publicar eventos interesantes para todos.',
                                    style: TextStyle(fontSize: 16.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                  try {
                                    final User? usuario = await loginGoogle.googleLogin();
                                    if (usuario != null) {
          
                                    String email = usuario.email ?? '';
                                    if (email == 'rovox123@gmail.com') {
                                      print('Bienvenido, eres ADMIN');
                                      
                                       Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => HomeAdminPage(usuario: usuario),
                                        ),
                                      );
                                    } else {
                                      
                                      print('Bienvenido, eres cliente');
                                       Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => HomePage(usuario: usuario),
                                        ),
                                      );
                                    }
                                  }
                                    
                                  } catch (e) {
                                    
                                    print('Error al iniciar sesión: $e');
                                    
                                  }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 221, 232, 242), 
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0), 
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                                child: Text(
                                  'Comenzar a pedir',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  )
                ]
              )
            )
          ]
        )
        
    );
  }
}
