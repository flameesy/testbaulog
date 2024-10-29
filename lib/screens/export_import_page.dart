import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportImportPage extends StatefulWidget {
  final Database database;

  const ExportImportPage({super.key, required this.database});

  @override
  _ExportImportPageState createState() => _ExportImportPageState();
}

class _ExportImportPageState extends State<ExportImportPage> {
  List<String> _tables = [];
  String? _selectedTable;

  @override
  void initState() {
    super.initState();
    _fetchTables();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final permissionStatus = await Permission.storage.status;
    if (permissionStatus.isDenied) {
      await Permission.storage.request();
      if (permissionStatus.isDenied) {
        // Handle denied permission
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      // Handle permanently denied permission
    } else {
      // Permission granted, proceed with operations
    }
  }

  Future<void> _fetchTables() async {
    List<Map<String, dynamic>> tables =
    await widget.database.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    setState(() {
      _tables = tables.map((e) => e['name'].toString()).toList();
    });
  }

  Future<void> _exportData(String? tableName) async {
    if (tableName != null) {
      List<Map<String, dynamic>> data =
      await widget.database.rawQuery("SELECT * FROM $tableName");
      List<List<dynamic>> csvData = [];
      csvData.add(data[0].keys.toList()); // Header
      for (var row in data) {
        csvData.add(row.values.toList());
      }
      String csv = const ListToCsvConverter().convert(csvData);
      String dir = (await getExternalStorageDirectory())!.path;
      File file = File('$dir/$tableName.csv');
      await file.writeAsString(csv);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Data exported successfully'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a table to export'),
      ));
    }
  }

  Future<void> _exportAllData() async {
    for (String tableName in _tables) {
      List<Map<String, dynamic>> data =
      await widget.database.rawQuery("SELECT * FROM $tableName");
      if (data.isNotEmpty) { // Check if data is not empty
        List<List<dynamic>> csvData = [];
        csvData.add(data[0].keys.toList()); // Header
        for (var row in data) {
          csvData.add(row.values.toList());
        }
        String csv = const ListToCsvConverter().convert(csvData);
        String dir = (await getExternalStorageDirectory())!.path;
        File file = File('$dir/$tableName.csv');
        await file.writeAsString(csv);
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('All tables exported successfully'),
    ));
  }


  Future<void> _importData(FilePickerResult? result) async {
    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      File pickedFile = File(file.path!);
      String csvString = await pickedFile.readAsString();
      List<List<dynamic>> csvData = const CsvToListConverter().convert(csvString);

      // Step 1: Let the user select the table to import into
      String? selectedTable = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select table to import into'),
          content: DropdownButton<String>(
            value: _selectedTable,
            hint: const Text('Select a table'),
            onChanged: (value) {
              setState(() {
                _selectedTable = value;
              });
              Navigator.of(context).pop(value);
            },
            items: _tables.map((table) {
              return DropdownMenuItem<String>(
                value: table,
                child: Text(table),
              );
            }).toList(),
          ),
        ),
      );

      if (selectedTable != null) {
        List<String> headerRow = csvData[0].map((e) => e.toString()).toList();
        // Assuming first row is the header
        // Map CSV columns to database columns
        Map<String, String> columnMapping = {};
        for (var column in headerRow) {
          // You can prompt the user to map each CSV column to a database column
          // For simplicity, I'm just assuming they are the same
          columnMapping[column] = column;
        }
        // Insert data into database based on mapping
        for (var i = 1; i < csvData.length; i++) {
          List<dynamic> row = csvData[i];
          Map<String, dynamic> mappedRow = {};
          for (var j = 0; j < row.length; j++) {
            mappedRow[columnMapping[headerRow[j]]!] = row[j];
          }
          await widget.database.insert(selectedTable, mappedRow); // Step 3: Insert into selected table
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Data imported successfully'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select a table to import into'),
        ));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export / Import Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Export Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedTable,
              hint: const Text('Select a table'),
              onChanged: (value) {
                setState(() {
                  _selectedTable = value;
                });
              },
              items: _tables.map((table) {
                return DropdownMenuItem<String>(
                  value: table,
                  child: Text(table),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _exportData(_selectedTable),
              child: const Text('Export'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _exportAllData,
              child: const Text('Export All Tables'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Import Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['csv'],
                );
                _importData(result);
              },
              child: const Text('Select CSV File'),
            ),
          ],
        ),
      ),
    );
  }

}
