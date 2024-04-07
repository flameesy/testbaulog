import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  int? _selectedTemplateId;
  List<Map<String, dynamic>> _emailTemplates = [];
  late DatabaseHelper _databaseHelper;
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _ccController = TextEditingController();
  final _bccController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  XFile? _imageFile; // Neu hinzugefügt

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper(database: widget.database);
    _loadEmailTemplates();
  }

  Future<void> _loadEmailTemplates() async {
    try {
      final List<Map<String, dynamic>> templates =
      await _databaseHelper.fetchItems('EMAIL_TEMPLATE');
      setState(() {
        _emailTemplates = templates;
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
      _subjectController.text =
          _replacePlaceholders(selectedTemplate['subject']);
      _bodyController.text = _replacePlaceholders(selectedTemplate['body']);
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = pickedFile;
    });
  }

  void _sendEmail() async {
    if (_formKey.currentState!.validate()) {
      final recipient = _recipientController.text;
      final cc = _ccController.text;
      final bcc = _bccController.text;
      final subject = _subjectController.text;
      final body = _replacePlaceholders(_bodyController.text);

      try {
        final String emailUriString =
            'mailto:$recipient?cc=$cc&bcc=$bcc&subject=$subject&body=$body';

        // Öffnen der E-Mail-App mit der HTML-formatierten E-Mail
        await launchUrl(Uri.parse(emailUriString));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email sent and saved!')),
        );
      } catch (e) {
        print('Error saving email: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error saving email')),
        );
      }
    }
  }

  // Methode zum Laden des Bilds
  Future<void> _loadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

// Methode zum Einbetten des Bilds in den E-Mail-Body
  Future<String> _embedImage() async {
    if (_imageFile != null) {
      final bytes = await _imageFile!.readAsBytes();
      final String base64Image = base64Encode(bytes);
      return 'data:image/png;base64,$base64Image';
    } else {
      return ''; // Falls kein Bild ausgewählt wurde
    }
  }

// Methode zum Ersetzen der Platzhalter und Einbetten des Bilds
  String _replacePlaceholders(String body) {
    // Hier ersetzen Sie die Platzhalter in der Vorlage durch die entsprechenden Werte
    body = body.replaceAll('ORDER_ID', '55432');

    // HTML-Format für das Bild und die Signatur
    final String imageHtml = '<img src="${_embedImage()}" alt="User Image">';
    const String signatureHtml =
        'Best regards, <a href="https://example.com">User</a>';

    // Fügen Sie das Bild und die Signatur dem E-Mail-Body hinzu
    body += '<br><br>$imageHtml<br><br>$signatureHtml';

    return body;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Send Email',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: _selectedTemplateId,
                items: [
                  const DropdownMenuItem<int>(
                    value: null, // Standardwert auf null setzen
                    child: Text('Select Email Template'),
                  ),
                  ..._emailTemplates.map<DropdownMenuItem<int>>(
                        (template) => DropdownMenuItem<int>(
                      value: template['id'],
                      child: Text(template['name'] ?? ''),
                    ),
                  ),
                ],
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    _selectTemplate(newValue);
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Select Email Template',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12.0),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'), // Neu hinzugefügt
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: _recipientController,
                decoration: const InputDecoration(
                  labelText: 'To:',
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
                  labelText: 'Subject:',
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
                minLines: 5,
                maxLines: null,
                keyboardType: TextInputType.multiline,
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
                  'Send Email',
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
