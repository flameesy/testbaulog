import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'order_form_page.dart';
import 'order_list_view.dart';

class OrderPage extends StatelessWidget {
  final Database database;

  const OrderPage({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order Page'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'View Orders'),
              Tab(text: 'Create Order'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrderListView(database: database),
            OrderFormPage(database: database),
          ],
        ),
      ),
    );
  }
}
