import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PruebaCalendarioPage extends StatefulWidget {
  
  @override
  _PruebaCalendarioPageState createState() => _PruebaCalendarioPageState();
}

class _PruebaCalendarioPageState extends State<PruebaCalendarioPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<dynamic>> _events;
  

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _events = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Weekdays'),
      ),
      body: Center(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2023, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (_isAllowedDay(selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                } else {
                  // Mostrar un mensaje o ignorar la selección
                  // Ejemplo: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selecciona un día válido')));
                }
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_isAllowedDay(_selectedDay)) {
                  if (_events[_selectedDay] == null) {
                    _events[_selectedDay] = [];
                  }
                  _events[_selectedDay]!.add('Evento agregado');
                  setState(() {});
                } else {
                  // Mostrar un mensaje o ignorar la acción
                  // Ejemplo: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selecciona un día válido')));
                }
              },
              child: Text('Agregar Fecha'),
            ),
            SizedBox(height: 20),
            Text('Fechas Seleccionadas:'),
            Expanded(
              child: ListView(
                children: _events.keys.map((date) {
                  return ListTile(
                    title: Text(date.toString()),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Agregar lógica para guardar fechas seleccionadas
                //realizar una acción específica
                List<DateTime> fechasSeleccionadas = _events.keys.toList(); // Obtener lista de fechas seleccionadas

                // Enviar las fechas seleccionadas de vuelta a la página anterior
                Navigator.pop(context, fechasSeleccionadas);


              },
              child: Text('Guardar fechas seleccionadas'),
            ),
          ],
        ),
      ),
    );
  }

 
  bool _isAllowedDay(DateTime day) {
  bool isMondayToThursday = day.weekday >= DateTime.monday && day.weekday <= DateTime.thursday;
  bool isNotPastToday = day.isAfter(DateTime.now().subtract(Duration(days: 1))); // Evita días anteriores a hoy
  bool isBeforeNoon = DateTime.now().hour < 12; // Verifica si la hora actual es antes de las 12:00 pm

  if (isMondayToThursday && isNotPastToday) {
    if (day.day == DateTime.now().day && !isBeforeNoon) {
      return false; // No permitir seleccionar el día de hoy si es después de las 12:00 pm
    }
    return true; // Permitir días de lunes a jueves que no sean anteriores al día de hoy
  }
  return false; // Restringir días no válidos
}

}
