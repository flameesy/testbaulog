import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/database_helper.dart';
import 'csv_viewer_page.dart';


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
  late PlatformFile _selectedFile;
  List<PlatformFile> _attachmentFiles = [];

  @override
  void initState() {
    super.initState();
    _selectedFile = PlatformFile(name: '', size: 0); // Initialisierung von _selectedFile
    _getAttachmentFiles();
    _textEditingController = TextEditingController(text: widget.appointment['text'] ?? '');
    _dateEditingController = TextEditingController(text: _formatDate(widget.appointment['appointment_date']));
    _startTimeEditingController = TextEditingController(text: (widget.appointment['start_time']));
    _endTimeEditingController = TextEditingController(text: (widget.appointment['end_time']));
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
              _buildAttachmentList(),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: _attachFile,
                    child: const Text('Datei anhängen'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _saveAppointment,
                        child: const Text('Speichern'),
                      ),
                      const SizedBox(width: 10), // Abstand zwischen den Buttons
                      ElevatedButton(
                        onPressed: () {
                          // Aktion für den Löschen-Button hinzufügen
                        },
                        child: const Text('Löschen'),
                      ),
                    ],
                  ),
                ],
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

  String _formatDate(dynamic date) {
    if (date == null) {
      return DateFormat('dd.MM.yyyy').format(DateTime.now());
    } else if (date is String) {
      // Wenn date ein String ist, versuchen wir ihn in ein DateTime-Objekt umzuwandeln
      try {
        final parsedDate = DateTime.parse(date);
        return DateFormat('dd.MM.yyyy').format(parsedDate);
      } catch (e) {
        // Fehler beim Parsen des Datums, geben Sie das aktuelle Datum zurück
        return DateFormat('dd.MM.yyyy').format(DateTime.now());
      }
    } else if (date is DateTime) {
      // Wenn date bereits ein DateTime-Objekt ist, formatieren wir es direkt
      return DateFormat('dd.MM.yyyy').format(date);
    } else {
      // Für alle anderen Fälle geben wir das aktuelle Datum zurück
      return DateFormat('dd.MM.yyyy').format(DateTime.now());
    }
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

  Future<void> _attachFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) { // Überprüfen, ob eine Datei ausgewählt wurde
      setState(() {
        // Das ausgewählte File aus dem Resultat extrahieren
        _selectedFile = result.files.single;
      });
      await _saveAttachmentInDatabase(result.files.single);
    }
  }

  Future<void> _getAttachmentFiles() async {
    int appointmentId = widget.appointment['id'];
    List<PlatformFile> files = await widget.databaseHelper.getFilesForAppointment(appointmentId);
    setState(() {
      _attachmentFiles = files;
    });
  }

  Widget _buildAttachmentList() {
    if (_attachmentFiles.isEmpty) {
      return const Text('Keine Dateien angehängt');
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _attachmentFiles.map((file) {
          List<String> pathParts = file.name.split('/');
          String fileName = pathParts.last;
          return ListTile(
            leading: const Icon(Icons.attach_file),
            title: Text(fileName),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmationDialog(file); // Zeige Dialog zum Löschen an
              },
            ),
            onTap: () {
              _showFileViewer(file.name); // Öffne Datei im Viewer
            },
          );
        }).toList(),
      );
    }
  }

  void _showFileViewer(String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CSVViewerPage(filePath: filePath),
      ),
    );
  }


  Future<void> _showDeleteConfirmationDialog(PlatformFile file) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Anhang löschen'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Möchtest du diesen Anhang wirklich löschen?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Löschen'),
              onPressed: () {
                Navigator.of(context).pop(); // Schließe Dialog
                _deleteAttachment(file); // Lösche den Anhang
              },
            ),
          ],
        );
      },
    );
  }



  Future<void> _saveAttachmentInDatabase(PlatformFile file) async {
    int appointmentId = widget.appointment['id'];
    try {
      await widget.databaseHelper.saveAttachmentForAppointment(appointmentId, file);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Datei erfolgreich angehängt!'),
      ));
      await _getAttachmentFiles();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Fehler beim Speichern der Datei: $error'),
      ));
    }
  }

  Future<void> _deleteAttachment(PlatformFile file) async {
    try {
      await widget.databaseHelper.deleteAttachmentForAppointment(widget.appointment['id'],file.name);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Anhang erfolgreich gelöscht!'),
      ));
      await _getAttachmentFiles(); // Aktualisiere die Liste der Anhänge
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Fehler beim Löschen des Anhangs: $error'),
      ));
    }
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
