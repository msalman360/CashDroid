
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database_helper.dart';

class Account {
  late final int? id; // Add the id field
  final String name;
  double balance;

  Account({
    this.id, // Add the id parameter
    required this.name,
    required this.balance,
  });

  // Convert an Account to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
    };
  }

  // Create an Account from Map
  static Account fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'], // Map the id field
      name: map['name'],
      balance: map['balance'],
    );
  }
}


class AccountProvider with ChangeNotifier {
  final DatabaseHelper databaseHelper = DatabaseHelper.instance; // Initialize your database helper

  List<Account> _accounts = [];

  List<Account> get accounts => _accounts;

  // Load accounts from the local database during provider initialization
  AccountProvider() {
    _loadAccountsFromDatabase();
  }

  // Load accounts from the local database
  void _loadAccountsFromDatabase() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> accountMaps = await db.query('accounts');

    _accounts = accountMaps.map((accountMap) => Account.fromMap(accountMap)).toList().cast<Account>();

    notifyListeners();
  }


  // Add an account to the local database and update the provider
  Future<void> addAccount(Account account) async {
    final db = await databaseHelper.database;
    final id = await db.insert('accounts', account.toMap());

    // Set the generated ID on the account and add it to the provider
    account.id = id;
    _accounts.add(account);

    notifyListeners();
  }

  void updateBalance(String accountName, double newBalance, int id) {
    final account = _accounts.firstWhere((acc) => acc.name == accountName,
        orElse: () => Account(name: accountName, balance: newBalance, id: id));
    account.balance = newBalance;
    notifyListeners();
  }

  void removeAccount(String accountName) {
    final account = _accounts.firstWhere( (acc) => acc.name == accountName, orElse: () => Account(name: accountName, balance: 0.0)); // Create a default Account here );
    _accounts.remove(account);
    final db = databaseHelper.database;
    db.then((value) => value.delete('accounts', where: 'id = ?', whereArgs: [account.id]));

    notifyListeners();
  }



  double getTotalBalance() {
    double totalBalance = 0;

    for (Account account in _accounts) {
      totalBalance += account.balance;
    }

    return totalBalance;
  }

  Account getAccountByName(String accountName) {
    return _accounts.firstWhere((acc) => acc.name == accountName, orElse: () => Account(name: accountName, balance: 0));
  }

  static AccountProvider instance(BuildContext context, {bool listen = false}) {
    return Provider.of<AccountProvider>(context, listen: listen);
  }
}
