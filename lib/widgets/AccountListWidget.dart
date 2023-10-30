import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AccountListWidget extends StatelessWidget {
  final List<CustomerAccount> customerAccounts;

  AccountListWidget(this.customerAccounts);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: customerAccounts.length,
      itemBuilder: (context, index) {
        final account = customerAccounts[index];
        return ListTile(
          title: Text(account.name),
          subtitle: Text('Balance: \$${account.balance.toStringAsFixed(2)}'),
        );
      },
    );
  }
}
class CustomerAccount {
  final String name;
  final double balance;

  CustomerAccount({
    required this.name,
    required this.balance,
  });
}