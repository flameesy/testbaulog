import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../helpers/database_helper.dart';

class EmailTemplateDetailPage extends StatefulWidget {
  final DatabaseHelper databaseHelper;
  final Map<String, dynamic>? templateData; // Template-Daten für den Bearbeitungsmodus

  const EmailTemplateDetailPage({Key? key, required this.databaseHelper, this.templateData}) : super(key: key);

  @override
  _EmailTemplateDetailPageState createState() => _EmailTemplateDetailPageState();
}

class _EmailTemplateDetailPageState extends State<EmailTemplateDetailPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Wenn Template-Daten vorhanden sind, fülle die Textfelder damit
    if (widget.templateData != null) {
      _nameController.text = widget.templateData!['name'];
      _subjectController.text = widget.templateData!['subject'];
      _bodyController.text = widget.templateData!['body'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.templateData != null ? 'Vorlage bearbeiten' : 'Vorlage erstellen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Betreff',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: 'Text',
                border: OutlineInputBorder(),
              ),
              maxLines: 15,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.top,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Wenn Template-Daten vorhanden sind, führe ein Update durch, sonst füge ein neues Template ein
                if (widget.templateData != null) {
                  _updateTemplate();
                } else {
                  _saveTemplate();
                }
              },
              child: Text(widget.templateData != null ? 'Aktualisieren' : 'Speichern'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTemplate() async {
    final String name = _nameController.text.trim();
    final String subject = _subjectController.text.trim();
    final String body = _bodyController.text.trim();

    if (name.isNotEmpty && subject.isNotEmpty && body.isNotEmpty) {
      final Map<String, dynamic> templateData = {
        'name': name,
        'subject': subject,
        'body': body,
      };

      final int templateId = await widget.databaseHelper.insertEmailTemplate(templateData);

      if (templateId != -1) {
        Navigator.pop(context, true);
      } else {
        _showErrorDialog('Fehler beim Speichern der E-Mail-Vorlage.');
      }
    } else {
      _showErrorDialog('Bitte füllen Sie alle Felder aus.');
    }
  }

  Future<void> _updateTemplate() async {
    final String name = _nameController.text.trim();
    final String subject = _subjectController.text.trim();
    final String body = _bodyController.text.trim();

    final int templateId = widget.templateData!['id'];

    if (name.isNotEmpty && subject.isNotEmpty && body.isNotEmpty) {
      final Map<String, dynamic> templateData = {
        'id': templateId,
        'name': name,
        'subject': subject,
        'body': body,
      };

      await widget.databaseHelper.updateEmailTemplate(templateId, templateData);

      Navigator.pop(context, true);
    } else {
      _showErrorDialog('Bitte füllen Sie alle Felder aus.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Fehler'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}
