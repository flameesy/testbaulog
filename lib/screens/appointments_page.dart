import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:table_calendar/table_calendar.dart';
import '../helpers/database_helper.dart';
import '../widgets/filter_bar.dart';
import 'add_appointment_dialog.dart';
import 'appointment_detail_page.dart';

class AppointmentsPage extends StatefulWidget {
  final Database database;

  const AppointmentsPage({super.key, required this.database});

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  late List<Map<String, dynamic>> _appointments;
  late Map<DateTime, List<Map<String, dynamic>>> _appointmentsByDate = {};
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _selectedDay = DateTime.now();
  late DateTime _focusedDay = DateTime.now();
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _appointments = [];
    _appointmentsByDate = {};
    _calendarFormat = CalendarFormat.month;
    _selectedDay = DateTime.now();
    _focusedDay = _selectedDay;
    _searchController = TextEditingController();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    final DatabaseHelper dbHelper = DatabaseHelper(database: widget.database);
    try {
      final List<Map<String, dynamic>> appointments =
      await dbHelper.fetchItems('APPOINTMENT');
      final List<Map<String, dynamic>> formattedAppointments = appointments.map((appointment) {
        final String dateString = appointment['appointment_date'];
        final DateTime date = DateTime.parse(dateString);
        appointment['appointment_date'] = date;
        return appointment;
      }).toList();
      setState(() {
        _appointments = formattedAppointments;
        _appointmentsByDate = _groupAppointmentsByDate(formattedAppointments);
      });
    } catch (e) {
      print('Error fetching appointments: $e');
      // Handle error if needed
    }
  }


  Map<DateTime, List<Map<String, dynamic>>> _groupAppointmentsByDate(
      List<Map<String, dynamic>> appointments) {
    Map<DateTime, List<Map<String, dynamic>>> appointmentsByDate = {};
    for (var appointment in appointments) {
      DateTime date = appointment['appointment_date'];
      print('Appointment Date: $date');
      if (!appointmentsByDate.containsKey(date)) {
        appointmentsByDate[date] = [];
      }
      appointmentsByDate[date]!.add(appointment);
    }
    print('Appointments by Date: $appointmentsByDate');
    return appointmentsByDate;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termine'),
      ),
      body: Column(
        children: [
          FilterBar(
            onSearchChanged: _filterAppointments, onSortChanged: (String ) {  },
          ),
          TableCalendar(
            firstDay: DateTime.utc(2021, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(height: 10),
          const Text(
            'Termine für den ausgewählten Tag:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: _buildSelectedDayAppointmentsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddAppointmentDialog();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _appointmentsByDate[day] ?? [];
  }

  Widget _buildSelectedDayAppointmentsList() {
    final List<Map<String, dynamic>> appointments =
        _appointmentsByDate[_selectedDay] ?? [];

    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return ListTile(
          title: Text(
            appointment['text'] ?? 'Kein Text verfügbar',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Startzeit: ${appointment['start_time']} | Endzeit: ${appointment['end_time']}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Beschreibung: ${appointment['description'] ?? 'Keine Beschreibung verfügbar'}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppointmentDetailPage(appointment: appointment),
              ),
            );
          },
        );
      },
    );
  }

  void _filterAppointments(String query) {
    if (query.isEmpty) {
      fetchAppointments();
    } else {
      final filteredAppointments = _appointments.where((appointment) {
        final text = appointment['text']?.toString().toLowerCase() ?? '';
        return text.contains(query.toLowerCase());
      }).toList();
      setState(() {
        _appointmentsByDate = _groupAppointmentsByDate(filteredAppointments);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
