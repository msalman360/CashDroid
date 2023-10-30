
import 'package:cash_droid/pages/accounts_page.dart';
import 'package:cash_droid/pages/add_screen.dart';
import 'package:cash_droid/pages/categories.dart';
import 'package:cash_droid/pages/chart.dart';
import 'package:cash_droid/pages/daily_page.dart';
import 'package:cash_droid/pages/profile_page.dart';
import 'package:cash_droid/pages/settings_page.dart';
import 'package:cash_droid/pages/stats_page.dart';
import 'package:cash_droid/pages/trans.dart';
import 'package:cash_droid/scoped_model/expenseScope.dart';

import 'package:cash_droid/widgets/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AccountProvider()), // Add your AccountProvider
        // ChangeNotifierProvider(create: (context) => TransactionProvider()), // Add your AccountProvider
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InitialLogoScreen(),
    );
  }
}

class InitialLogoScreen extends StatefulWidget {
  @override
  _InitialLogoScreenState createState() => _InitialLogoScreenState();
}

class _InitialLogoScreenState extends State<InitialLogoScreen> {
  @override
  void initState() {
    super.initState();

    // Simulate a delay to display the initial logo
    Future.delayed(Duration(seconds: 2), () {
      // After the delay, navigate to the OnboardingScreen or HomeScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Display the initial logo
        child: Image.asset('assets/images/cashdroid.png'),
      ),
    );
  }
}

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int _selectedIndex = 0;
  GlobalKey key = GlobalKey();
  static final List<Widget Function()> _widgetOptions = <Widget Function()>[
        () => AccountPage(), // Use a lambda function
        () =>  TransactionPage(),
        () => StatsPage(),
        () => ProfilePage(), // Add the CategoryPage
  ];



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Cash Droid'),
      // ),
      body: Center(
        child: _widgetOptions[_selectedIndex](),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on), // Change to an appropriate budget icon
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,        // Set the selected item color to blue
        unselectedItemColor: Colors.grey,      // Set the unselected item color to grey or any other color you prefer
      ),

    );
  }

}
