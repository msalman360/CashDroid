
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PieChartPage extends StatelessWidget {
  final DateTime selectedMonth;

  PieChartPage({required this.selectedMonth});

  @override
  Widget build(BuildContext context) {
    // Use the selectedMonth to display the pie chart for the chosen month
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Pie Chart'),
      ),
      body: Center(
        child: Text('Display Pie Chart for ${DateFormat.yMMMM().format(selectedMonth)}'), // Example text
      ),
    );
  }
}
