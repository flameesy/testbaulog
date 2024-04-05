import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../helpers/database_helper.dart';
import '../widgets/selected_day_appointments_list.dart';
import 'appointment_detail_page.dart';

class RoomDetailPage extends StatefulWidget {
  final Map<String, dynamic> room;
  final Database database;

  const RoomDetailPage({super.key, required this.room, required this.database});

  @override
  _RoomDetailPageState createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  List<Map<String, dynamic>> _appointments = [];
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _levelIdController = TextEditingController();
  final TextEditingController _accessController = TextEditingController();
  final TextEditingController _syncStatusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAppointments();
    _idController.text = widget.room['id'].toString();
    _nameController.text = widget.room['name'];
    _levelIdController.text = widget.room['level_id'].toString();
    _accessController.text = widget.room['access'].toString();
    _syncStatusController.text = widget.room['sync_status'].toString();
  }

  Future<void> fetchAppointments() async {
    final DatabaseHelper dbHelper = DatabaseHelper(database: widget.database);
    try {
      final List<Map<String, dynamic>> appointments = await dbHelper.fetchItemsWithWhere(
        'APPOINTMENT',
        'room_id = ?',
        [widget.room['id']],
      );
      setState(() {
        _appointments = appointments;
      });
      dbHelper.printAppointmentTableSchema();
    } catch (e) {
      print('Error fetching appointments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Room Details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _idController,
              enabled: false, // Make it non-editable
              decoration: const InputDecoration(labelText: 'ID'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Room Name'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _levelIdController,
              decoration: const InputDecoration(labelText: 'Level ID'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _accessController,
              decoration: const InputDecoration(labelText: 'Access'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _syncStatusController,
              decoration: const InputDecoration(labelText: 'Sync Status'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Termine für den ausgewählten Raum:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SelectedDayAppointmentsList(
                appointments: _appointments,
                fetchAppointments: fetchAppointments,
                appointmentsByDate: _groupAppointmentsByDate(_appointments),
                navigateToAppointmentDetailPage: navigateToAppointmentDetailPage,
                databaseHelper: DatabaseHelper(database: widget.database),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _updateRoom();
          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  void _updateRoom() {
    final name = _nameController.text;
    final levelId = int.tryParse(_levelIdController.text) ?? 0;
    final access = int.tryParse(_accessController.text) ?? 0;
    final syncStatus = int.tryParse(_syncStatusController.text) ?? 0;
    final dbHelper = DatabaseHelper(database: widget.database);
    dbHelper.updateRoom(widget.room['id'], name, levelId, access, syncStatus);
  }

  Map<DateTime, List<dynamic>> _groupAppointmentsByDate(List<Map<String, dynamic>> appointments) {
    Map<DateTime, List<dynamic>> appointmentsByDate = {};
    for (var appointment in appointments) {
      DateTime date = DateTime.parse(appointment['appointment_date']);
      if (!appointmentsByDate.containsKey(date)) {
        appointmentsByDate[date] = [];
      }
      appointmentsByDate[date]!.add(appointment);
    }
    return appointmentsByDate;
  }

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
    _nameController.dispose();
    _levelIdController.dispose();
    _accessController.dispose();
    _syncStatusController.dispose();
    super.dispose();
  }
}

