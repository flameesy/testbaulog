import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import '../helpers/database_helper.dart';
import '../widgets/filter_bar.dart';
import '../widgets/selected_day_appointments_list.dart';
import 'appointment_detail_page.dart';

class AppointmentsPage extends StatefulWidget {
  final Database database;

  const AppointmentsPage({super.key, required this.database});

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List<Map<String, dynamic>> _appointments = [];
  Map<DateTime, List<dynamic>> _appointmentsByDate = {};
  DateTime _selectedDay = DateTime.now();
  final TextEditingController _searchController = TextEditingController();
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
      final List<Map<String, dynamic>> formattedAppointments = [];
      for (var appointment in appointments) {
        final DateTime appointmentDate = appointment['appointment_date'] != null
            ? DateTime.parse(appointment['appointment_date'])
            : DateTime.now();
        final String startTime = appointment['start_time'] ?? '';
        final String endTime = appointment['end_time'] ?? '';
        final String text = appointment['text'] ?? '';
        final String description = appointment['description'] ?? '';
        final int id = appointment['id'] ?? 0; // Feld 'id' hinzugefügt
        final int roomId = appointment['room_id'] ?? 0; // Feld 'room_id' hinzugefügt
        final formattedAppointment = {
          'id': id,
          'room_id': roomId,
          'appointment_date': appointmentDate,
          'start_time': startTime,
          'end_time': endTime,
          'text': text,
          'description': description,
        };
        formattedAppointments.add(formattedAppointment);
      }
      setState(() {
        _appointments = formattedAppointments;
        _appointmentsByDate = _groupAppointmentsByDate(formattedAppointments);
      });
    } catch (e) {
      print('Error fetching appointments: $e');
      // Handle error if needed
    }
  }


  Map<DateTime, List<dynamic>> _groupAppointmentsByDate(
      List<Map<String, dynamic>> appointments) {
    Map<DateTime, List<dynamic>> appointmentsByDate = {};
    for (var appointment in appointments) {
      DateTime date = appointment['appointment_date'];
      if (!appointmentsByDate.containsKey(date)) {
        appointmentsByDate[date] = [];
      }
      appointmentsByDate[date]!.add(appointment);
    }
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
            onSearchChanged: _filterAppointments,
            onSortChanged: (test) {},
          ),
          CalendarCarousel(
            onDayPressed: (DateTime date, List<dynamic> events) {
              setState(() {
                _selectedDay = date;
              });
            },
            weekendTextStyle: TextStyle(color: Colors.red[300]),
            thisMonthDayBorderColor: Colors.grey,
            weekFormat: false,
            height: 400.0,
            selectedDateTime: _selectedDay,
            selectedDayTextStyle: const TextStyle(color: Colors.white),
            selectedDayButtonColor: Colors.yellow.shade800,
            selectedDayBorderColor: Colors.yellow.shade800,
            todayButtonColor: Colors.red.shade100,
            todayBorderColor: Colors.red.shade100,
            daysHaveCircularBorder: true,
            headerMargin: const EdgeInsets.symmetric(vertical: 5.0),
            locale: 'de', // Setzen der Lokalisierung auf Deutsch
            headerTextStyle: const TextStyle(fontSize: 20.0, color: Colors.black),
            customDayBuilder: (
                bool isSelectable,
                int index,
                bool isSelectedDay,
                bool isToday,
                bool isPrevMonthDay,
                TextStyle textStyle,
                bool isNextMonthDay,
                bool isThisMonthDay,
                DateTime day,
                ) {
              bool hasAppointments = _appointmentsByDate.containsKey(day);
              Color dayColor = isToday && !isSelectedDay ? Colors.orange : textStyle.color!;
              return Container(
                decoration: BoxDecoration(
                  color: null,
                  shape: BoxShape.circle,
                  border: Border.all(color: hasAppointments ? Colors.transparent : Colors.transparent),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        '${day.day}',
                        style: textStyle.copyWith(color: dayColor),
                      ),
                    ),
                    if (hasAppointments)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: CircleAvatar(
                          backgroundColor: Colors.green.shade100,//TODO: Wechseln Sie die Farbe wenn es überfällige Termine gibt?
                          radius: 8,
                          child: Text(
                            '${_appointmentsByDate[day]!.length}',
                            style: const TextStyle(fontSize: 10, color: Colors.black),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
            markedDateShowIcon: true,
            markedDateIconMaxShown: 2,
            markedDateMoreShowTotal: null,
          ),
          const SizedBox(height: 10),
          const Text(
            'Termine für den ausgewählten Tag:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: SelectedDayAppointmentsList(
              appointments: _getEventsForDay(_selectedDay),
              fetchAppointments: fetchAppointments,
              navigateToAppointmentDetailPage: navigateToAppointmentDetailPage,
              appointmentsByDate: _appointmentsByDate,
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


  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    List<Map<String, dynamic>> eventsList = [];
    List<dynamic> events = _appointmentsByDate[day] ?? [];
    for (var event in events) {
      if (event is Map<String, dynamic>) {
        eventsList.add(event);
      }
    }
    return eventsList;
  }





  void _filterAppointments(String query) {
    if (query.isEmpty) {
      fetchAppointments(); // Zeige alle Termine, wenn die Suchanfrage leer ist
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


  // Die Funktion, um zur Appointment-Detailseite zu navigieren
  // In Ihrer AppointmentsPage-Klasse
  Future<dynamic> navigateToAppointmentDetailPage(BuildContext context, Map<String, dynamic> appointment, DatabaseHelper databaseHelper) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentDetailPage(appointment: appointment, databaseHelper: databaseHelper),
      ),
    );
  }



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
