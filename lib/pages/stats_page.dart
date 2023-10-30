// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> with SingleTickerProviderStateMixin {
  late Map<String, double> pieData;
  late TabController _controller;
  late int selectedMonth;


  @override
  void initState() {
    selectedMonth = DateTime.now().month; // Start with the current month

    super.initState();
    int currentMonthIndex = getCurrentMonth() - 1; // Subtracting 1 because lists are 0-based
    _controller = TabController(vsync: this, length: 13, initialIndex: 0);
    pieData = {
      'Food': 500,
      'Fuel': 2000,
      'Internet': 2500,
      'Insurance': 5000,
    };
  }
  int getCurrentMonth() {
    return DateTime.now().month; // This will return a value between 1 and 12
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  Widget getBody() {
    Map<String, String> months = {
      "1": "January",
      "2": "February",
      "3": "March",
      "4": "April",
      "5": "May",
      "6": "June",
      "7": "July",
      "8": "August",
      "9": "September",
      "10": "October",
      "11": "November",
      "12": "December",
      "13": "All"
    };

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.01),
                spreadRadius: 10,
                blurRadius: 3,
              ),
            ],
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.green],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Report",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.black38, width: 1.5)),
                        ),
                        child: TabBar(
                          controller: _controller,
                          onTap: _updateMonthTab,
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.black,
                          isScrollable: true,
                          tabs: List.generate(
                            months.length,
                                (i) => Tab(
                              child: Text(
                                months.values.toList()[i],
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      Container(
                        child: PieChart(
                          dataMap: pieData,
                          animationDuration: Duration(milliseconds: 800),
                          chartLegendSpacing: 32, // Increased spacing for category legends
                          chartRadius: MediaQuery.of(context).size.width / 1.5, // Enlarged circle
                          initialAngleInDegree: 0,
                          chartType: ChartType.disc,
                          ringStrokeWidth: 32, // Adjusted to suit the enlarged circle
                          legendOptions: LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.bottom, // Categories display below
                            showLegends: true,
                            legendTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          chartValuesOptions: ChartValuesOptions(
                            showChartValueBackground: false,
                            showChartValues: true,
                            showChartValuesInPercentage: true,
                            showChartValuesOutside: false,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _updateMonthTab(int v) {
    setState(() {
      // Update data based on selected month
    });
  }
}
