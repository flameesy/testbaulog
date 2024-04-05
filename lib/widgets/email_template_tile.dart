import 'package:flutter/material.dart';

class EmailTemplateTile extends StatelessWidget {
  final Map<String, dynamic> template;
  final VoidCallback onTap;

  const EmailTemplateTile({Key? key, required this.template, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(template['name'] ?? ''),
      subtitle: Text(template['subject'] ?? ''),
      onTap: onTap,
    );
  }
}
