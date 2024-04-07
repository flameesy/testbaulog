import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/database_helper.dart';

class AppointmentDetailPage extends StatefulWidget {
  final Map<String, dynamic> appointment;
  final DatabaseHelper databaseHelper;

  const AppointmentDetailPage({Key? key, required this.appointment, required this.databaseHelper}) : super(key: key);

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
    _dateEditingController = TextEditingController(text: _formatDate(widget.appointment['appointment_date']));
    _startTimeEditingController = TextEditingController(text: _formatTime(widget.appointment['start_time']));
    _endTimeEditingController = TextEditingController(text: _formatTime(widget.appointment['end_time']));
    _descriptionEditingController = TextEditingController(text: widget.appointment['description'] ?? '');
    _participantIdsEditingController = TextEditingController(text: widget.appointment['participant_ids'] ?? '');
    _platformIdEditingController = TextEditingController(text: widget.appointment['platform_id']?.toString() ?? '');
    _roomIdEditingController = TextEditingController(text: widget.appointment['room_id']?.toString() ?? '');
    _buildingIdEditingController = TextEditingController(text: widget.appointment['building_id']?.toString() ?? '');
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
                readOnly: true,
                onTap: _selectDate,
                decoration: const InputDecoration(
                  labelText: 'Datum (TT.MM.JJJJ)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startTimeEditingController,
                      readOnly: true,
                      onTap: _selectStartTime,
                      decoration: const InputDecoration(
                        labelText: 'Startzeit',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _endTimeEditingController,
                      readOnly: true,
                      onTap: _selectEndTime,
                      decoration: const InputDecoration(
                        labelText: 'Endzeit',
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

  Future<void> _selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _dateEditingController.text = _formatDate(selectedDate);
      });
    }
  }

  Future<void> _selectStartTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        _startTimeEditingController.text = _formatTimeOfDay(selectedTime);
      });
    }
  }

  Future<void> _selectEndTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        _endTimeEditingController.text = _formatTimeOfDay(selectedTime);
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) {
      return ''; // Wenn der Wert leer ist, gib einen leeren String zurück
    } else {
      final parts = time.split(' '); // Teile den String am Leerzeichen
      final timePart = parts.length > 1 ? parts[1] : ''; // Extrahiere den Zeit-Teil
      return timePart; // Gib den Zeit-Teil zurück
    }
  }


  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat.Hm().format(dt);
  }

  void _saveAppointment() {
    DateTime appointmentDate = DateFormat('dd.MM.yyyy').parse(_dateEditingController.text);
    DateTime startTime = _parseDateTime(_startTimeEditingController.text);
    DateTime endTime = _parseDateTime(_endTimeEditingController.text);

    final Map<String, dynamic> newAppointment = {
      'text': _textEditingController.text,
      'appointment_date': DateFormat('yyyy-MM-dd').format(appointmentDate),
      'start_time': DateFormat('HH:mm:ss').format(startTime),
      'end_time': DateFormat('HH:mm:ss').format(endTime),
      'description': _descriptionEditingController.text,
      'participant_ids': _participantIdsEditingController.text,
      'platform_id': int.tryParse(_platformIdEditingController.text) ?? 0,
      'room_id': int.tryParse(_roomIdEditingController.text) ?? 0,
      'building_id': int.tryParse(_buildingIdEditingController.text) ?? 0,
    };

    int? appointmentId = widget.appointment['id'];

    if (appointmentId != null) {
      widget.databaseHelper
          .updateAppointment(appointmentId, newAppointment)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Termin erfolgreich aktualisiert!'),
        ));
        Navigator.pop(context, true);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Fehler beim Aktualisieren des Termins: $error'),
        ));
      });
    } else {
      widget.databaseHelper
          .insertAppointment(
        appointmentDate: appointmentDate,
        startTime: startTime,
        endTime: endTime,
        text: _textEditingController.text,
        description: _descriptionEditingController.text,
        roomId: int.tryParse(_roomIdEditingController.text) ?? 0,
        platformId: int.tryParse(_platformIdEditingController.text) ?? 0,
      )
          .then((insertedId) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Termin erfolgreich erstellt! ID: $insertedId'),
        ));
        Navigator.pop(context, true);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Fehler beim Erstellen des Termins: $error'),
        ));
      });
    }
  }

  DateTime _parseDateTime(String time) {
    final now = DateTime.now();
    final parsedTime = DateFormat('HH:mm').parse(time);
    return DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
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
