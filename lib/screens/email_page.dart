import 'package:flutter/material.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'E-Mail senden',
          style: TextStyle(fontSize: 20.0), // Adjust font size
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'An:',
                border: OutlineInputBorder(), // Add border
                contentPadding: EdgeInsets.all(12.0), // Add padding
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Betreff:',
                border: OutlineInputBorder(), // Add border
                contentPadding: EdgeInsets.all(12.0), // Add padding
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: TextField(
                maxLines: null, // Allow unlimited lines
                expands: true,
                decoration: InputDecoration(
                  labelText: 'Nachricht',
                  border: OutlineInputBorder(), // Add border
                  contentPadding: EdgeInsets.all(12.0), // Add padding
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implementieren Sie hier die Logik zum Senden der E-Mail
              },
              child: Text(
                'E-Mail senden',
                style: TextStyle(fontSize: 18.0), // Adjust font size
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.0), // Adjust padding
              ),
            ),
          ],
        ),
      ),
    );
  }
}
