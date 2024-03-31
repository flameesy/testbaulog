// main.dart

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:testbaulog/screens/add_appointment_page.dart';
import 'package:testbaulog/screens/settings_page.dart';
import 'screens/login_page.dart';
import 'helpers/database_helper.dart';
import 'theme/baulog_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  databaseFactory = databaseFactoryFfiWeb;
  final Database database = await openDatabase('baulog.db');
  final DatabaseHelper dbHelper = DatabaseHelper(database: database);

  //await dbHelper.createUserTable(); // Ensure USERS table exists
  //await dbHelper.insertUser('test@example.com', 'password123');


  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final Database database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BauLog',
      initialRoute: '/', // Set initial route to login page
      routes: {
        '/': (context) => AddAppointmentPage(database: database),
        '/login': (context) => LoginPage(database: database),
        '/termine': (context) => AddAppointmentPage(database: database),
        '/settings': (context) => SettingsPage(database: database),
        // Add other routes as needed
      },
      theme: BauLogTheme.getTheme(), // Apply BauLogTheme
    );
  }
}
