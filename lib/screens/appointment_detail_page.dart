import 'package:flutter/material.dart';

class AppointmentDetailPage extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const AppointmentDetailPage({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termin Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Termin Details:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text('Text: ${appointment['text']}'),
            const SizedBox(height: 10),
            Text('Datum: ${appointment['appointment_date']}'),
            const SizedBox(height: 10),
            Text('Startzeit: ${appointment['start_time']}'),
            const SizedBox(height: 10),
            Text('Endzeit: ${appointment['end_time']}'),
            // Weitere Details je nach Bedarf hier hinzufügen
          ],
        ),
      ),
    );
  }
}
