import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:animations/animations.dart';
import 'package:share_plus/share_plus.dart';

import 'category_management.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController userControler = TextEditingController();
  TextEditingController categoryControler = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    userControler.dispose();
    categoryControler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.withOpacity(0.05),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 56, // 56 is the height of the bottom navigation bar
        child: getBody(),
      ),
    );
  }

  Widget getBody() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(

            color: Colors.lightGreen,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.01),
                spreadRadius: 10,
                blurRadius: 3,
              ),
            ],
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.green],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.0, 2.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 25),
            child: Row(
              children: <Widget>[],
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Column(
          children: [
            Image.asset(
              "assets/images/budget.png",
              height: 100,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 13,
            ),
            Text(
              "Cash Droid",
              style: TextStyle(
                fontSize: 25,
                color: Colors.blue, // You can use your color
              ),
            ),
            Text(
              "v 1.4.3.5",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 13),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedElevation: 0,
                openElevation: 0,
                middleColor: Colors.transparent,
                openColor: Colors.transparent,
                closedColor: Colors.transparent,
                closedBuilder: (_, __) => Row(
                  children: [
                    Icon(Icons.person_outline),
                    SizedBox(width: 10),
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    )
                  ],
                ),
                openBuilder: (_, __) => CategoryManagementPage(), // Replace with your category management page
              ),
              Divider(
                indent: 30,
                thickness: 1.0,
                height: 15,
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: showResetDialog,
                child: Row(
                  children: [
                    Icon(Icons.restore), // Use your desired icon
                    SizedBox(width: 10),
                    Text(
                      "Reset Data",
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                indent: 30,
                thickness: 1.0,
                height: 15,
              ),
              SizedBox(
                height: 13,
              ),
              InkWell(
                onTap: exportData,
                child: Row(
                  children: [
                    Icon(Icons.file_upload), // Use your desired icon
                    SizedBox(width: 10),
                    Text(
                      "Export Data",
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                indent: 30,
                thickness: 1.0,
                height: 15,
              ),
              SizedBox(
                height: 13,
              ),
              InkWell(
                onTap: importData,
                child: Row(
                  children: [
                    Icon(Icons.file_download), // Use your desired icon
                    SizedBox(width: 10),
                    Text(
                      "Import Data",
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(child: Container()),
        Column(
          children: [
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Copyright \u00a9',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " 2023 "),
                  TextSpan(
                    text: '',
                    style: TextStyle(color: Colors.blueAccent.shade700),
                    recognizer: TapGestureRecognizer()..onTap = _launchURL,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 13,
            )
          ],
        ),
      ],
    );
  }

  var _url = 'https://github.com/Koushikphy/Shared-Expense-Manager';

  void _launchURL() async {
    // ignore: deprecated_member_use
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  void showResetDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear Expense Entries'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to clear all expense entries?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Clear your expense entries here
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void importData() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This will clear all existing records.\n Want to proceed?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                loadUserData();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void loadUserData() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }

    String? fileName = result.files.single.path;
    var data = json.decode(File(fileName!).readAsStringSync());

    // ignore: unused_local_variable
    List<String> _uList = (data["users"] as List).map((e) => e as String).toList();
    // ignore: unused_local_variable
    List<String> _cList = (data["categories"] as List).map((e) => e as String).toList();
    // ignore: unused_local_variable
    List<Map<String, dynamic>> _exList = (data["expenses"] as List).map((e) => Map<String, dynamic>.from(e)).toList();

    // Process the imported data as needed
  }

  void exportData() async {
    String timeStamp = DateFormat('dd_MM_yyyy').format(DateTime.now());
    final directory = await getExternalStorageDirectory();
    String fileName = "${directory!.path}/Expenses_$timeStamp.txt";
    File file = File(fileName);

    file.writeAsString(json.encode({
      "users": [], // Replace with your list of users
      "categories": [], // Replace with your list of categories
      "expenses": [], // Replace with your list of expenses
    }));

    // ignore: deprecated_member_use
    await Share.shareFiles([file.path]);
  }
}
