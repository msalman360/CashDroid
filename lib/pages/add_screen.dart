import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Transaction {
  final double amount;
  final String category;
  final DateTime dateTime;
  final bool isIncome;

  Transaction({
    required this.amount,
    required this.category,
    required this.dateTime,
    required this.isIncome,
  });
}

// class TransactionProvider with ChangeNotifier {
//   List<Transaction> _transactions = [];
//
//   List<Transaction> get transactions => _transactions;
//
//   void addTransaction(Transaction transaction) {
//     _transactions.add(transaction);
//     notifyListeners();
//   }
//
//   void removeTransaction(int index) {
//     if (index >= 0 && index < _transactions.length) {
//       _transactions.removeAt(index);
//       notifyListeners();
//     }
//   }
// }

class IncomeExpensePage extends StatefulWidget {
  @override
  _IncomeExpensePageState createState() => _IncomeExpensePageState();
}

class _IncomeExpensePageState extends State<IncomeExpensePage> {

  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedCategory = 'Category 1'; // Default category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: Column(
        children: [
          // List of transactions here
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openTransactionForm(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _openTransactionForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Transaction',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: TextEditingController(text: selectedCategory),
                  decoration: InputDecoration(labelText: 'Category'),
                  onChanged: (value) {
                    selectedCategory = value;
                  },
                ),
                Row(
                  children: [
                    Text(
                      'Date: ${DateFormat('MM/dd/yyyy').format(selectedDate)}',
                    ),
                    TextButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: Text(
                        'Select Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final transaction = Transaction(
                        amount: double.parse(amountController.text),
                        category: selectedCategory,
                        dateTime: selectedDate,
                        isIncome: false, // Hard-coded as an expense
                      );

                      // final transactionProvider =
                      // // Provider.of<TransactionProvider>(context, listen: false);
                      // transactionProvider.addTransaction(transaction);

                      Navigator.pop(context);
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
