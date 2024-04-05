import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'
if (dart.library.html) 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:testbaulog/screens/email_templates_page.dart';

import 'helpers/database_helper.dart';
import 'screens/appointments_page.dart';
import 'screens/email_page.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/order_page.dart';
import 'screens/rooms_page.dart';
import 'screens/settings_page.dart';
import 'theme/baulog_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await initializeDatabase();
  //createAppointmentTable(database);
  printAppointments(database);
  createLevelEntry('Etage 1', 1, database);
  createLevelEntry('Etage 2', 1, database);
  runApp(MyApp(database: database));
}

Future<void> createLevelEntry(String name, int buildingId,database) async {
  final DatabaseHelper dbHelper = DatabaseHelper(database: database);
  try {
    await dbHelper.insertLevel(name,buildingId);
  } catch (e) {
    print('Error creating Level Entry: $e');
  }
}



Future<Database> initializeDatabase() async {
  late Database database;

  if (kIsWeb) {
    var data = await rootBundle.load('assets/baulog.db');
    data.buffer.asUint8List();
    database = await databaseFactoryFfiWeb.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await DatabaseHelper(database: db).createTablesIfNotExists();
        },
      ),
    );
  } else {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "baulog.db");
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load(join('assets', 'baulog.db'));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }
    database = await openDatabase(path);
  }

  DatabaseHelper databaseHelper = DatabaseHelper(database: database);
  await databaseHelper.createTablesIfNotExists();
  databaseHelper.printAppointmentTableSchema();
  //await databaseHelper.insertUser('l', 'l');
  return database;
}

Future<void> printAppointments(database) async {
  DatabaseHelper databaseHelper = DatabaseHelper(database: database);
  List<Map<String, dynamic>> appointments = await databaseHelper.fetchAppointments(); // Annahme: getAppointments ist eine Methode, um alle Termine aus der Datenbank abzurufen
  for (var appointment in appointments) {
    print('Appointment: $appointment');
  }
}

void createAppointmentTable(Database database) async {
  try {
    await database.execute('''      
      
      ALTER TABLE APPOINTMENT
      ADD COLUMN location TEXT;
    ''');
    var databaseHelper = DatabaseHelper(database: database);
    databaseHelper.printAppointmentTableSchema();
    print('APPOINTMENT table altered successfully.');
  } catch (e) {
    print('Error altering APPOINTMENT table: $e');
  }
}



class MyApp extends StatelessWidget {
  final Database database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BauLog',
      initialRoute: '/login',
      routes: {
        '/': (context) => AppWrapper(child: HomePage(database: database)),
        '/login': (context) => AppWrapper(child: LoginPage(database: database)),
        '/mail': (context) => AppWrapper(child: EmailPage(database: database)),
        '/templates': (context) => AppWrapper(child: EmailTemplatesPage(database: database)),
        '/termine': (context) => AppWrapper(child: AppointmentsPage(database: database)),
        '/rooms': (context) => AppWrapper(child: RoomsPage(database: database)),
        '/order': (context) => AppWrapper(child: OrderPage(database: database)),
        '/einstellungen': (context) => AppWrapper(child: SettingsPage(database: database)),
      },
      theme: BauLogTheme.getTheme(),
    );
  }
}

class AppWrapper extends StatelessWidget {
  final Widget child;

  const AppWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - kToolbarHeight,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
