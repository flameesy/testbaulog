import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import '../helpers/database_helper.dart';
import '../helpers/export_csv.dart';
import 'package:file_picker/file_picker.dart';

class SettingsPage extends StatefulWidget {
  final Database database;

  const SettingsPage({Key? key, required this.database}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Color _themeColor = Colors.blue; // Default theme color
  double _fontSize = 16.0; // Default font size
  double _zoomLevel = 1.0; // Default zoom level
  String _exportPath = ''; // Path for CSV export

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Color:',
              style: Theme.of(context).textTheme.headline6,
            ),
            ColorPicker(
              currentColor: _themeColor,
              onColorChanged: (Color color) {
                setState(() {
                  _themeColor = color;
                });
              },
            ),
            const SizedBox(height: 20.0),
            Text(
              'Font Size:',
              style: Theme.of(context).textTheme.headline6,
            ),
            Slider(
              value: _fontSize,
              min: 10.0,
              max: 30.0,
              onChanged: (double value) {
                setState(() {
                  _fontSize = value;
                });
              },
            ),
            const SizedBox(height: 20.0),
            Text(
              'Zoom Level:',
              style: Theme.of(context).textTheme.headline6,
            ),
            Slider(
              value: _zoomLevel,
              min: 0.5,
              max: 2.0,
              onChanged: (double value) {
                setState(() {
                  _zoomLevel = value;
                });
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Save settings to JSON file and database
                _saveSettings();
              },
              child: const Text('Save Settings'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Export database to CSV
                await _exportToCSV();
              },
              child: const Text('Export to CSV'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveSettings() {
    // Save settings to JSON file
    _saveSettingsToJson();

    // Save settings to database
    _saveSettingsToDatabase();
  }

  void _saveSettingsToJson() {
    // Implement saving settings to JSON file
  }

  void _saveSettingsToDatabase() {
    // Implement saving settings to database
  }

  Future<void> _exportToCSV() async {
    try {
      // Get export path
      _exportPath = await _getExportPath();

      if (_exportPath.isNotEmpty) {
        // Export each table to CSV
        final List<String> tableNames = await widget.database
            .query('sqlite_master', where: 'type = ?', whereArgs: ['table'])
            .then((tables) =>
            tables.map<String>((table) => table['name'] as String).toList());

        for (final tableName in tableNames) {
          final exportCSV = ExportCSV(tableName, widget.database);
          await exportCSV.exportTableToCSV(_exportPath, widget.database);
        }

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Export successful'),
          ),
        );
      } else {
        // Show error message if export path is empty
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Export path is empty'),
          ),
        );
      }
    } catch (e) {
      print('Error exporting database: $e');
      // Handle error if needed
    }
  }

  Future<String> _getExportPath() async {
    try {
      final directory = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
      return directory?.path ?? '';
    } catch (e) {
      print('Error getting export path: $e');
      return '';
    }
  }
}

class ColorPicker extends StatelessWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({
    Key? key,
    required this.currentColor,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: currentColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showColorPicker(context);
          },
          child: const Icon(
            Icons.color_lens,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    // Implement color picker dialog
  }
}
