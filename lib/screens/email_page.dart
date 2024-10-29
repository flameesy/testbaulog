import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:html_editor_enhanced/html_editor.dart'; // Füge das HTML-Editor-Paket hinzu

class EmailPage extends StatefulWidget {
  final Database database;
  const EmailPage({super.key, required this.database});

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _subjectController = TextEditingController();
  final HtmlEditorController _htmlEditorController = HtmlEditorController();
  bool showCcBccFields = false;
  final List<File> _attachments = [];

  @override
  void dispose() {
    _recipientController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  void _toggleCcBcc() {
    setState(() {
      showCcBccFields = !showCcBccFields;
    });
  }

  Future<void> _pickAttachment() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _attachments.add(File(result.files.single.path!));
      });
    }
  }

  Future<void> _addImageToBody() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final imgTag = '<img src="data:image/png;base64,$base64Image">';

      // Holt den aktuellen Inhalt des Editors und fügt das Bild hinzu
      String? currentText = await _htmlEditorController.getText();
      String newText = currentText != null ? currentText + imgTag : imgTag;
      _htmlEditorController.setText(newText); // Bild im Editor hinzufügen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Mail mit Anhängen senden'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Hinzugefügt für Scrollbarkeit
            child: Column( // Ändere ListView in Column
              children: [
                TextFormField(
                  controller: _recipientController,
                  decoration: const InputDecoration(
                    labelText: 'An',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Bitte Empfänger eingeben' : null,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _toggleCcBcc,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'CC / BCC hinzufügen',
                        style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
                if (showCcBccFields) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'CC',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'BCC',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Betreff',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Bitte Betreff eingeben' : null,
                ),
                const SizedBox(height: 16),
                // Hier den HtmlEditor hinzufügen
                SizedBox(
                  height: 400, // Höhe anpassen
                  child: HtmlEditor(
                    controller: _htmlEditorController,
                    htmlEditorOptions: HtmlEditorOptions(
                      initialText: "E-Mail-Text hier eingeben...",
                      shouldEnsureVisible: true,
                    ),
                    otherOptions: OtherOptions(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addImageToBody,
                  child: const Text('Bild zum E-Mail-Text hinzufügen'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _pickAttachment,
                  child: const Text('Anhang hinzufügen'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Hier kannst du die Logik für das Senden der E-Mail einfügen
                      // Du kannst den HTML-Inhalt mit _htmlEditorController.getText() abrufen
                    }
                  },
                  child: const Text('E-Mail senden'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
