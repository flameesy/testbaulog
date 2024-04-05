import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../helpers/database_helper.dart';
import '../widgets/filter_bar.dart';
import '../widgets/email_template_tile.dart';
import 'email_template_detail_page.dart';

class EmailTemplatesPage extends StatefulWidget {
  final Database database;

  const EmailTemplatesPage({super.key, required this.database});

  @override
  _EmailTemplatesPageState createState() => _EmailTemplatesPageState();
}

class _EmailTemplatesPageState extends State<EmailTemplatesPage> {
  List<Map<String, dynamic>> _templates = [];
  late DatabaseHelper _databaseHelper;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper(database: widget.database);
    _initDatabaseHelper();
  }

  Future<void> _initDatabaseHelper() async {
    await fetchTemplates();
  }

  Future<void> fetchTemplates() async {
    try {
      final List<Map<String, dynamic>> templates = await _databaseHelper.fetchItems('EMAIL_TEMPLATE');
      setState(() {
        _templates = templates;
      });
    } catch (e) {
      print('Error fetching email templates: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Templates'),
      ),
      body: Column(
        children: [
          FilterBar(
            onSearchChanged: _filterTemplates,
            onSortChanged: (String) {},
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _templates.length,
              itemBuilder: (context, index) {
                final template = _templates[index];
                return EmailTemplateTile(
                  template: template,
                  onTap: () {
                    _navigateToTemplateDetailPage(template);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToTemplateDetailPage(null); // Neues Template erstellen
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _filterTemplates(String query) {
    // Implementiere die Filterlogik hier
  }

  Future<void> _navigateToTemplateDetailPage(Map<String, dynamic>? templateData) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailTemplateDetailPage(templateData: templateData, databaseHelper: _databaseHelper),
      ),
    );
    if (result != null) {
      fetchTemplates(); // Aktualisiere die Vorlagen nach dem Speichern oder Löschen
    }
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
