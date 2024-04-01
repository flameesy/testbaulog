import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testbaulog/screens/appointment_detail_page.dart';
import '../helpers/database_helper.dart';
import '../widgets/filter_bar.dart';
import 'add_appointment_dialog.dart';

class AppointmentsPage extends StatefulWidget {
  final Database database;

  const AppointmentsPage({Key? key, required this.database}) : super(key: key);

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List<Map<String, dynamic>> _appointments = [];

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

  void _filterAppointments(String query) {
    if (query.isEmpty) {
      fetchAppointments();
    } else {
      final filteredAppointments = _appointments.where((appointment) {
        final text = appointment['text']?.toString().toLowerCase() ?? '';
        return text.contains(query.toLowerCase());
      }).toList();
      setState(() {
        _appointments = filteredAppointments;
      });
    }
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
            // Implement sorting options if needed
          ),
          Expanded(
            child: _buildAppointmentsList(),
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

  Widget _buildAppointmentsList() {
    return _appointments.isNotEmpty
        ? GroupedListView<dynamic, String>(
      elements: _appointments,
      groupBy: (appointment) => appointment['appointment_date'] != null
          ? appointment['appointment_date'].toString()
          : '',
      groupSeparatorBuilder: (String date) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          date,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      itemBuilder: (context, appointment) => _buildAppointmentTile(appointment),
    )
        : const Center(
      child: Text('Keine Termine vorhanden'),
    );
  }

  Widget _buildAppointmentTile(Map<String, dynamic> appointment) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
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
      ),
    );
  }
}
