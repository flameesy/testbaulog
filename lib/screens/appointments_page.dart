import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sqflite/sqflite.dart';
import '../helpers/database_helper.dart';

class AppointmentsPage extends StatefulWidget {
  final Database database;

  const AppointmentsPage({Key? key, required this.database}) : super(key: key);

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  late List<Map<String, dynamic>> _appointments = [];
  late Map<DateTime, List<dynamic>> _events;
  late List<Map<String, dynamic>> _thisWeekAppointments = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    final List<Map<String, dynamic>> appointments = await widget.database.query('APPOINTMENT');
    setState(() {
      _appointments = appointments;
      _events = _groupAppointmentsByDate(appointments);
      _thisWeekAppointments = _getThisWeekAppointments(appointments);
    });
  }

  Map<DateTime, List<dynamic>> _groupAppointmentsByDate(List<Map<String, dynamic>> appointments) {
    Map<DateTime, List<dynamic>> events = {};
    for (var appointment in appointments) {
      DateTime date = DateTime.parse(appointment['appointment_date']);
      if (events.containsKey(date)) {
        events[date]!.add(appointment);
      } else {
        events[date] = [appointment];
      }
    }
    return events;
  }

  List<Map<String, dynamic>> _getThisWeekAppointments(List<Map<String, dynamic>> appointments) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = DateTime(now.year, now.month, now.day - now.weekday);
    DateTime endOfWeek = startOfWeek.add(Duration(days: 7));

    return appointments.where((appointment) {
      DateTime appointmentDate = DateTime.parse(appointment['appointment_date']);
      return appointmentDate.isAfter(startOfWeek) && appointmentDate.isBefore(endOfWeek);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: _appointments.isNotEmpty
          ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
              ),
              eventLoader: (day) {
                // Return events for the specified day from the _events map
                return _events[day] ?? [];
              },
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              // Customize calendar properties as needed
            ),
            // Other widgets or components can be added here
          ],
        ),
      )
          : const Center(
        child: Text('No appointments available'),
      ),
    );
  }
}
