// ignore_for_file: unnecessary_null_comparison

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:cash_droid/database_helper.dart';





class AccountPage extends StatefulWidget {
  final dbHelper = DatabaseHelper.instance;
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _accountNameController = TextEditingController();
  TextEditingController _accountTypeController = TextEditingController();
  TextEditingController _balanceController = TextEditingController();
  NumberFormat currencyFormat = NumberFormat.currency(symbol: 'PKR');

  // ignore: unused_element
  void _showAddAccountDialog(AccountProvider accountProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Account"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _accountNameController,
                  decoration: InputDecoration(
                    labelText: 'Account Name',
                    hintText: 'e.g., Savings Account',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an account name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _accountTypeController,
                  decoration: InputDecoration(
                    labelText: 'Account Type',
                    hintText: 'e.g., Checking',
                  ),
                ),
                TextFormField(
                  controller: _balanceController,
                  decoration: InputDecoration(
                    labelText: 'Balance',
                    hintText: 'e.g., 1000.00',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Add"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Account newAccount = Account(
                    accountName: _accountNameController.text,
                    accountType: _accountTypeController.text,
                    balance: double.parse(_balanceController.text), name: '', id:0,
                  );

                  // Use the provider to add the account
                  accountProvider.addAccount(newAccount);

                  _clearForm();
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                _clearForm();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    _accountNameController.clear();
    _accountTypeController.clear();
    _balanceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accounts"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Consumer<AccountProvider>( // Use Consumer to access account data
            builder: (context, accountProvider, child) {
              double totalBalance = accountProvider.getTotalBalance();

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.all(16),
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue, Colors.deepPurple],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Total Balance",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "${currencyFormat.format(totalBalance)}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: Consumer<AccountProvider>( // Use Consumer to access account data
              builder: (context, accountProvider, child) {
                return ListView.builder(
                  itemCount: accountProvider.accounts.length,
                  itemBuilder: (context, index) {
                    return _buildAccountCard(accountProvider.accounts[index]);
                  },
                );
              },
            ),
          ),
          // Stylish Add Account Form
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.all(16),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: _accountNameController,
                      decoration: InputDecoration(
                        labelText: 'Account Name',
                        hintText: 'e.g., Savings Account',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an account name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _accountTypeController,
                      decoration: InputDecoration(
                        labelText: 'Account Type',
                        hintText: 'e.g., Checking',
                      ),
                    ),
                    TextFormField(
                      controller: _balanceController,
                      decoration: InputDecoration(
                        labelText: 'Balance',
                        hintText: 'e.g., 1000.00',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Account newAccount = Account(
                            accountName: _accountNameController.text,
                            accountType: _accountTypeController.text,
                            balance: double.parse(_balanceController.text), name: '', id: 0,
                          );

                          // Use the provider to add the account
                          Provider.of<AccountProvider>(context, listen: false).addAccount(newAccount);


                          _clearForm();
                        }
                      },
                      child: Text('Add Account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(Account account) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(account.accountName),
        subtitle: Text(account.accountType),
        trailing: Text("${currencyFormat.format(account.balance)}"),
      ),
    );
  }
}


class Account {
  int id;

  // Add an ID to uniquely identify accounts
  final String accountName;
  final String name;
  final String accountType;
  late final double balance;

  Account({
    required this.id,
    required this.accountName,
    required this.accountType,
    required this.balance,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'accountName': accountName,
      'accountType': accountType,
      'balance': balance,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }





  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      accountName: map['accountName'],
      accountType: map['accountType'],
      balance: map['balance'],
      name: map['name'],
    );
  }
}


class AccountProvider with ChangeNotifier {
  final dbHelper = DatabaseHelper.instance;
  List<Account> _accounts = [];

  List<Account> get accounts => _accounts;




  Future<void> addAccount(Account account) async {
    // ignore: unused_local_variable
    final id = await dbHelper.insert(account.toMap());
    _accounts.add(Account(id: id, accountName: account.accountName, accountType: account.accountType, balance: account.balance, name: account.name));
    notifyListeners();
  }

  Future<void> updateBalance(String accountName, double newBalance) async {
    final account = _accounts.firstWhere((acc) => acc.name == accountName);
    account.balance = newBalance;
    await dbHelper.update(account.toMap());
    notifyListeners();
  }

  Future<void> removeAccount(String accountName) async {
    // Find the account by name
    Account? accountToRemove = _accounts.firstWhereOrNull((acc) => acc.name == accountName);




    // If found, delete it from the list and the database
    _accounts.remove(accountToRemove);
    await dbHelper.delete(accountToRemove!.id);
  }

  double getTotalBalance() {
    double total = 0.0;
    for (var account in _accounts) {
      total += account.balance;
    }
    return total;
  }


  Account getAccountByName(String accountName) {
    return _accounts.firstWhere( (acc) => acc.name == accountName, orElse: () => Account( id: 1, name: accountName, balance: 0.0, accountName: 'name', accountType: '' ), );  }
  static AccountProvider instance(BuildContext context, {bool listen = false}) {
    return Provider.of<AccountProvider>(context, listen: listen);
  }
}
class YourWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the AccountProvider using the instance() getter
    final accountProvider = AccountProvider.instance(context);

    // Create a new account
    final newAccount = Account(
      accountName: 'Savings',
      accountType: 'Savings Account',
      balance: 1000.0,
      name: '',
      id: 1,
    );
    Provider.of<AccountProvider>(context, listen: false).addAccount(newAccount);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Widget'),
      ),
      body: Column(
        children: [
          // Display account data
          Text('Account Name: ${newAccount.accountName}'),
          Text('Account Type: ${newAccount.accountType}'),
          Text('Balance: \$${newAccount.balance.toStringAsFixed(2)}'),

          // Button to add the new account
          ElevatedButton(
            onPressed: () {
              // Add the new account to the AccountProvider
              accountProvider.addAccount(newAccount);
            },
            child: Text('Add Account'),
          ),
        ],
      ),
    );
  }
}
