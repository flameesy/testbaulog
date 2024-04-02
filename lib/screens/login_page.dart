import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../helpers/database_helper.dart';
// Import AddAppointmentPage

class LoginPage extends StatefulWidget {
  final Database database;

  const LoginPage({super.key, required this.database});

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
                  Navigator.pushReplacementNamed(context, '/');
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Deaktiviere die Zurücknavigation
    ModalRoute.of(context)?.removeScopedWillPopCallback(_onWillPop);
    ModalRoute.of(context)?.addScopedWillPopCallback(_onWillPop);
  }

  Future<bool> _onWillPop() async {
    return false; // Blockiere das Zurücknavigieren
  }
}
