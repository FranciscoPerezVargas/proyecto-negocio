import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../login_page.dart'; 
import '../Clients/EventosPage/eventos_page.dart';



class HomeAdminPage extends StatefulWidget {
  final User? usuario;

  const HomeAdminPage({required this.usuario});

  @override
  _HomeAdminPageState createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  bool _showEventos = true;

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('ADMIN de Eventos Publicos'),
        backgroundColor: const Color.fromARGB(255, 91, 150, 199),
        leading: Builder(
          builder: (BuildContext context) {
            return widget.usuario != null
              ? GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          widget.usuario!.displayName?.substring(0, 1).toUpperCase() ?? '',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox();
          },
        ),
        
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 90.0),
        child: _showEventos ? EventosPage(usuario: widget.usuario) : null,
      ),
      drawer: widget.usuario != null
    ? Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.usuario!.displayName ?? ''),
              accountEmail: Text(widget.usuario!.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 60,
                child: Text(
                  widget.usuario!.displayName?.substring(0, 1).toUpperCase() ?? '',
                  style: TextStyle(fontSize: 36),
                ),
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 28, 97, 154),
              ),
            ),
            ListTile(
              title: Text('Cerrar sesión'),
              onTap: () async {
                await _cerrarSesion(context); 
              },
            ),
          ],
        ),
      )
    : null,
    );
  }
}
