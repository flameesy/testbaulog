import 'package:sqflite_common/sqlite_api.dart';

class EmailTemplateProcessor {
  final Database database;

  EmailTemplateProcessor({required this.database});

  Future<Map<String, String>> loadVariables() async {
    final List<Map<String, dynamic>> variableRecords = await database.query('EMAIL_VARIABLES');
    return Map.fromEntries(variableRecords.map((record) => MapEntry(record['name'], record['default_value'] ?? '')));
  }

  String replaceVariables(String template, Map<String, String> variables) {
    return template.replaceAllMapped(
      RegExp(r'\$\{([^}]+)\}'),
          (match) => variables[match.group(1)] ?? match.group(0)!,
    );
  }
}
