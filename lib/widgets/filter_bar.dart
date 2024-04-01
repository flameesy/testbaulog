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
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              widget.onSearchChanged(value); // Call the callback function with the search query
            },
            decoration: const InputDecoration(
              hintText: 'Suche...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () {
            _showSortOptions(context);
          },
        ),
      ],
    );
  }

  void _showSortOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sortieren nach'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildSortOption('Option 1', 'option1'),
                _buildSortOption('Option 2', 'option2'),
                _buildSortOption('Option 3', 'option3'),
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
      trailing: _selectedSortOption == option ? const Icon(Icons.check) : null,
    );
  }
}
