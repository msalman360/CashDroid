import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartPage extends StatefulWidget {
  @override
  _PieChartPageState createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  final List<PieChartSectionData> pieChartSections = [
    PieChartSectionData(
      value: 30, // Value for the first section
      color: Colors.blue, // Color for the first section
      title: 'Category 1', // Title for the first section
      radius: 50, // Radius for the first section
    ),
    PieChartSectionData(
      value: 20, // Value for the second section
      color: Colors.red, // Color for the second section
      title: 'Category 2', // Title for the second section
      radius: 50, // Radius for the second section
    ),
    // Add more sections as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pie Chart Page'),
      ),
      body: Center(
        child: PieChart(
          PieChartData(
            sections: pieChartSections,
            borderData: FlBorderData(show: false),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
          ),
        ),
      ),
    );
  }
}
