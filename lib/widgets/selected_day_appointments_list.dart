import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/database_helper.dart';
import '../screens/appointment_detail_page.dart';

class SelectedDayAppointmentsList extends StatelessWidget {
  final List<Map<String, dynamic>> appointments;
  final Function fetchAppointments;
  final Function navigateToAppointmentDetailPage;
  final Map<DateTime, List<dynamic>> appointmentsByDate;
  final DatabaseHelper databaseHelper;

  const SelectedDayAppointmentsList({
    super.key,
    required this.appointments,
    required this.fetchAppointments,
    required this.navigateToAppointmentDetailPage,
    required this.appointmentsByDate,
    required this.databaseHelper,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appointments.length + 1,
      itemBuilder: (context, index) {
        if (index == appointments.length) {
          return ListTile(
            title: Text(
              'Neuer Termin hinzufügen',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () async {
              final result = await navigateToNewAppointmentDetailPage(context, const {}, databaseHelper);
              if (result != null) {
                fetchAppointments();
              }
            },
          );
        } else {
          final appointment = appointments[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
                    'Startzeit: ${appointment['start_time'] != null ? DateFormat('HH:mm').format(DateTime.parse(appointment['start_time'])) : 'Keine Startzeit verfügbar'} | Endzeit: ${appointment['end_time'] != null ? DateFormat('HH:mm').format(DateTime.parse(appointment['end_time'])) : 'Keine Endzeit verfügbar'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Beschreibung: ${appointment['description'] ?? 'Keine Beschreibung verfügbar'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ID: ${appointment['id'] ?? 'Keine ID verfügbar'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Raum ID: ${appointment['room_id'] ?? 'Keine Raum ID verfügbar'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              onTap: () async {
                final result = await navigateToAppointmentDetailPage(context, appointment, databaseHelper);
                if (result != null) {
                  fetchAppointments();
                }
              },
            ),
          );
        }
      },
    );
  }

  Future<dynamic> navigateToNewAppointmentDetailPage(BuildContext context, Map<String, dynamic> appointment, DatabaseHelper databaseHelper) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentDetailPage(appointment: appointment, databaseHelper: databaseHelper),
      ),
    );
  }
}
