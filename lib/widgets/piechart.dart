import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final double income;
  final double expenses;

  PieChartWidget({required this.income, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Set the width as needed
      height: 200, // Set the height as needed
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.green, // Color for income
              value: income,
              title: 'Income',
            ),
            PieChartSectionData(
              color: Colors.red, // Color for expenses
              value: expenses,
              title: 'Expenses',
            ),
          ],
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          startDegreeOffset: 180,
        ),
      ),
    );
  }
}
