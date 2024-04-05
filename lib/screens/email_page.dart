import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helpers/database_helper.dart';

class EmailPage extends StatefulWidget {
  final Database database;

  const EmailPage({super.key, required this.database});

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  late int _selectedTemplateId = 0; // Definiere _selectedTemplateId
  late List<Map<String, dynamic>> _emailTemplates;
  late DatabaseHelper _databaseHelper;
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _ccController = TextEditingController();
  final _bccController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailTemplates = [];
    _databaseHelper = DatabaseHelper(database: widget.database);
    _loadEmailTemplates();
  }

  Future<void> _loadEmailTemplates() async {
    try {
      final List<Map<String, dynamic>> templates =
      await _databaseHelper.fetchItems('EMAIL_TEMPLATE');
      setState(() {
        _emailTemplates = templates;
        // Hier wird der Standardwert für _selectedTemplateId gesetzt,
        // um die ID der ersten Vorlage auszuwählen,
        if (templates.isNotEmpty) {
          _selectedTemplateId = templates.first['id'];
          _subjectController.text = templates.first['subject'];
          _bodyController.text = templates.first['body'];
        }
      });
    } catch (e) {
      print('Error loading email templates: $e');
    }
  }

  void _selectTemplate(int templateId) {
    final selectedTemplate = _emailTemplates
        .firstWhere((template) => template['id'] == templateId);
    setState(() {
      _selectedTemplateId = templateId;
      _subjectController.text = selectedTemplate['subject'];
      _bodyController.text = selectedTemplate['body'];
    });
  }

  void _sendEmail() async {
    if (_formKey.currentState!.validate()) {
      final recipient = _recipientController.text;
      final cc = _ccController.text;
      final bcc = _bccController.text;
      final subject = _subjectController.text;
      final body = _bodyController.text;

      // Speichern Sie die Daten in der Datenbank
      try {
        await widget.database.insert('EMAIL', {
          'recipient': recipient,
          'cc': cc,
          'bcc': bcc,
          'subject': subject,
          'body': body,
        });
        // Hier wird die URL für die E-Mail erstellt
        final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: recipient,
          queryParameters: {
            'cc': cc,
            'bcc': bcc,
            'subject': subject,
            'body': body,
          },
        );
          await launchUrl(emailLaunchUri);
        // Zeigen Sie eine Bestätigungsmeldung an oder navigieren Sie zu einer anderen Seite
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email gesendet und gespeichert!')),
        );
      } catch (e) {
        print('Error saving email: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fehler beim Speichern der Email')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-Mail senden',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20), // Mehr Platz zwischen Dropdown und Betreff
              DropdownButtonFormField<int>(
                value: _selectedTemplateId,
                items: _emailTemplates
                    .map<DropdownMenuItem<int>>(
                      (template) => DropdownMenuItem<int>(
                    value: template['id'],
                    child: Text(template['name']),
                  ),
                )
                    .toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    _selectTemplate(newValue); // Hier wird die Vorlagen-ID übergeben
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'E-Mail-Vorlage auswählen',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12.0),
                ),
              ),

              const SizedBox(height: 20), // Mehr Platz zwischen Dropdown und Betreff
              TextFormField(
                controller: _recipientController,
                decoration: const InputDecoration(
                  labelText: 'An:',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter recipient email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ccController,
                decoration: const InputDecoration(
                  labelText: 'CC:',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12.0),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _bccController,
                decoration: const InputDecoration(
                  labelText: 'BCC:',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12.0),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Betreff:',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _bodyController,
                minLines: 5, // Mindestanzahl von Zeilen
                maxLines: null, // Anzahl der Zeilen ist unbegrenzt
                keyboardType: TextInputType.multiline, // Mehrzeiliges Textfeld
                decoration: const InputDecoration(
                  labelText: 'Text:',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email body';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendEmail,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                ),
                child: const Text(
                  'E-Mail senden',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _ccController.dispose();
    _bccController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}
