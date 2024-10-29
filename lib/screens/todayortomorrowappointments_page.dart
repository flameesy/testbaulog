import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../helpers/database_helper.dart';
import '../widgets/selected_day_appointments_list.dart';
import 'appointment_detail_page.dart';

class TodayOrTomorrowAppointmentsPage extends StatefulWidget {
  final Database database;

  const TodayOrTomorrowAppointmentsPage({super.key, required this.database});

  @override
  _TodayOrTomorrowAppointmentsPageState createState() => _TodayOrTomorrowAppointmentsPageState();
}

class _TodayOrTomorrowAppointmentsPageState extends State<TodayOrTomorrowAppointmentsPage> {
  List<Map<String, dynamic>> _appointments = [];
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper(database: widget.database);
    _initDatabaseHelper();
  }

  Future<void> _initDatabaseHelper() async {
    await fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      final List<Map<String, dynamic>> appointments = await _databaseHelper.fetchAppointments();
      final DateTime now = DateTime.now();
      final DateTime tomorrow = now.add(const Duration(days: 1));

      // Filter appointments for today or tomorrow
      final List<Map<String, dynamic>> filteredAppointments = appointments.where((appointment) {
        final DateTime appointmentDate = DateTime.parse(appointment['appointment_date']).toLocal();
        return (appointmentDate.isAfter(now.subtract(Duration(hours: 24))) &&
            appointmentDate.isBefore(tomorrow.add(Duration(days: 1))) );
      }).toList();

      setState(() {
        _appointments = filteredAppointments;
      });

      // Log appointments to check
      print('Gefilterte Termine: $filteredAppointments');
    } catch (e) {
      print('Fehler beim Laden der Termine: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termine für Heute und Morgen'),
        backgroundColor: Colors.blueAccent, // Optische Verbesserung
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'Termine für heute oder morgen:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: SelectedDayAppointmentsList(
              appointments: _appointments,
              fetchAppointments: fetchAppointments,
              navigateToAppointmentDetailPage: navigateToAppointmentDetailPage,
              appointmentsByDate: {}, // Hier nicht benötigt
              databaseHelper: _databaseHelper,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentDetailPage(appointment: const {}, databaseHelper: _databaseHelper),
            ),
          );
          if (result != null) {
            fetchAppointments();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> navigateToAppointmentDetailPage(BuildContext context, Map<String, dynamic> appointment, DatabaseHelper databaseHelper) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentDetailPage(appointment: appointment, databaseHelper: databaseHelper),
      ),
    );
  }
}
