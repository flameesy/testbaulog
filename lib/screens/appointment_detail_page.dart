import 'package:flutter/material.dart';

class AppointmentDetailPage extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const AppointmentDetailPage({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Termin Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Termin Details:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text('Text: ${appointment['text']}'),
            SizedBox(height: 10),
            Text('Datum: ${appointment['appointment_date']}'),
            SizedBox(height: 10),
            Text('Startzeit: ${appointment['start_time']}'),
            SizedBox(height: 10),
            Text('Endzeit: ${appointment['end_time']}'),
            // Weitere Details je nach Bedarf hier hinzufügen
          ],
        ),
      ),
    );
  }
}
