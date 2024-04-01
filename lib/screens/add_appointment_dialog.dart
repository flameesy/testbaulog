import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddAppointmentDialog extends StatefulWidget {
  const AddAppointmentDialog({Key? key}) : super(key: key);

  @override
  _AddAppointmentDialogState createState() => _AddAppointmentDialogState();
}

class _AddAppointmentDialogState extends State<AddAppointmentDialog> {
  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  int _duration = 0;
  String _title = '';
  String _description = '';

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now();
    _startTime = TimeOfDay.now();
    _endTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context), // Use the theme of the current context
      child: AlertDialog(
        title: const Text('Neuen Termin hinzufügen'),
        contentPadding: const EdgeInsets.all(16.0),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateTimePicker(
                'Datum von:',
                _startDate,
                    (DateTime date) {
                  setState(() {
                    _startDate = date;
                  });
                },
              ),
              _buildDateTimePicker(
                'Datum bis:',
                _endDate,
                    (DateTime date) {
                  setState(() {
                    _endDate = date;
                  });
                },
              ),
              _buildTimePicker(
                'Uhrzeit von:',
                _startTime,
                    (TimeOfDay time) {
                  setState(() {
                    _startTime = time;
                  });
                },
              ),
              _buildTimePicker(
                'Uhrzeit bis:',
                _endTime,
                    (TimeOfDay time) {
                  setState(() {
                    _endTime = time;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Betreff/Titel',
                ),
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Beschreibung',
                ),
                maxLines: 3, // Allow multiline input for description
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Dauer (Minuten)',
                ),
                keyboardType: TextInputType.number,
                maxLength: 3, // Limit input to 3 digits
                inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Allow only digit input
                textAlign: TextAlign.center, // Center align text
                style: TextStyle(fontSize: 16), // Adjust font size
                onChanged: (value) {
                  setState(() {
                    _duration = int.tryParse(value) ?? 0;
                  });
                },
              ),

            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Add logic to save the appointment to the database
              // Use _startDate, _endDate, _startTime, _endTime, _duration, _title, _description
              Navigator.pop(context);
            },
            child: const Text('Speichern'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimePicker(String label, DateTime initialDate, Function(DateTime) onChanged) {
    return ListTile(
      title: Text(label),
      trailing: GestureDetector(
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year + 1),
          );
          if (pickedDate != null) {
            onChanged(pickedDate);
          }
        },
        child: Text(
          '${initialDate.day}.${initialDate.month}.${initialDate.year}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay initialTime, Function(TimeOfDay) onChanged) {
    return ListTile(
      title: Text(label),
      trailing: GestureDetector(
        onTap: () async {
          final pickedTime = await showTimePicker(
            context: context,
            initialTime: initialTime,
          );
          if (pickedTime != null) {
            onChanged(pickedTime);
          }
        },
        child: Text(
          '${initialTime.hour}:${initialTime.minute}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
