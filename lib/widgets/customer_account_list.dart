import 'package:flutter/material.dart';

class CustomerAccountList extends StatelessWidget {
  final List<CustomerAccount> customerAccounts;

  CustomerAccountList({required this.customerAccounts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: customerAccounts.length,
      itemBuilder: (context, index) {
        final account = customerAccounts[index];
        return ListTile(
          title: Text(account.customerName),
          subtitle: Text('Balance: \$${account.accountBalance.toStringAsFixed(2)}'),
        );
      },
    );
  }
}

class CustomerAccount {
  final String customerName;
  double accountBalance;

  CustomerAccount(this.customerName, this.accountBalance);
}
