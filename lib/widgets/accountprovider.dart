import 'package:flutter/material.dart';
import '../pages/accounts_page.dart';
import 'package:provider/provider.dart';

class AccountsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the AccountProvider using Provider.of
    final accountProvider = Provider.of<AccountProvider>(context);

    // Create a new account
    final newAccount = Account(
      accountName: 'Savings',
      accountType: 'Savings Account',
      balance: 1000.0, name: '', id: 1,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts Page'),
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
