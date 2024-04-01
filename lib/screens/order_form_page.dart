import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class OrderFormPage extends StatefulWidget {
  final Database database;

  const OrderFormPage({Key? key, required this.database}) : super(key: key);

  @override
  _OrderFormPageState createState() => _OrderFormPageState();
}

class _OrderFormPageState extends State<OrderFormPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextFieldWithTooltip('Kontakt-Email', 'Bitte geben Sie Ihre Kontakt-E-Mail-Adresse ein.'),
          SizedBox(height: 10),
          _buildTextFieldWithTooltip('Bestellnummer', 'Bitte geben Sie die Bestellnummer ein.'),
          SizedBox(height: 10),
          _buildTextFieldWithTooltip('Artikel', 'Bitte geben Sie die Artikel ein.'),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Add logic to save the order to the database
              _submitOrder();
            },
            child: Text('Senden'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithTooltip(String labelText, String tooltipText) {
    return ListTile(
      title: Text(labelText),
      trailing: GestureDetector(
        onTap: () {
          _showTooltip(context, tooltipText);
        },
        child: Icon(Icons.help_outline),
      ),
      subtitle: TextFormField(
        decoration: InputDecoration(
          hintText: labelText,
        ),
      ),
    );
  }

  void _showTooltip(BuildContext context, String tooltipText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hilfe'),
          content: Text(tooltipText),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _submitOrder() {
    // Add logic to save the order to the database
    // You can access the text fields' values and save them to the database here
  }
}