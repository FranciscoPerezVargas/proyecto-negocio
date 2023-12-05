import 'package:flutter/material.dart';

import 'package:flutter_certamen_aplicacion/services/firestore_service.dart';

class EditarAlmuerzosSemanalesPage extends StatefulWidget {
  @override
  _EditarAlmuerzosSemanalesPageState createState() =>
      _EditarAlmuerzosSemanalesPageState();
}

class _EditarAlmuerzosSemanalesPageState
    extends State<EditarAlmuerzosSemanalesPage> {
  List<String> almuerzoLunes = [];
  List<String> almuerzoMartes = [];
  List<String> almuerzoMiercoles = [];
  List<String> almuerzoJueves = [];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<String> CodigosAlmuerzos = [];
  ValueNotifier<String> selectedItem1 = ValueNotifier<String>('');
  ValueNotifier<String> selectedItem2 = ValueNotifier<String>('');
  ValueNotifier<String> selectedItem3 = ValueNotifier<String>('');
  ValueNotifier<String> selectedItem4 = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    cargarNombresAlmuerzos();
  }

  Future<void> cargarNombresAlmuerzos() async {
    List<String> CodigosAlmuerzos =
        await FirestoreService().getCodigosAlmuerzos();
    setState(() {
      this.CodigosAlmuerzos = CodigosAlmuerzos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Almuerzos Semanales'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildComboBox(almuerzoLunes, 'Lunes', selectedItem1),
                buildComboBox(almuerzoMartes, 'Martes', selectedItem2),
                buildComboBox(almuerzoMiercoles, 'Miércoles', selectedItem3),
                buildComboBox(almuerzoJueves, 'Jueves', selectedItem4),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (almuerzoLunes.isNotEmpty &&
              almuerzoMartes.isNotEmpty &&
              almuerzoMiercoles.isNotEmpty &&
              almuerzoJueves.isNotEmpty) {
            print('Todo bien');
            FirestoreService().editaAlmuerzoSemanal(almuerzoLunes,
                almuerzoMartes, almuerzoMiercoles, almuerzoJueves);
            Navigator.pop(context);
          } else {
            print('Al menos una lista está vacía');
          }
        },
        child: Icon(Icons.edit),
      ),
    );
  }

Widget buildComboBox(
  List<String> lista, 
  String label, 
  ValueNotifier<String?> selectedItem
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      DropdownButton<String>(
        value: selectedItem.value != null &&
            CodigosAlmuerzos.contains(selectedItem.value!)
            ? selectedItem.value
            : null,
        items: CodigosAlmuerzos.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.black)), // Color del texto del menú desplegable
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            if (newValue != null) {
              selectedItem.value = newValue;
              if (!lista.contains(newValue)) {
                lista.add(newValue);
              } else {
                print('Ya tiene ese almuerzo');
              }
            }
          });
        },
        style: TextStyle(color: Colors.black), // Color del texto del DropdownButton
        isExpanded: true,
        iconSize: 30,
        underline: Container(
          height: 2,
          color: Colors.black,
        ),
        elevation: 8,
        dropdownColor: Colors.white,
      ),
      Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Almuerzos del Día:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: lista.length,
              itemBuilder: (BuildContext context, int index) {
                final selectedItem = lista[index];
                return ListTile(
                  title: Text(selectedItem),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        lista.removeAt(index);
                      });
                    },
                    child: Text('Eliminar'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ],
  );
}

    }