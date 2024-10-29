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
import 'package:testbaulog/screens/export_import_page.dart';
import 'package:testbaulog/screens/todayortomorrowappointments_page.dart';

import 'helpers/database_helper.dart';
import 'screens/appointments_page.dart';
import 'screens/email_page.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/order_page.dart';
import 'screens/rooms_page.dart';
import 'theme/baulog_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await initializeDatabase();
  runApp(MyApp(database: database));
}

Future<Database> initializeDatabase() async {
  late Database database;

  if (kIsWeb) {
    // Web-spezifische Initialisierung
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
    // Pfad für die mobile Datenbank
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "baulog.db");

    // Löschen der alten Datenbank, falls vorhanden
    //if (await File(path).exists()) {
    //  await File(path).delete();
    //}

    // Datenbank neu erstellen
    ByteData data = await rootBundle.load(join('assets', 'baulog.db'));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);

    database = await openDatabase(path);
  }

  DatabaseHelper databaseHelper = DatabaseHelper(database: database);
  await databaseHelper.createTablesIfNotExists();
  await databaseHelper.insertExampleData();
  await databaseHelper.insertUser('demo', '134');
  await databaseHelper.insertUser('oli', 'passwort');

  return database;
}


Future<void> printEmailTemplates(databaseHelper) async {
  try {
    final List<Map<String, dynamic>> emailTemplates = await databaseHelper.fetchItems('APPOINTMENT');
    for (var template in emailTemplates) {
      print(template); // Gibt jeden Datensatz in der Liste aus
    }
  } catch (error) {
    print('Error fetching email templates: $error');
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
        '/einstellungen': (context) => AppWrapper(child: ExportImportPage(database: database)),
        '/termineheute': (context) => AppWrapper(child: TodayOrTomorrowAppointmentsPage(database: database)),
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
              maxHeight: MediaQuery.of(context).size.height - 24,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
