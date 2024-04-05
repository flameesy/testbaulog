import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';

class AppointmentDetailPage extends StatefulWidget {
  final Map<String, dynamic> appointment;
  final DatabaseHelper databaseHelper;

  const AppointmentDetailPage({super.key, required this.appointment, required this.databaseHelper});

  @override
  _AppointmentDetailPageState createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  late TextEditingController _textEditingController;
  late TextEditingController _dateEditingController;
  late TextEditingController _startTimeEditingController;
  late TextEditingController _endTimeEditingController;
  late TextEditingController _descriptionEditingController;
  late TextEditingController _participantIdsEditingController;
  late TextEditingController _platformIdEditingController;
  late TextEditingController _roomIdEditingController;
  late TextEditingController _buildingIdEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.appointment['text'] ?? '');
    _dateEditingController = TextEditingController(text: widget.appointment['appointment_date'] != null ? widget.appointment['appointment_date'].toString() : '');
    _startTimeEditingController = TextEditingController(text: widget.appointment['start_time'] != null ? widget.appointment['start_time'].toString() : '');
    _endTimeEditingController = TextEditingController(text: widget.appointment['end_time'] != null ? widget.appointment['end_time'].toString() : '');
    _descriptionEditingController = TextEditingController(text: widget.appointment['description'] ?? '');
    _participantIdsEditingController = TextEditingController(text: widget.appointment['participant_ids'] ?? '');
    _platformIdEditingController = TextEditingController(text: widget.appointment['platform_id'] != null ? widget.appointment['platform_id'].toString() : '');
    _roomIdEditingController = TextEditingController(text: widget.appointment['room_id'] != null ? widget.appointment['room_id'].toString() : '');
    _buildingIdEditingController = TextEditingController(text: widget.appointment['building_id'] != null ? widget.appointment['building_id'].toString() : '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termin Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              if (widget.appointment['id'] != null) ...[
                // Display ID if available
                Text(
                  'ID: ${widget.appointment['id']}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 10),
              TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  labelText: 'Text',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _dateEditingController,
                decoration: const InputDecoration(
                  labelText: 'Datum (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startTimeEditingController,
                      decoration: const InputDecoration(
                        labelText: 'Startzeit (HH:MM)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _endTimeEditingController,
                      decoration: const InputDecoration(
                        labelText: 'Endzeit (HH:MM)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionEditingController,
                decoration: const InputDecoration(
                  labelText: 'Beschreibung',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _participantIdsEditingController,
                decoration: const InputDecoration(
                  labelText: 'Teilnehmer IDs',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _platformIdEditingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Platform ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _roomIdEditingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Raum ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _buildingIdEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Gebäude ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAppointment,
                child: const Text('Speichern'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveAppointment() {
    // Convert date and time values to the correct format
    DateTime appointmentDate = DateTime.parse(_dateEditingController.text);

    // Parse time inputs and combine with appointment date
    List<String> startTimeParts = _startTimeEditingController.text.split(':');
    List<String> endTimeParts = _endTimeEditingController.text.split(':');

    int startHour = int.tryParse(startTimeParts[0]) ?? 0;
    int startMinute = int.tryParse(startTimeParts[1]) ?? 0;

    int endHour = int.tryParse(endTimeParts[0]) ?? 0;
    int endMinute = int.tryParse(endTimeParts[1]) ?? 0;

    DateTime startTime = DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day, startHour, startMinute);
    DateTime endTime = DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day, endHour, endMinute);

    final Map<String, dynamic> newAppointment = {
      'text': _textEditingController.text,
      'appointment_date': appointmentDate.toIso8601String(),
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'description': _descriptionEditingController.text,
      'participant_ids': _participantIdsEditingController.text,
      'platform_id': _platformIdEditingController.text.isNotEmpty ? int.tryParse(_platformIdEditingController.text) ?? 0 : 0,
      'room_id': _roomIdEditingController.text.isNotEmpty ? int.tryParse(_roomIdEditingController.text) ?? 0 : 0,
      'building_id': _buildingIdEditingController.text.isNotEmpty ? int.tryParse(_buildingIdEditingController.text) ?? 0 : 0,
    };

    int? appointmentId = widget.appointment['id']; // Get the appointment ID from the existing appointment

    if (appointmentId != null) {
      // If the ID exists and is not null, update the appointment
      widget.databaseHelper.updateAppointment(appointmentId, newAppointment)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Termin erfolgreich aktualisiert!'),
        ));
        Navigator.pop(context, true); // Signal that an appointment has been updated
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Fehler beim Aktualisieren des Termins: $error'),
        ));
      });
    } else {
      // If the ID is null, insert a new appointment
      _generateAndSaveNewAppointment(newAppointment);
    }
  }


  Future<void> _generateAndSaveNewAppointment(Map<String, dynamic> newAppointment) async {
    // Check if the appointment already has an ID, if not, generate a new one
    int appointmentId = newAppointment['id'] ?? await _generateUniqueId();

    // Insert the appointment into the database
    widget.databaseHelper.insertAppointment(
      appointmentDate: DateTime.parse(newAppointment['appointment_date']),
      startTime: DateTime.parse(newAppointment['start_time']),
      endTime: DateTime.parse(newAppointment['end_time']),
      text: newAppointment['text'],
      description: newAppointment['description'] ?? '',
      roomId: newAppointment['room_id'] ?? 0,
      platformId: newAppointment['platform_id'] ?? 0,
    ).then((insertedId) {
      String stringValue = insertedId.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Termin erfolgreich erstellt! $stringValue'),
      ));
      Navigator.pop(context, true); // Signal that a new appointment has been created
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Fehler beim Erstellen des Termins: $error'),
      ));
    });
  }

  // Method to generate a unique ID if necessary
  Future<int> _generateUniqueId() async {
    // Implement your logic to generate a unique ID
    // For example, you can use a timestamp, a random number, or any other method that guarantees uniqueness
    // In this example, I'll use a simple timestamp-based approach
    return DateTime.now().millisecondsSinceEpoch;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _dateEditingController.dispose();
    _startTimeEditingController.dispose();
    _endTimeEditingController.dispose();
    _descriptionEditingController.dispose();
    _participantIdsEditingController.dispose();
    _platformIdEditingController.dispose();
    _roomIdEditingController.dispose();
    _buildingIdEditingController.dispose();
    super.dispose();
  }
}
