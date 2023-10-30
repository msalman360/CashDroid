import 'package:flutter/material.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 3,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'App Version',
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    Text(
                      'v 1.0.0', // Replace with your app version
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/logo.png', // Replace with your logo image
                  height: 80, // Adjust the height as needed
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        ListTile(
          leading: Icon(Icons.account_balance_wallet),
          title: Text('Add/Remove Accounts'),
          onTap: () {
            // Handle adding/removing accounts
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.file_upload),
          title: Text('Import Data'),
          onTap: () {
            // Handle importing data
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.file_download),
          title: Text('Export Data'),
          onTap: () {
            // Handle exporting data
          },
        ),
        Divider(),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Copyright ©',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' 2023 '),
                        // TextSpan(
                        //   text: 'Your Company Name',
                        //   style: TextStyle(color: Colors.blue),
                        //   recognizer: TapGestureRecognizer()
                        //     ..onTap = () {
                        //       _launchURL('https://example.com'); // Replace with your website URL
                        //     },
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

}
class User {
  final String username;
  final String email;

  User(this.username, this.email);
}
class AuthService {
  User? _user; // The currently logged-in user

  User? get user => _user;

  Future<bool> login(String username, String password) async {
    // You can add authentication logic here
    // For simplicity, we set a user if login is successful
    if (username == 'example' && password == 'password') {
      _user = User(username, 'user@example.com');
      return true;
    } else {
      return false;
    }
  }

  void logout() {
    _user = null;
  }
}
