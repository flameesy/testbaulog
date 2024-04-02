import 'package:flutter/material.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _ccController = TextEditingController();
  final _bccController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  final _replyToController = TextEditingController();
  String _priority = 'Normal';
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-Mail senden',
          style: TextStyle(fontSize: 20.0), // Adjust font size
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _recipientController,
                decoration: InputDecoration(
                  labelText: 'An:',
                  border: OutlineInputBorder(), // Add border
                  contentPadding: EdgeInsets.all(12.0), // Add padding
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter recipient email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
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
                controller: _replyToController,
                decoration: const InputDecoration(
                  labelText: 'Reply-To:',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12.0),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _priority,
                items: ['High', 'Normal', 'Low'].map((String priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _priority = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Priority:',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12.0),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Betreff:',
                  border: OutlineInputBorder(), // Add border
                  contentPadding: EdgeInsets.all(12.0), // Add padding
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TextFormField(
                  controller: _bodyController,
                  maxLines: null, // Allow unlimited lines
                  expands: true,
                  decoration: const InputDecoration(
                    labelText: 'Nachricht',
                    border: OutlineInputBorder(), // Add border
                    contentPadding: EdgeInsets.all(12.0), // Add padding
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the body of the email';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: Text('Select date'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Implementieren Sie hier die Logik zum Senden der E-Mail
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14.0), // Adjust padding
                ),
                child: const Text(
                  'E-Mail senden',
                  style: TextStyle(fontSize: 18.0), // Adjust font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}