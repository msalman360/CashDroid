import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class Expense {
  final int id;
  final String date;
  final String person;
  final String item;
  final String category;
  final String amount;
  final Map<String, String> sharedBy;

  Expense({
    required this.id,
    required this.date,
    required this.person,
    required this.item,
    required this.category,
    required this.amount,
    required this.sharedBy,
  });
}

class ExpenseModel extends Model {
  List<Expense> expenses = [];
  ExpenseModel yourExpenseModel = ExpenseModel();
  void updateExpenses(List<Expense> updatedExpenses) {
    expenses = updatedExpenses;
  }// Replace 'ExpenseModel' with your actual model class name

  ExpenseModel() {
    setInitValues();
  }

  List<String> _categories = [];
  List<String> _users = [];
  List<Map<String, dynamic>> _expenses = [];
  String _currentMonth = '1';

  List<Map<String, dynamic>> get getExpenses => _expenses;
  List<String> get getCategories => _categories;
  List<String> get getUsers => _users;
  String get getCurrentMonth => _currentMonth;

  void setUsers(List<String> userList) {
    _users = userList;
    upDateUserData(true, false, false, false);
    notifyListeners();
  }

  void setCategories(List<String> categoryList) {
    _categories = categoryList;
    upDateUserData(false, true, false, false);
    notifyListeners();
  }

  void resetAll() {
    _categories = [];
    _users = [];
    _expenses = [];
    notifyListeners();
  }

  void addExpense(Map<String, dynamic> newExpenseEntry) {
    _expenses.insert(0, newExpenseEntry);
    sortExpenses();
    upDateUserData(false, false, true, false);
    notifyListeners();
  }

  void deleteExpense(int index) {
    _expenses.removeAt(index);
    sortExpenses();
    upDateUserData(false, false, true, false);
    notifyListeners();
  }

  void editExpense(int index, Map<String, dynamic> updatedExpenseEntry) {
    _expenses[index] = updatedExpenseEntry;
    sortExpenses();
    upDateUserData(false, false, true, false);
    notifyListeners();
  }

  void setCurrentMonth(String cMonth) {
    _currentMonth = cMonth;
    upDateUserData(false, false, false, true);
    calculateShares();
    notifyListeners();
  }

  Future<void> setInitValues() async {
    if (!kReleaseMode) {
      testData();
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    _users = prefs.getStringList('users') ?? [];
    _categories = prefs.getStringList('categories') ?? [];
    _currentMonth = prefs.getString('currentMonth') ?? '1';
    if (_users.isNotEmpty && _categories.isNotEmpty) {
      final expensesString = prefs.getString('expenses');
      if (expensesString != null) {
        _expenses = (json.decode(expensesString) as Iterable)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      } else {
        _expenses = [];
      }
    } else {
      _expenses = [];
    }
    notifyListeners();
  }

  Future<void> upDateUserData(bool u, bool c, bool e, bool d) async {
    final prefs = await SharedPreferences.getInstance();
    if (e) await prefs.setString('expenses', json.encode(_expenses));
    if (u) await prefs.setStringList('users', _users);
    if (c) await prefs.setStringList('categories', _categories);
    if (d) await prefs.setString('currentMonth', _currentMonth);
  }

  void newDataLoaded(List<String> uList, List<String> cList, List<Map<String, dynamic>> exList) {
    _users = uList;
    _categories = cList;
    _expenses = exList;
    upDateUserData(true, true, true, false);
    notifyListeners();
  }

  Map<String, Map<String, double>> calculateShares() {
    Map<String, Map<String, double>> tmpStats = {
      "Total Spends": {for (var v in _users) v: 0},
      "Total Owe": {for (var v in _users) v: 0},
      "Net Owe": {for (var v in _users) v: 0}
    };

    for (Map entry in _expenses) {
      String month = int.parse(entry['date'].split('-')[1]).toString();

      if (_currentMonth != '13' && _currentMonth != month) {
        continue;
      }
      double amount = double.parse(entry["amount"]);
      tmpStats["Total Spends"]?[entry["person"]] = amount;
      for (MapEntry val in entry["shareBy"].entries) {
        tmpStats["Total Owe"]?[val.key] = double.parse(val.value);
        tmpStats["Net Owe"]?[val.key] = double.parse(val.value);
      }
    }

    for (String u in _users) {
      tmpStats["Net Owe"]?[u] = tmpStats["Total Owe"]![u]! - tmpStats["Total Spends"]![u]!;
    }

    return tmpStats;
  }

  Map calculateCategoryShare() {
    Map<String, double> cShare = {for (var v in _categories) v: 0};
    for (Map entry in _expenses) {
      String month = int.parse(entry['date'].split('-')[1]).toString();

      if (_currentMonth != '13' && _currentMonth != month) {
        continue;
      }
      cShare[entry['category']] = double.parse(entry['amount']);
    }

    Map pieData = <String, double>{};
    for (String en in _categories) {
      pieData[en + " Rs ${cShare[en]}"] = cShare[en];
    }
    return pieData;
  }

  void sortExpenses() {
    _expenses.sort((a, b) => a['date'].compareTo(b['date']));
  }

  void testData() {
    _categories = ["Bills", "Food", "Misc"];
    _users = ["John", "Sam", "Will"];

    _expenses = [
      {
        "date": "01-03-2021",
        "person": "Sam",
        "item": "Groceries",
        "category": "Food",
        "amount": "300",
        "shareBy": {"Sam": "100", "Will": "100", "John": "100"}
      },
      // Add your test data here...
    ];
  }
}
