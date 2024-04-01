import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Function(String) onSortChanged;

  const FilterBar({
    Key? key,
    required this.onSearchChanged,
    required this.onSortChanged,
  }) : super(key: key);

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  String _searchQuery = '';
  String _selectedSortOption = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.grey[200], // Background color
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                widget.onSearchChanged(value); // Call the callback function with the search query
              },
              decoration: InputDecoration(
                hintText: 'Suche...',
                filled: true,
                fillColor: Colors.white, // Text field background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none, // Hide border
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(width: 8.0), // Spacer
          InkWell(
            onTap: () {
              _showSortOptions(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sortieren nach',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4.0),
                Icon(Icons.sort),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sortieren nach',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildSortOption('Startzeit', 'option1'),
                _buildSortOption('Text', 'option2'),
                _buildSortOption('Dauer', 'option3'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String label, String option) {
    return ListTile(
      title: Text(label),
      onTap: () {
        setState(() {
          _selectedSortOption = option;
        });
        widget.onSortChanged(option); // Call the callback function with the selected sorting option
        Navigator.pop(context);
      },
      trailing: _selectedSortOption == option ? Icon(Icons.check) : null,
    );
  }
}
