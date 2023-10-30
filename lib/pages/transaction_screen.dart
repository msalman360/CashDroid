import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: subtitleController,
              decoration: InputDecoration(labelText: 'Subtitle'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Add Transaction'),
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    subtitleController.text.isNotEmpty &&
                    amountController.text.isNotEmpty &&
                    _isValidDouble(amountController.text)) {

                  final transaction = Transaction(
                    title: titleController.text,
                    subtitle: subtitleController.text,
                    amount: double.parse(amountController.text) * -1, // Convert to negative for deduction
                    date: DateTime.now(),
                  );
                  context.read<BudgetData>().addTransaction(transaction);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill out all fields correctly!')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _isValidDouble(String value) {
    try {
      double.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }
}

class Transaction {
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;

  Transaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
  });
}

class Account {
  double balance = 10000.0; // Initial balance for the account
}

class BudgetData with ChangeNotifier {
  final Account account = Account();
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);

    // Deduct the transaction amount from the account balance
    account.balance += transaction.amount;

    notifyListeners(); // Notify listeners about the change
  }
}
