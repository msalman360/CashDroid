import 'package:cash_droid/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Assuming you've already created the AuthService class as mentioned before
// Import and initialize it in your widget

class YourLoginPage extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: authService.user != null
            ? buildLogoutUI(authService)
            : buildLoginUI(authService),
      ),
    );
  }

  Widget buildLoginUI(AuthService authService) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: usernameController,
          decoration: InputDecoration(labelText: 'Username'),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(labelText: 'Password'),
        ),
        ElevatedButton(
          onPressed: () {
            authService.login(usernameController.text, passwordController.text).then((success) {
              if (success) {
                // Login successful, handle navigation or UI updates
              } else {
                // Show an error message
              }
            });
          },
          child: Text('Login'),
        ),
      ],
    );
  }

  Widget buildLogoutUI(AuthService authService) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Welcome, ${authService.user!.username}'),
        ElevatedButton(
          onPressed: () {
            authService.logout();
            // Handle navigation or UI updates for logout
          },
          child: Text('Logout'),
        ),
      ],
    );
  }
}