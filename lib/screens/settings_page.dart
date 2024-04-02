import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required Database database});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Color _themeColor = Colors.blue; // Default theme color
  double _fontSize = 16.0; // Default font size
  double _zoomLevel = 1.0; // Default zoom level

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
              style: Theme.of(context).textTheme.titleLarge,
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
              style: Theme.of(context).textTheme.titleLarge,
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
              style: Theme.of(context).textTheme.titleLarge,
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
}

class ColorPicker extends StatelessWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({
    super.key,
    required this.currentColor,
    required this.onColorChanged,
  });

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
