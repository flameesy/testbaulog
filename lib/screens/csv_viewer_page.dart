import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class CSVViewerPage extends StatefulWidget {
  final String filePath;

  CSVViewerPage({super.key, required this.filePath});

  @override
  _CSVViewerPageState createState() => _CSVViewerPageState();
}

class _CSVViewerPageState extends State<CSVViewerPage> {
  List<List<dynamic>>? _csvData;

  @override
  void initState() {
    super.initState();
    _loadCSVData();
  }

  Future<void> _loadCSVData() async {
    try {
      File file = File(widget.filePath);
      String fileContent = await file.readAsString();
      List<List<dynamic>> csvData = const CsvToListConverter().convert(fileContent);
      setState(() {
        _csvData = csvData;
      });
    } catch (e) {
      print('Error loading CSV file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSV Viewer'),
      ),
      body: _csvData != null
          ? SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: _csvData![0].map((header) => DataColumn(label: Text(header.toString()))).toList(),
          rows: _csvData!.sublist(1).map((row) {
            return DataRow(cells: row.map((cell) => DataCell(Text(cell.toString()))).toList());
          }).toList(),
        ),
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// Verwendung:
// CSVViewerPage(filePath: '/data/user/0/com.example.baulog/APPOINTMENT.csv');
