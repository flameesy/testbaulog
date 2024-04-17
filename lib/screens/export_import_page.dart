import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportImportPage extends StatefulWidget {
  final Database database;

  ExportImportPage({required this.database});

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
      // Here just ask for the permission for the first time
      await Permission.storage.request();

      // I noticed that sometimes popup won't show after user press deny
      // so I do the check once again but now go straight to appSettings
      if (permissionStatus.isDenied) {

      }
    } else if (permissionStatus.isPermanentlyDenied) {
      // Here open app settings for user to manually enable permission in case
      // where permission was permanently denied
    } else {
      // Do stuff that require permission here
    }
  }

  Future<void> _fetchTables() async {
    List<Map<String, dynamic>> tables =
    await widget.database.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    setState(() {
      _tables = tables.map((e) => e['name'].toString()).toList();
    });
  }

  Future<void> _exportData() async {
    if (_selectedTable != null) {
      List<Map<String, dynamic>> data =
      await widget.database.rawQuery("SELECT * FROM $_selectedTable");
      List<List<dynamic>> csvData = [];
      csvData.add(data[0].keys.toList()); // Header
      for (var row in data) {
        csvData.add(row.values.toList());
      }
      String csv = const ListToCsvConverter().convert(csvData);
      String dir = (await getExternalStorageDirectory())!.path;
      File file = File('$dir/$_selectedTable.csv');
      print('$dir/$_selectedTable.csv');
      await file.writeAsString(csv);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data exported successfully'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a table to export'),
      ));
    }
  }

  Future<void> _importData(FilePickerResult? result) async {
    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      File pickedFile = File(file.path!);
      String csvString = await pickedFile.readAsString();
      List<List<dynamic>> csvData = CsvToListConverter().convert(csvString);
      List<String> headerRow = csvData[0].map((e) => e.toString()).toList();
      // Assuming first row is the header
      // Map CSV columns to database columns
      // You might need to implement a UI for this step
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
        await widget.database.insert(_selectedTable!, mappedRow);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data imported successfully'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Export / Import Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Export Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedTable,
              hint: Text('Select a table'),
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
            ElevatedButton(
              onPressed: _exportData,
              child: Text('Export'),
            ),
            SizedBox(height: 20),
            Text(
              'Import Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['csv'],
                );
                _importData(result);
              },
              child: Text('Select CSV File'),
            ),
          ],
        ),
      ),
    );
  }
}
