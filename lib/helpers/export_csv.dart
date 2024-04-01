import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class ExportCSV {
  late final Database database;

  ExportCSV(String tableName,database) {
    exportTableToCSV(tableName, database);
  }

  Future<void> exportTableToCSV(String tableName, database) async {
    try {
      DatabaseHelper databaseHelper = DatabaseHelper(database: database);
      // Daten aus der Tabelle abrufen
      final List<Map<String, dynamic>> tableData = await database.query(
          tableName);

      // Verzeichnis für die Speicherung der CSV-Datei abrufen
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$tableName.csv');

      // CSV-Datei erstellen und Daten schreiben
      String csvData = '';
      if (tableData.isNotEmpty) {
        // Spaltenüberschriften schreiben
        csvData += '${tableData.first.keys.join(';')}\n';
        // Datenzeilen schreiben
        for (final row in tableData) {
          csvData +=
          '${row.values.map((value) => value.toString()).join(';')}\n';
        }
      }

      // CSV-Daten in die Datei schreiben
      await file.writeAsString(csvData);

      print('Export erfolgreich: ${file.path}');
    } catch (e) {
      print('Fehler beim Exportieren der Daten: $e');
      // Fehlerbehandlung bei Bedarf
    }
  }
}