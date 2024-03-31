// login_page.dart

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../helpers/database_helper.dart';
import '../screens/add_appointment_page.dart'; // Import AddAppointmentPage

class LoginPage extends StatefulWidget {
  final Database database;

  const LoginPage({Key? key, required this.database}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                final String email = _emailController.text.trim();
                final String password = _passwordController.text.trim();

                // Authenticate user
                final DatabaseHelper dbHelper = DatabaseHelper(database: widget.database);
                final bool isAuthenticated = await dbHelper.authenticateUser(email, password);
                if (isAuthenticated) {
                  // Navigate to the main screen upon successful authentication
                  Navigator.pushReplacementNamed(context, '/termine');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid email or password.'),
                    ),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
