import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../helpers/database_helper.dart';

class RoomDetailPage extends StatefulWidget {
  final Map<String, dynamic> room;
  final Database database;

  const RoomDetailPage({super.key, required this.room, required this.database});

  @override
  _RoomDetailPageState createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  List<Map<String, dynamic>> _appointments = []; // Liste der Termine für diesen Raum
  final TextEditingController _nameController = TextEditingController();
  String _selectedAccess = '';

  @override
  void initState() {
    super.initState();
    fetchAppointments();
    _nameController.text = widget.room['name'];
    _selectedAccess = widget.room['access'].toString();
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
    } catch (e) {
      print('Error fetching appointments: $e');
      // Handle error if needed
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
              'Raumdetails:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Raumname'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedAccess,
              items: ['1', '2', '3', '4', '5']
                  .map((value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAccess = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Zugang'),
            ),
            // Weitere Raumdetails hinzufügen
            const SizedBox(height: 20),
            const Text(
              'Termine in diesem Raum:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _appointments.length,
                itemBuilder: (context, index) {
                  final appointment = _appointments[index];
                  return ListTile(
                    title: Text('Datum: ${appointment['appointment_date']}'),
                    subtitle: Text(
                      'Startzeit: ${appointment['start_time']} | Endzeit: ${appointment['end_time']}',
                    ),
                    // Weitere Termindetails hinzufügen
                  );
                },
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
    final access = int.tryParse(_selectedAccess) ?? 0;
    final dbHelper = DatabaseHelper(database: widget.database);
    dbHelper.updateRoom(widget.room['id'], name, widget.room['level_id'], access);
  }
}
