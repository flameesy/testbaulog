import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class OrderFormPage extends StatefulWidget {
  final Database database;

  const OrderFormPage({super.key, required this.database});

  @override
  _OrderFormPageState createState() => _OrderFormPageState();
}

class _OrderFormPageState extends State<OrderFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _contactEmailController = TextEditingController();
  final _orderNumberController = TextEditingController();
  String? _selectedArticle;
  List<Map<String, dynamic>> _articles = [];

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    // Lade die Artikel aus der ARTIKEL-Tabelle
    final List<Map<String, dynamic>> articles = await widget.database.query('ARTIKEL');
    setState(() {
      _articles = articles;
    });
  }

  void _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      // Erstelle eine Bestellung und speichere sie in der Datenbank
      final orderData = {
        'contact_email': _contactEmailController.text,
        'order_number': _orderNumberController.text,
        'article_id': _selectedArticle,
      };
      await widget.database.insert('ORDERS', orderData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bestellung wurde erfolgreich gespeichert.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bestellformular')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextFieldWithTooltip(
                labelText: 'Kontakt-Email',
                tooltipText: 'Bitte geben Sie Ihre Kontakt-E-Mail-Adresse ein.',
                controller: _contactEmailController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Kontakt-Email ist erforderlich';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Ungültige E-Mail-Adresse';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _buildTextFieldWithTooltip(
                labelText: 'Bestellnummer',
                tooltipText: 'Bitte geben Sie die Bestellnummer ein.',
                controller: _orderNumberController,
                validator: (value) => value == null || value.isEmpty ? 'Bestellnummer ist erforderlich' : null,
              ),
              const SizedBox(height: 10),
              _buildArticleDropdown(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitOrder,
                child: const Text('Senden'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithTooltip({
    required String labelText,
    required String tooltipText,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return ListTile(
      title: Text(labelText),
      trailing: GestureDetector(
        onTap: () {
          _showTooltip(context, tooltipText);
        },
        child: const Icon(Icons.help_outline),
      ),
      subtitle: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: labelText,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildArticleDropdown() {
    return ListTile(
      title: const Text('Artikel'),
      trailing: GestureDetector(
        onTap: () {
          _showTooltip(context, 'Wählen Sie einen Artikel aus der Liste.');
        },
        child: const Icon(Icons.help_outline),
      ),
      subtitle: DropdownButtonFormField<String>(
        isExpanded: true,
        value: _selectedArticle,
        items: _articles.map((article) {
          return DropdownMenuItem<String>(
            value: article['id'].toString(),
            child: Text(article['name'] ?? ''),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedArticle = newValue;
          });
        },
        decoration: const InputDecoration(
          hintText: 'Bitte wählen Sie einen Artikel',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Bitte wählen Sie einen Artikel aus' : null,
      ),
    );
  }

  void _showTooltip(BuildContext context, String tooltipText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hilfe'),
          content: Text(tooltipText),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
