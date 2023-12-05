import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_certamen_aplicacion/pages/Admin/InsumosPage/administrar_insumos.dart';
import 'package:flutter_certamen_aplicacion/pages/Admin/AlmuerzosPage/administrar_almuerzos.dart';
import 'package:flutter_certamen_aplicacion/pages/Admin/AlmuerzosSemanalesPage/administrar_AlmSem.dart';
import 'package:flutter_certamen_aplicacion/pages/Admin/lista_pedidos_admin_page.dart';
import 'package:flutter_certamen_aplicacion/pages/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';


class HomeAdminPage extends StatefulWidget {
  final User? usuario;

  const HomeAdminPage({required this.usuario});

  @override
  _HomeAdminPageState createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  int _selectedIndex = 0;
  static const List<IconData> _selectedIcons = [
    Icons.restaurant,
    Icons.fastfood,
    Icons.menu,
    Icons.access_alarm,
  ];
  static const List<IconData> _unselectedIcons = [
    Icons.restaurant_outlined,
    Icons.fastfood_outlined,
    Icons.menu_outlined,
    Icons.access_alarm_outlined,
  ];

  final List<Widget> _widgetOptions = [
    ListaAlmuerzoPage(),
    ListaInsumoPage(),
    AlmuerzosSemanalesPage(),
    ListaPedidosAdminPage(),
  ];

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
        title: Text('Sector de Administración'),
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
                            widget.usuario!.displayName
                                    ?.substring(0, 1)
                                    .toUpperCase() ??
                                '',
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
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Nuevo Almuerzo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Nuevo Insumo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu Semanal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm),
            label: 'Pedidos',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Color para el ícono seleccionado
        unselectedItemColor: Colors.black, // Color para el ícono no seleccionado
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
                        widget.usuario!.displayName
                                ?.substring(0, 1)
                                .toUpperCase() ??
                            '',
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
