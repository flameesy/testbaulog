import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testbaulog/screens/appointment_detail_page.dart';

import '../helpers/database_helper.dart';

class AppointmentsPage extends StatefulWidget {
  final Database database;

  const AppointmentsPage({Key? key, required this.database}) : super(key: key);

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List<Map<String, dynamic>> _appointments = []; // Initialize with an empty list

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    final DatabaseHelper dbHelper = DatabaseHelper(database: widget.database);
    try {
      final List<Map<String, dynamic>> appointments = await dbHelper.fetchItems('APPOINTMENT');
      if (mounted) {
        setState(() {
          _appointments = appointments;
        });
      }
    } catch (e) {
      print('Error fetching appointments: $e');
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termine'),
      ),
      body: _appointments.isNotEmpty
          ? GroupedListView<dynamic, String>(
        elements: _appointments,
        groupBy: (appointment) => appointment['appointment_date'] != null ? appointment['appointment_date'].toString() : '',// Hier nach Datum gruppieren
        groupSeparatorBuilder: (String date) => ListTile(
          title: Text(date),
          tileColor: Colors.grey[300],
        ),
        itemBuilder: (context, appointment) => ListTile(
          title: Text(appointment['text'] ?? 'Kein Text verfügbar'),
          subtitle: Text(
            'Startzeit: ${appointment['start_time']} | Endzeit: ${appointment['end_time']}',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppointmentDetailPage(appointment: appointment),
              ),
            );
          },
        ),
      )
          : const Center(
        child: Text('Keine Termine vorhanden'),
      ),
    );
  }
}
