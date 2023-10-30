import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import '../database_helper.dart';

class Transaction {
  final int id;
  final double amount;
  final String category;
  final DateTime dateTime;
  final String type;
  final String account;

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.dateTime,
    required this.type,
    required this.account,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'dateTime': dateTime.toIso8601String(),
      'type': type,
      'account': account,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      category: map['category'],
      dateTime: DateTime.parse(map['dateTime']),
      type: map['type'],
      account: map['account'],
    );
  }
}

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double amount = 0.0;
  String category = '';
  DateTime dateTime = DateTime.now();
  String type = 'Expense';
  String account = 'Cash';
  int id = 0;

  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'id DESC',
      limit: 10,
    );
    setState(() {
      transactions = List.generate(maps.length, (i) {
        return Transaction.fromMap(maps[i]);
      });
    });
  }

  void saveTransactions() async {
    // You can save transactions in the local database
    // using the addTransaction method as shown earlier.
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final transaction = Transaction(
        amount: amount,
        category: category,
        dateTime: dateTime,
        type: type,
        account: account,
        id: id,
      );

      setState(() {
        id++; // Generate a unique ID for each transaction
        transactions.add(transaction);
        addTransaction(transaction); // Add transaction to the database
      });

      // Clear the form
      _formKey.currentState!.reset();
      amount = 0.0;
      dateTime = DateTime.now();
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('transactions', transaction.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    amount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Category'),
                onChanged: (value) {
                  setState(() {
                    category = value;
                  });
                },
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTime,
                initialValue: dateTime.toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Date and Time',
                onChanged: (val) {
                  setState(() {
                    dateTime = DateTime.parse(val);
                  });
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Type'),
                value: type,
                items: ['Income', 'Expense'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    type = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Account'),
                value: account,
                items: ['Cash', 'Bank', 'Credit Card'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    account = value!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save Transaction'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text('${transaction.category}'),
                        subtitle: Text('${transaction.type}'),
                        trailing: Text("PKR ${transaction.amount.toStringAsFixed(2)}"),
                        // Showing formatted date
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TransactionPage(),
  ));
}
