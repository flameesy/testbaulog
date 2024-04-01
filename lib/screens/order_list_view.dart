import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class OrderListView extends StatefulWidget {
  final Database database;

  const OrderListView({Key? key, required this.database}) : super(key: key);

  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  List<Map<String, dynamic>> _orders = []; // List to store orders retrieved from the database

  @override
  void initState() {
    super.initState();
    fetchOrders(); // Fetch orders when the widget initializes
  }

  Future<void> fetchOrders() async {
    try {
      final List<Map<String, dynamic>> orders = await widget.database.query('ORDER'); // Query the 'ORDER' table
      setState(() {
        _orders = orders; // Update the list of orders
      });
    } catch (e) {
      print('Error fetching orders: $e');
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return _orders.isNotEmpty
        ? ListView.builder(
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        return ListTile(
          title: Text('Bestellnummer: ${order['order_number']}'),
          subtitle: Text('Kontakt-Email: ${order['contact_email']}'),
          // Add more order details here
        );
      },
    )
        : Center(
      child: Text('Keine Bestellungen vorhanden'),
    );
  }
}
