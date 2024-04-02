import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CsvFileManager {
  // Methode zum Exportieren von Daten in eine CSV-Datei
  static Future<void> exportToCsv(String fileName, List<List<dynamic>> data) async {
    try {
      // Dateipfad abrufen, um die CSV-Datei zu speichern
      Directory? directory = await getExternalStorageDirectory();
      String filePath = '${directory?.path}/$fileName.csv';

      // CSV-Datei erstellen und Daten schreiben
      File csvFile = File(filePath);
      String csvData = '';

      for (var row in data) {
        csvData += '${row.join(';')}\n';
      }

      await csvFile.writeAsString(csvData);

      print('CSV-Datei erfolgreich exportiert: $filePath');
    } catch (e) {
      print('Fehler beim Exportieren der CSV-Datei: $e');
    }
  }

  // Methode zum Importieren von Daten aus einer CSV-Datei
  static Future<List<List<dynamic>>> importFromCsv(String filePath) async {
    try {
      File csvFile = File(filePath);
      List<List<dynamic>> csvData = [];

      // CSV-Datei lesen und Daten parsen
      await csvFile.readAsLines().then((lines) {
        for (var line in lines) {
          csvData.add(line.split(';'));
        }
      });

      return csvData;
    } catch (e) {
      print('Fehler beim Importieren der CSV-Datei: $e');
      return [];
    }
  }
}
