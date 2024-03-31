import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/database_helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class AddAppointmentPage extends StatefulWidget {
  const AddAppointmentPage({Key? key, required this.database}) : super(key: key);

  final Database database;

  @override
  _AddAppointmentPageState createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  final TextEditingController _appointmentController = TextEditingController();
  late DatabaseHelper _databaseHelper;
  late List<Map<String, dynamic>> _terminEntries = [];

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper(database: widget.database);
    // Fetch TERMIN entries after initializing the database
    fetchTerminEntries();
  }

  Future<void> fetchTerminEntries() async {
    final terminEntries = await _databaseHelper.fetchAppointments();
    setState(() {
      _terminEntries = terminEntries;
    });
  }

  void _addAppointment(BuildContext context) async {
    final String appointment = _appointmentController.text;
    await _databaseHelper.fetchAppointments();
    // Refresh TERMIN entries
    await fetchTerminEntries();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Termin hinzugefügt'),
      ),
    );
  }

  void _deleteAppointment(int id) async {
    await _databaseHelper.deleteAppointment(id);
    // Refresh TERMIN entries
    await fetchTerminEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _appointmentController,
              decoration: const InputDecoration(labelText: 'Terminname'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _addAppointment(context);
              },
              child: const Text('Termin hinzufügen'),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: _terminEntries.length,
                itemBuilder: (context, index) {
                  final terminEntry = _terminEntries[index];
                  return ListTile(
                    title: Text('ID: ${terminEntry['id']}, Text: ${terminEntry['appointment_name']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteAppointment(terminEntry['id'] as int);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: const CustomAppDrawer(),
    );
  }
}
