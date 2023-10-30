import 'package:flutter/material.dart';
import 'package:cash_droid/theme/colors.dart';
import 'package:cash_droid/pages/newentry_page.dart';
import 'package:animations/animations.dart';

class DailyPage extends StatelessWidget {
  const DailyPage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<Map<String, dynamic>> _expenses = []; // Replace with your list of expenses

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: myColors[0],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.0, 2.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Transactions",
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          _expenses.isEmpty
              ? noExpenseDefault(context)
              : Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(13),
              children: List.generate(
                _expenses.length,
                    (i) => OpenContainer(
                  transitionType: ContainerTransitionType.fadeThrough,
                  closedElevation: 0,
                  openElevation: 0,
                  middleColor: Colors.transparent,
                  openColor: Colors.transparent,
                  closedColor: Colors.transparent,
                  closedBuilder: (_, __) => makeRecordTile(size, _expenses[i]),
                  openBuilder: (_, __) => NewEntryLog(), // Replace with the appropriate parameters
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column noExpenseDefault(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Text(
          "No transaction entries found",
          style: TextStyle(fontSize: 21),
        ),
        TextButton(
          child: Text("Add new entries"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewEntryLog(), // Replace with the appropriate parameters
              ),
            );
          },
        )
      ],
    );
  }

  Column makeRecordTile(Size size, Map<String, dynamic> record) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  record['item'],
                  style: TextStyle(
                    fontSize: 17,
                    color: black,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  record['person'],
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Pkr ${record['amount']}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  record['date'],
                  style: TextStyle(
                    fontSize: 12,
                    color: black.withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 8, right: 10),
          child: Divider(
            indent: 0,
            thickness: 0.8,
          ),
        ),
      ],
    );
  }
}
